// To parse this JSON data, do
//
//     final profileResModel = profileResModelFromMap(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'profile_res_model.freezed.dart';

part 'profile_res_model.g.dart';

@freezed
class ProfileResModel with _$ProfileResModel {
  const factory ProfileResModel({
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "data") Data? data,
    @JsonKey(name: "message") String? message,
  }) = _ProfileResModel;

  factory ProfileResModel.fromJson(Map<String, dynamic> json) => _$ProfileResModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    @JsonKey(name: "client") Client? client,
    @JsonKey(name: "authToken") AuthToken? authToken,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
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
class Client with _$Client {
  const factory Client({
    @JsonKey(name: "clientData") ClientData? clientData,
    @JsonKey(name: "cartId") String? cartId,
  }) = _Client;

  factory Client.fromJson(Map<String, dynamic> json) => _$ClientFromJson(json);
}

@freezed
class ClientData with _$ClientData {
  const factory ClientData({
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "password") dynamic password,
    @JsonKey(name: "firstName") String? firstName,
    @JsonKey(name: "lastName") String? lastName,
    @JsonKey(name: "phoneNumber") String? phoneNumber,
    @JsonKey(name: "address") String? address,
    @JsonKey(name: "cityId") String? cityId,
    @JsonKey(name: "contactName") String? contactName,
    @JsonKey(name: "statusId") String? statusId,
    @JsonKey(name: "logo") String? logo,
    @JsonKey(name: "profileImage") String? profileImage,
    @JsonKey(name: "adminTypeId") String? adminTypeId,
    @JsonKey(name: "clientDetail") ClientDetail? clientDetail,
    @JsonKey(name: "isDeleted") bool? isDeleted,
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "createdAt") String? createdAt,
    @JsonKey(name: "updatedAt") String? updatedAt,
    @JsonKey(name: "__v") int? v,
  }) = _ClientData;

  factory ClientData.fromJson(Map<String, dynamic> json) => _$ClientDataFromJson(json);
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
    @JsonKey(name: "lastSeen") String? lastSeen,
    @JsonKey(name: "applicationVersion") String? applicationVersion,
    @JsonKey(name: "deviceType") String? deviceType,
    @JsonKey(name: "operationTime") List<dynamic>? operationTime,
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "createdAt") String? createdAt,
    @JsonKey(name: "updatedAt") String? updatedAt,
  }) = _ClientDetail;

  factory ClientDetail.fromJson(Map<String, dynamic> json) => _$ClientDetailFromJson(json);
}