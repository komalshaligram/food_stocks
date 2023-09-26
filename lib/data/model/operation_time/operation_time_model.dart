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
    @JsonKey(name: 'openingIndex') String? openingIndex,
  }) = _OperationTimeModel;

  factory OperationTimeModel.fromJson(Map<String, dynamic> json) =>
      _$OperationTimeModelFromJson(json);
}