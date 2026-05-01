import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'pay_invoice_creditcard_request_model.freezed.dart';
part 'pay_invoice_creditcard_request_model.g.dart';

PayInvoiceCreditCardRequestModel payInvoiceCreditCardRequestModelFromJson(String str) => PayInvoiceCreditCardRequestModel.fromJson(json.decode(str));

String payInvoiceCreditCardRequestModelToJson(PayInvoiceCreditCardRequestModel data) => json.encode(data.toJson());

@freezed
class PayInvoiceCreditCardRequestModel
    with _$PayInvoiceCreditCardRequestModel {
  const factory PayInvoiceCreditCardRequestModel({
    @JsonKey(name: "orderId") String? orderId,
    @JsonKey(name: "invoiceNumber") int? invoiceNumber,
  }) = _PayInvoiceCreditCardRequestModel;

  factory PayInvoiceCreditCardRequestModel.fromJson(
      Map<String, dynamic> json) =>
      _$PayInvoiceCreditCardRequestModelFromJson(json);
}