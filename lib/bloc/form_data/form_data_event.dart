part of 'form_data_bloc.dart';

@freezed
class FormDataEvent with _$FormDataEvent {
  factory FormDataEvent.selectAgentEvent({
    required String agent,
  }) = _selectAgentEvent;

  factory FormDataEvent.selectBusinessTypeEvent({
    required String business,
    required bool haveMultiple,
  }) = _selectBusinessTypeEvent;

  factory FormDataEvent.getAgentEvent({
    required BuildContext context,
  }) = _getAgentEvent;

  factory FormDataEvent.getBusinessTypeEvent({
    required BuildContext context,
  }) = _getBusinessTypeEvent;

  factory FormDataEvent.navigateToNextScreenEvent({
    required BuildContext context,
  }) = _navigateToNextScreenEvent;

  factory FormDataEvent.verifyAgentEvent({
    required BuildContext context,
  }) = _verifyAgentEvent;

  factory FormDataEvent.selectOwnerNoEvent({
    required String owner,
  }) = _selectOwnerNoEvent;

  factory FormDataEvent.getArgumentEvent({
    required String owner,
    required String businessTypeId,
    required bool isFreelancer,
  }) = _getArgumentEvent;
  const factory FormDataEvent.generalSettings({
    required BuildContext context,
  }) = _generalSettings;
}
