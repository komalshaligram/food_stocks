// To parse this JSON data, do
//
//     final profileDetailsResModel = profileDetailsResModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'profile_details_res_model.freezed.dart';

part 'profile_details_res_model.g.dart';

ProfileDetailsResModel profileDetailsResModelFromJson(String str) =>
    ProfileDetailsResModel.fromJson(json.decode(str));

String profileDetailsResModelToJson(ProfileDetailsResModel data) =>
    json.encode(data.toJson());

@freezed
class ProfileDetailsResModel with _$ProfileDetailsResModel {
  const factory ProfileDetailsResModel({
    int? status,
    Data? data,
    String? message,
  }) = _ProfileDetailsResModel;

  factory ProfileDetailsResModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileDetailsResModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    List<Client>? clients,
    int? totalRecords,
    int? totalPages,
    int? currentPage,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class Client with _$Client {
  const factory Client({
    @JsonKey(name: "_id") String? id,
    String? email,
    String? phoneNumber,
    String? address,
    String? contactName,
    String? logo,
    String? adminTypeId,
    ClientDetail? clientDetail,
    DateTime? updatedAt,
    RoleDetails? roleDetails,
    City? city,
    Status? status,
  }) = _Client;

  factory Client.fromJson(Map<String, dynamic> json) => _$ClientFromJson(json);
}

@freezed
class City with _$City {
  const factory City({
    @JsonKey(name: "_id") String? id,
    String? cityName,
  }) = _City;

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);
}

@freezed
class ClientDetail with _$ClientDetail {
  const factory ClientDetail({
    int? bussinessId,
    String? bussinessName,
    String? ownerName,
    String? clientTypeId,
    String? israelId,
    String? tokenId,
    String? fax,
    DateTime? lastSeen,
    String? monthlyCredits,
    String? applicationVersion,
    String? deviceType,
    List<OperationTime>? operationTime,
    String? personalGuarantee,
    String? promissoryNote,
    String? businessCertificate,
    String? israelIdImage,
    @JsonKey(name: "_id") String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<ClientType>? clientTypes,
    String? totalExpense,
    String? expenseByMonth,
  }) = _ClientDetail;

  factory ClientDetail.fromJson(Map<String, dynamic> json) =>
      _$ClientDetailFromJson(json);
}

@freezed
class ClientType with _$ClientType {
  const factory ClientType({
    @JsonKey(name: "_id") String? id,
    String? businessType,
    String? createdBy,
    String? updatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    @JsonKey(name: "__v") int? v,
  }) = _ClientType;

  factory ClientType.fromJson(Map<String, dynamic> json) =>
      _$ClientTypeFromJson(json);
}

@freezed
class OperationTime with _$OperationTime {
  const factory OperationTime({
    @JsonKey(name: "Monday") List<Monday>? monday,
  }) = _OperationTime;

  factory OperationTime.fromJson(Map<String, dynamic> json) =>
      _$OperationTimeFromJson(json);
}

@freezed
class Monday with _$Monday {
  const factory Monday({
    String? from,
    String? until,
  }) = _Monday;

  factory Monday.fromJson(Map<String, dynamic> json) => _$MondayFromJson(json);
}

@freezed
class RoleDetails with _$RoleDetails {
  const factory RoleDetails({
    String? adminType,
    String? status,
  }) = _RoleDetails;

  factory RoleDetails.fromJson(Map<String, dynamic> json) =>
      _$RoleDetailsFromJson(json);
}

@freezed
class Status with _$Status {
  const factory Status({
    @JsonKey(name: "_id") String? id,
    String? statusName,
  }) = _Status;

  factory Status.fromJson(Map<String, dynamic> json) => _$StatusFromJson(json);
}
