part of 'login_bloc.dart';

@freezed
class LogInEvent with _$LogInEvent{

   factory LogInEvent.buttonPressed({
      required String name,
      required String email,}
       ) = _LogInButtonPressedEvent;
}