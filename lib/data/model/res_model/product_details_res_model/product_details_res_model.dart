// To parse this JSON data, do
//
//     final productDetailsResModel = productDetailsResModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'product_details_res_model.freezed.dart';

part 'product_details_res_model.g.dart';

ProductDetailsResModel productDetailsResModelFromJson(String str) =>
    ProductDetailsResModel.fromJson(json.decode(str));

String productDetailsResModelToJson(ProductDetailsResModel data) =>
    json.encode(data.toJson());

@freezed
class ProductDetailsResModel with _$ProductDetailsResModel {
  const factory ProductDetailsResModel({
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "product") List<Product>? product,
    @JsonKey(name: "message") String? message,
  }) = _ProductDetailsResModel;

  factory ProductDetailsResModel.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailsResModelFromJson(json);
}

@freezed
class Product with _$Product {
  const factory Product({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "productName") String? productName,
    @JsonKey(name: "brandName") String? brandName,
    @JsonKey(name: "productDescription") String? productDescription,
    @JsonKey(name: "component") String? component,
    @JsonKey(name: "nutritionalValue") String? nutritionalValue,
    @JsonKey(name: "sku") String? sku,
    @JsonKey(name: "kosharMilk") bool? kosharMilk,
    @JsonKey(name: "categoryId") String? categoryId,
    @JsonKey(name: "subCategoryId") String? subCategoryId,
    @JsonKey(name: "subSubCategoryId") String? subSubCategoryId,
    @JsonKey(name: "manufacturingCountryId") String? manufacturingCountryId,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "isDeleted") bool? isDeleted,
    @JsonKey(name: "images") List<dynamic>? images,
    @JsonKey(name: "createdAt") DateTime? createdAt,
    @JsonKey(name: "updatedAt") DateTime? updatedAt,
    @JsonKey(name: "__v") int? v,
    @JsonKey(name: "qrcode") String? qrcode,
    @JsonKey(name: "supplierSales") List<SupplierSale>? supplierSales,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}

@freezed
class SupplierSale with _$SupplierSale {
  const factory SupplierSale({
    @JsonKey(name: "supplier") Supplier? supplier,
  }) = _SupplierSale;

  factory SupplierSale.fromJson(Map<String, dynamic> json) =>
      _$SupplierSaleFromJson(json);
}

@freezed
class Supplier with _$Supplier {
  const factory Supplier({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "companyName") String? companyName,
    @JsonKey(name: "sale") List<Sale>? sale,
  }) = _Supplier;

  factory Supplier.fromJson(Map<String, dynamic> json) =>
      _$SupplierFromJson(json);
}

@freezed
class Sale with _$Sale {
  const factory Sale({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "productId") String? productId,
    @JsonKey(name: "supplierId") String? supplierId,
    @JsonKey(name: "saleId") String? saleId,
    @JsonKey(name: "isDeleted") bool? isDeleted,
    @JsonKey(name: "__v") int? v,
    @JsonKey(name: "createdAt") DateTime? createdAt,
    @JsonKey(name: "updatedAt") DateTime? updatedAt,
    @JsonKey(name: "sales") Sales? sales,
  }) = _Sale;

  factory Sale.fromJson(Map<String, dynamic> json) => _$SaleFromJson(json);
}

@freezed
class Sales with _$Sales {
  const factory Sales({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "supplierDetails") String? supplierDetails,
    @JsonKey(name: "salesName") String? salesName,
    @JsonKey(name: "discountPercentage") int? discountPercentage,
    @JsonKey(name: "salesType") String? salesType,
    @JsonKey(name: "salesDescription") String? salesDescription,
    @JsonKey(name: "fromDate") DateTime? fromDate,
    @JsonKey(name: "endDate") DateTime? endDate,
    @JsonKey(name: "salesTerms") String? salesTerms,
    @JsonKey(name: "isDeleted") bool? isDeleted,
    @JsonKey(name: "createdAt") DateTime? createdAt,
    @JsonKey(name: "updatedAt") DateTime? updatedAt,
    @JsonKey(name: "__v") int? v,
  }) = _Sales;

  factory Sales.fromJson(Map<String, dynamic> json) => _$SalesFromJson(json);
}
