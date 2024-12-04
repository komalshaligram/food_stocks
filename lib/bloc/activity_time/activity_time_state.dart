part of 'activity_time_bloc.dart';

@freezed
class ActivityTimeState with _$ActivityTimeState {
  const factory ActivityTimeState({
    required String time,
    required List<ActivityTimeModel> operationTimeList,
    required bool isRefresh,
    required String errorMessage,
    required bool isUpdate,
    required bool isLoading,
    required bool isShimmering,

  }) = _ActivityTimeState;

  factory ActivityTimeState.initial()=>  const ActivityTimeState(
    time: AppStrings.timeString,
        operationTimeList: [],
        isRefresh: false,
        errorMessage: '',
        isUpdate: false,
        isLoading: false,
        isShimmering: false,
      );
}