import 'package:freezed_annotation/freezed_annotation.dart';
part 'operation_time_req_model.freezed.dart';
part 'operation_time_req_model.g.dart';



@freezed
class OperationTimeReqModel with _$OperationTimeReqModel {
  const factory OperationTimeReqModel({
    OperationTime? operationTime,
  }) = _OperationTimeReqModel;

  factory OperationTimeReqModel.fromJson(Map<String, dynamic> json) => _$OperationTimeReqModelFromJson(json);
}

@freezed
class OperationTime with _$OperationTime {
  const factory OperationTime({
    List<Day>? sunday,
    List<Day>? monday,
    List<Day>? tuesday,
    List<Day>? wednesday,
    List<Day>? thursday,
    List<Day>? fridayAndHolidayEves,
    List<Day>? saturdayAndHolidays,
  }) = _OperationTime;

  factory OperationTime.fromJson(Map<String, dynamic> json) => _$OperationTimeFromJson(json);
}

@freezed
class Day with _$Day{
  const factory Day({
    String? from,
    String? until,
  }) = _Day;

  factory Day.fromJson(Map<String, dynamic> json) => _$DayFromJson(json);
}


