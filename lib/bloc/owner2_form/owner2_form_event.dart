part of 'owner2_form_bloc.dart';

@freezed
class Owner2FormEvent with _$Owner2FormEvent {
  factory Owner2FormEvent.navigateToNextScreenEvent({required BuildContext context}) = _navigateToNextScreenEvent;

  factory Owner2FormEvent.getArgumentEvent({required TermsConditionReqModel reqModel}) = _getArgumentEvent;
}
