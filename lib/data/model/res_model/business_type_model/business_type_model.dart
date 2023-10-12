// To parse this JSON data, do
//
//     final businessTypeModel = businessTypeModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'business_type_model.freezed.dart';

part 'business_type_model.g.dart';

BusinessTypeModel businessTypeModelFromJson(String str) =>
    BusinessTypeModel.fromJson(json.decode(str));

String businessTypeModelToJson(BusinessTypeModel data) =>
    json.encode(data.toJson());

@freezed
class BusinessTypeModel with _$BusinessTypeModel {
  const factory BusinessTypeModel({
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "data") Data? data,
    @JsonKey(name: "message") String? message,
  }) = _BusinessTypeModel;

  factory BusinessTypeModel.fromJson(Map<String, dynamic> json) => _$BusinessTypeModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    @JsonKey(name: "ClientTypes") List<ClientType>? clientTypes,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
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

  factory ClientType.fromJson(Map<String, dynamic> json) => _$ClientTypeFromJson(json);
}
