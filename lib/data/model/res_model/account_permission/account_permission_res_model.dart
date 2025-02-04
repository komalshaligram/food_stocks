

import 'package:freezed_annotation/freezed_annotation.dart';
part 'account_permission_res_model.freezed.dart';
part 'account_permission_res_model.g.dart';



@freezed
class AccountPermissionResModel with _$AccountPermissionResModel {
  const factory AccountPermissionResModel({
    @JsonKey(name: "data")
    Data? data,
    @JsonKey(name: "status")
    int? status,
    @JsonKey(name: "message")
    String? message,
  }) = _AccountPermissionResModel;

  factory AccountPermissionResModel.fromJson(Map<String, dynamic> json) => _$AccountPermissionResModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "subUserId")
    String? subUserId,
    @JsonKey(name: "permissions")
    Permissions? permissions,
    @JsonKey(name: "createdBy")
    String? createdBy,
    @JsonKey(name: "createdAt")
    String? createdAt,
    @JsonKey(name: "updatedAt")
    String? updatedAt,
    @JsonKey(name: "__v")
    int? v,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class Permissions with _$Permissions {
  const factory Permissions({
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
    bool? canSeeReturns
  }) = _Permissions;

  factory Permissions.fromJson(Map<String, dynamic> json) => _$PermissionsFromJson(json);
}
