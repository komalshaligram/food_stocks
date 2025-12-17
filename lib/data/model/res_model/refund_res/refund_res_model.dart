import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'refund_res_model.freezed.dart';
part 'refund_res_model.g.dart';

RefundResModel refundResModelFromJson(String str) =>
    RefundResModel.fromJson(json.decode(str));

String refundResModelToJson(RefundResModel data) =>
    json.encode(data.toJson());

@freezed
class RefundResModel with _$RefundResModel {
  const factory RefundResModel({
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "message") String? message,
    @JsonKey(name: "data") RefundData? data,

  }) = _RefundResModel;

  factory RefundResModel.fromJson(Map<String, dynamic> json) =>
      _$RefundResModelFromJson(json);
}

@freezed
class RefundData with _$RefundData {
  const factory RefundData({
    @JsonKey(name: "totalOpenRefundAmount")
    String? totalOpenRefundAmount,

    /// refundInvoices → list
    @JsonKey(name: "refundInvoices")
    List<RefundInvoice>? refundInvoices,
  }) = _RefundData;

  factory RefundData.fromJson(Map<String, dynamic> json) =>
      _$RefundDataFromJson(json);
}

@freezed
class RefundInvoice with _$RefundInvoice {
  const factory RefundInvoice({
    @JsonKey(name: "rivchitApiKey") String? rivchitApiKey,
    @JsonKey(name: "invoiceNumber") int? invoiceNumber,
    @JsonKey(name: "invoiceLink") String? invoiceLink,
    @JsonKey(name: "invoiceDate") String? invoiceDate,
    @JsonKey(name: "status") String? status,

    /// refundedOnOrders → List
    @JsonKey(name: "refundedOnOrders")
    List<RefundedOrder>? refundedOnOrders,

    /// refundedOnInvoice → List
    @JsonKey(name: "refundedOnInvoice")
    List<RefundedInvoice>? refundedOnInvoice,

    /// totalAmount (string/number → double)
    @JsonKey(name: "totalAmount" )
    String? totalAmount,

    /// remainingAmount (string/number → double)
    @JsonKey(name: "remainingAmount")
    String? remainingAmount,
  }) = _RefundInvoice;

  factory RefundInvoice.fromJson(Map<String, dynamic> json) =>
      _$RefundInvoiceFromJson(json);
}

@freezed
class RefundedOrder with _$RefundedOrder {
  const factory RefundedOrder({
    @JsonKey(name: "orderNumber") String? orderNumber,
    @JsonKey(name: "orderId") String? orderId,
    @JsonKey(name: "orderAdjustAmount")
    String? orderAdjustAmount,
    @JsonKey(name: "status") String? status,
  }) = _RefundedOrder;

  factory RefundedOrder.fromJson(Map<String, dynamic> json) =>
      _$RefundedOrderFromJson(json);
}

@freezed
class RefundedInvoice with _$RefundedInvoice {
  const factory RefundedInvoice({
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
    String? dueDate,
    String? supplierName,
    String? status
  }) = _RefundedInvoice;

  factory RefundedInvoice.fromJson(Map<String, dynamic> json) =>
      _$RefundedInvoiceFromJson(json);
}


