import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_res_model.freezed.dart';
part 'login_res_model.g.dart';

LoginResModel loginResModelFromJson(String str) => LoginResModel.fromJson(json.decode(str));

String loginResModelToJson(LoginResModel data) => json.encode(data.toJson());

@freezed
class LoginResModel with _$LoginResModel {
  const factory LoginResModel({
    required int status,
    required String message,
    required User user,
    required bool success,
  }) = _LoginResModel;

  factory LoginResModel.fromJson(Map<String, dynamic> json) => _$LoginResModelFromJson(json);
}

@freezed
class User with _$User {
  const factory User({
    required bool isDeleted,
    @JsonKey(name: "_id")
    required String id,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String address,
    required String cityId,
    required String contactName,
    required String statusId,
    required String logo,
    required String adminTypeId,
    required ClientDetail clientDetail,
    required String createdBy,
    required String updatedBy,
    required DateTime createdAt,
    required DateTime updatedAt,
    @JsonKey(name: "__v")
    required int v,
  }) = _User;
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
class ClientDetail with _$ClientDetail {
  const factory ClientDetail({
    required int bussinessId,
    required String bussinessName,
    required String ownerName,
    required String clientTypeId,
    required String israelId,
    required String tokenId,
    required String fax,
    required DateTime lastSeen,
    required int monthlyCredits,
    required String applicationVersion,
    required String deviceType,
    required List<OperationTime> operationTime,
    @JsonKey(name: "_id")
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ClientDetail;
  factory ClientDetail.fromJson(Map<String, dynamic> json) => _$ClientDetailFromJson(json);
}

@freezed
class OperationTime with _$OperationTime {
  const factory OperationTime({
    @JsonKey(name: "Monday")
    required List<Monday> monday,
  }) = _OperationTime;
  factory OperationTime.fromJson(Map<String, dynamic> json) => _$OperationTimeFromJson(json);
}

@freezed
class Monday with _$Monday{
  const factory Monday({
    required String from,
    required String unitl,
  }) = _Monday;
  factory Monday.fromJson(Map<String, dynamic> json) => _$MondayFromJson(json);
}
