import 'package:freezed_annotation/freezed_annotation.dart';

part 'related_product_res_model.freezed.dart';
part 'related_product_res_model.g.dart';

@freezed
class RelatedProductResModel with _$RelatedProductResModel {
  const factory RelatedProductResModel({
    required int status,
    required String message,
    required List<RelatedProductDatum> data,
  }) = _RelatedProductResModel;

  factory RelatedProductResModel.fromJson(Map<String, dynamic> json) => _$RelatedProductResModelFromJson(json);
}

@freezed
class RelatedProductDatum with _$RelatedProductDatum {
  const factory RelatedProductDatum({
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
    @JsonKey(name: "numberProductStock")
    required double numberProductStock,
    @JsonKey(name: "productPrice")
    required double productPrice,
    @JsonKey(name: "totalSale")
    required int totalSale,
    @JsonKey(name: "lowStock")
    required String lowStock,
  }) = _Datum;

  factory RelatedProductDatum.fromJson(Map<String, dynamic> json) => _$RelatedProductDatumFromJson(json);
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