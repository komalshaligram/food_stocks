// To parse this JSON data, do
//
//     final bankDetailModel = bankDetailModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';


part 'bank_detail_model.freezed.dart';
part 'bank_detail_model.g.dart';


@freezed
class BankDetailModel with _$BankDetailModel {
  const factory BankDetailModel({
    @JsonKey(name: "status")
    int? status,
    @JsonKey(name: "data")
    Data? data,
    @JsonKey(name: "message")
    String? message,
  }) = _BankDetailModel;

  factory BankDetailModel.fromJson(Map<String, dynamic> json) => _$BankDetailModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    @JsonKey(name: "BankDetail")
    List<BankDetail>? bankDetail,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class BankDetail with _$BankDetail {
  const factory BankDetail({
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "bankName")
    String? bankName,
    @JsonKey(name: "bankNumber")
    String? bankNumber,
    @JsonKey(name: "isDeleted")
    bool? isDeleted,
    @JsonKey(name: "bankIncrementalNumber")
    int? bankIncrementalNumber,
    @JsonKey(name: "createdAt")
    String? createdAt,
    @JsonKey(name: "updatedAt")
    String? updatedAt,
    @JsonKey(name: "__v")
    int? v,
    @JsonKey(name: "lowerField")
    String? lowerField,
  }) = _BankDetail;

  factory BankDetail.fromJson(Map<String, dynamic> json) => _$BankDetailFromJson(json);
}
