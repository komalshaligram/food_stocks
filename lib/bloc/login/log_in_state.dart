part of 'log_in_bloc.dart';

@freezed
class LogInState with _$LogInState {
  const factory LogInState({
    required bool isLoginSuccess,
    required bool isLoading,
    required bool isRegister,
    required String errorMessage,
    required String mobileErrorMessage,
  }) = _LogInState;

  factory LogInState.initial() => LogInState(
    isLoginSuccess: false,
        isRegister: false,
        errorMessage: '',
        mobileErrorMessage: ' ',
        isLoading: false,
      );
}
