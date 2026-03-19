import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_account_card_invoices_res_model.freezed.dart';
part 'my_account_card_invoices_res_model.g.dart';

MyAccountCardInvoicesResModel myAccountCardInvoicesResModelFromJson(String str) => MyAccountCardInvoicesResModel.fromJson(json.decode(str));

String myAccountCardInvoicesResModelToJson(MyAccountCardInvoicesResModel data) => json.encode(data.toJson());

@freezed
class MyAccountCardInvoicesResModel with _$MyAccountCardInvoicesResModel {
  const factory MyAccountCardInvoicesResModel({
    int? status,
    String? message,
    MyAccountData? data,
  }) = _MyAccountCardInvoicesResModel;

  factory MyAccountCardInvoicesResModel.fromJson(Map<String, dynamic> json) => _$MyAccountCardInvoicesResModelFromJson(json);
}

@freezed
class MyAccountData with _$MyAccountData {
  const factory MyAccountData({
    @JsonKey(fromJson: _doubleFromJson) double? totalOpenInvoiceAmount,
    @JsonKey(fromJson: _doubleFromJson) double? clientBalance,
    List<MyCardInvoice>? invoices,
  }) = _MyAccountData;

  factory MyAccountData.fromJson(Map<String, dynamic> json) => _$MyAccountDataFromJson(json);
}

double? _doubleFromJson(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

@freezed
class MyCardInvoice with _$MyCardInvoice {
  const factory MyCardInvoice({
    @JsonKey(name: "rivchitApiKey") String? rivchitApiKey,
    @JsonKey(name: "invoiceNumber") int? invoiceNumber,
    @JsonKey(name: "invoiceLink") String? invoiceLink,
    @JsonKey(name: "invoiceDate") String? invoiceDate,
    @JsonKey(name: "dueDate") String? dueDate,
    @JsonKey(name: "paymentStatus") String? paymentStatus,
    @JsonKey(name: "orderId") String? orderId,
    @JsonKey(name: "orderNumber") String? orderNumber,
    @JsonKey(name: "invoiceAmount") String? invoiceAmount,
  }) = _MyCardInvoice;

  factory MyCardInvoice.fromJson(Map<String, dynamic> json) => _$MyCardInvoiceFromJson(json);
}
