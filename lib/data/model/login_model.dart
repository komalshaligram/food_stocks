import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_model.freezed.dart';
part 'login_model.g.dart';


@freezed
class LogInReqModel with _$LogInReqModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory LogInReqModel({
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'email')String? email,
    @JsonKey(name: 'password') String? password,


  }) = _LogInReqModel;

  factory LogInReqModel.fromJson(Map<String,dynamic> json) =>
      _$LogInReqModelFromJson(json);
}