// To parse this JSON data, do
//
//     final updatePermissionModel = updatePermissionModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'update_permission_model.freezed.dart';
part 'update_permission_model.g.dart';

UpdatePermissionModel updatePermissionModelFromJson(String str) => UpdatePermissionModel.fromJson(json.decode(str));

String updatePermissionModelToJson(UpdatePermissionModel data) => json.encode(data.toJson());

@Freezed(makeCollectionsUnmodifiable: false)
class UpdatePermissionModel with _$UpdatePermissionModel {
  const factory UpdatePermissionModel({
    @JsonKey(name: "accountPermissions")
    AccountPermissions? accountPermissions,
    @JsonKey(name: "categoryPermissions")
    List<CategoryPermission>? categoryPermissions,
    @JsonKey(name: "brandPermissions")
    List<BrandPermission>? brandPermissions,
    @JsonKey(name: "supplierPermissions")
    List<SupplierPermission>? supplierPermissions,
  }) = _UpdatePermissionModel;

  factory UpdatePermissionModel.fromJson(Map<String, dynamic> json) => _$UpdatePermissionModelFromJson(json);
}

@freezed
class AccountPermissions with _$AccountPermissions {
  const factory AccountPermissions({
    @JsonKey(name: "accountAdmin")
    bool? accountAdmin,
    @JsonKey(name: "canSeeWallet")
    bool? canSeeWallet,
    @JsonKey(name: "canCreateOrder")
    bool? canCreateOrder,
    @JsonKey(name: "canAddToCart")
    bool? canAddToCart,
    @JsonKey(name: "canSeeOrders")
    bool? canSeeOrders,
    @JsonKey(name: "canApproveOrders")
    bool? canApproveOrders,
    @JsonKey(name: "canDuplicateOrders")
    bool? canDuplicateOrders,
    @JsonKey(name: "canSeeAndUpdateBusinessInfo")
    bool? canSeeAndUpdateBusinessInfo,
    @JsonKey(name: "canSeeAndUpdateAdditionalInfo")
    bool? canSeeAndUpdateAdditionalInfo,
    @JsonKey(name: "canSeeFileAndForms")
    bool? canSeeFileAndForms,
    @JsonKey(name: "canManageSubUsers")
    bool? canManageSubUsers,
    bool? canSeeAndUpdateTimesInfo,
    bool? canSeeInvoices,
  }) = _AccountPermissions;

  factory AccountPermissions.fromJson(Map<String, dynamic> json) => _$AccountPermissionsFromJson(json);
}

@freezed
class BrandPermission with _$BrandPermission {
  const factory BrandPermission({
    @JsonKey(name: "brandId")
    String? brandId,
    @JsonKey(name: "isAllowed")
    bool? isAllowed,
  }) = _BrandPermission;

  factory BrandPermission.fromJson(Map<String, dynamic> json) => _$BrandPermissionFromJson(json);
}

@freezed
class CategoryPermission with _$CategoryPermission {
  const factory CategoryPermission({
    @JsonKey(name: "categoryId")
    String? categoryId,
    @JsonKey(name: "isAllowed")
    bool? isAllowed,
    @JsonKey(name: "subCategories")
    List<SubCategory>? subCategories,
  }) = _CategoryPermission;

  factory CategoryPermission.fromJson(Map<String, dynamic> json) => _$CategoryPermissionFromJson(json);
}

@freezed
class SubCategory with _$SubCategory {
  const factory SubCategory({
    @JsonKey(name: "subCategoryId")
    String? subCategoryId,
    @JsonKey(name: "isAllowed")
    bool? isAllowed,
  }) = _SubCategory;

  factory SubCategory.fromJson(Map<String, dynamic> json) => _$SubCategoryFromJson(json);
}

@freezed
class SupplierPermission with _$SupplierPermission {
  const factory SupplierPermission({
    @JsonKey(name: "supplierId")
    String? supplierId,
    @JsonKey(name: "isAllowed")
    bool? isAllowed,
  }) = _SupplierPermission;

  factory SupplierPermission.fromJson(Map<String, dynamic> json) => _$SupplierPermissionFromJson(json);
}
