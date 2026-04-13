part of 'registration_success_bloc.dart';

@freezed
class RegistrationSuccessEvent with _$RegistrationSuccessEvent {
  const factory RegistrationSuccessEvent.celebrationEvent() = _celebrationEvent;

  const factory RegistrationSuccessEvent.generalSettings({required BuildContext context}) = _generalSettings;
}
