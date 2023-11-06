// To parse this JSON data, do
//
//     final productSubcategoriesReqModel = productSubcategoriesReqModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'product_subcategories_req_model.freezed.dart';

part 'product_subcategories_req_model.g.dart';

ProductSubcategoriesReqModel productSubcategoriesReqModelFromJson(String str) =>
    ProductSubcategoriesReqModel.fromJson(json.decode(str));

String productSubcategoriesReqModelToJson(ProductSubcategoriesReqModel data) =>
    json.encode(data.toJson());

@freezed
class ProductSubcategoriesReqModel with _$ProductSubcategoriesReqModel {
  const factory ProductSubcategoriesReqModel({
    @JsonKey(name: "parentCategoryId") String? parentCategoryId,
    @JsonKey(name: "pageNum") int? pageNum,
    @JsonKey(name: "pageLimit") int? pageLimit,
  }) = _ProductSubcategoriesReqModel;

  factory ProductSubcategoriesReqModel.fromJson(Map<String, dynamic> json) =>
      _$ProductSubcategoriesReqModelFromJson(json);
}
