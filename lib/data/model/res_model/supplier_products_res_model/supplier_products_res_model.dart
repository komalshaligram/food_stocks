// To parse this JSON data, do
//
//     final supplierProductsResModel = supplierProductsResModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'supplier_products_res_model.freezed.dart';

part 'supplier_products_res_model.g.dart';

SupplierProductsResModel supplierProductsResModelFromJson(String str) =>
    SupplierProductsResModel.fromJson(json.decode(str));

String supplierProductsResModelToJson(SupplierProductsResModel data) =>
    json.encode(data.toJson());

@freezed
class SupplierProductsResModel with _$SupplierProductsResModel {
  const factory SupplierProductsResModel({
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "data") List<Datum>? data,
    @JsonKey(name: "metaData") MetaData? metaData,
    @JsonKey(name: "message") String? message,
  }) = _SupplierProductsResModel;

  factory SupplierProductsResModel.fromJson(Map<String, dynamic> json) =>
      _$SupplierProductsResModelFromJson(json);
}

@freezed
class Datum with _$Datum {
  const factory Datum({
    @JsonKey(name: "createdAt") String? createdAt,
    @JsonKey(name: "updatedAt") String? updatedAt,
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "productName") String? productName,
    @JsonKey(name: "brandName") String? brandName,
    @JsonKey(name: "manufactureName") String? manufactureName,
    @JsonKey(name: "healthAndLifestye") String? healthAndLifestye,
    @JsonKey(name: "productDescription") String? productDescription,
    @JsonKey(name: "component") String? component,
    @JsonKey(name: "nutritionalValue") String? nutritionalValue,
    @JsonKey(name: "mainImage") String? mainImage,
    @JsonKey(name: "images") List<Image>? images,
    @JsonKey(name: "qrcode") String? qrcode,
    @JsonKey(name: "sku") String? sku,
    @JsonKey(name: "numberOfUnit") int? numberOfUnit,
    @JsonKey(name: "totalWeightCardboard") int? totalWeightCardboard,
    @JsonKey(name: "totalWeightSurface") int? totalWeightSurface,
    @JsonKey(name: "categories") String? categories,
    @JsonKey(name: "subcategories") String? subcategories,
    @JsonKey(name: "subsubcategories") String? subsubcategories,
    @JsonKey(name: "manufacturingCountry") String? manufacturingCountry,
    @JsonKey(name: "productType") String? productType,
    @JsonKey(name: "caseType") String? caseType,
    @JsonKey(name: "scale") String? scale,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "userId") String? userId,
    @JsonKey(name: "itemsWeight") dynamic itemsWeight,
    @JsonKey(name: "totalWeight") int? totalWeight,
  }) = _Datum;

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
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
