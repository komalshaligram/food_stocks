import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'supplier_brand_product_request_model.freezed.dart';

part 'supplier_brand_product_request_model.g.dart';

SupplierBrandProductRequestModel supplierBrandProductRequestFromJson(String str) => SupplierBrandProductRequestModel.fromJson(json.decode(str));

String supplierBrandProductRequestModelToJson(SupplierBrandProductRequestModel data) => json.encode(data.toJson());

@freezed
class SupplierBrandProductRequestModel with _$SupplierBrandProductRequestModel {
  const factory SupplierBrandProductRequestModel({
    @JsonKey(name: "supplierId") String? supplierId,
    @JsonKey(name: "pageLimit") int? pageLimit,
    @JsonKey(name: "pageNum") int? pageNum,
    @JsonKey(name: "brandId") String? brandId,
    @JsonKey(name: "categoryId") String? categoryId,
  }) = _SupplierBrandProductRequestModel;

  factory SupplierBrandProductRequestModel.fromJson(Map<String, dynamic> json) => _$SupplierBrandProductRequestModelFromJson(json);
}