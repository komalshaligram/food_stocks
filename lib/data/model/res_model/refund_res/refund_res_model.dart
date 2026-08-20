import 'package:freezed_annotation/freezed_annotation.dart';
import '../refund_invoice_common_res/refund_invoice_common.dart';
part 'refund_res_model.freezed.dart';
part 'refund_res_model.g.dart';

@freezed
class RefundResModel with _$RefundResModel {
  const factory RefundResModel({
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "message") String? message,
    @JsonKey(name: "data") List<RefundInvoiceCommon>? data,
  }) = _RefundResModel;

  factory RefundResModel.fromJson(Map<String, dynamic> json) => _$RefundResModelFromJson(json);
}
