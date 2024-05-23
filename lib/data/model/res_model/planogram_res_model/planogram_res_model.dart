// To parse this JSON data, do
//
//     final planogramResModel = planogramResModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'planogram_res_model.freezed.dart';

part 'planogram_res_model.g.dart';

PlanogramResModel planogramResModelFromJson(String str) =>
    PlanogramResModel.fromJson(json.decode(str));

String planogramResModelToJson(PlanogramResModel data) =>
    json.encode(data.toJson());

@freezed
class PlanogramResModel with _$PlanogramResModel {
  const factory PlanogramResModel({
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "data") List<PlanogramDatum>? data,
    @JsonKey(name: "metaData") MetaData? metaData,
    @JsonKey(name: "message") String? message,
  }) = _PlanogramResModel;

  factory PlanogramResModel.fromJson(Map<String, dynamic> json) =>
      _$PlanogramResModelFromJson(json);
}

@freezed
class PlanogramDatum with _$PlanogramDatum {
  const factory PlanogramDatum({
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
    @JsonKey(name: "isPesach")
    required bool isPesach,
    @JsonKey(name: "nmMashlim")
    required String nmMashlim,
    @JsonKey(name: "mainImage")
    required String mainImage,
    @JsonKey(name: "productName")
    required String productName,
    @JsonKey(name: "order")
    required int order,
    @JsonKey(name: "numberOfUnit")
    required int numberOfUnit,
    @JsonKey(name: "sale")
    required Sale sale,
  }) = _PlanogramDatum;

  factory PlanogramDatum.fromJson(Map<String, dynamic> json) =>
      _$PlanogramDatumFromJson(json);
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
class Planogramproduct with _$Planogramproduct {
  const factory Planogramproduct({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "productStock") double? productStock,
    @JsonKey(name: "totalSale") int? totalSale,
    @JsonKey(name: "productPrice") double? productPrice,
    @JsonKey(name: "mainImage") String? mainImage,
    @JsonKey(name: "productName") String? productName,
    @JsonKey(name: "order") int? order,
    @JsonKey(name: "isPesach") bool? isPesach,
    @JsonKey(name: "nmMashlim") String? nmMashlim,
    int? numberOfUnit,
    String? lowStock,
  }) = _Planogramproduct;

  factory Planogramproduct.fromJson(Map<String, dynamic> json) =>
      _$PlanogramproductFromJson(json);
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
