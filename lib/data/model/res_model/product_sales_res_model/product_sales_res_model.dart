import 'package:meta/meta.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'product_sales_res_model.freezed.dart';
part 'product_sales_res_model.g.dart';

ProductSalesResModel productSalesResModelFromJson(String str) => ProductSalesResModel.fromJson(json.decode(str));

String productSalesResModelToJson(ProductSalesResModel data) => json.encode(data.toJson());

@freezed
class ProductSalesResModel with _$ProductSalesResModel {
  const factory ProductSalesResModel({
    @JsonKey(name: "status")
    required int status,
    @JsonKey(name: "data")
    required List<ProductSale> data,
    @JsonKey(name: "metaData")
    required MetaData metaData,
    @JsonKey(name: "message")
    required String message,
  }) = _ProductSalesResModel;

  factory ProductSalesResModel.fromJson(Map<String, dynamic> json) => _$ProductSalesResModelFromJson(json);
}

@freezed
class ProductSale with _$ProductSale{
  const factory ProductSale({
    @JsonKey(name: "createdAt")
    required String createdAt,
    @JsonKey(name: "isBottle")
    required bool isBottle,
    @JsonKey(name: "itemsWeight")
    required String itemsWeight,
    @JsonKey(name: "numberOfUnit")
    required String numberOfUnit,
    @JsonKey(name: "totalWeightCardboard")
    required String totalWeightCardboard,
    @JsonKey(name: "totalWeightSurface")
    required String totalWeightSurface,
    @JsonKey(name: "updatedAt")
    required String updatedAt,
    @JsonKey(name: "totalWeight")
    required String totalWeight,
    @JsonKey(name: "productStock")
    required int productStock,
    @JsonKey(name: "sale")
    required Sale sale,
    @JsonKey(name: "_id")
    required String id,
    @JsonKey(name: "productName")
    required String productName,
    @JsonKey(name: "brandId")
    required String brandId,
    @JsonKey(name: "brandLogo")
    required String brandLogo,
    @JsonKey(name: "manufactureName")
    required String manufactureName,
    @JsonKey(name: "healthAndLifestye")
    required String healthAndLifestye,
    @JsonKey(name: "productDescription")
    required String productDescription,
    @JsonKey(name: "component")
    required String component,
    @JsonKey(name: "nutritionalValue")
    required String nutritionalValue,
    @JsonKey(name: "mainImage")
    required String mainImage,
    @JsonKey(name: "images")
    required List<dynamic> images,
    @JsonKey(name: "qrcode")
    required String qrcode,
    @JsonKey(name: "sku")
    required String sku,
    @JsonKey(name: "isPesach")
    required bool isPesach,
    @JsonKey(name: "nmMashlim")
    required String nmMashlim,
    @JsonKey(name: "createdBy")
    required String createdBy,
    @JsonKey(name: "updatedBy")
    required String updatedBy,
    @JsonKey(name: "categories")
    required String categories,
    @JsonKey(name: "subcategories")
    required String subcategories,
    @JsonKey(name: "subCategoryPseachOrder")
    required int subCategoryPseachOrder,
    @JsonKey(name: "manufacturingCountry")
    required String manufacturingCountry,
    @JsonKey(name: "caseType")
    required String caseType,
    @JsonKey(name: "scale")
    required String scale,
    @JsonKey(name: "status")
    required String status,
    @JsonKey(name: "productNumber")
    required String productNumber,
    @JsonKey(name: "boxes")
    required double boxes,
    @JsonKey(name: "productPrice")
    required double productPrice,
    @JsonKey(name: "totalSale")
    required int totalSale,
    @JsonKey(name: "lowStock")
    required String lowStock,
  }) = _ProductSale;

  factory ProductSale.fromJson(Map<String, dynamic> json) => _$ProductSaleFromJson(json);
}

@freezed
class Sale with _$Sale {
  const factory Sale({
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
  }) = _Sale;

  factory Sale.fromJson(Map<String, dynamic> json) => _$SaleFromJson(json);
}

@freezed
class MetaData with _$MetaData {
  const factory MetaData({
    @JsonKey(name: "currentPage")
    required int currentPage,
    @JsonKey(name: "totalFilteredCount")
    required int totalFilteredCount,
    @JsonKey(name: "totalFilteredPage")
    required int totalFilteredPage,
  }) = _MetaData;

  factory MetaData.fromJson(Map<String, dynamic> json) => _$MetaDataFromJson(json);
}
