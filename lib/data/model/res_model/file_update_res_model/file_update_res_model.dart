// To parse this JSON data, do
//
//     final fileUpdateResModel = fileUpdateResModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'file_update_res_model.freezed.dart';

part 'file_update_res_model.g.dart';

FileUpdateResModel fileUpdateResModelFromJson(String str) =>
    FileUpdateResModel.fromJson(json.decode(str));

String fileUpdateResModelToJson(FileUpdateResModel data) =>
    json.encode(data.toJson());

@freezed
class FileUpdateResModel with _$FileUpdateResModel {
  const factory FileUpdateResModel({
   int? status,
   Data? data,
   String? message,
  }) = _FileUpdateResModel;

  factory FileUpdateResModel.fromJson(Map<String, dynamic> json) =>
      _$FileUpdateResModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    @JsonKey(name: "client") Client? client,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class Client with _$Client {
  const factory Client({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "password") dynamic password,
    @JsonKey(name: "phoneNumber") String? phoneNumber,
    @JsonKey(name: "address") String? address,
    @JsonKey(name: "cityId") String? cityId,
    @JsonKey(name: "contactName") String? contactName,
    @JsonKey(name: "statusId") String? statusId,
    @JsonKey(name: "logo") String? logo,
    @JsonKey(name: "profileImage") String? profileImage,
    @JsonKey(name: "adminTypeId") String? adminTypeId,
    @JsonKey(name: "clientDetail") ClientDetail? clientDetail,
    @JsonKey(name: "createdBy") String? createdBy,
    @JsonKey(name: "updatedBy") String? updatedBy,
    @JsonKey(name: "isDeleted") bool? isDeleted,
    @JsonKey(name: "createdAt") DateTime? createdAt,
    @JsonKey(name: "updatedAt") DateTime? updatedAt,
    @JsonKey(name: "__v") int? v,
  }) = _Client;

  factory Client.fromJson(Map<String, dynamic> json) => _$ClientFromJson(json);
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
