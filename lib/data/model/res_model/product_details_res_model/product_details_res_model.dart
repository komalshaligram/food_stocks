// To parse this JSON data, do
//
//     final productDetailsResModel = productDetailsResModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'product_details_res_model.freezed.dart';
part 'product_details_res_model.g.dart';

ProductDetailsResModel productDetailsResModelFromJson(String str) => ProductDetailsResModel.fromJson(json.decode(str));

String productDetailsResModelToJson(ProductDetailsResModel data) => json.encode(data.toJson());

@freezed
class ProductDetailsResModel with _$ProductDetailsResModel
{
  @JsonSerializable(includeIfNull: false)
  const factory ProductDetailsResModel({
    @JsonKey(name: "status")
    required int status,
    @JsonKey(name: "product")
    required List<Product> product,
    @JsonKey(name: "message")
    required String message,
  }) = _ProductDetailsResModel;

  factory ProductDetailsResModel.fromJson(Map<String, dynamic> json) => _$ProductDetailsResModelFromJson(json);
}

@freezed
class Product with _$Product {
  @JsonSerializable(includeIfNull: true)
  const factory Product({
    @JsonKey(name: "_id")
    required String id,
    @JsonKey(name: "productName")
    required String productName,
    @JsonKey(name: "brandId")
    required String brandId,
    @JsonKey(name: "mainImage")
    required String mainImage,
    @JsonKey(name: "qrcode")
    required String qrcode,
    @JsonKey(name: "sku")
    required String sku,
    @JsonKey(name: "numberOfUnit")
    required int numberOfUnit,
    @JsonKey(name: "itemsWeight")
    required int itemsWeight,
    @JsonKey(name: "totalWeightCardboard")
    required int totalWeightCardboard,
    @JsonKey(name: "totalWeightSurface")
    required int totalWeightSurface,
    @JsonKey(name: "totalWeight")
    required int totalWeight,
    @JsonKey(name: "kosharMilk")
    required bool kosharMilk,
    @JsonKey(name: "dairyMeatyAndFur")
    required String dairyMeatyAndFur,
    @JsonKey(name: "categoryId",includeIfNull: false)
    required String categoryId,
    @JsonKey(name: "subCategoryId",includeIfNull: false)
    required String subCategoryId,
    @JsonKey(name: "manufacturingCountryId",includeIfNull: false)
    required String manufacturingCountryId,
    @JsonKey(name: "caseTypeId")
    required String caseTypeId,
    @JsonKey(name: "scaleId")
    required String scaleId,
    @JsonKey(name: "status")
    required String status,
    @JsonKey(name: "isDeleted")
    required bool isDeleted,
    @JsonKey(name: "productNumber")
    required int productNumber,
    @JsonKey(name: "images")
    required List<dynamic> images,
    @JsonKey(name: "isBottle")
    required bool isBottle,
    @JsonKey(name: "nmMashlim")
    required String nmMashlim,
    @JsonKey(name: "isPesach",includeIfNull: false)
    required bool isPesach,
    @JsonKey(name: "statusId")
    required String statusId,
    @JsonKey(name: "sale")
    required SaleProduct sale,
    @JsonKey(name: "scales")
    required Scales scales,
    @JsonKey(name: "supplierSales")
    required List<SupplierSale> supplierSales,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}

@freezed
class SaleProduct with _$SaleProduct {
  @JsonSerializable(includeIfNull: false)
  const factory SaleProduct({
    @JsonKey(name: "isSale")
    required bool isSale,
    @JsonKey(name: "salePrice")
    required String salePrice,
    @JsonKey(name: "saleFromDate")
    required String saleFromDate,
    @JsonKey(name: "saleUntilDate")
    required String saleUntilDate,
    @JsonKey(name: "saleMaxQuantity")
    required String saleMaxQuantity,
    @JsonKey(name: "saleDescription")
    required String saleDescription,
  }) = _SaleProduct;

  factory SaleProduct.fromJson(Map<String, dynamic> json) => _$SaleProductFromJson(json);
}

@freezed
class Scales with _$Scales {
  @JsonSerializable(includeIfNull: false)
  const factory Scales({
    @JsonKey(name: "_id")
    required String id,
    @JsonKey(name: "scaleType")
    required String scaleType,
    @JsonKey(name: "createdAt")
    required DateTime createdAt,
    @JsonKey(name: "updatedAt")
    required DateTime updatedAt,
    @JsonKey(name: "__v")
    required int v,
    @JsonKey(name: "isDeleted")
    required bool isDeleted,
    @JsonKey(name: "scaleNumber")
    required int scaleNumber,
  }) = _Scales;

  factory Scales.fromJson(Map<String, dynamic> json) => _$ScalesFromJson(json);
}

@freezed
class SupplierSale with _$SupplierSale {
  @JsonSerializable(includeIfNull: false)
  const factory SupplierSale({
    @JsonKey(name: "_id")
    required Id id,
    @JsonKey(name: "supplierId")
    required String supplierId,
    @JsonKey(name: "supplierName")
    required String supplierName,
    @JsonKey(name: "supplierCompanyName")
    required String supplierCompanyName,
    @JsonKey(name: "productPrice")
    required String productPrice,
    @JsonKey(name: "productStock")
    required String productStock,
    @JsonKey(name: "saleProduct")
    required List<dynamic> saleProduct,
    @JsonKey(name: "lowStock")
    required String lowStock,
  }) = _SupplierSale;

  factory SupplierSale.fromJson(Map<String, dynamic> json) => _$SupplierSaleFromJson(json);
}

@freezed
class Id with _$Id {
  const factory Id({
    @JsonKey(name: "supplierId")
    required String supplierId,
    @JsonKey(name: "productId")
    required String productId,
  }) = _Id;

  factory Id.fromJson(Map<String, dynamic> json) => _$IdFromJson(json);
}
