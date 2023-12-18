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
    @JsonKey(name: "data") List<SupplierDatum>? data,
    @JsonKey(name: "metaData") MetaData? metaData,
    @JsonKey(name: "message") String? message,
  }) = _SupplierProductsResModel;

  factory SupplierProductsResModel.fromJson(Map<String, dynamic> json) =>
      _$SupplierProductsResModelFromJson(json);
}

@freezed
class SupplierDatum with _$SupplierDatum {
  const factory SupplierDatum({
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
    @JsonKey(name: "productStock") double? productStock,
  }) = _SupplierDatum;

  factory SupplierDatum.fromJson(Map<String, dynamic> json) =>
      _$SupplierDatumFromJson(json);
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
