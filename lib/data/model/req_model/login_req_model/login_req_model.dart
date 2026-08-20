import 'package:freezed_annotation/freezed_annotation.dart';
part 'login_req_model.freezed.dart';
part 'login_req_model.g.dart';

@freezed
class LoginReqModel with _$LoginReqModel {
  const factory LoginReqModel({
    required String contact,
    required String applicationName,
  }) = _LoginReqModel;

  factory LoginReqModel.fromJson(Map<String, dynamic> json) => _$LoginReqModelFromJson(json);
}
