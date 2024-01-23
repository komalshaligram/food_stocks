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






import '../req_model/activity_time/activity_time_req_model.dart';

class ActivityTimeModel{
   List<Day>monday;
   String dayString = '';
  ActivityTimeModel({
     required this.monday,
    required this.dayString,

});
   ActivityTimeModel.fromJson(Map<String, dynamic> json)
       : monday = json['Monday'],
         dayString = json['dayString'];

   Map<String, dynamic> toJson() => {
     'monday': monday,
     'dayString': dayString,
   };

  }





