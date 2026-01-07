import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../refund_invoice_common_res/refund_invoice_common.dart'; // ← NEW IMPORT

part 'my_account_card_res_model.freezed.dart';
part 'my_account_card_res_model.g.dart';

MyAccountCardResModel myAccountCardResModelFromJson(String str) =>
    MyAccountCardResModel.fromJson(json.decode(str));

String myAccountCardResModelToJson(MyAccountCardResModel data) =>
    json.encode(data.toJson());

@freezed
class MyAccountCardResModel with _$MyAccountCardResModel {
  const factory MyAccountCardResModel({
    int? status,
    String? message,
    MyAccountData? data,
  }) = _MyAccountCardResModel;

  factory MyAccountCardResModel.fromJson(Map<String, dynamic> json) =>
      _$MyAccountCardResModelFromJson(json);
}

@freezed
class MyAccountData with _$MyAccountData {
  const factory MyAccountData({
    double? clientBalance,
    double? totalOpenInvoiceAmount,
    double? totalOpenRefundInvoiceAmount,
    List<MyCardRefundInvoice>? invoices,
    List<RefundInvoiceCommon>? refundInvoices, // ← CHANGED
  }) = _MyAccountData;

  factory MyAccountData.fromJson(Map<String, dynamic> json) =>
      _$MyAccountDataFromJson(json);
}

// MyCardRefundInvoice stays the same (it's only for normal invoices)
@freezed
class MyCardRefundInvoice with _$MyCardRefundInvoice {
  const factory MyCardRefundInvoice({
    @JsonKey(name: "rivchitApiKey") String? rivchitApiKey,
    @JsonKey(name: "invoiceNumber") int? invoiceNumber,
    @JsonKey(name: "invoiceLink") String? invoiceLink,
    @JsonKey(name: "invoiceDate") String? invoiceDate,
    @JsonKey(name: "dueDate") String? dueDate,
    @JsonKey(name: "paymentStatus") String? paymentStatus,
    @JsonKey(name: "orderId") String? orderId,
    @JsonKey(name: "orderNumber") String? orderNumber,
    @JsonKey(name: "invoiceAmount") String? invoiceAmount,
  }) = _MyCardRefundInvoice;

  factory MyCardRefundInvoice.fromJson(Map<String, dynamic> json) =>
      _$MyCardRefundInvoiceFromJson(json);
}

// Remove the old RefundInvoice, RefundedOnOrder, RefundedOnInvoice classes from this file