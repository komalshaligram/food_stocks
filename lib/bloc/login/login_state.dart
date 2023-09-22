part of 'login_bloc.dart';

enum LoginStatus {
  success,
  failure,
  loading,
}

/*
@freezed
class LogInState with _$LogInState {
   const factory LogInState({
     required LogInReqModel reqModel,
     required LoginStatus loginStatus
  })  = _LogInState;


  factory LogInState.initial()=> const LogInState(
  loginStatus:LoginStatus.loading,
    reqModel: LogInReqModel()
  );
}*/
