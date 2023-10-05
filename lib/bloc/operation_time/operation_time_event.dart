part of 'operation_time_bloc.dart';


@freezed
class OperationTimeEvent with _$OperationTimeEvent{

  factory OperationTimeEvent.timePickerEvent({
    required BuildContext timePickerContext,
    required int openingIndex,
    required int rowIndex,
    required int timeIndex,
    required String time,
    required BuildContext context,
}) = _timePickerEvent;

  factory OperationTimeEvent.defaultValueAddInListEvent({
    required BuildContext context,
}
  ) = _defaultValueAddInListEvent;

  factory OperationTimeEvent.addMoreTimeZoneEvent({
    required int rowIndex,
    required BuildContext context,
}
      ) = _addMoreTimeZoneEventEvent;

  factory OperationTimeEvent.deleteTimeZoneEvent({
    required int rowIndex,
    required int timeIndex,

  }
      ) = _deleteTimeZoneEvent;

 /* factory OperationTimeEvent.getProfileModelEvent(*//*{required ProfileModel profileModel}*//*) = _getProfileModelEvent;*/

  factory OperationTimeEvent.operationTimeApiEvent({
    required BuildContext context,
}
      ) = _operationTimeApiEvent;




}
