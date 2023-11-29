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
    @JsonKey(name: "productPrice") int? productPrice,
    @JsonKey(name: "productStock") int? productStock,
  }) = _SupplierProductDatum;

  factory SupplierProductDatum.fromJson(Map<String, dynamic> json) =>
      _$SupplierProductDatumFromJson(json);
}
