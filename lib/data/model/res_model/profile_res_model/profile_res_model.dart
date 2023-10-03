import 'package:freezed_annotation/freezed_annotation.dart';
part 'profile_res_model.freezed.dart';
part 'profile_res_model.g.dart';


@freezed
class ProfileResModel with _$ProfileResModel {
  const factory ProfileResModel({

    int? status,

    Data? data,

    String? message,
  }) = _ProfileResModel;

  factory ProfileResModel.fromJson(Map<String, dynamic> json) => _$ProfileResModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({

    ClientData? clientData,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class ClientData with _$ClientData {
  const factory ClientData({

    String? email,

    dynamic password,

    String? phoneNumber,

    String? address,

    String? cityId,

    String? contactName,

    String? statusId,

    String? logo,

    String? adminTypeId,

    @JsonKey(name: "clientDetail")
    ClientDetailRes? clientDetail,

    bool? isDeleted,
    @JsonKey(name: "_id")
    String? id,


    @JsonKey(name: "__v")
    int? v,
  }) = _ClientData;

  factory ClientData.fromJson(Map<String, dynamic> json) => _$ClientDataFromJson(json);
}

@freezed
class ClientDetailRes with _$ClientDetailRes {
  const factory ClientDetailRes({

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
    @JsonKey(name: "operationTime")
    List<OperationTimeRes>? operationTime,
    @JsonKey(name: "_id")
    String? id,

    String? createdBy,

    String? updatedBy,


  }) = _ClientDetailRes;

  factory ClientDetailRes.fromJson(Map<String, dynamic> json) => _$ClientDetailResFromJson(json);
}

@freezed
class OperationTimeRes with _$OperationTimeRes {
  const factory OperationTimeRes({
    @JsonKey(name: "monday")
    List<MondayRes>? monday,
    List<MondayRes>? tuesday,
    List<MondayRes>? wednesday,
    List<MondayRes>? thursday,
    List<MondayRes>? fridayAndHolidayEves,
    List<MondayRes>? saturdayAndHolidays,
    List<MondayRes>? sunday,

  }) = _OperationTimeRes;

  factory OperationTimeRes.fromJson(Map<String, dynamic> json) => _$OperationTimeResFromJson(json);
}

@freezed
class MondayRes with _$MondayRes {
  const factory MondayRes({

    String? from,

    String? unitl,
  }) = _MondayRes;

  factory MondayRes.fromJson(Map<String, dynamic> json) => _$MondayResFromJson(json);
}
