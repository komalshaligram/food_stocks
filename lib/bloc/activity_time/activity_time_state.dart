
part of 'activity_time_bloc.dart';


@freezed
class ActivityTimeState with _$ActivityTimeState {
  const factory ActivityTimeState({
    required String time,
    required List<ActivityTimeModel> OperationTimeList,
    required bool isRefresh,
    required bool isRegisterSuccess,
    required bool isRegisterFail,
    required String errorMessage,
    required bool isUpdate,
    required bool isLoading,
    required bool isShimmering,
  }) = _ActivityTimeState;

  factory ActivityTimeState.initial()=> ActivityTimeState(
    time: AppStrings.timeString,
        OperationTimeList: [],
        isRefresh: false,
        isRegisterSuccess: false,
        errorMessage: '',
        isRegisterFail: false,
        isUpdate: false,
        isLoading: false,
        isShimmering: false,
      );

}
