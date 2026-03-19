import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'refund_invoice_req_model.freezed.dart';
part 'refund_invoice_req_model.g.dart';

RefundInvoiceReqModel refundInvoiceReqModelFromJson(String str) => RefundInvoiceReqModel.fromJson(json.decode(str));

String refundInvoiceReqModelToJson(RefundInvoiceReqModel data) => json.encode(data.toJson());

@freezed
class RefundInvoiceReqModel with _$RefundInvoiceReqModel {
  const factory RefundInvoiceReqModel({
    @JsonKey(name: "clientId") String? clientId,
    @JsonKey(name: "invoiceNumber") int? invoiceNumber,
    @JsonKey(name: "rivchitApiKey") String? rivchitApiKey,
  }) = _RefundInvoiceReqModel;

  factory RefundInvoiceReqModel.fromJson(Map<String, dynamic> json) => _$RefundInvoiceReqModelFromJson(json);
}
