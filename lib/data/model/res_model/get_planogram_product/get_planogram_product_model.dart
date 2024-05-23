import 'package:freezed_annotation/freezed_annotation.dart';
part 'get_planogram_product_model.freezed.dart';
part 'get_planogram_product_model.g.dart';



@freezed
class GetPlanogramProductModel with _$GetPlanogramProductModel {
  const factory GetPlanogramProductModel({
    @JsonKey(name: "status")
    int? status,
    @JsonKey(name: "data")
    List<PlanogramAllProduct>? data,
    @JsonKey(name: "metaData")
    MetaData? metaData,
    @JsonKey(name: "message")
    String? message,
  }) = _GetPlanogramProductModel;

  factory GetPlanogramProductModel.fromJson(Map<String, dynamic> json) => _$GetPlanogramProductModelFromJson(json);
}

@freezed
class PlanogramAllProduct with _$PlanogramAllProduct {
  const factory PlanogramAllProduct({
    @JsonKey(name: "_id")
    required String id,
    @JsonKey(name: "subCategoryId")
    required String subCategoryId,
    @JsonKey(name: "productId")
    required String productId,
    @JsonKey(name: "__v")
    required int v,
    @JsonKey(name: "createdAt")
    required DateTime createdAt,
    @JsonKey(name: "isDeleted")
    required bool isDeleted,
    @JsonKey(name: "isHomePreference")
    required bool isHomePreference,
    @JsonKey(name: "order")
    required int order,
    @JsonKey(name: "updatedAt")
    required DateTime updatedAt,
    @JsonKey(name: "product")
    required PlanoProduct product,
    @JsonKey(name: "sortField")
    required double sortField,
  }) = _PlanogramAllProduct;

  factory PlanogramAllProduct.fromJson(Map<String, dynamic> json) => _$PlanogramAllProductFromJson(json);
}

@freezed
class PlanoProduct with _$PlanoProduct {
  const factory PlanoProduct({
    @JsonKey(name: "numberOfUnit")
    required String numberOfUnit,
    @JsonKey(name: "itemsWeight")
    required String itemsWeight,
    @JsonKey(name: "totalWeightCardboard")
    required String totalWeightCardboard,
    @JsonKey(name: "totalWeightSurface")
    required String totalWeightSurface,
    @JsonKey(name: "createdAt")
    required String createdAt,
    @JsonKey(name: "updatedAt")
    required String updatedAt,
    @JsonKey(name: "isBottle")
    required bool isBottle,
    @JsonKey(name: "filterProductId")
    required String filterProductId,
    @JsonKey(name: "filterBrandId")
    required String filterBrandId,
    @JsonKey(name: "filterCategoryId")
    required String filterCategoryId,
    @JsonKey(name: "totalWeight")
    required String totalWeight,
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
    @JsonKey(name: "productStock")
    required String productStock,
    @JsonKey(name: "productPrice")
    required double productPrice,
    @JsonKey(name: "totalSale")
    required int totalSale,
    @JsonKey(name: "lowStock")
    required String lowStock,
  }) = _PlanoProduct;

  factory PlanoProduct.fromJson(Map<String, dynamic> json) => _$PlanoProductFromJson(json);
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
    int? currentPage,
    @JsonKey(name: "totalFilteredCount")
    int? totalFilteredCount,
    @JsonKey(name: "totalFilteredPage")
    int? totalFilteredPage,
  }) = _MetaData;

  factory MetaData.fromJson(Map<String, dynamic> json) => _$MetaDataFromJson(json);
}