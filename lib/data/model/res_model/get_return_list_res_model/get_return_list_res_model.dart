// To parse this JSON data, do
//
//     final getReturnListResModel = getReturnListResModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'get_return_list_res_model.freezed.dart';
part 'get_return_list_res_model.g.dart';

GetReturnListResModel getReturnListResModelFromJson(String str) => GetReturnListResModel.fromJson(json.decode(str));

String getReturnListResModelToJson(GetReturnListResModel data) => json.encode(data.toJson());

@freezed
class GetReturnListResModel with _$GetReturnListResModel {
  const factory GetReturnListResModel({
    @JsonKey(name: "status")
    int? status,
    @JsonKey(name: "data")
    Data? data,
    @JsonKey(name: "message")
    String? message,
  }) = _GetReturnListResModel;

  factory GetReturnListResModel.fromJson(Map<String, dynamic> json) => _$GetReturnListResModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    @JsonKey(name: "returns")
    List<Return>? returns,
    @JsonKey(name: "totalRecords")
    int? totalRecords,
    @JsonKey(name: "totalPages")
    int? totalPages,
    @JsonKey(name: "currentPage")
    String? currentPage,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class Return with _$Return {
  const factory Return({
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "returnNumber")
    int? returnNumber,
    @JsonKey(name: "returnStatusId")
    String? returnStatusId,
    @JsonKey(name: "returnStatusName")
    String? returnStatusName,
    @JsonKey(name: "returnStatusNumber")
    int? returnStatusNumber,
    @JsonKey(name: "applicationName")
    String? applicationName,
    @JsonKey(name: "subUserId")
    String? subUserId,
    @JsonKey(name: "totalPayment")
    String? totalPayment,
    @JsonKey(name: "invoiceDate")
    dynamic invoiceDate,
    @JsonKey(name: "rivchitInvoiceNumber")
    String? rivchitInvoiceNumber,
    @JsonKey(name: "createdAt")
    String? createdAt,
    @JsonKey(name: "clientName")
    String? clientName,
    @JsonKey(name: "businessName")
    String? businessName,
    @JsonKey(name: "rivchitId")
    String? rivchitId,
    @JsonKey(name: "subUserName")
    String? subUserName,
  }) = _Return;

  factory Return.fromJson(Map<String, dynamic> json) => _$ReturnFromJson(json);
}
