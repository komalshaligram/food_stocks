part of 'log_in_bloc.dart';

@freezed
class LogInState with _$LogInState {

  const factory LogInState({
    required bool isLoginSuccess,
    required bool isLoginFail,
    required String errorMessage,
  }) = _LogInState;

  factory LogInState.initial()=>  LogInState(
    isLoginFail: false,
    isLoginSuccess: false,
     errorMessage: ''
  );


}


