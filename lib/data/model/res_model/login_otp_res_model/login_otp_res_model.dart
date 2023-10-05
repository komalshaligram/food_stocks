// To parse this JSON data, do
//
//     final loginOtpResModel = loginOtpResModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'login_otp_res_model.freezed.dart';

part 'login_otp_res_model.g.dart';

LoginOtpResModel loginOtpResModelFromJson(String str) =>
    LoginOtpResModel.fromJson(json.decode(str));

String loginOtpResModelToJson(LoginOtpResModel data) =>
    json.encode(data.toJson());

@freezed
class LoginOtpResModel with _$LoginOtpResModel {
  const factory LoginOtpResModel({
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "authToken") AuthToken? authToken,
    @JsonKey(name: "data") Data? data,
    @JsonKey(name: "message") String? message,
  }) = _LoginOtpResModel;

  factory LoginOtpResModel.fromJson(Map<String, dynamic> json) =>
      _$LoginOtpResModelFromJson(json);
}

@freezed
class AuthToken with _$AuthToken {
  const factory AuthToken({
    @JsonKey(name: "accessToken") String? accessToken,
    @JsonKey(name: "refreshToken") String? refreshToken,
  }) = _AuthToken;

  factory AuthToken.fromJson(Map<String, dynamic> json) =>
      _$AuthTokenFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "adminTypedata") AdminTypedata? adminTypedata,
    @JsonKey(name: "clientDetail") ClientDetail? clientDetail,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class AdminTypedata with _$AdminTypedata {
  const factory AdminTypedata({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "adminTypeName") String? adminTypeName,
    @JsonKey(name: "adminType") String? adminType,
    @JsonKey(name: "defaultType") bool? defaultType,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "permissions") List<Permission>? permissions,
  }) = _AdminTypedata;

  factory AdminTypedata.fromJson(Map<String, dynamic> json) =>
      _$AdminTypedataFromJson(json);
}

@freezed
class Permission with _$Permission {
  const factory Permission({
    @JsonKey(name: "moduleid") String? moduleid,
    @JsonKey(name: "moduleName") String? moduleName,
    @JsonKey(name: "read") bool? read,
    @JsonKey(name: "write") bool? write,
  }) = _Permission;

  factory Permission.fromJson(Map<String, dynamic> json) =>
      _$PermissionFromJson(json);
}

@freezed
class ClientDetail with _$ClientDetail {
  const factory ClientDetail({
    @JsonKey(name: "bussinessId") int? bussinessId,
    @JsonKey(name: "bussinessName") String? bussinessName,
    @JsonKey(name: "ownerName") String? ownerName,
    @JsonKey(name: "clientTypeId") String? clientTypeId,
    @JsonKey(name: "israelId") String? israelId,
    @JsonKey(name: "tokenId") String? tokenId,
    @JsonKey(name: "fax") String? fax,
    @JsonKey(name: "lastSeen") DateTime? lastSeen,
    @JsonKey(name: "monthlyCredits") int? monthlyCredits,
    @JsonKey(name: "applicationVersion") String? applicationVersion,
    @JsonKey(name: "deviceType") String? deviceType,
    @JsonKey(name: "operationTime") List<OperationTime>? operationTime,
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "createdAt") DateTime? createdAt,
    @JsonKey(name: "updatedAt") DateTime? updatedAt,
  }) = _ClientDetail;

  factory ClientDetail.fromJson(Map<String, dynamic> json) =>
      _$ClientDetailFromJson(json);
}

@freezed
class OperationTime with _$OperationTime {
  const factory OperationTime({
    @JsonKey(name: "Monday") dynamic monday,
    @JsonKey(name: "tuesday") dynamic tuesday,
    @JsonKey(name: "wednesday") dynamic wednesday,
    @JsonKey(name: "thursday") dynamic thursday,
    @JsonKey(name: "fridayAndHolidayEves") dynamic fridayAndHolidayEves,
    @JsonKey(name: "saturdayAndHolidays") dynamic saturdayAndHolidays,
    @JsonKey(name: "sunday") dynamic sunday,
  }) = _OperationTime;

  factory OperationTime.fromJson(Map<String, dynamic> json) =>
      _$OperationTimeFromJson(json);
}
