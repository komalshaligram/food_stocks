// To parse this JSON data, do
//
//     final profileDetailsResModel = profileDetailsResModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

import '../../req_model/activity_time/activity_time_req_model.dart';

part 'profile_details_res_model.freezed.dart';
part 'profile_details_res_model.g.dart';

ProfileDetailsResModel profileDetailsResModelFromJson(String str) =>
    ProfileDetailsResModel.fromJson(json.decode(str));

String profileDetailsResModelToJson(ProfileDetailsResModel data) =>
    json.encode(data.toJson());

@freezed
class ProfileDetailsResModel with _$ProfileDetailsResModel {
  const factory ProfileDetailsResModel({
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "data") Data? data,
    @JsonKey(name: "message") String? message,
  }) = _ProfileDetailsResModel;

  factory ProfileDetailsResModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileDetailsResModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    @JsonKey(name: "clients") List<Client>? clients,
    @JsonKey(name: "totalRecords") int? totalRecords,
    @JsonKey(name: "totalPages") int? totalPages,
    @JsonKey(name: "currentPage") int? currentPage,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class Client with _$Client {
  const factory Client({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "phoneNumber") String? phoneNumber,
    @JsonKey(name: "address") String? address,
    @JsonKey(name: "contactName") String? contactName,
    @JsonKey(name: "logo") String? logo,
    @JsonKey(name: "profileImage") String? profileImage,
    @JsonKey(name: "adminTypeId") String? adminTypeId,
    @JsonKey(name: "clientDetail") ClientDetail? clientDetail,
    @JsonKey(name: "roleDetails") RoleDetails? roleDetails,
    @JsonKey(name: "city") City? city,
    @JsonKey(name: "status") Status? status,
  }) = _Client;

  factory Client.fromJson(Map<String, dynamic> json) => _$ClientFromJson(json);
}

@freezed
class City with _$City {
  const factory City({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "cityName") String? cityName,
  }) = _City;

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);
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
    // @JsonKey(name: "lastSeen") DateTime? lastSeen,
    @JsonKey(name: "monthlyCredits") String? monthlyCredits,
    @JsonKey(name: "applicationVersion") String? applicationVersion,
    @JsonKey(name: "deviceType") String? deviceType,
    @JsonKey(name: "operationTime") List<OperationTime>? operationTime,
    @JsonKey(name: "personalGuarantee") String? personalGuarantee,
    @JsonKey(name: "promissoryNote") String? promissoryNote,
    @JsonKey(name: "businessCertificate") String? businessCertificate,
    @JsonKey(name: "israelIdImage") String? israelIdImage,
    @JsonKey(name: "forms") dynamic forms,
    @JsonKey(name: "files") dynamic files,
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "createdAt") DateTime? createdAt,
    @JsonKey(name: "updatedAt") DateTime? updatedAt,
    @JsonKey(name: "clientTypes") List<ClientType>? clientTypes,
    @JsonKey(name: "totalExpense") String? totalExpense,
    @JsonKey(name: "expenseByMonth") String? expenseByMonth,
  }) = _ClientDetail;

  factory ClientDetail.fromJson(Map<String, dynamic> json) =>
      _$ClientDetailFromJson(json);
}

@freezed
class ClientType with _$ClientType {
  const factory ClientType({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "businessType") String? businessType,
    @JsonKey(name: "createdBy") String? createdBy,
    @JsonKey(name: "updatedBy") String? updatedBy,
    @JsonKey(name: "createdAt") DateTime? createdAt,
    @JsonKey(name: "updatedAt") DateTime? updatedAt,
    @JsonKey(name: "__v") int? v,
  }) = _ClientType;

  factory ClientType.fromJson(Map<String, dynamic> json) =>
      _$ClientTypeFromJson(json);
}



@freezed
class RoleDetails with _$RoleDetails {
  const factory RoleDetails({
    @JsonKey(name: "adminType") String? adminType,
    // @JsonKey(name: "status") String? status,
  }) = _RoleDetails;

  factory RoleDetails.fromJson(Map<String, dynamic> json) =>
      _$RoleDetailsFromJson(json);
}

@freezed
class Status with _$Status {
  const factory Status({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "statusName") String? statusName,
  }) = _Status;

  factory Status.fromJson(Map<String, dynamic> json) => _$StatusFromJson(json);
}
