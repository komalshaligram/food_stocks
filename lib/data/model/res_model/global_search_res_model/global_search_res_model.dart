// To parse this JSON data, do
//
//     final globalSearchResModel = globalSearchResModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'global_search_res_model.freezed.dart';

part 'global_search_res_model.g.dart';

GlobalSearchResModel globalSearchResModelFromJson(String str) =>
    GlobalSearchResModel.fromJson(json.decode(str));

String globalSearchResModelToJson(GlobalSearchResModel data) =>
    json.encode(data.toJson());

@freezed
class GlobalSearchResModel with _$GlobalSearchResModel {
  const factory GlobalSearchResModel({
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "data") Data? data,
    @JsonKey(name: "message") String? message,
  }) = _GlobalSearchResModel;

  factory GlobalSearchResModel.fromJson(Map<String, dynamic> json) =>
      _$GlobalSearchResModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    @JsonKey(name: "categoryData") List<CategoryDatum>? categoryData,
    @JsonKey(name: "companyData") List<CompanyDatum>? companyData,
    @JsonKey(name: "saleData") List<SaleDatum>? saleData,
    @JsonKey(name: "supplierProductData")
    List<SupplierProductDatum>? supplierProductData,
    @JsonKey(name: "supplierData") List<SupplierDatum>? supplierData,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class CategoryDatum with _$CategoryDatum {
  const factory CategoryDatum({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "categoryName") String? categoryName,
    @JsonKey(name: "createdAt") DateTime? createdAt,
    @JsonKey(name: "updatedAt") DateTime? updatedAt,
    @JsonKey(name: "__v") int? v,
    @JsonKey(name: "categoryImage") String? categoryImage,
    @JsonKey(name: "isHomePreference") bool? isHomePreference,
    @JsonKey(name: "order") int? order,
    @JsonKey(name: "isDeleted") bool? isDeleted,
  }) = _CategoryDatum;

  factory CategoryDatum.fromJson(Map<String, dynamic> json) =>
      _$CategoryDatumFromJson(json);
}

@freezed
class CompanyDatum with _$CompanyDatum {
  const factory CompanyDatum({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "brandName") String? brandName,
    @JsonKey(name: "brandLogo") String? brandLogo,
    @JsonKey(name: "isHomePreference") bool? isHomePreference,
    @JsonKey(name: "order") int? order,
    @JsonKey(name: "createdAt") DateTime? createdAt,
    @JsonKey(name: "updatedAt") DateTime? updatedAt,
    @JsonKey(name: "__v") int? v,
  }) = _CompanyDatum;

  factory CompanyDatum.fromJson(Map<String, dynamic> json) =>
      _$CompanyDatumFromJson(json);
}

@freezed
class SaleDatum with _$SaleDatum {
  const factory SaleDatum({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "category") String? category,
    @JsonKey(name: "subcategories") String? subcategories,
    @JsonKey(name: "subsubcategories") String? subsubcategories,
    @JsonKey(name: "casetypes") String? casetypes,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "sku") String? sku,
    @JsonKey(name: "brandName") String? brandName,
    @JsonKey(name: "images") List<Image>? images,
    @JsonKey(name: "mainImage") String? mainImage,
    @JsonKey(name: "numberOfUnit") String? numberOfUnit,
    @JsonKey(name: "itemsWeight") String? itemsWeight,
    @JsonKey(name: "totalWeight") String? totalWeight,
    @JsonKey(name: "productName") String? productName,
    @JsonKey(name: "createdBy") String? createdBy,
    @JsonKey(name: "updatedBy") String? updatedBy,
    @JsonKey(name: "createdAt") String? createdAt,
    @JsonKey(name: "updatedAt") String? updatedAt,
    @JsonKey(name: "salesName") String? salesName,
    @JsonKey(name: "discountPercentage") String? discountPercentage,
    @JsonKey(name: "salesDescription") String? salesDescription,
    @JsonKey(name: "fromDate") DateTime? fromDate,
    @JsonKey(name: "endDate") DateTime? endDate,
  }) = _SaleDatum;

  factory SaleDatum.fromJson(Map<String, dynamic> json) =>
      _$SaleDatumFromJson(json);
}

@freezed
class Image with _$Image {
  const factory Image({
    @JsonKey(name: "imageUrl") String? imageUrl,
    @JsonKey(name: "order") int? order,
  }) = _Image;

  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);
}

@freezed
class SupplierDatum with _$SupplierDatum {
  const factory SupplierDatum({
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
    @JsonKey(name: "lastSeen") dynamic lastSeen,
    @JsonKey(name: "status") Status? status,
    @JsonKey(name: "fromDate") dynamic fromDate,
    @JsonKey(name: "order") String? order,
    @JsonKey(name: "totalIncome") String? totalIncome,
    @JsonKey(name: "incomeByThisMonth") String? incomeByThisMonth,
    @JsonKey(name: "_idSearch") String? idSearch,
  }) = _SupplierDatum;

  factory SupplierDatum.fromJson(Map<String, dynamic> json) =>
      _$SupplierDatumFromJson(json);
}

@freezed
class Status with _$Status {
  const factory Status({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "statusName") String? statusName,
    @JsonKey(name: "createdAt") DateTime? createdAt,
    @JsonKey(name: "updatedAt") DateTime? updatedAt,
    @JsonKey(name: "__v") int? v,
    @JsonKey(name: "isDeleted") bool? isDeleted,
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
    @JsonKey(name: "categoriesIds") List<String>? categoriesIds,
    @JsonKey(name: "suplierPolicy") List<SuplierPolicy>? suplierPolicy,
    @JsonKey(name: "hasDistributionPolicy") bool? hasDistributionPolicy,
    @JsonKey(name: "distributionDetails")
    DistributionDetails? distributionDetails,
    @JsonKey(name: "order") dynamic order,
    @JsonKey(name: "isHomePreference") bool? isHomePreference,
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "createdAt") DateTime? createdAt,
    @JsonKey(name: "updatedAt") DateTime? updatedAt,
  }) = _SupplierDetail;

  factory SupplierDetail.fromJson(Map<String, dynamic> json) =>
      _$SupplierDetailFromJson(json);
}

@freezed
class DistributionDetails with _$DistributionDetails {
  const factory DistributionDetails({
    @JsonKey(name: "A1") A1? a1,
    @JsonKey(name: "center") A1? center,
    @JsonKey(name: "east") A1? east,
    @JsonKey(name: "judea") A1? judea,
    @JsonKey(name: "north") A1? north,
    @JsonKey(name: "south") A1? south,
    @JsonKey(name: "west") A1? west,
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
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "policyHeading") String? policyHeading,
    @JsonKey(name: "toggleSwitchKey") String? toggleSwitchKey,
    @JsonKey(name: "fields") List<Field>? fields,
    @JsonKey(name: "updatedAt") DateTime? updatedAt,
    @JsonKey(name: "createdAt") DateTime? createdAt,
    @JsonKey(name: "toggleSwitchValue") bool? toggleSwitchValue,
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
  }) = _Field;

  factory Field.fromJson(Map<String, dynamic> json) => _$FieldFromJson(json);
}

@freezed
class SupplierProductDatum with _$SupplierProductDatum {
  const factory SupplierProductDatum({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "category") String? category,
    @JsonKey(name: "subcategories") String? subcategories,
    @JsonKey(name: "subsubcategories") String? subsubcategories,
    @JsonKey(name: "casetypes") String? casetypes,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "sku") String? sku,
    @JsonKey(name: "brandName") String? brandName,
    @JsonKey(name: "numberOfUnit") String? numberOfUnit,
    @JsonKey(name: "productName") String? productName,
    @JsonKey(name: "mainImage") String? mainImage,
    @JsonKey(name: "itemsWeight") String? itemsWeight,
    @JsonKey(name: "totalWeight") String? totalWeight,
    @JsonKey(name: "createdBy") String? createdBy,
    @JsonKey(name: "updatedBy") String? updatedBy,
    @JsonKey(name: "createdAt") String? createdAt,
    @JsonKey(name: "updatedAt") String? updatedAt,
    @JsonKey(name: "productId") String? productId,
    @JsonKey(name: "supplierId") String? supplierId,
    @JsonKey(name: "productPrice") double? productPrice,
    @JsonKey(name: "productStock") int? productStock,
  }) = _SupplierProductDatum;

  factory SupplierProductDatum.fromJson(Map<String, dynamic> json) =>
      _$SupplierProductDatumFromJson(json);
}
