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
    @JsonKey(name: "healthAndLifestye") String? healthAndLifestye,
    @JsonKey(name: "productDescription") String? productDescription,
    @JsonKey(name: "component") String? component,
    @JsonKey(name: "nutritionalValue") String? nutritionalValue,
    @JsonKey(name: "qrcode") String? qrcode,
    @JsonKey(name: "sku") String? sku,
    @JsonKey(name: "itemsWeight") int? itemsWeight,
    @JsonKey(name: "totalWeightCardboard") int? totalWeightCardboard,
    @JsonKey(name: "totalWeightSurface") int? totalWeightSurface,
    @JsonKey(name: "totalWeight") int? totalWeight,
    @JsonKey(name: "kosharMilk") bool? kosharMilk,
    @JsonKey(name: "dairyMeatyAndFur") String? dairyMeatyAndFur,
    @JsonKey(name: "categoryId") String? categoryId,
    @JsonKey(name: "subCategoryId") String? subCategoryId,
    @JsonKey(name: "subSubCategoryId") String? subSubCategoryId,
    @JsonKey(name: "manufacturingCountryId") String? manufacturingCountryId,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "isDeleted") bool? isDeleted,
    @JsonKey(name: "images") List<Image>? images,
    @JsonKey(name: "createdAt") DateTime? createdAt,
    @JsonKey(name: "updatedAt") DateTime? updatedAt,
    @JsonKey(name: "__v") int? v,
    @JsonKey(name: "mainImage") String? mainImage,
    @JsonKey(name: "caseTypeId") String? caseTypeId,
    @JsonKey(name: "numberOfUnit") int? numberOfUnit,
    @JsonKey(name: "scaleId") String? scaleId,
    @JsonKey(name: "supplierSales") SupplierSales? supplierSales,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}

@freezed
class Image with _$Image {
  const factory Image({
    @JsonKey(name: "imageUrl") String? imageUrl,
    @JsonKey(name: "order") int? order,
  }) = _Image;

  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);
}

@freezed
class SupplierSales with _$SupplierSales {
  const factory SupplierSales({
    @JsonKey(name: "supplier") Supplier? supplier,
  }) = _SupplierSales;

  factory SupplierSales.fromJson(Map<String, dynamic> json) =>
      _$SupplierSalesFromJson(json);
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
    @JsonKey(name: "saleId") String? saleId,
    @JsonKey(name: "sd") String? sd,
    @JsonKey(name: "salesName") String? salesName,
    @JsonKey(name: "discountPercentage") int? discountPercentage,
    @JsonKey(name: "salesDescription") String? salesDescription,
    @JsonKey(name: "fromDate") DateTime? fromDate,
    @JsonKey(name: "endDate") DateTime? endDate,
  }) = _Sale;

  factory Sale.fromJson(Map<String, dynamic> json) => _$SaleFromJson(json);
}
