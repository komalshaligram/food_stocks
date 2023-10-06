
import 'package:freezed_annotation/freezed_annotation.dart';
part 'operation_time_res_model.freezed.dart';
part 'operation_time_res_model.g.dart';


@freezed
class OperationTimeResModel with _$OperationTimeResModel {
  const factory OperationTimeResModel({
    @JsonKey(name: "status")
    int? status,
    @JsonKey(name: "data")
    Data? data,
    @JsonKey(name: "message")
    String? message,
  }) = _OperationTimeResModel;

  factory OperationTimeResModel.fromJson(Map<String, dynamic> json) => _$OperationTimeResModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    @JsonKey(name: "client")
    Client? client,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class Client with _$Client {
  const factory Client({
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "email")
    String? email,
    @JsonKey(name: "password")
    dynamic password,
    @JsonKey(name: "phoneNumber")
    String? phoneNumber,
    @JsonKey(name: "address")
    String? address,
    @JsonKey(name: "cityId")
    String? cityId,
    @JsonKey(name: "contactName")
    String? contactName,
    @JsonKey(name: "statusId")
    String? statusId,
    @JsonKey(name: "logo")
    String? logo,
    @JsonKey(name: "profileImage")
    String? profileImage,
    @JsonKey(name: "adminTypeId")
    String? adminTypeId,
    @JsonKey(name: "clientDetail")
    ClientDetail? clientDetail,
    @JsonKey(name: "createdBy")
    String? createdBy,
    @JsonKey(name: "updatedBy")
    String? updatedBy,
    @JsonKey(name: "isDeleted")
    bool? isDeleted,
    @JsonKey(name: "createdAt")
    DateTime? createdAt,
    @JsonKey(name: "updatedAt")
    DateTime? updatedAt,
    @JsonKey(name: "__v")
    int? v,
  }) = _Client;

  factory Client.fromJson(Map<String, dynamic> json) => _$ClientFromJson(json);
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
    String? israelId,
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
    List<OperationTime>? operationTime,
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "createdAt")
    DateTime? createdAt,
    @JsonKey(name: "updatedAt")
    DateTime? updatedAt,
  }) = _ClientDetail;

  factory ClientDetail.fromJson(Map<String, dynamic> json) => _$ClientDetailFromJson(json);
}

@freezed
class OperationTime with _$OperationTime {
  const factory OperationTime({
    List<Day>? sunday,

    List<Day>? monday,

    List<Day>? tuesday,

    List<Day>? wednesday,

    List<Day>? thursday,

    List<Day>? fridayAndHolidayEves,

    List<Day>? saturdayAndHolidays,
  }) = _OperationTime;

  factory OperationTime.fromJson(Map<String, dynamic> json) => _$OperationTimeFromJson(json);
}

@freezed
class Day with _$Day {
  const factory Day({
    @JsonKey(name: "from")
    String? from,
    @JsonKey(name: "until")
    String? until,
  }) = _Day;

  factory Day.fromJson(Map<String, dynamic> json) => _$DayFromJson(json);
}


