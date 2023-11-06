// To parse this JSON data, do
//
//     final productSalesReqModel = productSalesReqModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'product_sales_req_model.freezed.dart';

part 'product_sales_req_model.g.dart';

ProductSalesReqModel productSalesReqModelFromJson(String str) =>
    ProductSalesReqModel.fromJson(json.decode(str));

String productSalesReqModelToJson(ProductSalesReqModel data) =>
    json.encode(data.toJson());

@freezed
class ProductSalesReqModel with _$ProductSalesReqModel {
  const factory ProductSalesReqModel({
    @JsonKey(name: "pageNum") int? pageNum,
    @JsonKey(name: "pageLimit") int? pageLimit,
  }) = _ProductSalesReqModel;

  factory ProductSalesReqModel.fromJson(Map<String, dynamic> json) =>
      _$ProductSalesReqModelFromJson(json);
}
