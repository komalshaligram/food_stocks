// To parse this JSON data, do
//
//     final getReturnByIdResModel = getReturnByIdResModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'get_return_by_id_res_model.freezed.dart';
part 'get_return_by_id_res_model.g.dart';

GetReturnByIdResModel getReturnByIdResModelFromJson(String str) => GetReturnByIdResModel.fromJson(json.decode(str));

String getReturnByIdResModelToJson(GetReturnByIdResModel data) => json.encode(data.toJson());

@freezed
class GetReturnByIdResModel with _$GetReturnByIdResModel {
  const factory GetReturnByIdResModel({
    @JsonKey(name: "status")
    int? status,
    @JsonKey(name: "message")
    String? message,
    @JsonKey(name: "data")
    Data? data,
  }) = _GetReturnByIdResModel;

  factory GetReturnByIdResModel.fromJson(Map<String, dynamic> json) => _$GetReturnByIdResModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
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
    @JsonKey(name: "clientId")
    String? clientId,
    @JsonKey(name: "subUserId")
    String? subUserId,
    @JsonKey(name: "totalPayment")
    int? totalPayment,
    @JsonKey(name: "invoiceDate")
    dynamic invoiceDate,
    @JsonKey(name: "rivchitInvoiceNumber")
    dynamic rivchitInvoiceNumber,
    @JsonKey(name: "referenceRivchitInvoiceId")
    dynamic referenceRivchitInvoiceId,
    @JsonKey(name: "referenceSupplierInvoiceId")
    dynamic referenceSupplierInvoiceId,
    @JsonKey(name: "createdAt")
    String? createdAt,
    @JsonKey(name: "returnProducts")
    List<ReturnProduct>? returnProducts,
    @JsonKey(name: "clientName")
    String? clientName,
    @JsonKey(name: "businessName")
    String? businessName,
    @JsonKey(name: "clientRivchitId")
    int? clientRivchitId,
    @JsonKey(name: "totalRefund")
    int? totalRefund,
    @JsonKey(name: "subUserName")
    String? subUserName,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class ReturnProduct with _$ReturnProduct {
  const factory ReturnProduct({
    @JsonKey(name: "productName")
    String? productName,
    @JsonKey(name: "barcode")
    String? barcode,
    @JsonKey(name: "notes")
    String? notes,
    @JsonKey(name: "totalUnits")
    int? totalUnits,
    @JsonKey(name: "totalRefund")
    int? totalRefund,
    @JsonKey(name: "isApproved")
    bool? isApproved,
    @JsonKey(name: "proofImages")
    List<String>? proofImages,
    String? reasonToReturn,
    @JsonKey(name: "productImage")
    String? productImg
  }) = _ReturnProduct;

  factory ReturnProduct.fromJson(Map<String, dynamic> json) => _$ReturnProductFromJson(json);
}
