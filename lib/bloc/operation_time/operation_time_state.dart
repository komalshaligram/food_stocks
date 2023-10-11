part of 'operation_time_bloc.dart';

@freezed
class OperationTimeState with _$OperationTimeState{
  const factory OperationTimeState({
    required String time,
   required List<OperationTimeModel> OperationTimeList,
    required bool isRefresh,
    required bool isRegisterSuccess,
    required bool isRegisterFail,
    required String errorMessage,
    required bool isUpdate,


  }) = _OperationTimeState;

  factory OperationTimeState.initial()=> OperationTimeState(
    time:  AppStrings.timeString,
    OperationTimeList: [],
    isRefresh: false,
    isRegisterSuccess: false,
    errorMessage: '',
    isRegisterFail: false,
    isUpdate:false,
  );

}
