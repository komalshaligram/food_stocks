// To parse this JSON data, do
//
//     final supplierProductsReqModel = supplierProductsReqModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'supplier_products_req_model.freezed.dart';

part 'supplier_products_req_model.g.dart';

SupplierProductsReqModel supplierProductsReqModelFromJson(String str) =>
    SupplierProductsReqModel.fromJson(json.decode(str));

String supplierProductsReqModelToJson(SupplierProductsReqModel data) =>
    json.encode(data.toJson());

@freezed
class SupplierProductsReqModel with _$SupplierProductsReqModel {
  const factory SupplierProductsReqModel({
    @JsonKey(name: "pageLimit") int? pageLimit,
    @JsonKey(name: "pageNum") int? pageNum,
    @JsonKey(name: "supplierId") String? userId,
  }) = _SupplierProductsReqModel;

  factory SupplierProductsReqModel.fromJson(Map<String, dynamic> json) =>
      _$SupplierProductsReqModelFromJson(json);
}
