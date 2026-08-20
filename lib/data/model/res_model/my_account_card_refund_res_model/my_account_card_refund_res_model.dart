import 'package:freezed_annotation/freezed_annotation.dart';
import '../refund_invoice_common_res/refund_invoice_common.dart';
part 'my_account_card_refund_res_model.freezed.dart';
part 'my_account_card_refund_res_model.g.dart';

@freezed
class MyAccountCardRefundResModel with _$MyAccountCardRefundResModel {
  const factory MyAccountCardRefundResModel({
    int? status,
    String? message,
    MyAccountRefundData? data,
  }) = _MyAccountCardRefundResModel;

  factory MyAccountCardRefundResModel.fromJson(Map<String, dynamic> json) => _$MyAccountCardRefundResModelFromJson(json);
}

@freezed
class MyAccountRefundData with _$MyAccountRefundData {
  const factory MyAccountRefundData({
    @JsonKey(fromJson: _doubleFromJson) double? totalOpenRefundInvoiceAmount,
    @JsonKey(fromJson: _doubleFromJson) double? clientBalance,
    List<RefundInvoiceCommon>? refundInvoices,
  }) = _MyAccountRefundData;

  factory MyAccountRefundData.fromJson(Map<String, dynamic> json) => _$MyAccountRefundDataFromJson(json);
}

double? _doubleFromJson(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

@freezed
class MyCardRefundInvoice with _$MyCardRefundInvoice {
  const factory MyCardRefundInvoice({
    String? someRefundField,
  }) = _MyCardRefundInvoice;

  factory MyCardRefundInvoice.fromJson(Map<String, dynamic> json) => _$MyCardRefundInvoiceFromJson(json);
}
