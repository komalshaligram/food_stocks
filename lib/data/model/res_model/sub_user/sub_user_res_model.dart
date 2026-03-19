import 'package:freezed_annotation/freezed_annotation.dart';

part 'sub_user_res_model.freezed.dart';
part 'sub_user_res_model.g.dart';

@freezed
class SubUserResModel with _$SubUserResModel {
  const factory SubUserResModel({
    @JsonKey(name: "data") Data? data,
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "message") String? message,
  }) = _SubUserResModel;

  factory SubUserResModel.fromJson(Map<String, dynamic> json) => _$SubUserResModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    @JsonKey(name: "password") dynamic password,
    @JsonKey(name: "phoneNumber") String? phoneNumber,
    @JsonKey(name: "contactName") String? contactName,
    @JsonKey(name: "adminTypeId") String? adminTypeId,
    @JsonKey(name: "clientDetail") ClientDetail? clientDetail,
    @JsonKey(name: "createdBy") String? createdBy,
    @JsonKey(name: "isDeleted") bool? isDeleted,
    @JsonKey(name: "userNumber") int? userNumber,
    @JsonKey(name: "isClientFormEmailSend") bool? isClientFormEmailSend,
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "createdAt") String? createdAt,
    @JsonKey(name: "updatedAt") String? updatedAt,
    @JsonKey(name: "__v") int? v,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class ClientDetail with _$ClientDetail {
  const factory ClientDetail({
    @JsonKey(name: "israelId") String? israelId,
    @JsonKey(name: "operationTime") List<dynamic>? operationTime,
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "createdAt") String? createdAt,
    @JsonKey(name: "updatedAt") String? updatedAt,
  }) = _ClientDetail;

  factory ClientDetail.fromJson(Map<String, dynamic> json) => _$ClientDetailFromJson(json);
}
