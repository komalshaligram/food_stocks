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

    String? email,

    String? phoneNumber,

    String? address,

    String? cityId,

    String? logo,

    String? contactName,

    String? profileImage,

    ClientDetail? clientDetail,

    String? createdBy,

    String? updatedBy,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => _$ProfileModelFromJson(json);
}

@freezed
class ClientDetail with _$ClientDetail {
  const factory ClientDetail({

    int? bussinessId,

    String? bussinessName,

    String? ownerName,

    String? clientTypeId,

    bool? israelId,

    String? tokenId,

    String? fax,

    DateTime? lastSeen,

    int? monthlyCredits,

    String? applicationVersion,

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
    List<Monday>? tuesday,
    List<Monday>? wednesday,
    List<Monday>? thursday,
    List<Monday>? fridayAndHolidayEves,
    List<Monday>? saturdayAndHolidays,
    List<Monday>? sunday,


  }) = _OperationTime;

  factory OperationTime.fromJson(Map<String, dynamic> json) => _$OperationTimeFromJson(json);
}

@freezed
class Monday with _$Monday {
  const factory Monday({

    String? from,

    String? unitl,
  }) = _Monday;

  factory Monday.fromJson(Map<String, dynamic> json) => _$MondayFromJson(json);
}
