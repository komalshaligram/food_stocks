part of 'operation_time_bloc.dart';

@freezed
class OperationTimeState with _$OperationTimeState{
  const factory OperationTimeState({
    required String? selectCity,




  }) = _OperationTimeState;

  factory OperationTimeState.initial()=> OperationTimeState(
    selectCity: 'q',

  );

}
