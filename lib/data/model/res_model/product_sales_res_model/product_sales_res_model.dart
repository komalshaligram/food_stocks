// To parse this JSON data, do
//
//     final productSalesResModel = productSalesResModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'product_sales_res_model.freezed.dart';

part 'product_sales_res_model.g.dart';

ProductSalesResModel productSalesResModelFromJson(String str) =>
    ProductSalesResModel.fromJson(json.decode(str));

String productSalesResModelToJson(ProductSalesResModel data) =>
    json.encode(data.toJson());

@freezed
class ProductSalesResModel with _$ProductSalesResModel {
  const factory ProductSalesResModel({
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "data") Data? data,
    @JsonKey(name: "message") String? message,
  }) = _ProductSalesResModel;

  factory ProductSalesResModel.fromJson(Map<String, dynamic> json) =>
      _$ProductSalesResModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    @JsonKey(name: "sales") List<Sale>? sales,
    @JsonKey(name: "totalRecords") int? totalRecords,
    @JsonKey(name: "totalPages") int? totalPages,
    @JsonKey(name: "currentPage") int? currentPage,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class Sale with _$Sale {
  const factory Sale({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "productDetailsCounts") String? productDetailsCounts,
    @JsonKey(name: "supplierDetails") String? supplierDetails,
    @JsonKey(name: "salesType") String? salesType,
    @JsonKey(name: "createdFirstName") String? createdFirstName,
    @JsonKey(name: "createdLastName") String? createdLastName,
    @JsonKey(name: "salesName") String? salesName,
    @JsonKey(name: "discountPercentage") String? discountPercentage,
    @JsonKey(name: "salesDescription") String? salesDescription,
    @JsonKey(name: "fromDate") String? fromDate,
    @JsonKey(name: "endDate") String? endDate,
    @JsonKey(name: "salesTerms") String? salesTerms,
    @JsonKey(name: "createdBy") String? createdBy,
    @JsonKey(name: "updatedBy") String? updatedBy,
    @JsonKey(name: "createdAt") String? createdAt,
    @JsonKey(name: "updatedAt") String? updatedAt,
  }) = _Sale;

  factory Sale.fromJson(Map<String, dynamic> json) => _$SaleFromJson(json);
}
