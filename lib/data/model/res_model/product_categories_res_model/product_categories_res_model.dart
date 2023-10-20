// To parse this JSON data, do
//
//     final productCategoriesResModel = productCategoriesResModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'product_categories_res_model.freezed.dart';

part 'product_categories_res_model.g.dart';

ProductCategoriesResModel productCategoriesResModelFromJson(String str) =>
    ProductCategoriesResModel.fromJson(json.decode(str));

String productCategoriesResModelToJson(ProductCategoriesResModel data) =>
    json.encode(data.toJson());

@freezed
class ProductCategoriesResModel with _$ProductCategoriesResModel {
  const factory ProductCategoriesResModel({
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "data") Data? data,
    @JsonKey(name: "message") String? message,
  }) = _ProductCategoriesResModel;

  factory ProductCategoriesResModel.fromJson(Map<String, dynamic> json) =>
      _$ProductCategoriesResModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    @JsonKey(name: "Categories") List<Category>? categories,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class Category with _$Category {
  const factory Category({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "categoryName") String? categoryName,
    @JsonKey(name: "createdAt") DateTime? createdAt,
    @JsonKey(name: "updatedAt") DateTime? updatedAt,
    @JsonKey(name: "__v") int? v,
    @JsonKey(name: "categoryImage") String? categoryImage,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}
