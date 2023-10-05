part of 'log_in_bloc.dart';

@freezed
class LogInState with _$LogInState {
  const factory LogInState({
    required bool isLoginSuccess,
    required bool isLoginFail,
    required bool isLoading,
    required String errorMessage,
    required String mobileErrorMessage,
  }) = _LogInState;

  factory LogInState.initial() => LogInState(
        isLoginFail: false,
        isLoginSuccess: false,
        errorMessage: '',
        mobileErrorMessage: '',
        isLoading: false,
      );
}
