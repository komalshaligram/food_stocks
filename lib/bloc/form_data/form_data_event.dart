part of 'form_data_bloc.dart';

@freezed
class FormDataEvent with _$FormDataEvent {
  factory FormDataEvent.selectAgentEvent({required String agent}) =
  _selectAgentEvent;
  factory FormDataEvent.selectBusinessTypeEvent({required String business}) =
  _selectBusinessTypeEvent;
}