// To parse this JSON data, do
//
//     final productStockVerifyReqModel = productStockVerifyReqModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'product_stock_verify_req_model.freezed.dart';

part 'product_stock_verify_req_model.g.dart';

ProductStockVerifyReqModel productStockVerifyReqModelFromJson(String str) =>
    ProductStockVerifyReqModel.fromJson(json.decode(str));

String productStockVerifyReqModelToJson(ProductStockVerifyReqModel data) =>
    json.encode(data.toJson());

@freezed
class ProductStockVerifyReqModel with _$ProductStockVerifyReqModel {
  const factory ProductStockVerifyReqModel({
    @JsonKey(name: "quantity") int? quantity,
    @JsonKey(name: "supplierId") List<String>? supplierId,
    @JsonKey(name: "productId") String? productId,
  }) = _ProductStockVerifyReqModel;

  factory ProductStockVerifyReqModel.fromJson(Map<String, dynamic> json) =>
      _$ProductStockVerifyReqModelFromJson(json);
}
