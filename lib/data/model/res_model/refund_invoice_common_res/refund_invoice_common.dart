import 'package:freezed_annotation/freezed_annotation.dart';

part 'refund_invoice_common.freezed.dart';
part 'refund_invoice_common.g.dart';

@freezed
class RefundInvoiceCommon with _$RefundInvoiceCommon {
  const factory RefundInvoiceCommon({
    @JsonKey(name: "rivchitApiKey") String? rivchitApiKey,
    @JsonKey(name: "invoiceNumber") String? invoiceNumber,
    @JsonKey(name: "invoiceLink") String? invoiceLink,
    @JsonKey(name: "invoiceDate") String? invoiceDate,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "refundedOnOrders") List<RefundedOrderCommon>? refundedOnOrders,
    @JsonKey(name: "refundedOnInvoice") List<RefundedInvoiceCommon>? refundedOnInvoice,
    @JsonKey(name: "totalAmount") String? totalAmount,
    @JsonKey(name: "remainingAmount") String? remainingAmount,
  }) = _RefundInvoiceCommon;

  factory RefundInvoiceCommon.fromJson(Map<String, dynamic> json) => _$RefundInvoiceCommonFromJson(json);
}

@freezed
class RefundedOrderCommon with _$RefundedOrderCommon {
  const factory RefundedOrderCommon({
    @JsonKey(name: "orderNumber") String? orderNumber,
    @JsonKey(name: "orderId") String? orderId,
    @JsonKey(name: "orderAdjustAmount") String? orderAdjustAmount,
    @JsonKey(name: "status") String? status,
  }) = _RefundedOrderCommon;

  factory RefundedOrderCommon.fromJson(Map<String, dynamic> json) => _$RefundedOrderCommonFromJson(json);
}

@freezed
class RefundedInvoiceCommon with _$RefundedInvoiceCommon {
  const factory RefundedInvoiceCommon({
    @JsonKey(name: "rivchitApiKey") String? rivchitApiKey,
    @JsonKey(name: "invoiceNumber") String? invoiceNumber,
    @JsonKey(name: "invoiceLink") String? invoiceLink,
    @JsonKey(name: "invoiceDate") String? invoiceDate,
    @JsonKey(name: "dueDate") String? dueDate,
    @JsonKey(name: "paymentStatus") String? paymentStatus,
    @JsonKey(name: "orderId") String? orderId,
    @JsonKey(name: "orderNumber") String? orderNumber,
    @JsonKey(name: "invoiceAmount") String? invoiceAmount,
    @JsonKey(name: "invoiceAdjustAmount") String? invoiceAdjustAmount,
    @JsonKey(name: "status") String? status,
  }) = _RefundedInvoiceCommon;

  factory RefundedInvoiceCommon.fromJson(Map<String, dynamic> json) => _$RefundedInvoiceCommonFromJson(json);
}
