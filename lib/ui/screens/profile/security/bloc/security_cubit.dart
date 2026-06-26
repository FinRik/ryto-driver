import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../../../../../core/repos/local_auth_repo.dart';
part 'security_state.dart';

class SecurityCubit extends HydratedCubit<SecurityState> {
  final LocalAuthRepo _authRepo;

  SecurityCubit(this._authRepo) : super(const SecurityState());

  Future<void> toggleBiometric(bool value) async {
    if (value) {
      emit(state.copyWith(status: BiometricStatus.authenticating));
      try {
        final isAvailable = await _authRepo.isBiometricAvailable();

        if (!isAvailable) {
          emit(state.copyWith(
            status: BiometricStatus.failure,
            errorMessage: "Biometric hardware is not available on this device.",
          ));
          return;
        }

        final didAuthenticate = await _authRepo.authenticateUser(
          reason: 'Please authenticate to enable Biometric Login',
        );

        if (didAuthenticate) {
          emit(state.copyWith(
            isBiometricEnabled: true,
            status: BiometricStatus.success,
          ));
        } else {
          emit(state.copyWith(status: BiometricStatus.initial));
        }
      } catch (e) {
        emit(state.copyWith(
          status: BiometricStatus.failure,
          errorMessage: "Failed to auth, please try again",
        ));
      }
    } else {
      emit(state.copyWith(
        isBiometricEnabled: false,
        status: BiometricStatus.initial,
      ));
    }
  }

  @override
  SecurityState? fromJson(Map<String, dynamic> json) {
    return SecurityState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(SecurityState state) {
    return state.toMap();
  }
}