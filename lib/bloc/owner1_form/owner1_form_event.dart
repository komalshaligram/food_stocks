part of 'owner1_form_bloc.dart';

@freezed
class Owner1FormEvent with _$Owner1FormEvent {
  factory Owner1FormEvent.selectAgentEvent({
    required String agent,
  }) = _selectAgentEvent;

  factory Owner1FormEvent.selectBusinessTypeEvent({
    required String business,
    required bool haveMultiple,
  }) = _selectBusinessTypeEvent;

  factory Owner1FormEvent.getAgentEvent({
    required BuildContext context,
  }) = _getAgentEvent;

  factory Owner1FormEvent.getBusinessTypeEvent({
    required BuildContext context,
  }) = _getBusinessTypeEvent;

  factory Owner1FormEvent.navigateToNextScreenEvent({
    required BuildContext context,
  }) = _navigateToNextScreenEvent;

  factory Owner1FormEvent.verifyAgentEvent({
    required BuildContext context,
  }) = _verifyAgentEvent;

  factory Owner1FormEvent.selectOwnerNoEvent({
    required String owner,
  }) = _selectOwnerNoEvent;

  factory Owner1FormEvent.getArgumentEvent({
    required String owner,
    required String businessTypeId,
    required bool isFreelancer,
  }) = _getArgumentEvent;
}
