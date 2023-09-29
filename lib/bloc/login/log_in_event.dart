part of 'log_in_bloc.dart';

@freezed
class LogInEvent with _$LogInEvent {

  factory LogInEvent.logInApiDataEvent({
    required  String contactNumber,
    required bool isRegister,
  }) = _logInApiDataEvent;

}