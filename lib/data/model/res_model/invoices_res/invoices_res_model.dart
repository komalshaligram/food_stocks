// To parse this JSON data, do
//
//     final invoicesResModel = invoicesResModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'invoices_res_model.freezed.dart';
part 'invoices_res_model.g.dart';

InvoicesResModel invoicesResModelFromJson(String str) => InvoicesResModel.fromJson(json.decode(str));

String invoicesResModelToJson(InvoicesResModel data) => json.encode(data.toJson());

@freezed
class InvoicesResModel with _$InvoicesResModel {
  const factory InvoicesResModel({
    @JsonKey(name: "status")
    int? status,
    @JsonKey(name: "data")
    Data? data,
    @JsonKey(name: "message")
    String? message,
  }) = _InvoicesResModel;

  factory InvoicesResModel.fromJson(Map<String, dynamic> json) => _$InvoicesResModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    @JsonKey(name: "invoices")
    List<Invoice>? invoices,
    @JsonKey(name: "totalRecords")
    int? totalRecords,
    @JsonKey(name: "totalPages")
    int? totalPages,
    @JsonKey(name: "currentPage")
    int? currentPage,

  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class Invoice with _$Invoice {
  const factory Invoice({
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "link")
    String? link,
    @JsonKey(name: "invoiceNumber")
    String? invoiceNumber,
    @JsonKey(name: "invoiceAmount")
    String? invoiceAmount,
    @JsonKey(name: "paymentStatus")
    String? paymentStatus,
    String? invoiceDate,
    String? invoiceType,
    String? dueDate
  }) = _Invoice;

  factory Invoice.fromJson(Map<String, dynamic> json) => _$InvoiceFromJson(json);
}