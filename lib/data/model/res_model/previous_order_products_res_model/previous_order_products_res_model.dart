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
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "message") String? message,
    @JsonKey(name: "data") List<PreviousOrderProductData>? previousProductData,
    @JsonKey(name: "metaData") MetaData? metaData,
  }) = _PreviousOrderProductsResModel;

  factory PreviousOrderProductsResModel.fromJson(Map<String, dynamic> json) =>
      _$PreviousOrderProductsResModelFromJson(json);
}

@freezed
class PreviousOrderProductData with _$PreviousOrderProductData {
  const factory PreviousOrderProductData({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "productStock") int? productStock,
    @JsonKey(name: "totalSale") int? totalSale,
    @JsonKey(name: "productPrice") double? productPrice,
    @JsonKey(name: "mainImage") String? mainImage,
    @JsonKey(name: "productName") String? productName,
  }) = _PreviousOrderProductData;

  factory PreviousOrderProductData.fromJson(Map<String, dynamic> json) =>
      _$PreviousOrderProductDataFromJson(json);
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
