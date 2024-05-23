// To parse this JSON data, do
//
//     final previousOrderProductsResModel = previousOrderProductsResModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'previous_order_products_res_model.freezed.dart';

part 'previous_order_products_res_model.g.dart';

PreviousOrderProductsResModel previousOrderProductsResModelFromJson(
        String str) =>
    PreviousOrderProductsResModel.fromJson(json.decode(str));

String previousOrderProductsResModelToJson(
        PreviousOrderProductsResModel data) =>
    json.encode(data.toJson());

@freezed
class PreviousOrderProductsResModel with _$PreviousOrderProductsResModel {
  const factory PreviousOrderProductsResModel({
     int? status,
    String? message,
    @JsonKey(name: "data") List<PreviousOrderProductData>? previousProductData,
     MetaData? metaData,
  }) = _PreviousOrderProductsResModel;

  factory PreviousOrderProductsResModel.fromJson(Map<String, dynamic> json) =>
      _$PreviousOrderProductsResModelFromJson(json);
}

@freezed
class PreviousOrderProductData with _$PreviousOrderProductData {
  const factory PreviousOrderProductData({
    @JsonKey(name: "_id")
    required String id,
    @JsonKey(name: "productStock")
    required int productStock,
    @JsonKey(name: "totalSale")
    required int totalSale,
    @JsonKey(name: "productPrice")
    required double productPrice,
    @JsonKey(name: "boxes")
    required int boxes,
    @JsonKey(name: "lowStock")
    required String lowStock,
    @JsonKey(name: "mainImage")
    required String mainImage,
    @JsonKey(name: "isPesach")
    required bool isPesach,
    @JsonKey(name: "nmMashlim")
    required String nmMashlim,
    @JsonKey(name: "productName")
    required String productName,
    @JsonKey(name: "numberOfUnit")
    required int numberOfUnit,
    @JsonKey(name: "sale")
    required Sale sale,
  }) = _PreviousOrderProductData;

  factory PreviousOrderProductData.fromJson(Map<String, dynamic> json) =>
      _$PreviousOrderProductDataFromJson(json);
}
@freezed
class Sale with _$Sale {
  const factory Sale({
    @JsonKey(name: "isSale")
    required bool isSale,
    @JsonKey(name: "salePrice")
    required String salePrice,
    @JsonKey(name: "saleFromDate")
    required String saleFromDate,
    @JsonKey(name: "saleUntilDate")
    required String saleUntilDate,
    @JsonKey(name: "saleMaxQuantity")
    required String saleMaxQuantity,
    @JsonKey(name: "saleDescription")
    required String saleDescription,
  }) = _Sale;

  factory Sale.fromJson(Map<String, dynamic> json) => _$SaleFromJson(json);
}

@freezed
class MetaData with _$MetaData {
  const factory MetaData({
     int? currentPage,
     int? totalFilteredCount,
     int? totalFilteredPage,
  }) = _MetaData;

  factory MetaData.fromJson(Map<String, dynamic> json) =>
      _$MetaDataFromJson(json);
}
