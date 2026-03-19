import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'get_sub_user_res_model.freezed.dart';
part 'get_sub_user_res_model.g.dart';

GetSubUserResModel getSubUserResModelFromJson(String str) => GetSubUserResModel.fromJson(json.decode(str));

String getSubUserResModelToJson(GetSubUserResModel data) => json.encode(data.toJson());

@freezed
class GetSubUserResModel with _$GetSubUserResModel {
  const factory GetSubUserResModel({
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "data") Data? data,
    @JsonKey(name: "message") String? message,
  }) = _GetSubUserResModel;

  factory GetSubUserResModel.fromJson(Map<String, dynamic> json) => _$GetSubUserResModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    @JsonKey(name: "users") List<User>? users,
    @JsonKey(name: "totalRecords") int? totalRecords,
    @JsonKey(name: "totalPages") int? totalPages,
    @JsonKey(name: "currentPage") int? currentPage,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class User with _$User {
  const factory User({
    @JsonKey(name: "adminType") AdminType? adminType,
    @JsonKey(name: "lastSeen") String? lastSeen,
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "contactName") String? contactName,
    @JsonKey(name: "createdAt") String? createdAt,
    @JsonKey(name: "updatedAt") String? updatedAt,
    @JsonKey(name: "createdBy") String? createdBy,
    @JsonKey(name: "updatedBy") String? updatedBy,
    @JsonKey(name: "israelId") String? israelId,
    @JsonKey(name: "userNumber") String? userNumber,
    @JsonKey(name: "profileImage") String? profileImage,
    @JsonKey(name: "phoneNumber") String? phoneNumber,
    @JsonKey(name: "tokenId") String? tokenId,
    @JsonKey(name: "lastSentOTP") String? lastSentOtp,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
class AdminType with _$AdminType {
  const factory AdminType({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "adminTypeName") String? adminTypeName,
    @JsonKey(name: "adminType") String? adminType,
  }) = _AdminType;

  factory AdminType.fromJson(Map<String, dynamic> json) => _$AdminTypeFromJson(json);
}
