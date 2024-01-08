
import 'package:freezed_annotation/freezed_annotation.dart';
part 'activity_time_res_model.freezed.dart';
part 'activity_time_res_model.g.dart';


@freezed
class ActivityTimeResModel with _$ActivityTimeResModel{
  const factory ActivityTimeResModel({

    int? status,

    Data? data,

    String? message,
  }) = _ActivityTimeResModel;

  factory ActivityTimeResModel.fromJson(Map<String, dynamic> json) => _$ActivityTimeResModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({

    Client? client,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class Client with _$Client {
  const factory Client({
    @JsonKey(name: "_id")
    String? id,

    String? email,

    dynamic password,

    String? phoneNumber,

    String? address,

    String? cityId,

    String? contactName,

    String? statusId,

    String? logo,

    String? profileImage,

    String? adminTypeId,

    ClientDetail? clientDetail,

    String? createdBy,

    String? updatedBy,

    bool? isDeleted,

    DateTime? createdAt,

    DateTime? updatedAt,
    @JsonKey(name: "__v")
    int? v,
  }) = _Client;

  factory Client.fromJson(Map<String, dynamic> json) => _$ClientFromJson(json);
}

@freezed
class ClientDetail with _$ClientDetail {
  const factory ClientDetail({

    int? bussinessId,

    String? bussinessName,

    String? ownerName,

    String? clientTypeId,

    String? israelId,

    String? tokenId,

    String? fax,

    DateTime? lastSeen,

    int? monthlyCredits,

    String? applicationVersion,

    String? deviceType,

    List<OperationTime>? operationTime,
    @JsonKey(name: "_id")
    String? id,

    DateTime? createdAt,

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

    String? from,

    String? until,
  }) = _Day;

  factory Day.fromJson(Map<String, dynamic> json) => _$DayFromJson(json);
}


