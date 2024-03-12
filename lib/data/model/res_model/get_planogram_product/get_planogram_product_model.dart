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
    String? id,
    @JsonKey(name: "productId")
    String? productId,
    @JsonKey(name: "subCategoryId")
    String? subCategoryId,
    @JsonKey(name: "__v")
    int? v,
    @JsonKey(name: "createdAt")
    DateTime? createdAt,
    @JsonKey(name: "isDeleted")
    bool? isDeleted,
    @JsonKey(name: "isHomePreference")
    bool? isHomePreference,
    @JsonKey(name: "order")
    int? order,
    @JsonKey(name: "updatedAt")
    DateTime? updatedAt,
    @JsonKey(name: "product")
    PlanoProduct? product,
    @JsonKey(name: "sortField")
    double? sortField,
  }) = _PlanogramAllProduct;

  factory PlanogramAllProduct.fromJson(Map<String, dynamic> json) => _$PlanogramAllProductFromJson(json);
}

@freezed
class PlanoProduct with _$PlanoProduct {
  const factory PlanoProduct({
    @JsonKey(name: "numberOfUnit")
    String? numberOfUnit,
    @JsonKey(name: "itemsWeight")
    String? itemsWeight,
    @JsonKey(name: "totalWeightCardboard")
    String? totalWeightCardboard,
    @JsonKey(name: "totalWeightSurface")
    String? totalWeightSurface,
    @JsonKey(name: "totalWeight")
    String? totalWeight,
    @JsonKey(name: "createdAt")
    String? createdAt,
    @JsonKey(name: "updatedAt")
    String? updatedAt,
    @JsonKey(name: "isBottle")
    bool? isBottle,
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
    @JsonKey(name: "createdBy")
    String? createdBy,
    @JsonKey(name: "updatedBy")
    String? updatedBy,
    @JsonKey(name: "categories")
    String? categories,
    @JsonKey(name: "subcategories")
    String? subcategories,
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
    @JsonKey(name: "productStock")
    String? productStock,
    @JsonKey(name: "productPrice")
    double? productPrice,
    @JsonKey(name: "totalSale")
    int? totalSale,
    String? lowStock,
  }) = _PlanoProduct;

  factory PlanoProduct.fromJson(Map<String, dynamic> json) => _$PlanoProductFromJson(json);
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