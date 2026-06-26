import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/app_setup_locator.dart';
import '../repos/arrival_time_repo.dart';
import '../repos/auth_repo.dart';
import '../repos/booking_repo.dart';
import '../repos/chat_repo.dart';
import '../repos/country_repo.dart';
import '../repos/dashboard_repo.dart';
import '../repos/local_auth_repo.dart';
import '../repos/regional_manager_repo.dart';
import '../repos/places_repo.dart';
import '../services/arrival_time_service.dart';
import '../services/chat_service.dart';
import '../services/g_api_service.dart';
import '../repos/pending_setup_repo.dart';
import '../repos/wallet_repo.dart';
import '../services/api_service.dart';
import '../services/regional_manager_service.dart';

class MultiRepoProvider extends StatelessWidget {
  const MultiRepoProvider({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepo>(
          create: (_) => AuthRepoImpl(service: sl<ApiService>()),
          lazy: false,
        ),
        RepositoryProvider<ChatRepo>(
          create: (_) => ChatRepoImpl(sl<ChatService>()),
          lazy: false,
        ),
        RepositoryProvider<CountryRepo>(
          create: (_) => CountryRepoImpl(service: sl<GApiService>()),
          lazy: false,
        ),
        RepositoryProvider<PlacesRepo>(
          create: (_) => PlacesRepoImpl(service: sl<GApiService>()),
          lazy: false,
        ),
        RepositoryProvider<PendingSetupRepo>(
          create: (_) => PendingSetupRepoImpl(
            apiService: sl<ApiService>(),
            gApiService: sl<GApiService>(),
          ),
          lazy: false,
        ),
        RepositoryProvider<LocalAuthRepo>(
          create: (_) => LocalAuthRepo(),
          lazy: true,
        ),
        RepositoryProvider<DashboardRepo>(
          create: (_) => DashboardRepoImpl(service: sl<ApiService>()),
          lazy: false,
        ),
        RepositoryProvider<BookingRepo>(
          create: (_) => BookingRepoImpl(service: sl<ApiService>()),
          lazy: false,
        ),
        RepositoryProvider<WalletRepo>(
          create: (_) => WalletRepoImpl(service: sl<ApiService>()),
          lazy: false,
        ),
        RepositoryProvider<ArrivalTimeRepo>(
          create: (_) => ArrivalTimeRepoImpl(sl<ArrivalTimeService>()),
          lazy: true,
        ),
        RepositoryProvider<RegionalManagerRepo>(
          create: (_) => RegionalManagerRepoImpl(sl<RegionalManagerService>()),
          lazy: true,
        ),
        // RepositoryProvider(
        //   create: (_) => AppLoaderController(),
        //   child: const AppLoader(),
        // ),
        // ChangeNotifierProvider(
        //   create: (context) => ThemeProvider(),
        // ),
        // ChangeNotifierProvider(
        //   create: (context) => MainScreenViewModel(),
        // ),
      ],
      child: child,
    );
  }
}
