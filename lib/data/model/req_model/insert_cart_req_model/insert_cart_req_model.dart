// To parse this JSON data, do
//
//     final insertCartReqModel = insertCartReqModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'insert_cart_req_model.freezed.dart';

part 'insert_cart_req_model.g.dart';

InsertCartReqModel insertCartReqModelFromJson(String str) =>
    InsertCartReqModel.fromJson(json.decode(str));

String insertCartReqModelToJson(InsertCartReqModel data) =>
    json.encode(data.toJson());

@freezed
class InsertCartReqModel with _$InsertCartReqModel {
  const factory InsertCartReqModel({
    @JsonKey(name: "products") List<Product>? products,
  }) = _InsertCartReqModel;

  factory InsertCartReqModel.fromJson(Map<String, dynamic> json) =>
      _$InsertCartReqModelFromJson(json);
}

@freezed
class Product with _$Product {
  const factory Product({
    @JsonKey(name: "productId") String? productId,
    @JsonKey(name: "quantity") int? quantity,
    @JsonKey(name: "supplierId") String? supplierId,
    @JsonKey(name: "saleId") String? saleId,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}
