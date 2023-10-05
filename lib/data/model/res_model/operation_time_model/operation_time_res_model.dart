
import 'package:freezed_annotation/freezed_annotation.dart';
part 'operation_time_res_model.freezed.dart';
part 'operation_time_res_model.g.dart';



@freezed
class OperationTimeResModel with _$OperationTimeResModel {
  const factory OperationTimeResModel({

    int? status,

    Data? data,

    String? message,
  }) = _OperationTimeResModel;

  factory OperationTimeResModel.fromJson(Map<String, dynamic> json) => _$OperationTimeResModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({

    Clients? clients,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class Clients with _$Clients {
  const factory Clients({
    @JsonKey(name: "_id")
    String? id,

    String? email,

    dynamic password,

    String? firstName,

    String? lastName,

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
  }) = _Clients;

  factory Clients.fromJson(Map<String, dynamic> json) => _$ClientsFromJson(json);
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
  }) = _Monday;

  factory Day.fromJson(Map<String, dynamic> json) => _$DayFromJson(json);
}

