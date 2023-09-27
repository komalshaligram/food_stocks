part of 'operation_time_bloc.dart';

@freezed
class OperationTimeState with _$OperationTimeState{
  const factory OperationTimeState({
    required String time,
   required List<OperationTimeModel> OperationTimeList,
    required bool isRefresh,

  }) = _OperationTimeState;

  factory OperationTimeState.initial()=> OperationTimeState(
    time:  '18:00',
    OperationTimeList: [

    ],
    isRefresh: false,

  );

}
