import 'package:freezed_annotation/freezed_annotation.dart';
part 'login_otp_res_model.freezed.dart';
part 'login_otp_res_model.g.dart';

@freezed
class LoginOtpResModel with _$LoginOtpResModel {
  const factory LoginOtpResModel({
    @JsonKey(name: "data")
    Data? data,
    @JsonKey(name: "status")
    int? status,
    @JsonKey(name: "message")
    String? message,
  }) = _LoginOtpResModel;

  factory LoginOtpResModel.fromJson(Map<String, dynamic> json) => _$LoginOtpResModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    @JsonKey(name: "user")
    User? user,
    @JsonKey(name: "authToken")
    AuthToken? authToken,
    @JsonKey(name: "cartId")
    String? cartId,
    @JsonKey(name: "agentId")
    String? agentId,
    @JsonKey(name: "wallet")
    String? wallet,
    String? adminType,
    SubUserPermissions? subUserPermissions,

  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class AuthToken with _$AuthToken {
  const factory AuthToken({
    @JsonKey(name: "accessToken")
    String? accessToken,
    @JsonKey(name: "refreshToken")
    String? refreshToken,
  }) = _AuthToken;

  factory AuthToken.fromJson(Map<String, dynamic> json) => _$AuthTokenFromJson(json);
}

@freezed
class SubUserPermissions with _$SubUserPermissions {
  const factory SubUserPermissions({
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
    @JsonKey(name: "canSeeAndUpdateTimesInfo")
    bool? canSeeAndUpdateTimesInfo,
  }) = _SubUserPermissions;

  factory SubUserPermissions.fromJson(Map<String, dynamic> json) => _$SubUserPermissionsFromJson(json);
}

@freezed
class User with _$User {
  const factory User({
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "email")
    String? email,
    @JsonKey(name: "phoneNumber")
    String? phoneNumber,
    @JsonKey(name: "logo")
    String? logo,
    @JsonKey(name: "profileImage")
    String? profileImage,
    @JsonKey(name: "clientDetail")
    ClientDetail? clientDetail,
    String? createdBy,
    String? contactName,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
class ClientDetail with _$ClientDetail {
  const factory ClientDetail({
    @JsonKey(name: "bussinessName")
    String? bussinessName,
    @JsonKey(name: "ownerName")
    String? ownerName,
    @JsonKey(name: "lastSeen")
    String? lastSeen,
    @JsonKey(name: "monthlyCredits")
    int? monthlyCredits,
  }) = _ClientDetail;

  factory ClientDetail.fromJson(Map<String, dynamic> json) => _$ClientDetailFromJson(json);
}
