// To parse this JSON data, do
//
//     final productStockVerifyResModel = productStockVerifyResModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'product_stock_verify_res_model.freezed.dart';

part 'product_stock_verify_res_model.g.dart';

ProductStockVerifyResModel productStockVerifyResModelFromJson(String str) =>
    ProductStockVerifyResModel.fromJson(json.decode(str));

String productStockVerifyResModelToJson(ProductStockVerifyResModel data) =>
    json.encode(data.toJson());

@freezed
class ProductStockVerifyResModel with _$ProductStockVerifyResModel {
  const factory ProductStockVerifyResModel({
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "data") ProductStockVerifyResModelData? data,
    @JsonKey(name: "message") String? message,
  }) = _ProductStockVerifyResModel;

  factory ProductStockVerifyResModel.fromJson(Map<String, dynamic> json) =>
      _$ProductStockVerifyResModelFromJson(json);
}

@freezed
class ProductStockVerifyResModelData with _$ProductStockVerifyResModelData {
  const factory ProductStockVerifyResModelData({
    @JsonKey(name: "stock") List<Stock>? stock,
  }) = _ProductStockVerifyResModelData;

  factory ProductStockVerifyResModelData.fromJson(Map<String, dynamic> json) =>
      _$ProductStockVerifyResModelDataFromJson(json);
}

@freezed
class Stock with _$Stock {
  const factory Stock({
    @JsonKey(name: "message") String? message,
    @JsonKey(name: "data") StockData? data,
  }) = _Stock;

  factory Stock.fromJson(Map<String, dynamic> json) => _$StockFromJson(json);
}

@freezed
class StockData with _$StockData {
  const factory StockData({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "productStock") int? productStock,
    @JsonKey(name: "productPrice") int? productPrice,
    @JsonKey(name: "supplierId") String? supplierId,
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "contactName") String? contactName,
  }) = _StockData;

  factory StockData.fromJson(Map<String, dynamic> json) =>
      _$StockDataFromJson(json);
}
