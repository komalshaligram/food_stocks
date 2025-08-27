import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'product_details_res_model.freezed.dart';
part 'product_details_res_model.g.dart';

ProductDetailsResModel productDetailsResModelFromJson(String str) => ProductDetailsResModel.fromJson(json.decode(str));

String productDetailsResModelToJson(ProductDetailsResModel data) => json.encode(data.toJson());

@freezed
class ProductDetailsResModel with _$ProductDetailsResModel {
  @JsonSerializable(includeIfNull: false)
  const factory ProductDetailsResModel({
    int? status,
    @JsonKey(name: "data") List<Product>? product,
    String? message,
  }) = _ProductDetailsResModel;

  factory ProductDetailsResModel.fromJson(Map<String, dynamic> json) => _$ProductDetailsResModelFromJson(json);
}

@freezed
class Product with _$Product {
  @JsonSerializable(includeIfNull: true)
  const factory Product({
    @JsonKey(name: "_id") String? id,
    String? productName,
    String? brandId,
    String? mainImage,
    String? qrcode,
    String? sku,
    int? numberOfUnit,
    int? itemsWeight,
    int? totalWeightCardboard,
    int? totalWeightSurface,
    int? totalWeight,
    bool? kosharMilk,
    String? dairyMeatyAndFur,
    @JsonKey(name: "categoryId", includeIfNull: false) String? categoryId,
    @JsonKey(name: "subCategoryId", includeIfNull: false) String? subCategoryId,
    @JsonKey(name: "caseTypeId") String? caseTypeId,
    @JsonKey(name: "scaleId") String? scaleId,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "isDeleted") bool? isDeleted,
    @JsonKey(name: "productNumber") int? productNumber,
    @JsonKey(name: "images") List<dynamic>? images,
    @JsonKey(name: "isBottle") bool? isBottle,
    String? supplierId,
    String? supplierName,
    String? nmMashlim,
    @JsonKey(name: "isPesach", includeIfNull: false) bool? isPesach,
    String? statusId,
    SaleProduct? sale,
    Scales? scales,
    @JsonKey(name: "supplierSales") List<SupplierSale>? supplierSales,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}

@freezed
class SaleProduct with _$SaleProduct {
  @JsonSerializable(includeIfNull: false)
  const factory SaleProduct({
    bool? isSale,
    bool? isMixedSale,
    List<dynamic>? sameSaleProducts,
    String? salePrice,
    String? saleFromDate,
    String? saleUntilDate,
    String? saleMaxQuantity,
    String? saleMinQuantity,
    String? saleDescription,
  }) = _SaleProduct;

  factory SaleProduct.fromJson(Map<String, dynamic> json) => _$SaleProductFromJson(json);
}

@freezed
class Scales with _$Scales {
  @JsonSerializable(includeIfNull: false)
  const factory Scales({
    @JsonKey(name: "_id") String? id,
    String? scaleType,
    @JsonKey(name: "__v") int? v,
    bool? isDeleted,
    int? scaleNumber,
  }) = _Scales;

  factory Scales.fromJson(Map<String, dynamic> json) => _$ScalesFromJson(json);
}

@freezed
class SupplierSale with _$SupplierSale {
  @JsonSerializable(includeIfNull: false)
  const factory SupplierSale({
    @JsonKey(name: "_id") Id? id,
    String? supplierId,
    String? supplierName,
    String? supplierCompanyName,
    String? productPrice,
    String? productStock,
    List<dynamic>? saleProduct,
    String? lowStock,
  }) = _SupplierSale;

  factory SupplierSale.fromJson(Map<String, dynamic> json) => _$SupplierSaleFromJson(json);
}

@freezed
class Id with _$Id {
  const factory Id({
    String? supplierId,
    String? productId,
  }) = _Id;

  factory Id.fromJson(Map<String, dynamic> json) => _$IdFromJson(json);
}
