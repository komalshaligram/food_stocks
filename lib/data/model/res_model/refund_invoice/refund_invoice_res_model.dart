import 'package:freezed_annotation/freezed_annotation.dart';

part 'refund_invoice_res_model.freezed.dart';
part 'refund_invoice_res_model.g.dart';

@freezed
class RefundInvoiceResModel with _$RefundInvoiceResModel {
  const factory RefundInvoiceResModel({
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "data") String? data,
    @JsonKey(name: "message") String? message,
  }) = _RefundInvoiceResModel;

  factory RefundInvoiceResModel.fromJson(Map<String, dynamic> json) => _$RefundInvoiceResModelFromJson(json);
}
