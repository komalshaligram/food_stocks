import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_client_waiting_for_new_order_return_products_model.freezed.dart';
part 'get_client_waiting_for_new_order_return_products_model.g.dart';

@freezed
class GetClientWaitingForNewOrderReturnModel with _$GetClientWaitingForNewOrderReturnModel {
  const factory GetClientWaitingForNewOrderReturnModel({
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "message") String? message,
    @JsonKey(name: "data") List<GetClientWaitingForNewOrderReturnData>? data,
  }) = _GetClientWaitingForNewOrderReturnModel;

  factory GetClientWaitingForNewOrderReturnModel.fromJson(Map<String, dynamic> json) => _$GetClientWaitingForNewOrderReturnModelFromJson(json);
}

@freezed
class GetClientWaitingForNewOrderReturnData with _$GetClientWaitingForNewOrderReturnData {
  const factory GetClientWaitingForNewOrderReturnData({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "returnNumber") int? returnNumber,
    @JsonKey(name: "returnStatusId") String? returnStatusId,
    @JsonKey(name: "returnStatusName") String? returnStatusName,
    @JsonKey(name: "returnStatusNumber") int? returnStatusNumber,
    @JsonKey(name: "applicationName") String? applicationName,
    @JsonKey(name: "clientId") String? clientId,
    @JsonKey(name: "orderId") String? orderId,
    @JsonKey(name: "supplierId") String? supplierId,
    @JsonKey(name: "totalPayment") double? totalPayment,
    @JsonKey(name: "invoiceDate") String? invoiceDate,
    @JsonKey(name: "requestDate") String? requestDate,
    @JsonKey(name: "comaxReturnOrderLink") String? comaxReturnOrderLink,
    @JsonKey(name: "comaxReturnOrderNumber") int? comaxReturnOrderNumber,
    @JsonKey(name: "comaxInvoiceLink") String? comaxInvoiceLink,
    @JsonKey(name: "comaxInvoiceNumber") int? comaxInvoiceNumber,
    @JsonKey(name: "rivchitInvoiceLink") String? rivchitInvoiceLink,
    @JsonKey(name: "rivchitInvoiceNumber") int? rivchitInvoiceNumber,
    @JsonKey(name: "rivchitInvoiceAmount") double? rivchitInvoiceAmount,
    @JsonKey(name: "referenceRivchitInvoiceId") int? referenceRivchitInvoiceId,
    @JsonKey(name: "referenceSupplierInvoiceId") int? referenceSupplierInvoiceId,
    @JsonKey(name: "errorMessage") List<dynamic>? errorMessage,
    @JsonKey(name: "isDeleted") bool? isDeleted,
    @JsonKey(name: "createdAt") String? createdAt,
    @JsonKey(name: "updatedAt") String? updatedAt,
    @JsonKey(name: "__v") int? v,
    @JsonKey(name: "returnProducts") List<GetClientReturnProduct>? returnProducts,
  }) = _GetClientWaitingForNewOrderReturnData;

  factory GetClientWaitingForNewOrderReturnData.fromJson(Map<String, dynamic> json) => _$GetClientWaitingForNewOrderReturnDataFromJson(json);
}

@freezed
class GetClientReturnProduct with _$GetClientReturnProduct {
  const factory GetClientReturnProduct({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "returnId") String? returnId,
    @JsonKey(name: "clientId") String? clientId,
    @JsonKey(name: "supplierId") String? supplierId,
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
    @JsonKey(name: "createdAt") String? createdAt,
    @JsonKey(name: "updatedAt") String? updatedAt,
    @JsonKey(name: "__v") int? v,
  }) = _GetClientReturnProduct;

  factory GetClientReturnProduct.fromJson(Map<String, dynamic> json) => _$GetClientReturnProductFromJson(json);
}
