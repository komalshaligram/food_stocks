import 'package:freezed_annotation/freezed_annotation.dart';
part 'refund_invoice_req_model.freezed.dart';
part 'refund_invoice_req_model.g.dart';

@freezed
class RefundInvoiceReqModel with _$RefundInvoiceReqModel {
  const factory RefundInvoiceReqModel({
    @JsonKey(name: "clientId") String? clientId,
    @JsonKey(name: "invoiceNumber") int? invoiceNumber,
    @JsonKey(name: "rivchitApiKey") String? rivchitApiKey,
  }) = _RefundInvoiceReqModel;

  factory RefundInvoiceReqModel.fromJson(Map<String, dynamic> json) => _$RefundInvoiceReqModelFromJson(json);
}
