import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'create_return_res_model.freezed.dart';
part 'create_return_res_model.g.dart';

CreateReturnResModel createReturnResModelFromJson(String str) => CreateReturnResModel.fromJson(json.decode(str));

String createReturnResModelToJson(CreateReturnResModel data) => json.encode(data.toJson());

@freezed
class CreateReturnResModel with _$CreateReturnResModel {
  const factory CreateReturnResModel({
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "message") String? message,
    @JsonKey(name: "agentPhoneNumber") String? agentPhoneNumber,
    @JsonKey(name: "data") List<Datum>? data,
    @JsonKey(name: "isPendingCreatedFromDraft") bool? isPendingCreatedFromDraft,
  }) = _CreateReturnResModel;

  factory CreateReturnResModel.fromJson(Map<String, dynamic> json) => _$CreateReturnResModelFromJson(json);
}

@freezed
class Datum with _$Datum {
  const factory Datum({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "returnNumber") int? returnNumber,
    @JsonKey(name: "returnStatusId") String? returnStatusId,
    @JsonKey(name: "returnStatusName") String? returnStatusName,
    @JsonKey(name: "returnStatusNumber") int? returnStatusNumber,
    @JsonKey(name: "applicationName") String? applicationName,
    @JsonKey(name: "clientId") String? clientId,
    @JsonKey(name: "orderId") dynamic orderId,
    @JsonKey(name: "subUserId") dynamic subUserId,
    @JsonKey(name: "supplierId") String? supplierId,
    @JsonKey(name: "totalPayment") double? totalPayment,
    @JsonKey(name: "invoiceDate") dynamic invoiceDate,
    @JsonKey(name: "requestDate") DateTime? requestDate,
    @JsonKey(name: "rivchitInvoiceLink") String? rivchitInvoiceLink,
    @JsonKey(name: "rivchitInvoiceNumber") dynamic rivchitInvoiceNumber,
    @JsonKey(name: "rivchitInvoiceAmount") int? rivchitInvoiceAmount,
    @JsonKey(name: "referenceRivchitInvoiceId") int? referenceRivchitInvoiceId,
    @JsonKey(name: "referenceSupplierInvoiceId") int? referenceSupplierInvoiceId,
    @JsonKey(name: "errorMessage") List<dynamic>? errorMessage,
    @JsonKey(name: "isDeleted") bool? isDeleted,
    @JsonKey(name: "createdAt") DateTime? createdAt,
    @JsonKey(name: "updatedAt") DateTime? updatedAt,
    @JsonKey(name: "__v") int? v,
    @JsonKey(name: "returnproducts") List<Returnproduct>? returnproducts,
  }) = _Datum;

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
}

@freezed
class Returnproduct with _$Returnproduct {
  const factory Returnproduct({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "returnId") String? returnId,
    @JsonKey(name: "clientId") String? clientId,
    @JsonKey(name: "productId") String? productId,
    @JsonKey(name: "productName") String? productName,
    @JsonKey(name: "barcode") String? barcode,
    @JsonKey(name: "reasonToReturn") String? reasonToReturn,
    @JsonKey(name: "notes") String? notes,
    @JsonKey(name: "totalUnits") int? totalUnits,
    @JsonKey(name: "totalRefund") double? totalRefund,
    @JsonKey(name: "isApproved") bool? isApproved,
    @JsonKey(name: "proofImages") List<String>? proofImages,
    @JsonKey(name: "productImage") String? productImage,
    @JsonKey(name: "createdAt") DateTime? createdAt,
    @JsonKey(name: "updatedAt") DateTime? updatedAt,
    @JsonKey(name: "__v") int? v,
    @JsonKey(name: "supplierId") String? supplierId,
    @JsonKey(name: "supplierName") String? supplierName,
  }) = _Returnproduct;

  factory Returnproduct.fromJson(Map<String, dynamic> json) => _$ReturnproductFromJson(json);
}
