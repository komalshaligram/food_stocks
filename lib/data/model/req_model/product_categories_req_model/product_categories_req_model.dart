// To parse this JSON data, do
//
//     final productCategoriesReqModel = productCategoriesReqModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'product_categories_req_model.freezed.dart';

part 'product_categories_req_model.g.dart';

ProductCategoriesReqModel productCategoriesReqModelFromJson(String str) =>
    ProductCategoriesReqModel.fromJson(json.decode(str));

String productCategoriesReqModelToJson(ProductCategoriesReqModel data) =>
    json.encode(data.toJson());

@freezed
class ProductCategoriesReqModel with _$ProductCategoriesReqModel {
  const factory ProductCategoriesReqModel({
    @JsonKey(name: "pageNum") int? pageNum,
    @JsonKey(name: "pageLimit") int? pageLimit,
    @JsonKey(name: "search") String? search,
  }) = _ProductCategoriesReqModel;

  factory ProductCategoriesReqModel.fromJson(Map<String, dynamic> json) =>
      _$ProductCategoriesReqModelFromJson(json);
}
