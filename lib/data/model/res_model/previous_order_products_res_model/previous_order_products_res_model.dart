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
    @JsonKey(name: "_id") String? id,
     double? productStock,
     int? totalSale,
     double? productPrice,
     String? mainImage,
    String? productName,
    int? numberOfUnit,
    String? lowStock,
    bool? isPesach,
   String? nmMashlim,
  }) = _PreviousOrderProductData;

  factory PreviousOrderProductData.fromJson(Map<String, dynamic> json) =>
      _$PreviousOrderProductDataFromJson(json);
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
