part of 'security_cubit.dart';

enum BiometricStatus { initial, authenticating, success, failure }

class SecurityState {
  final bool isBiometricEnabled;
  final BiometricStatus status;
  final String? errorMessage;

  const SecurityState({
    this.isBiometricEnabled = false,
    this.status = BiometricStatus.initial,
    this.errorMessage,
  });

  SecurityState copyWith({
    bool? isBiometricEnabled,
    BiometricStatus? status,
    String? errorMessage,
  }) {
    return SecurityState(
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  Map<String, dynamic> toMap() {
    return {'isBiometricEnabled': isBiometricEnabled};
  }

  factory SecurityState.fromMap(Map<String, dynamic> map) {
    return SecurityState(
      isBiometricEnabled: map['isBiometricEnabled'] ?? false,
    );
  }
}