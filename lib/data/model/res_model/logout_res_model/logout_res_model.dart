// To parse this JSON data, do
//
//     final logoutResModel = logoutResModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'logout_res_model.freezed.dart';

part 'logout_res_model.g.dart';

LogoutResModel logoutResModelFromJson(String str) =>
    LogoutResModel.fromJson(json.decode(str));

String logoutResModelToJson(LogoutResModel data) => json.encode(data.toJson());

@freezed
class LogoutResModel with _$LogoutResModel {
  const factory LogoutResModel({
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "message") String? message,
  }) = _LogoutResModel;

  factory LogoutResModel.fromJson(Map<String, dynamic> json) =>
      _$LogoutResModelFromJson(json);
}
