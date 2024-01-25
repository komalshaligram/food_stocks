part of 'activity_time_bloc.dart';


@freezed
class ActivityTimeEvent with _$ActivityTimeEvent{

  factory ActivityTimeEvent.timePickerEvent({
    required BuildContext timePickerContext,
    required int openingIndex,
    required int rowIndex,
    required int timeIndex,
    required String time,
    required BuildContext context,
}) = _timePickerEvent;

  factory ActivityTimeEvent.defaultValueAddInListEvent({
    required BuildContext context,
}
  ) = _defaultValueAddInListEvent;

  factory ActivityTimeEvent.addMoreTimeZoneEvent({
    required int rowIndex,
    required BuildContext context,
}
      ) = _addMoreTimeZoneEventEvent;

  factory ActivityTimeEvent.deleteTimeZoneEvent({
    required int rowIndex,
    required int timeIndex,

  }
      ) = _deleteTimeZoneEvent;

  factory ActivityTimeEvent.activityTimeApiEvent({
    required BuildContext context,

}
      ) = _activityTimeApiEvent;

  factory ActivityTimeEvent.getActivityTimeListEvent({
    required BuildContext context,

}
      ) = _getActivityTimeListEvent;

  factory ActivityTimeEvent.getActivityTimeDetailsEvent({
    required bool isUpdate,
  }
      ) = _getActivityTimeDetailsEvent;



}
