part of 'form_data_bloc.dart';

@freezed
class FormDataEvent with _$FormDataEvent {
  factory FormDataEvent.selectBusinessTypeEvent({required String business , required bool haveMultiple}) =
  _selectBusinessTypeEvent;
  factory FormDataEvent.getBusinessTypeEvent({required BuildContext context}) =
  _getBusinessTypeEvent;
  factory FormDataEvent.navigateToNextScreenEvent({required BuildContext context}) =
  _navigateToNextScreenEvent;

}