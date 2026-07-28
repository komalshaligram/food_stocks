part of 'log_in_bloc.dart';

@freezed
class LogInState with _$LogInState {
  const factory LogInState({
    required bool isLoading,
    required bool isRegister,
    required int otpCooldown,
  }) = _LogInState;

  factory LogInState.initial() => const LogInState(
        isRegister: false,
        isLoading: false,
        otpCooldown: 0,
      );
}
