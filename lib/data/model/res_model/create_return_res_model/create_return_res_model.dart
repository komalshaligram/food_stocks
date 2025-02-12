// To parse this JSON data, do
//
//     final createReturnResModel = createReturnResModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_return_res_model.freezed.dart';
part 'create_return_res_model.g.dart';

CreateReturnResModel createReturnResModelFromJson(String str) => CreateReturnResModel.fromJson(json.decode(str));

String createReturnResModelToJson(CreateReturnResModel data) => json.encode(data.toJson());

@freezed
class CreateReturnResModel with _$CreateReturnResModel {
  const factory CreateReturnResModel({
    @JsonKey(name: "status")
    int? status,
    @JsonKey(name: "message")
    String? message,
    @JsonKey(name: "data")
    Data? data,
  }) = _CreateReturnResModel;

  factory CreateReturnResModel.fromJson(Map<String, dynamic> json) => _$CreateReturnResModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
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
    @JsonKey(name: "clientId")
    String? clientId,
    @JsonKey(name: "subUserId")
    dynamic subUserId,
    @JsonKey(name: "totalPayment")
    int? totalPayment,
    @JsonKey(name: "invoiceDate")
    dynamic invoiceDate,
    @JsonKey(name: "rivchitInvoiceLink")
    String? rivchitInvoiceLink,
    @JsonKey(name: "rivchitInvoiceNumber")
    dynamic rivchitInvoiceNumber,
    @JsonKey(name: "referenceRivchitInvoiceId")
    dynamic referenceRivchitInvoiceId,
    @JsonKey(name: "referenceSupplierInvoiceId")
    dynamic referenceSupplierInvoiceId,
    @JsonKey(name: "errorMessage")
    List<dynamic>? errorMessage,
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "createdAt")
    String? createdAt,
    @JsonKey(name: "updatedAt")
    String? updatedAt,
    @JsonKey(name: "__v")
    int? v,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}
