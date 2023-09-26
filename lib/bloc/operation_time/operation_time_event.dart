part of 'operation_time_bloc.dart';


@freezed
class OperationTimeEvent with _$OperationTimeEvent{

  factory OperationTimeEvent.timePickerEvent({
    required BuildContext context,
    required int openingIndex,
    required int index
}) = _timePickerEvent;



}
