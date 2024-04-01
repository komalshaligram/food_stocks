part of 'log_in_bloc.dart';

@freezed
class LogInState with _$LogInState {
  const factory LogInState({
    required bool isLoading,
    required bool isRegister,
  }) = _LogInState;

  factory LogInState.initial() => LogInState(
        isRegister: false,
        isLoading: false,
      );
}
