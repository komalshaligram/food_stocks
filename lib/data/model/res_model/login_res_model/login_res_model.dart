
import 'package:freezed_annotation/freezed_annotation.dart';
part 'login_res_model.freezed.dart';
part 'login_res_model.g.dart';


@freezed
class LoginResModel with _$LoginResModel {
  const factory LoginResModel({

    int? status,

    String? message,

    User? user,

    bool? success,
  }) = _LoginResModel;

  factory LoginResModel.fromJson(Map<String, dynamic> json) => _$LoginResModelFromJson(json);
}

@freezed
class User with _$User {
  const factory User({

    bool? isDeleted,
    @JsonKey(name: "_id")
    String? id,

    String? email,

    String? password,

    String? firstName,

    String? lastName,

    String? phoneNumber,

    String? address,

    String? cityId,

    String? contactName,

    String? statusId,

    String? logo,

    String? adminTypeId,
    @JsonKey(name: "clientDetail")
    ClientDetail? clientDetail,
    @JsonKey(name: "createdBy")
    String? createdBy,
    @JsonKey(name: "updatedBy")
    String? updatedBy,
    @JsonKey(name: "createdAt")
    DateTime? createdAt,
    @JsonKey(name: "updatedAt")
    DateTime? updatedAt,
    @JsonKey(name: "__v")
    int? v,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
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
