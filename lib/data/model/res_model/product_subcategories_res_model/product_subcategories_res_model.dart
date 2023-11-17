// To parse this JSON data, do
//
//     final productSubcategoriesResModel = productSubcategoriesResModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'product_subcategories_res_model.freezed.dart';

part 'product_subcategories_res_model.g.dart';

ProductSubcategoriesResModel productSubcategoriesResModelFromJson(String str) =>
    ProductSubcategoriesResModel.fromJson(json.decode(str));

String productSubcategoriesResModelToJson(ProductSubcategoriesResModel data) =>
    json.encode(data.toJson());

@freezed
class ProductSubcategoriesResModel with _$ProductSubcategoriesResModel {
  const factory ProductSubcategoriesResModel({
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "data") Data? data,
    @JsonKey(name: "message") String? message,
  }) = _ProductSubcategoriesResModel;

  factory ProductSubcategoriesResModel.fromJson(Map<String, dynamic> json) =>
      _$ProductSubcategoriesResModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    @JsonKey(name: "subCategories") List<SubCategory>? subCategories,
    @JsonKey(name: "totalRecords") int? totalRecords,
    @JsonKey(name: "totalPages") int? totalPages,
    @JsonKey(name: "currentPage") int? currentPage,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class SubCategory with _$SubCategory {
  const factory SubCategory({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "subCategoryName") String? subCategoryName,
    @JsonKey(name: "parentCategoryId") String? parentCategoryId,
    @JsonKey(name: "createdAt") DateTime? createdAt,
    @JsonKey(name: "updatedAt") DateTime? updatedAt,
    @JsonKey(name: "__v") int? v,
  }) = _SubCategory;

  factory SubCategory.fromJson(Map<String, dynamic> json) =>
      _$SubCategoryFromJson(json);
}
