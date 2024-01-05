// To parse this JSON data, do
//
//     final refreshTokenModel = refreshTokenModelFromMap(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';


part 'refresh_token_model.freezed.dart';
part 'refresh_token_model.g.dart';



@freezed
class RefreshTokenModel with _$RefreshTokenModel {
  const factory RefreshTokenModel({
    @JsonKey(name: "status")
    int? status,
    @JsonKey(name: "data")
    Data? data,
    @JsonKey(name: "message")
    String? message,
  }) = _RefreshTokenModel;

  factory RefreshTokenModel.fromJson(Map<String, dynamic> json) => _$RefreshTokenModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    @JsonKey(name: "accessToken")
    String? accessToken,
    @JsonKey(name: "refreshToken")
    String? refreshToken,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}
