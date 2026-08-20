import 'package:freezed_annotation/freezed_annotation.dart';
part 'invoices_res_model.freezed.dart';
part 'invoices_res_model.g.dart';

@freezed
class InvoicesResModel with _$InvoicesResModel {
  const factory InvoicesResModel({
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "data") Data? data,
    @JsonKey(name: "message") String? message,
  }) = _InvoicesResModel;

  factory InvoicesResModel.fromJson(Map<String, dynamic> json) => _$InvoicesResModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    @JsonKey(name: "orderInvoices") InvoiceGroup? orderInvoices,
    @JsonKey(name: "refundInvoices") InvoiceGroup? refundInvoices,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class InvoiceGroup with _$InvoiceGroup {
  const factory InvoiceGroup({
    @JsonKey(name: "invoices") List<Invoice>? invoices,
    @JsonKey(name: "totalRecords") int? totalRecords,
    @JsonKey(name: "totalPages") int? totalPages,
    @JsonKey(name: "currentPage") int? currentPage,
  }) = _InvoiceGroup;

  factory InvoiceGroup.fromJson(Map<String, dynamic> json) => _$InvoiceGroupFromJson(json);
}

@freezed
class Invoice with _$Invoice {
  const factory Invoice({
    @JsonKey(name: "invoiceLink") String? invoiceLink,
    @JsonKey(name: "invoiceNumber") String? invoiceNumber,
    @JsonKey(name: "invoiceAmount") String? invoiceAmount,
    @JsonKey(name: "paymentStatus") String? paymentStatus,
    @JsonKey(name: "invoiceAdjustAmount") double? invoiceAdjustAmount,
    @JsonKey(name: "invoiceDate") String? invoiceDate,
    @JsonKey(name: "invoiceType") String? invoiceType,
    @JsonKey(name: "dueDate") String? dueDate,
    @JsonKey(name: "supplierName") String? supplierName,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "orderNumber") String? orderNumber,
    @JsonKey(name: "orderId") String? orderId,
    @JsonKey(name: "rivchitApiKey") String? rivchitApiKey,
    @JsonKey(name: "cardNumber") String? cardNumber,
    @JsonKey(name: "paymentMethod") String? paymentMethod,
  }) = _Invoice;

  factory Invoice.fromJson(Map<String, dynamic> json) => _$InvoiceFromJson(json);
}
