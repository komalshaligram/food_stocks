import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_req_model.freezed.dart';
part 'login_req_model.g.dart';


LoginReqModel loginRequestFromJson(String str) => LoginReqModel.fromJson(json.decode(str));

String loginRequestToJson(LoginReqModel data) => json.encode(data.toJson());

@freezed
class LoginReqModel with _$LoginReqModel {
  const factory LoginReqModel({
    required String contact,
    required bool isRegistration,
  }) = _LoginReqModel;

  factory LoginReqModel.fromJson(Map<String, dynamic> json) => _$LoginReqModelFromJson(json);

}
