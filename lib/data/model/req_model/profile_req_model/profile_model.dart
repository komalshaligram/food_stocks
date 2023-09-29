// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

@freezed
class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    @JsonKey(name: "status")
    int? status,
    @JsonKey(name: "data")
    Data? data,
    @JsonKey(name: "message")
    String? message,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => _$ProfileModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    @JsonKey(name: "ClientData")
    ClientData? clientData,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class ClientData with _$ClientData {
  const factory ClientData({
    @JsonKey(name: "email")
    String? email,
    @JsonKey(name: "password")
    dynamic password,
    @JsonKey(name: "firstName")
    String? firstName,
    @JsonKey(name: "lastName")
    String? lastName,
    @JsonKey(name: "phoneNumber")
    String? phoneNumber,
    @JsonKey(name: "address")
    String? address,
    @JsonKey(name: "cityId")
    String? cityId,
    @JsonKey(name: "contactName")
    String? contactName,
    @JsonKey(name: "statusId")
    String? statusId,
    @JsonKey(name: "logo")
    String? logo,
    @JsonKey(name: "profileImage")
    String? profileImage,
    @JsonKey(name: "adminTypeId")
    String? adminTypeId,
    @JsonKey(name: "clientDetail")
    ClientDetail? clientDetail,
    @JsonKey(name: "createdBy")
    String? createdBy,
    @JsonKey(name: "updatedBy")
    String? updatedBy,
    @JsonKey(name: "isDeleted")
    bool? isDeleted,
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "createdAt")
    DateTime? createdAt,
    @JsonKey(name: "updatedAt")
    DateTime? updatedAt,
    @JsonKey(name: "__v")
    int? v,
  }) = _ClientData;

  factory ClientData.fromJson(Map<String, dynamic> json) => _$ClientDataFromJson(json);
}

@freezed
class ClientDetail with _$ClientDetail {
  const factory ClientDetail({
    @JsonKey(name: "bussinessId")
    int? bussinessId,
    @JsonKey(name: "bussinessName")
    String? bussinessName,
    @JsonKey(name: "ownerName")
    String? ownerName,
    @JsonKey(name: "clientTypeId")
    String? clientTypeId,
    @JsonKey(name: "israelId")
    String? israelId,
    @JsonKey(name: "tokenId")
    String? tokenId,
    @JsonKey(name: "fax")
    String? fax,
    @JsonKey(name: "lastSeen")
    DateTime? lastSeen,
    @JsonKey(name: "monthlyCredits")
    int? monthlyCredits,
    @JsonKey(name: "applicationVersion")
    String? applicationVersion,
    @JsonKey(name: "deviceType")
    String? deviceType,
    @JsonKey(name: "operationTime")
    List<OperationTime>? operationTime,
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "createdAt")
    DateTime? createdAt,
    @JsonKey(name: "updatedAt")
    DateTime? updatedAt,
  }) = _ClientDetail;

  factory ClientDetail.fromJson(Map<String, dynamic> json) => _$ClientDetailFromJson(json);
}

@freezed
class OperationTime with _$OperationTime {
  const factory OperationTime({
    @JsonKey(name: "Monday")
    List<Monday>? monday,
  }) = _OperationTime;

  factory OperationTime.fromJson(Map<String, dynamic> json) => _$OperationTimeFromJson(json);
}

@freezed
class Monday with _$Monday {
  const factory Monday({
    @JsonKey(name: "from")
    String? from,
    @JsonKey(name: "unitl")
    String? unitl,
  }) = _Monday;

  factory Monday.fromJson(Map<String, dynamic> json) => _$MondayFromJson(json);
}
