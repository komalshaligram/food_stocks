import 'package:freezed_annotation/freezed_annotation.dart';
part 'supplier_list_products_response_model.freezed.dart';
part 'supplier_list_products_response_model.g.dart';

@freezed
class SupplierListProductsResponseModel with _$SupplierListProductsResponseModel {
  const factory SupplierListProductsResponseModel({
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "data") SupplierListProductsData? data,
    @JsonKey(name: "metaData") MetaData? metaData,
    @JsonKey(name: "message") String? message,
  }) = _SupplierListProductsResponseModel;

  factory SupplierListProductsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SupplierListProductsResponseModelFromJson(json);
}

@freezed
class SupplierListProductsData with _$SupplierListProductsData {
  const factory SupplierListProductsData({
    @JsonKey(name: "brands") List<BrandData>? brands,
    @JsonKey(name: "categories") List<SupplierCategoryData>? categories,
    @JsonKey(name: "subCategories") List<SupplierSubCategoryData>? subCategories,
    @JsonKey(name: "products") List<ProductData>? products,
  }) = _SupplierListProductsData;

  factory SupplierListProductsData.fromJson(Map<String, dynamic> json) =>
      _$SupplierListProductsDataFromJson(json);
}

@freezed
class SupplierCategoryData with _$SupplierCategoryData {
  const factory SupplierCategoryData({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "categoryName") String? categoryName,
    @JsonKey(name: "categoryImage") String? categoryImage,
    @JsonKey(name: "isHomePreference") bool? isHomePreference,
    @JsonKey(name: "order") int? order,
  }) = _SupplierCategoryData;

  factory SupplierCategoryData.fromJson(Map<String, dynamic> json) =>
      _$SupplierCategoryDataFromJson(json);
}

@freezed
class SupplierSubCategoryData with _$SupplierSubCategoryData {
  const factory SupplierSubCategoryData({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "subCategoryName") String? subCategoryName,
  }) = _SupplierSubCategoryData;

  factory SupplierSubCategoryData.fromJson(Map<String, dynamic> json) =>
      _$SupplierSubCategoryDataFromJson(json);
}

@freezed
class BrandData with _$BrandData {
  const factory BrandData({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "brandName") String? brandName,
    @JsonKey(name: "brandLogo") String? brandLogo,
    @JsonKey(name: "isHomePreference") bool? isHomePreference,
    @JsonKey(name: "order") int? order,
    @JsonKey(name: "isDeleted") bool? isDeleted,
    @JsonKey(name: "brandNumber") int? brandNumber,
    @JsonKey(name: "createdAt") String? createdAt,
    @JsonKey(name: "updatedAt") String? updatedAt,
  }) = _BrandData;

  factory BrandData.fromJson(Map<String, dynamic> json) =>
      _$BrandDataFromJson(json);
}

@freezed
class ProductData with _$ProductData {
  const factory ProductData({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "productName") String? productName,
    @JsonKey(name: "brandId") String? brandId,
    @JsonKey(name: "brandLogo") String? brandLogo,
    @JsonKey(name: "supplierId") String? supplierId,
    @JsonKey(name: "mainImage") String? mainImage,
    @JsonKey(name: "images") List<dynamic>? images,
    @JsonKey(name: "sku") String? sku,
    @JsonKey(name: "qrcode") String? qrcode,
    @JsonKey(name: "productNumber") String? productNumber,
    @JsonKey(name: "categories") String? categories,
    @JsonKey(name: "subcategories") String? subcategories,
    @JsonKey(name: "productDescription") String? productDescription,
    @JsonKey(name: "component") String? component,
    @JsonKey(name: "healthAndLifestye") String? healthAndLifestye,
    @JsonKey(name: "numberOfUnit") String? numberOfUnit,
    @JsonKey(name: "scaleType") String? scaleType,
    @JsonKey(name: "isBottle") bool? isBottle,
    @JsonKey(name: "isPesach") bool? isPesach,
    @JsonKey(name: "nmMashlim") String? nmMashlim,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "productStock") dynamic productStock,
    @JsonKey(name: "productPrice") dynamic productPrice,
    @JsonKey(name: "stringProductPrice") String? stringProductPrice,
    @JsonKey(name: "recommendedRetailPrice") String? recommendedRetailPrice,
    @JsonKey(name: "recommendedConsumerOffer") String? recommendedConsumerOffer,
    @JsonKey(name: "totalSale") int? totalSale,
    @JsonKey(name: "lowStock") String? lowStock,
    @JsonKey(name: "createdAt") String? createdAt,
    @JsonKey(name: "updatedAt") String? updatedAt,
    @JsonKey(name: "sale") Sale? sale,

    // filters
    @JsonKey(name: "filterProductId") String? filterProductId,
    @JsonKey(name: "filterBrandId") String? filterBrandId,
    @JsonKey(name: "filterCategoryId") String? filterCategoryId,
    @JsonKey(name: "filterSupplierId") String? filterSupplierId,
    @JsonKey(name: "filtersubCategoryId") String? filtersubCategoryId,
  }) = _ProductData;

  factory ProductData.fromJson(Map<String, dynamic> json) =>
      _$ProductDataFromJson(json);
}

@freezed
class Sale with _$Sale {
  const factory Sale({
    @JsonKey(name: "isSale") bool? isSale,
    @JsonKey(name: "salePrice") String? salePrice,
    @JsonKey(name: "saleFromDate") String? saleFromDate,
    @JsonKey(name: "saleUntilDate") String? saleUntilDate,
    @JsonKey(name: "saleMaxQuantity") String? saleMaxQuantity,
    @JsonKey(name: "saleMinQuantity") String? saleMinQuantity,
    @JsonKey(name: "saleDescription") String? saleDescription,
    @JsonKey(name: "isMixedSale") bool? isMixedSale,
    @JsonKey(name: "sameSaleProducts") List<dynamic>? sameSaleProducts,
  }) = _Sale;

  factory Sale.fromJson(Map<String, dynamic> json) =>
      _$SaleFromJson(json);
}

@freezed
class MetaData with _$MetaData {
  const factory MetaData({
    @JsonKey(name: "currentPage") int? currentPage,
    @JsonKey(name: "totalFilteredCount") int? totalFilteredCount,
    @JsonKey(name: "totalFilteredPage") int? totalFilteredPage,
  }) = _MetaData;

  factory MetaData.fromJson(Map<String, dynamic> json) =>
      _$MetaDataFromJson(json);
}