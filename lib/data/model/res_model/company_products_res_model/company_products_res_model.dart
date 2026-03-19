import 'package:freezed_annotation/freezed_annotation.dart';
part 'company_products_res_model.freezed.dart';
part 'company_products_res_model.g.dart';

@freezed
class CompanyProductsResModel with _$CompanyProductsResModel {
  const factory CompanyProductsResModel({
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "data") List<CompanyData>? data,
    @JsonKey(name: "metaData") MetaData? metaData,
    @JsonKey(name: "message") String? message,
  }) = _CompanyProductsResModel;

  factory CompanyProductsResModel.fromJson(Map<String, dynamic> json) => _$CompanyProductsResModelFromJson(json);
}

@freezed
class CompanyData with _$CompanyData {
  const factory CompanyData({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "brandId") String? brandId,
    @JsonKey(name: "productId") String? productId,
    @JsonKey(name: "__v") int? v,
    @JsonKey(name: "createdAt") String? createdAt,
    @JsonKey(name: "isDeleted") bool? isDeleted,
    @JsonKey(name: "isHomePreference") bool? isHomePreference,
    @JsonKey(name: "order") int? order,
    @JsonKey(name: "updatedAt") String? updatedAt,
    @JsonKey(name: "product") CompanyProduct? product,
    @JsonKey(name: "sortField") double? sortField,
  }) = _CompanyData;

  factory CompanyData.fromJson(Map<String, dynamic> json) => _$CompanyDataFromJson(json);
}

@freezed
class CompanyProduct with _$CompanyProduct {
  const factory CompanyProduct({
    @JsonKey(name: "numberOfUnit") String? numberOfUnit,
    @JsonKey(name: "supplierId") String? supplierId,
    @JsonKey(name: "itemsWeight") String? itemsWeight,
    @JsonKey(name: "totalWeightCardboard") String? totalWeightCardboard,
    @JsonKey(name: "totalWeightSurface") String? totalWeightSurface,
    @JsonKey(name: "createdAt") String? createdAt,
    @JsonKey(name: "updatedAt") String? updatedAt,
    @JsonKey(name: "isBottle") bool? isBottle,
    @JsonKey(name: "filterProductId") String? filterProductId,
    @JsonKey(name: "filterBrandId") String? filterBrandId,
    @JsonKey(name: "filterCategoryId") String? filterCategoryId,
    @JsonKey(name: "totalWeight") String? totalWeight,
    @JsonKey(name: "sale") Sale? sale,
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "productName") String? productName,
    @JsonKey(name: "brandId") String? brandId,
    @JsonKey(name: "brandLogo") String? brandLogo,
    @JsonKey(name: "manufactureName") String? manufactureName,
    @JsonKey(name: "healthAndLifestye") String? healthAndLifestye,
    @JsonKey(name: "productDescription") String? productDescription,
    @JsonKey(name: "component") String? component,
    @JsonKey(name: "nutritionalValue") String? nutritionalValue,
    @JsonKey(name: "mainImage") String? mainImage,
    @JsonKey(name: "images") List<dynamic>? images,
    @JsonKey(name: "qrcode") String? qrcode,
    @JsonKey(name: "sku") String? sku,
    @JsonKey(name: "isPesach") bool? isPesach,
    @JsonKey(name: "nmMashlim") String? nmMashlim,
    @JsonKey(name: "createdBy") String? createdBy,
    @JsonKey(name: "updatedBy") String? updatedBy,
    @JsonKey(name: "categories") String? categories,
    @JsonKey(name: "subcategories") String? subcategories,
    @JsonKey(name: "manufacturingCountry") String? manufacturingCountry,
    @JsonKey(name: "caseType") String? caseType,
    @JsonKey(name: "scale") String? scale,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "productNumber") String? productNumber,
    @JsonKey(name: "productStock") String? productStock,
    @JsonKey(name: "productPrice") double? productPrice,
    @JsonKey(name: "totalSale") int? totalSale,
    @JsonKey(name: "lowStock") String? lowStock,
    @JsonKey(name: "recommendedRetailPrice") String? recommendedRetailPrice,
    @JsonKey(name: "recommendedConsumerOffer") String? recommendedConsumerOffer,
  }) = _CompanyProduct;

  factory CompanyProduct.fromJson(Map<String, dynamic> json) => _$CompanyProductFromJson(json);
}

@freezed
class Sale with _$Sale {
  const factory Sale({
    @JsonKey(name: "isSale") bool? isSale,
    @JsonKey(name: "isMixedSale") bool? isMixedSale,
    @JsonKey(name: "sameSaleProducts") List<dynamic>? sameSaleProducts,
    @JsonKey(name: "salePrice") String? salePrice,
    @JsonKey(name: "saleFromDate") String? saleFromDate,
    @JsonKey(name: "saleUntilDate") String? saleUntilDate,
    @JsonKey(name: "saleMaxQuantity") String? saleMaxQuantity,
    @JsonKey(name: "saleMinQuantity") String? saleMinQuantity,
    @JsonKey(name: "saleDescription") String? saleDescription,
  }) = _Sale;

  factory Sale.fromJson(Map<String, dynamic> json) => _$SaleFromJson(json);
}

@freezed
class MetaData with _$MetaData {
  const factory MetaData({
    @JsonKey(name: "currentPage") int? currentPage,
    @JsonKey(name: "totalFilteredCount") int? totalFilteredCount,
    @JsonKey(name: "totalFilteredPage") int? totalFilteredPage,
  }) = _MetaData;

  factory MetaData.fromJson(Map<String, dynamic> json) => _$MetaDataFromJson(json);
}
