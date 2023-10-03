part of 'operation_time_bloc.dart';


@freezed
class OperationTimeEvent with _$OperationTimeEvent{

  factory OperationTimeEvent.timePickerEvent({
    required BuildContext context,
    required int openingIndex,
    required int rowIndex,
    required int timeIndex,
    required String time,
}) = _timePickerEvent;

  factory OperationTimeEvent.defaultValueAddInListEvent(
  ) = _defaultValueAddInListEvent;

  factory OperationTimeEvent.addMoreTimeZoneEvent({
    required int rowIndex,
}
      ) = _addMoreTimeZoneEventEvent;

  factory OperationTimeEvent.deleteTimeZoneEvent({
    required int rowIndex,
    required int timeIndex,
  }
      ) = _deleteTimeZoneEvent;

  factory OperationTimeEvent.getProfileModelEvent({required ProfileModel profileModel}) = _getProfileModelEvent;

  factory OperationTimeEvent.timeZoneApiEvent(
      ) = _timeZoneApiEvent;

}
