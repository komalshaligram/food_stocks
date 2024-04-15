part of 'form_data_bloc.dart';

@freezed
class FormDataEvent with _$FormDataEvent {
  factory FormDataEvent.selectAgentEvent({required String agent}) =
  _selectAgentEvent;
  factory FormDataEvent.selectBusinessTypeEvent({required String business , required bool haveMultiple}) =
  _selectBusinessTypeEvent;
  factory FormDataEvent.getAgentEvent({required BuildContext context}) =
  _getAgentEvent;
  factory FormDataEvent.getBusinessTypeEvent({required BuildContext context}) =
  _getBusinessTypeEvent;
  factory FormDataEvent.navigateToNextScreenEvent({required BuildContext context}) =
  _navigateToNextScreenEvent;


}