// To parse this JSON data, do
//
//     final suppliersResModel = suppliersResModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'suppliers_res_model.freezed.dart';

part 'suppliers_res_model.g.dart';

SuppliersResModel suppliersResModelFromJson(String str) =>
    SuppliersResModel.fromJson(json.decode(str));

String suppliersResModelToJson(SuppliersResModel data) =>
    json.encode(data.toJson());

@freezed
class SuppliersResModel with _$SuppliersResModel {
  const factory SuppliersResModel({
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "data") List<Datum>? data,
    @JsonKey(name: "metaData") MetaData? metaData,
    @JsonKey(name: "message") String? message,
  }) = _SuppliersResModel;

  factory SuppliersResModel.fromJson(Map<String, dynamic> json) =>
      _$SuppliersResModelFromJson(json);
}

@freezed
class Datum with _$Datum {
  const factory Datum({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "password") String? password,
    @JsonKey(name: "phoneNumber") String? phoneNumber,
    @JsonKey(name: "address") String? address,
    @JsonKey(name: "cityId") String? cityId,
    @JsonKey(name: "contactName") String? contactName,
    @JsonKey(name: "statusId") String? statusId,
    @JsonKey(name: "logo") String? logo,
    @JsonKey(name: "adminTypeId") String? adminTypeId,
    @JsonKey(name: "supplierDetail") SupplierDetail? supplierDetail,
    @JsonKey(name: "createdBy") String? createdBy,
    @JsonKey(name: "updatedBy") String? updatedBy,
    @JsonKey(name: "isDeleted") bool? isDeleted,
    @JsonKey(name: "createdAt") String? createdAt,
    @JsonKey(name: "updatedAt") String? updatedAt,
    @JsonKey(name: "__v") int? v,
    @JsonKey(name: "status") Status? status,
    @JsonKey(name: "fromDate") dynamic fromDate,
    @JsonKey(name: "lastSeen") String? lastSeen,
  }) = _Datum;

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
}

@freezed
class Status with _$Status {
  const factory Status({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "statusName") String? statusName,
    @JsonKey(name: "createdAt") DateTime? createdAt,
    @JsonKey(name: "updatedAt") DateTime? updatedAt,
    @JsonKey(name: "__v") int? v,
  }) = _Status;

  factory Status.fromJson(Map<String, dynamic> json) => _$StatusFromJson(json);
}

@freezed
class SupplierDetail with _$SupplierDetail {
  const factory SupplierDetail({
    @JsonKey(name: "companyIdNumber") int? companyIdNumber,
    @JsonKey(name: "companyName") String? companyName,
    @JsonKey(name: "suppliersTypeId") String? suppliersTypeId,
    @JsonKey(name: "hasImport") bool? hasImport,
    @JsonKey(name: "hasLogistics") bool? hasLogistics,
    @JsonKey(name: "hasDistribution") bool? hasDistribution,
    @JsonKey(name: "categoriesIds") List<String?>? categoriesIds,
    @JsonKey(name: "suplierPolicy") List<SuplierPolicy>? suplierPolicy,
    @JsonKey(name: "hasDistributionPolicy") bool? hasDistributionPolicy,
    @JsonKey(name: "distributionDetails")
    DistributionDetails? distributionDetails,
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "createdAt") DateTime? createdAt,
    @JsonKey(name: "updatedAt") DateTime? updatedAt,
    @JsonKey(name: "totalIncome") int? totalIncome,
    @JsonKey(name: "incomeByThisMonth") int? incomeByThisMonth,
    @JsonKey(name: "orders") int? orders,
    @JsonKey(name:"isHomePreference") bool? isHomePreference
  }) = _SupplierDetail;

  factory SupplierDetail.fromJson(Map<String, dynamic> json) =>
      _$SupplierDetailFromJson(json);
}

@freezed
class DistributionDetails with _$DistributionDetails {
  const factory DistributionDetails({
    @JsonKey(name: "center") A1? center,
    @JsonKey(name: "north") A1? north,
    @JsonKey(name: "south") A1? south,
    @JsonKey(name: "judea") A1? judea,
    @JsonKey(name: "west") A1? west,
    @JsonKey(name: "east") A1? east,
    @JsonKey(name: "A1") A1? a1,
  }) = _DistributionDetails;

  factory DistributionDetails.fromJson(Map<String, dynamic> json) =>
      _$DistributionDetailsFromJson(json);
}

@freezed
class A1 with _$A1 {
  const factory A1({
    @JsonKey(name: "Sunday") Day? sunday,
    @JsonKey(name: "Monday") Day? monday,
    @JsonKey(name: "Tuesday") Day? tuesday,
    @JsonKey(name: "Wednesday") Day? wednesday,
    @JsonKey(name: "Thursday") Day? thursday,
    @JsonKey(name: "Friday") Day? friday,
    @JsonKey(name: "Saturday") Day? saturday,
  }) = _A1;

  factory A1.fromJson(Map<String, dynamic> json) => _$A1FromJson(json);
}

@freezed
class Day with _$Day {
  const factory Day({
    @JsonKey(name: "startTime") String? startTime,
    @JsonKey(name: "endTime") String? endTime,
  }) = _Day;

  factory Day.fromJson(Map<String, dynamic> json) => _$DayFromJson(json);
}

@freezed
class SuplierPolicy with _$SuplierPolicy {
  const factory SuplierPolicy({
    @JsonKey(name: "fields") List<Field>? fields,
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "policyHeading") String? policyHeading,
    @JsonKey(name: "toggleSwitchKey") String? toggleSwitchKey,
    @JsonKey(name: "toggleSwitchValue") bool? toggleSwitchValue,
    @JsonKey(name: "updatedAt") DateTime? updatedAt,
    @JsonKey(name: "createdAt") DateTime? createdAt,
  }) = _SuplierPolicy;

  factory SuplierPolicy.fromJson(Map<String, dynamic> json) =>
      _$SuplierPolicyFromJson(json);
}

@freezed
class Field with _$Field {
  const factory Field({
    @JsonKey(name: "fieldKey") String? fieldKey,
    @JsonKey(name: "fieldType") String? fieldType,
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "value") String? value,
  }) = _Field;

  factory Field.fromJson(Map<String, dynamic> json) => _$FieldFromJson(json);
}

@freezed
class MetaData with _$MetaData {
  const factory MetaData({
    @JsonKey(name: "currentPage") int? currentPage,
    @JsonKey(name: "totalRecords") int? totalRecords,
  }) = _MetaData;

  factory MetaData.fromJson(Map<String, dynamic> json) =>
      _$MetaDataFromJson(json);
}
