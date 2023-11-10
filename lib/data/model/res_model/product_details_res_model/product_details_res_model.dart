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
    @JsonKey(name: "sku") String? sku,
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
    @JsonKey(name: "qrcode") String? qrcode,
    @JsonKey(name: "mainImage") String? mainImage,
    @JsonKey(name: "itemsWeight") int? itemsWeight,
    @JsonKey(name: "totalWeight") int? totalWeight,
    @JsonKey(name: "totalWeightCardboard") int? totalWeightCardboard,
    @JsonKey(name: "totalWeightSurface") int? totalWeightSurface,
    @JsonKey(name: "numberOfUnit") int? numberOfUnit,
    @JsonKey(name: "scaleId") String? scaleId,
    @JsonKey(name: "scales") Scales? scales,
    @JsonKey(name: "supplierSales") List<SupplierSale>? supplierSales,
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
class Scales with _$Scales {
  const factory Scales({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "scaleType") String? scaleType,
    @JsonKey(name: "createdAt") DateTime? createdAt,
    @JsonKey(name: "updatedAt") DateTime? updatedAt,
    @JsonKey(name: "__v") int? v,
  }) = _Scales;

  factory Scales.fromJson(Map<String, dynamic> json) => _$ScalesFromJson(json);
}

@freezed
class SupplierSale with _$SupplierSale {
  const factory SupplierSale({
    @JsonKey(name: "_id") Id? id,
    @JsonKey(name: "supplierId") String? supplierId,
    @JsonKey(name: "supplierName") String? supplierName,
    @JsonKey(name: "supplierCompanyName") String? supplierCompanyName,
    @JsonKey(name: "productPrice") String? productPrice,
    @JsonKey(name: "saleProduct") List<SaleProduct>? saleProduct,
  }) = _SupplierSale;

  factory SupplierSale.fromJson(Map<String, dynamic> json) =>
      _$SupplierSaleFromJson(json);
}

@freezed
class Id with _$Id {
  const factory Id({
    @JsonKey(name: "supplierId") String? supplierId,
    @JsonKey(name: "productId") String? productId,
  }) = _Id;

  factory Id.fromJson(Map<String, dynamic> json) => _$IdFromJson(json);
}

@freezed
class SaleProduct with _$SaleProduct {
  const factory SaleProduct({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "price") String? price,
    @JsonKey(name: "discountPercentage") String? discountPercentage,
    @JsonKey(name: "discountedPrice") String? discountedPrice,
    @JsonKey(name: "saleId") String? saleId,
    @JsonKey(name: "saleName") String? saleName,
    @JsonKey(name: "salesDescription") String? salesDescription,
  }) = _SaleProduct;

  factory SaleProduct.fromJson(Map<String, dynamic> json) =>
      _$SaleProductFromJson(json);
}
