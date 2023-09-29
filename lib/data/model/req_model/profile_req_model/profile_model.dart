// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

@freezed
class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    @JsonKey(name: "email")
    String? email,
    @JsonKey(name: "phoneNumber")
    String? phoneNumber,
    @JsonKey(name: "address")
    String? address,
    @JsonKey(name: "cityId")
    String? cityId,
    @JsonKey(name: "logo")
    String? logo,
    @JsonKey(name: "contactName")
    String? contactName,
    @JsonKey(name: "profileImage")
    String? profileImage,
    @JsonKey(name: "clientDetail")
    ClientDetail? clientDetail,
    @JsonKey(name: "createdBy")
    String? createdBy,
    @JsonKey(name: "updatedBy")
    String? updatedBy,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => _$ProfileModelFromJson(json);
}

@freezed
class ClientDetail with _$ClientDetail {
  const factory ClientDetail({
    @JsonKey(name: "bussinessId")
    int? bussinessId,
    @JsonKey(name: "bussinessName")
    String? bussinessName,
    @JsonKey(name: "ownerName")
    String? ownerName,
    @JsonKey(name: "clientTypeId")
    String? clientTypeId,
    @JsonKey(name: "israelId")
    bool? israelId,
    @JsonKey(name: "tokenId")
    String? tokenId,
    @JsonKey(name: "fax")
    String? fax,
    @JsonKey(name: "lastSeen")
    DateTime? lastSeen,
    @JsonKey(name: "monthlyCredits")
    int? monthlyCredits,
    @JsonKey(name: "applicationVersion")
    String? applicationVersion,
    @JsonKey(name: "deviceType")
    String? deviceType,
    @JsonKey(name: "operationTime")
    OperationTime? operationTime,
  }) = _ClientDetail;

  factory ClientDetail.fromJson(Map<String, dynamic> json) => _$ClientDetailFromJson(json);
}

@freezed
class OperationTime with _$OperationTime {
  const factory OperationTime({
    @JsonKey(name: "Monday")
    List<Monday>? monday,
  }) = _OperationTime;

  factory OperationTime.fromJson(Map<String, dynamic> json) => _$OperationTimeFromJson(json);
}

@freezed
class Monday with _$Monday {
  const factory Monday({
    @JsonKey(name: "from")
    String? from,
    @JsonKey(name: "unitl")
    String? unitl,
  }) = _Monday;

  factory Monday.fromJson(Map<String, dynamic> json) => _$MondayFromJson(json);
}
