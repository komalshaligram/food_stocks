part of 'connect_bloc.dart';

@freezed
class ConnectState with _$ConnectState {
  const factory ConnectState({
    required bool isLoginSuccess,
    required bool isLoading,
    required bool isRegister,
    required String errorMessage,
    required String mobileErrorMessage,
  }) = _ConnectState;

  factory ConnectState.initial() => ConnectState(
    isLoginSuccess: false,
    isRegister: false,
    errorMessage: '',
    mobileErrorMessage: ' ',
    isLoading: false,
  );
}
