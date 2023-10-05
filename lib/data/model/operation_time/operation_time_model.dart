/*
import 'package:freezed_annotation/freezed_annotation.dart';

part 'operation_time_model.freezed.dart';

part 'operation_time_model.g.dart';

@freezed
class OperationTimeModel with _$OperationTimeModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory OperationTimeModel({
    @JsonKey(name: 'dayString') String? dayString,
    @JsonKey(name: 'index') int? index,
    @JsonKey(name: 'openingTime') String? openingTime,
    @JsonKey(name: 'openingIndex') int? openingIndex,
  }) = _OperationTimeModel;

  factory OperationTimeModel.fromJson(Map<String, dynamic> json) =>
      _$OperationTimeModelFromJson(json);
}
*/



import '../req_model/operation_time/operation_time_req_model.dart';


class OperationTimeModel{
   List<Day>monday;
   String dayString;
  OperationTimeModel({
     required this.monday,
    required this.dayString,

});

  }

/*class Sunday {
  String from;
  String unitl;
  Sunday({
     required this.from,required this.unitl
  });*/




