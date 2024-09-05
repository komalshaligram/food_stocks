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
    int? status,
    @JsonKey(name: "data")
    List<ProductSale>? data,
    @JsonKey(name: "metaData")
    MetaData? metaData,
    @JsonKey(name: "message")
    String? message,
  }) = _ProductSalesResModel;

  factory ProductSalesResModel.fromJson(Map<String, dynamic> json) => _$ProductSalesResModelFromJson(json);
}

@freezed
class ProductSale with _$ProductSale{
  const factory ProductSale({
    @JsonKey(name: "createdAt")
    String? createdAt,
    @JsonKey(name: "isBottle")
    bool? isBottle,
    @JsonKey(name: "itemsWeight")
    String? itemsWeight,
    @JsonKey(name: "numberOfUnit")
    String? numberOfUnit,
    @JsonKey(name: "totalWeight")
    String? totalWeight,
    @JsonKey(name: "totalWeightCardboard")
    String? totalWeightCardboard,
    @JsonKey(name: "totalWeightSurface")
    String? totalWeightSurface,
    @JsonKey(name: "updatedAt")
    String? updatedAt,
    @JsonKey(name: "productStock")
    double? productStock,
    @JsonKey(name: "sale")
    Sale? sale,
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "productName")
    String? productName,
    @JsonKey(name: "brandId")
    String? brandId,
    @JsonKey(name: "brandLogo")
    String? brandLogo,
    @JsonKey(name: "manufactureName")
    String? manufactureName,
    @JsonKey(name: "healthAndLifestye")
    String? healthAndLifestye,
    @JsonKey(name: "productDescription")
    String? productDescription,
    @JsonKey(name: "component")
    String? component,
    @JsonKey(name: "nutritionalValue")
    String? nutritionalValue,
    @JsonKey(name: "mainImage")
    String? mainImage,
    @JsonKey(name: "images")
    List<dynamic>? images,
    @JsonKey(name: "qrcode")
    String? qrcode,
    @JsonKey(name: "sku")
    String? sku,
    @JsonKey(name: "isPesach")
    bool? isPesach,
    @JsonKey(name: "nmMashlim")
    String? nmMashlim,
    @JsonKey(name: "createdBy")
    String? createdBy,
    @JsonKey(name: "updatedBy")
    String? updatedBy,
    @JsonKey(name: "categories")
    String? categories,
    @JsonKey(name: "subcategories")
    String? subcategories,
    @JsonKey(name: "subCategoryPseachOrder")
    int? subCategoryPseachOrder,
    @JsonKey(name: "manufacturingCountry")
    String? manufacturingCountry,
    @JsonKey(name: "caseType")
    String? caseType,
    @JsonKey(name: "scale")
    String? scale,
    @JsonKey(name: "status")
    String? status,
    @JsonKey(name: "productNumber")
    String? productNumber,
    @JsonKey(name: "boxes")
    double? boxes,
    @JsonKey(name: "productPrice")
    double? productPrice,
    @JsonKey(name: "totalSale")
    int? totalSale,
    @JsonKey(name: "lowStock")
    String? lowStock,
  }) = _ProductSale;

  factory ProductSale.fromJson(Map<String, dynamic> json) => _$ProductSaleFromJson(json);
}

@freezed
class Sale with _$Sale {
  const factory Sale({
    @JsonKey(name: "isSale")
    bool? isSale,
    @JsonKey(name: "salePrice")
    String? salePrice,
    @JsonKey(name: "saleFromDate")
    String? saleFromDate,
    @JsonKey(name: "saleUntilDate")
    String? saleUntilDate,
    @JsonKey(name: "saleMaxQuantity")
    String? saleMaxQuantity,
    @JsonKey(name: "saleDescription")
    String? saleDescription,
  }) = _Sale;

  factory Sale.fromJson(Map<String, dynamic> json) => _$SaleFromJson(json);
}

@freezed
class MetaData with _$MetaData {
  const factory MetaData({
    @JsonKey(name: "currentPage")
    int? currentPage,
    @JsonKey(name: "totalFilteredCount")
    int? totalFilteredCount,
    @JsonKey(name: "totalFilteredPage")
    int? totalFilteredPage,
  }) = _MetaData;

  factory MetaData.fromJson(Map<String, dynamic> json) => _$MetaDataFromJson(json);
}
