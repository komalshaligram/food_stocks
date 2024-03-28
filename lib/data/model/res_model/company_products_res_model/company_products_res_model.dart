// To parse this JSON data, do
//
//     final companyProductsResModel = companyProductsResModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'company_products_res_model.freezed.dart';

part 'company_products_res_model.g.dart';

CompanyProductsResModel companyProductsResModelFromJson(String str) =>
    CompanyProductsResModel.fromJson(json.decode(str));

String companyProductsResModelToJson(CompanyProductsResModel data) =>
    json.encode(data.toJson());

@freezed
class CompanyProductsResModel with _$CompanyProductsResModel {
  const factory CompanyProductsResModel({
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "data") List<CompanyData>? data,
    @JsonKey(name: "metaData") MetaData? metaData,
    @JsonKey(name: "message") String? message,
  }) = _CompanyProductsResModel;

  factory CompanyProductsResModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyProductsResModelFromJson(json);
}

@freezed
class CompanyData with _$CompanyData {
  const factory CompanyData({
    @JsonKey(name: "numberOfUnit") String? numberOfUnit,
    @JsonKey(name: "itemsWeight") String? itemsWeight,
    @JsonKey(name: "totalWeightCardboard") String? totalWeightCardboard,
    @JsonKey(name: "totalWeightSurface") String? totalWeightSurface,
    @JsonKey(name: "totalWeight") String? totalWeight,
    @JsonKey(name: "createdAt") String? createdAt,
    @JsonKey(name: "updatedAt") String? updatedAt,
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "productName") String? productName,
    @JsonKey(name: "brandId") String? brandId,
    @JsonKey(name: "brandLogo") String? brandLogo,
    @JsonKey(name: "manufactureName") String? manufactureName,
    @JsonKey(name: "healthAndLifestye") String? healthAndLifestye,
    @JsonKey(name: "productDescription") String? productDescription,
    @JsonKey(name: "component") String? component,
    @JsonKey(name: "nutritionalValue") String? nutritionalValue,
    @JsonKey(name: "mainImage") String? mainImage,
    @JsonKey(name: "images") List<Image>? images,
    @JsonKey(name: "qrcode") String? qrcode,
    @JsonKey(name: "sku") String? sku,
    @JsonKey(name: "categories") String? categories,
    @JsonKey(name: "subcategories") String? subcategories,
   // @JsonKey(name: "subsubcategories") String? subsubcategories,
    @JsonKey(name: "manufacturingCountry") String? manufacturingCountry,
    @JsonKey(name: "productType") String? productType,
    @JsonKey(name: "caseType") String? caseType,
    @JsonKey(name: "scale") String? scale,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "totalSale") int? totalSale,
    @JsonKey(name: "productStock") dynamic productStock,
    @JsonKey(name: "productPrice") double? productPrice,
    @JsonKey(name: "isPesach") bool? isPesach,
    @JsonKey(name: "nmMashlim") String? nmMashlim,
    String? lowStock,
  }) = _CompanyData;

  factory CompanyData.fromJson(Map<String, dynamic> json) =>
      _$CompanyDataFromJson(json);
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
class MetaData with _$MetaData {
  const factory MetaData({
    @JsonKey(name: "currentPage") int? currentPage,
    @JsonKey(name: "totalFilteredCount") int? totalFilteredCount,
    @JsonKey(name: "totalFilteredPage") int? totalFilteredPage,
  }) = _MetaData;

  factory MetaData.fromJson(Map<String, dynamic> json) =>
      _$MetaDataFromJson(json);
}
