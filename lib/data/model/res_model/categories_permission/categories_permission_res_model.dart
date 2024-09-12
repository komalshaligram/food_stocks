import 'package:freezed_annotation/freezed_annotation.dart';

part 'categories_permission_res_model.freezed.dart';
part 'categories_permission_res_model.g.dart';


@freezed
class CategoriesPermissionResModel with _$CategoriesPermissionResModel {
  const factory CategoriesPermissionResModel({
    @JsonKey(name: "data")
    List<CategoriesPermission>? data,
    @JsonKey(name: "status")
    int? status,
    @JsonKey(name: "message")
    String? message,
  }) = _CategoriesPermissionResModel;

  factory CategoriesPermissionResModel.fromJson(Map<String, dynamic> json) => _$CategoriesPermissionResModelFromJson(json);
}

@Freezed(makeCollectionsUnmodifiable: false)
class CategoriesPermission with _$CategoriesPermission {
  const factory CategoriesPermission({
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "categoryId")
    String? categoryId,
    @JsonKey(name: "isAllowed")
    bool? isAllowed,
    @JsonKey(name: "subCategories")
    List<SubCategory>? subCategories,
    @JsonKey(name: "category")
    Category? category,
  }) = _CategoriesPermission;

  factory CategoriesPermission.fromJson(Map<String, dynamic> json) => _$CategoriesPermissionFromJson(json);
}

@freezed
class Category with _$Category {
  const factory Category({
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "categoryName")
    String? categoryName,
    @JsonKey(name: "createdAt")
    String? createdAt,
    @JsonKey(name: "updatedAt")
    String? updatedAt,
    @JsonKey(name: "__v")
    int? v,
    @JsonKey(name: "categoryImage")
    String? categoryImage,
    @JsonKey(name: "isHomePreference")
    bool? isHomePreference,
    @JsonKey(name: "order")
    int? order,
    @JsonKey(name: "isDeleted")
    bool? isDeleted,
    @JsonKey(name: "categoryNumber")
    int? categoryNumber,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
}

@freezed
class SubCategory with _$SubCategory {
  const factory SubCategory({
    @JsonKey(name: "subCategoryId")
    String? subCategoryId,
    @JsonKey(name: "isAllowed")
    bool? isAllowed,
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "subCategoryData")
    SubCategoryData? subCategoryData,
  }) = _SubCategory;

  factory SubCategory.fromJson(Map<String, dynamic> json) => _$SubCategoryFromJson(json);
}

@freezed
class SubCategoryData with _$SubCategoryData {
  const factory SubCategoryData({
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "subCategoryName")
    String? subCategoryName,
    @JsonKey(name: "parentCategoryId")
    String? parentCategoryId,
    @JsonKey(name: "createdAt")
    String? createdAt,
    @JsonKey(name: "updatedAt")
    String? updatedAt,
    @JsonKey(name: "__v")
    int? v,
    @JsonKey(name: "isDeleted")
    bool? isDeleted,
    @JsonKey(name: "subCategoryNumber")
    int? subCategoryNumber,
  }) = _SubCategoryData;

  factory SubCategoryData.fromJson(Map<String, dynamic> json) => _$SubCategoryDataFromJson(json);
}
