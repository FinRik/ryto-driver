import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ui/blocs/country/country_bloc.dart';
import '../../ui/blocs/profile/profile_bloc.dart';
import '../../ui/layout/bottom_nav/cubit/bottom_nav_cubit.dart';
import '../../ui/screens/auth/bloc/auth_bloc.dart';
import '../../ui/screens/chat/bloc/chat_bloc.dart';
import '../../ui/screens/draft/bloc/trip_draft_bloc.dart';
import '../../ui/screens/home/bloc/home_bloc.dart';
import '../../ui/screens/pending_setup/payout_setup/bloc/payout_setup_bloc.dart';
import '../../ui/screens/pending_setup/preference_setup/bloc/preference_setup_bloc.dart';
import '../../ui/screens/pending_setup/vehicle_setup/bloc/vehicle_setup_bloc.dart';
import '../../ui/screens/pending_setup/verification_setup/bloc/verification_setup_bloc.dart';
import '../../ui/screens/profile/security/bloc/security_cubit.dart';
import '../../ui/screens/profile/settings/bloc/settings_cubit.dart';
import '../../ui/screens/trip_action/bloc/trip_action_bloc.dart';
import '../../ui/screens/trips/bloc/trips_bloc.dart';
import '../../ui/screens/trip_setup/bloc/trip_setup_bloc.dart';
import '../../ui/screens/wallet/bloc/wallet_bloc.dart';
import '../repos/auth_repo.dart';
import '../repos/booking_repo.dart';
import '../repos/chat_repo.dart';
import '../repos/country_repo.dart';
import '../repos/dashboard_repo.dart';
import '../repos/local_auth_repo.dart';
import '../repos/mocks/mock_pending_setup_repo.dart';
import '../repos/pending_setup_repo.dart';
import '../repos/wallet_repo.dart';

class MultiBlocsProvider extends StatelessWidget {
  const MultiBlocsProvider({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          lazy: true,
          create: (cxt) => AuthBloc(cxt.read<AuthRepo>()),
        ),
        BlocProvider<CountryBloc>(
          lazy: true,
          create: (cxt) => CountryBloc(cxt.read<CountryRepo>()),
        ),
        BlocProvider<ProfileBloc>(
          lazy: true,
          create: (cxt) => ProfileBloc(cxt.read<AuthRepo>()),
        ),
        BlocProvider<VerificationSetupBloc>(
          lazy: true,
          create: (cxt) {
            // Toggle this configuration flag to swap repos
            const bool useMockData = false;

            if (useMockData) {
              // Registers your mock instead of the actual API service
              return VerificationSetupBloc(MockPendingSetupRepoImpl());
            } else {
              return VerificationSetupBloc(cxt.read<PendingSetupRepo>());
            }
          },
        ),
        BlocProvider<VehicleSetupBloc>(
          lazy: true,
          create: (cxt) => VehicleSetupBloc(cxt.read<PendingSetupRepo>()),
        ),
        BlocProvider<PreferenceSetupBloc>(
          lazy: true,
          create: (cxt) => PreferenceSetupBloc(cxt.read<PendingSetupRepo>()),
        ),
        BlocProvider<PayoutSetupBloc>(
          lazy: true,
          create: (cxt) {
            // Toggle this configuration flag to swap repos
            const bool useMockData = false;

            if (useMockData) {
              // Registers your mock instead of the actual API service
              return PayoutSetupBloc(MockPendingSetupRepoImpl());
            } else {
              return PayoutSetupBloc(cxt.read<PendingSetupRepo>());
            }
          },
        ),
        BlocProvider<ChatBloc>(
          lazy: true,
          create: (cxt) => ChatBloc(cxt.read<ChatRepo>()),
        ),
        BlocProvider<HomeBloc>(
          lazy: true,
          create: (cxt) => HomeBloc(cxt.read<DashboardRepo>()),
        ),
        BlocProvider<TripSetupBloc>(
          lazy: true,
          create: (cxt) => TripSetupBloc(cxt.read<BookingRepo>()),
        ),
        BlocProvider<TripsBloc>(
          lazy: true,
          create: (cxt) => TripsBloc(cxt.read<BookingRepo>()),
        ),
        BlocProvider<TripActionsBloc>(
          lazy: true,
          create: (cxt) => TripActionsBloc(cxt.read<BookingRepo>()),
        ),
        BlocProvider<WalletBloc>(
          lazy: true,
          create: (cxt) => WalletBloc(cxt.read<WalletRepo>()),
        ),
        BlocProvider<TripDraftBloc>(
          lazy: true,
          create: (cxt) => TripDraftBloc(),
        ),
        BlocProvider<SettingsCubit>(
          create: (_) => SettingsCubit(),
          lazy: false,
        ),
        BlocProvider<SecurityCubit>(
          create: (ctx) => SecurityCubit(ctx.read<LocalAuthRepo>()),
          lazy: false,
        ),
        BlocProvider<BottomNavCubit>(
          create: (_) => BottomNavCubit(),
          lazy: false,
        ),
      ],
      child: child,
    );
  }
}
