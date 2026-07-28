# Ryto Driver — Architecture Review

Date: 2026-07-26
Branch reviewed: `staging`
Scope: Full codebase read-only analysis per `GUIDELINE.md` (no code changes made).

---

## 1. Overall Architecture

Flutter driver-side ride-hailing app using:
- **flutter_bloc** (Bloc/Cubit) for state management, with `hydrated_bloc` for select blocs that need cross-launch persistence.
- **go_router** (Navigator 2.0) for routing.
- A **hybrid DI** approach: `get_it` for low-level services, flutter_bloc's provider tree for repos/blocs.
- **Dio + retrofit** for networking, with a custom interceptor pipeline for auth headers and global error handling.
- **flutter_secure_storage** for token/session persistence.

Single active author, actively developed, no automated tests found, no crash reporting configured.

---

## 2. Folder Structure & Responsibilities

```
lib/
  app/            entry bootstrap (app.dart), get_it locator, API URL constants
  core/
    config/       DI providers (MultiRepoProvider/MultiBlocsProvider), custom exceptions
    enums/        shared enums (e.g. ActionStatus)
    interceptors/ Dio interceptors (auth header, error handling, logging, refresh-token stub)
    models/       data models (mixed hand-written / json_serializable code-gen)
    repos/        repository layer between blocs and services
    routes/       go_router route table + typed nav-arg classes
    services/     Dio client, retrofit ApiService, chat/socket service, push notifications, region/bottom-sheet services
    setups/       locator + bottom-sheet + region-identity setup functions
    theme_manager/ unused parallel theming abstraction (see Risks)
  ui/
    blocs/        (mostly co-located per-feature under screens/**/bloc instead)
    bottom_sheets/ modal bottom sheets, registered via BottomSheetService
    dialogs/       error/generic/status dialogs
    layout/        BottomNavLayout + shell navigation
    screens/       feature screens, each typically with its own bloc/ subfolder
    styles/        AppColors, AppDimensions, text styles, decorations, AppTheme
    widgets/       shared design-system components (buttons, inputs, loaders, cards, etc.)
  utils/
    helpers/       date/file/location/JWT/image helpers
    logger/        AppLogger wrapper
    storage/       secure-storage wrappers (token, FCM token, first-launch flag)
    typedefs/      JSON / QueryParams typedefs
```

---

## 3. Bootstrap Flow

`lib/main.dart`:
1. `WidgetsFlutterBinding.ensureInitialized()`
2. `HttpOverrides.global = MyHttpOverrides()` — **disables TLS certificate validation app-wide** (see Risks #2)
3. `App.init()` (see below)
4. Register `FirebaseMessaging.onBackgroundMessage`
5. `runApp(MyApp())` → `MultiRepoProvider` → `MultiBlocsProvider` → `MaterialApp.router`

`lib/app/app.dart` (`App.init`):
1. `dotenv.load(".env")`
2. `Firebase.initializeApp(...)`
3. `setupDependencies()` — get_it registration
4. `setupBottomSheetUi()`
5. `PushNotificationService().initNotification()`
6. `initGoogleMapKey()` — reads Maps key from `.env`
7. `HydratedBloc.storage = HydratedStorage.build(storageDirectory: getTemporaryDirectory())` — ⚠️ uses OS **temp** dir, not app-documents dir (persistence-reliability risk)

No `runZonedGuarded`, no `FlutterError.onError`, no crash reporting SDK anywhere.

---

## 4. Dependency Flow

Two coexisting mechanisms:

- **get_it** (`lib/app/app_setup_locator.dart`) — registers only low-level singletons: `DioService` (eager), `ApiService`, `GApiService`, `RegionalManagerService`, `ChatService`, `ArrivalTimeService` (all lazy), plus `BottomSheetService`.
- **flutter_bloc providers**:
  - `lib/core/config/multi_repo_provider.dart` — builds all repos (`AuthRepo`, `ChatRepo`, `CountryRepo`, `PlacesRepo`, `PendingSetupRepo`, `LocalAuthRepo`, `DashboardRepo`, `BookingRepo`, `WalletRepo`, `ArrivalTimeRepo`, `RegionalManagerRepo`), most `lazy: false`.
  - `lib/core/config/multi_blocs_provider.dart` — builds all Blocs/Cubits, reading repos via `context.read<T>()`.

Repo constructors typically **also** fall back to `sl<T>()` directly (`service ?? sl<ApiService>()`), so the DI graph is duplicated across both mechanisms rather than having one source of truth.

A manual mock/real toggle exists for `VerificationSetupBloc`/`PayoutSetupBloc` (`const bool useMockData = false;` in `multi_blocs_provider.dart`) — a hardcoded feature flag, not build-config driven.

`lib/core/setups/dialog_sheet_setup.dart` is dead code — entirely commented out, never called.

---

## 5. Navigation Flow

**go_router** (`lib/core/routes/router.dart`, `lib/core/routes/routes.dart`):
- Flat `GoRoute`s + one `ShellRoute` wrapping `BottomNavLayout` with Home/Trips/Earnings(Wallet)/Profile tabs.
- `BuildContext? get rootContext` — a global navigator-key-derived context, used app-wide as an ad hoc "NavigationService" substitute.
- Typed nav args (`VerifyOtpArgs`, `PassengerDetailsArgs`, `WebviewArgs`) passed via go_router's untyped `state.extra`, cast with `as T` at ~20 call sites — no compile-time safety, runtime crash risk on mismatch.
- Screens navigate directly via the global `router` singleton or `context.go/push`; there is **no dedicated NavigationService class**.
- The Dio `ErrorInterceptor` navigates directly (`router.go(Paths.LOGIN)`) on detected session expiry — **networking layer performing app navigation**, bypassing Blocs entirely.
- `BottomSheetService` similarly grabs the router's navigator-key context to show sheets outside any local widget context.
- Legacy/commented-out routes remain in the router file (dead code).

---

## 6. State Management (Bloc/Cubit) Flow

- Plain `Bloc`: `AuthBloc`, `TripActionsBloc`, `TripsBloc`, `CountryBloc`, `ProfileBloc`, and setup-flow blocs.
- `HydratedBloc`: `ChatBloc`, `WalletBloc`, `HomeBloc` — persisted across cold starts (cache shown instantly, refreshed in background).
- `Cubit`: simple local UI state — `BottomNavCubit`, `SettingsCubit`, `SecurityCubit`, `ArrivalTimeCubit`, `BookingCostCubit`, `LocationFetchCubit`.
- All events/states use `Equatable`. **No `BlocObserver`** anywhere — no centralized transition/error logging.
- `ChatBloc` correctly bridges a socket stream into bloc events via a private `_OnNewMessageReceived` event and disposes its `StreamSubscription` in `close()` — a good pattern, one of the few in the codebase.
- `HomeBloc` tracks onboarding-step completion (verification/vehicle/background/preference/payout), but the UI layer (`home_screen.dart`) *also* tracks completeness locally via `StatefulWidget` booleans — duplicated state, consistency risk.
- Nearly every bloc handler repeats identical `try { emit(success) } catch (e) { emit(failure) }` boilerplate, with inconsistent error messages (some blocs show raw `e.toString()` to users, others show friendly generic strings).

---

## 7. Data Flow (traced via Wallet feature)

```
Screen.initState()
  → context.read<WalletBloc>().add(FetchWalletDataRequested())
  → WalletBloc calls WalletRepoImpl.fetchUserWallet()
  → repo calls retrofit ApiService.fetchUserWallet()
  → shared Dio client (DioService) + interceptors:
       ApiInterceptor    → attaches bearer token from TokenStorage
       ErrorInterceptor  → global error dialogs / session-expiry handling
  → response parsed into BaseModel<WalletSummary> via _Converter<T>,
       which manually sniffs JSON keys to decide which model's fromJson to call
  → WalletBloc emits WalletState (success/failure)
  → BlocConsumer<WalletBloc, WalletState> rebuilds WalletScreen
```

This shape recurs identically across Home, Trips, TripActions, Profile, etc.

`lib/core/services/dio_service.dart` currently has an uncommitted change disabling `LoggingInterceptor()`; stray `print()` debug statements remain in `_initDioClient()`.

---

## 8. Networking Layer Detail

- `DioService` sets `validateStatus: (status) => true` — Dio never throws on 4xx/5xx itself; all HTTP status handling happens manually in `ErrorInterceptor.onResponse`.
- `ErrorInterceptor` (`lib/core/interceptors/error_interceptor.dart`) detects session/auth expiry via **string-matching** ("token" in message + 401/403) rather than a dedicated error code — fragile heuristic. Uses a static `_isDialogShowing` flag to prevent stacked dialogs.
- `RefreshTokenInterceptor` is defined but **never wired into the interceptor list** — dead code, and its `_refreshToken()` is a stub returning a hardcoded string. **No real token refresh exists.**
- Two overlapping exception wrapper types exist: `CustomDioException` (actively used) and `NetworkException` (dead code, unused app-wide).
- `ApiUrls.baseUrl` is a hardcoded production constant (`https://api.getryto.com`) — no dev/staging/prod switching, despite `.env` being used for other keys.
- Two service-authoring styles coexist: retrofit-annotated `ApiService` vs. hand-written Dio wrappers (`GApiService`, `ChatService`, `ArrivalTimeService`, `RegionalManagerService`).

---

## 9. Local Storage / Auth Persistence

- `flutter_secure_storage`-backed wrappers: `TokenStorage`, `FcmTokenStorage`, `AppLaunchState`.
- `AppLaunchState.isFirstLaunch()` has a **hidden write side-effect** on read (sets the flag to `false` as it returns `true`) — surprising behavior for any future caller.
- Splash screen (`splash_screen.dart`) validates the JWT **purely client-side** (decodes `exp` claim) with no server round-trip and no refresh — an expired token silently routes to Login.
- `HydratedBloc` storage (Chat/Wallet/Home state) is stored under the OS **temporary** directory, not app-documents — risk of silent cache loss.

---

## 10. Models

- Mixed hand-written and `json_serializable` code-genned models, with no clear convention for which style applies where.
- `BaseModel<T>` (`lib/core/models/base.dart`) is the universal API envelope, using a custom `_Converter<T>` that **manually sniffs JSON keys** to pick the right concrete model — brittle; adding a new response type requires a new hand-added disambiguation branch, and colliding key-signatures would silently mis-parse.
- Overlapping trip/booking concepts across `Trip`, `TripSummary`, `TripResponse`, `BookingSummary` suggest backend DTOs evolved independently and were modeled separately rather than sharing a base type.

---

## 11. Shared UI Components

- `lib/ui/styles/` — real design-system layer: `AppColors`, `AppDimensions`, text styles/decorations, `AppTheme` (light/dark).
- `Button` widget (`lib/ui/widgets/buttons/button.dart`) — named-constructor variants (primary/secondary/gradient/outline/cancel); carries dead commented-out theme-aware parameters from an abandoned refactor.
- `BaseScaffoldWidget` — shared scaffold wrapper used by nearly every screen.
- Reusable buckets: `inputs/`, `loaders/`, `customs/`, `texts/`, `graphs/` (fl_chart), `app_bars/`.
- Bottom sheets registered centrally via `BottomSheetService` with typed `SheetRequest`/`SheetResponse` generics; dialogs shown via plain `showDialog` (a `DialogService` exists but its actual usage should be verified).
- **Unused theming subsystem**: `lib/core/theme_manager/` + `AppTheme.dark` are fully built but `main.dart` hardcodes `themeMode: ThemeMode.light`, and `ThemeProvider`'s wiring is commented out in `multi_repo_provider.dart` — dark mode is dead code.
- Minor: `lib/ui/bottom_sheets/stripe_ identity_bottom_sheet.dart` has a literal space in the filename.

---

## 12. Real-Time Features (Sockets + Notifications)

- `ChatService` (`lib/core/services/chat_service.dart`) connects to a `/chat` socket.io namespace, streaming `chat:new-message` events into `ChatBloc`, and a separate `driver:notification` event that raises a native local notification via `PushNotificationService.showSocketNotification` — even while the app is foregrounded.
- `ChatService.dispose()` exists but is **never called** (low severity — it's an app-lifetime get_it singleton); the socket auth token is captured once at connect time with no reconnect/refresh handling.
- **Tapping any notification (FCM or socket-originated) currently does nothing** — `PushNotificationService._handleNotificationAction` only contains `// Example navigation:` comments, no actual deep-link/navigation implemented. This is the biggest functional gap in the recently-added "notifications for socket" feature.

---

## 13. External Dependencies / Integrations

| Package | Where used |
|---|---|
| go_router | Routing throughout |
| flutter_bloc + hydrated_bloc | State management |
| get_it | Low-level service locator |
| flutter_secure_storage | Token / FCM token / launch-state persistence |
| dio + retrofit + json_serializable | Networking + models |
| socket_io_client | `ChatService` only |
| firebase_messaging + flutter_local_notifications | Push + local notifications |
| google_maps_flutter, geolocator, geocoding, maps_toolkit | Trip routing/location |
| stripe_identity_plugin + google_mlkit_face_detection | KYC identity verification |
| local_auth | Biometric app-lock (`SecurityCubit`) |
| flutter_inappwebview | Generic webview (FAQ/privacy/terms) |
| fl_chart | Wallet weekly-earnings chart |
| table_calendar | Trip scheduling |
| flutter_dotenv | `.env` loading |

⚠️ No `flutter_stripe`/paystack SDK in dependencies — payment/identity flows route through `stripe_identity_plugin` and/or backend/webview flows, yet `.env` bundles **secret** Stripe/Paystack keys and webhook secrets that a client should never hold (see Risks #1).

---

## 14. Risks / Code Smells (ranked by severity)

1. **Secrets shipped in the binary** — `.env` (Stripe/Paystack *secret* keys, webhook secrets) is bundled as a Flutter asset, trivially extractable from the compiled app. Secret/webhook keys must never live client-side.
2. **TLS certificate validation disabled globally** — `lib/main.dart` (`MyHttpOverrides`) sets `badCertificateCallback` to always return `true`, unconditionally, in all builds. MITM exposure in production.
3. **No token refresh implemented** — `RefreshTokenInterceptor` is dead/stubbed code; session expiry just force-logs-out; JWT validity is checked client-side only.
4. **No crash reporting / global error handling** — no `runZonedGuarded`, no `FlutterError.onError`, no Crashlytics/Sentry, no `BlocObserver`.
5. **Un-disposed `TextEditingController`s** — bank details form, NIN/license verification screens, bank search bottom sheet, some shared input widgets. Pattern is known and done correctly elsewhere, just inconsistently applied.
6. **Duplicated/dead exception types** — `CustomDioException` (used) vs. `NetworkException` (dead, unused).
7. **Hardcoded production base URL and legal/social URLs** — no dev/staging/prod environment switching in the networking layer.
8. **Cross-layer navigation coupling** — networking layer (`ErrorInterceptor`) and `BottomSheetService` navigate/show UI directly via a global router context, bypassing Blocs — hard to unit test.
9. **Manual JSON-shape sniffing for generic deserialization** (`BaseModel<T>`) — brittle, doesn't scale, silent mis-parse risk on key collisions.
10. **Large god-files** mixing fetch/validation/UI in single `StatefulWidget`s (several screens 450–580+ lines).
11. **Substantial dead/commented-out code** left throughout instead of deleted (`dialog_sheet_setup.dart`, `refresh_token_interceptor.dart`, `logger.dart`, `app_colors.dart`, `router.dart`, old `api_service.dart` methods).
12. **Unused theming subsystem** — dark mode fully built but unwired; hardcoded to light mode.
13. **`isFirstLaunch()` has a hidden write side-effect** on read.
14. **Untapped notifications** — no navigation implemented for FCM or socket-originated notification taps.
15. Minor: filename with a literal space, stray `print()` debug statements instead of `AppLogger`, location-specific exceptions misplaced inside the Dio exception file.
16. **Unsafe `state.extra as T` casts** at ~20 router call sites — no null/type guard, runtime crash risk on mismatch.
17. **`ChatService.dispose()` never called** and no socket reconnect/token-refresh handling (low severity — app-lifetime singleton, but worth noting for long sessions where the JWT rotates).

---

## 15. Recommendations

**Urgent / ship-blocking:**
- Remove secret/webhook keys from the client `.env` — these belong server-side only. Audit exactly which keys the app actually needs at runtime vs. which were bundled by mistake.
- Remove or properly gate the TLS certificate bypass (`MyHttpOverrides`) — at minimum restrict it to debug builds pointing at a known self-signed staging host, ideally remove entirely.

**High priority:**
- Implement real token refresh, or explicitly document/design around re-login as the intended session-expiry UX.
- Add a `BlocObserver` and a global error zone (`runZonedGuarded` + `FlutterError.onError`), wired to a crash reporter (Crashlytics/Sentry).
- Implement notification-tap navigation (`PushNotificationService._handleNotificationAction`) — currently a no-op, likely a visible product gap.

**Medium priority:**
- Introduce a shared `safeEmit`/base-bloc helper to remove repeated try/catch/emit boilerplate and standardize user-facing error messages (stop leaking raw `e.toString()` in some blocs).
- Replace `BaseModel<T>`'s key-sniffing converter with per-endpoint typed parsing before adding more response types.
- Sweep for un-disposed `TextEditingController`s/subscriptions — mechanical, low-risk cleanup.
- Consolidate the two DI mechanisms (get_it vs. widget-tree providers) so there's one source of truth for each dependency, not both.
- Add environment/flavor-based base URL switching instead of a hardcoded production constant.

**Low priority / housekeeping:**
- Delete dead code: `dialog_sheet_setup.dart`, `refresh_token_interceptor.dart`, unused `NetworkException`, commented-out theme getters, commented-out routes, old logger implementation.
- Decide whether to finish or remove the unused dark-theme subsystem.
- Fix the filename with a literal space; replace stray `print()` calls with `AppLogger`.
- Relocate location-specific exceptions out of `custom_dio_exception.dart`.

---

*This document is a snapshot as of 2026-07-26 and reflects code state at the time of review — re-verify specifics (line numbers, "unused" claims) before acting, since the codebase is actively changing.*
