

import 'package:freezed_annotation/freezed_annotation.dart';


part 'activity_time_req_model.freezed.dart';
part 'activity_time_req_model.g.dart';



@freezed
class ActivityTimeReqModel with _$ActivityTimeReqModel {
  const factory ActivityTimeReqModel({
    @JsonKey(name: "operationTime")
    List<OperationTime>? operationTime,
  }) = _ActivityTimeReqModel;

  factory ActivityTimeReqModel.fromJson(Map<String, dynamic> json) => _$ActivityTimeReqModelFromJson(json);
}

@freezed
class OperationTime with _$OperationTime {
  const factory OperationTime({
    @JsonKey(name: "Sunday")
    List<Day>? Sunday,
    @JsonKey(name: "Monday")
    List<Day>? Monday,
    @JsonKey(name: "Tuesday")
    List<Day>? Tuesday,
    @JsonKey(name: "Wednesday")
    List<Day>? Wednesday,
    @JsonKey(name: "Thursday")
    List<Day>? Thursday,
    @JsonKey(name: "Friday")
    List<Day>? Friday,
    @JsonKey(name: "Saturday")
    List<Day>? Saturday,
  }) = _OperationTime;

  factory OperationTime.fromJson(Map<String, dynamic> json) => _$OperationTimeFromJson(json);
}

@freezed
class Day with _$Day {
  const factory Day({
    @JsonKey(name: "from")
    String? from,
    @JsonKey(name: "until")
    String? until,
  }) = _Day;

  factory Day.fromJson(Map<String, dynamic> json) => _$DayFromJson(json);
}
