import 'package:freezed_annotation/freezed_annotation.dart';

part 'related_product_res_model.freezed.dart';
part 'related_product_res_model.g.dart';

@freezed
class RelatedProductResModel with _$RelatedProductResModel {
  const factory RelatedProductResModel({
    int? status,
    String? message,
    List<RelatedProductDatum>? data,
  }) = _RelatedProductResModel;

  factory RelatedProductResModel.fromJson(Map<String, dynamic> json) => _$RelatedProductResModelFromJson(json);
}

@freezed
class RelatedProductDatum with _$RelatedProductDatum {
  const factory RelatedProductDatum({
    @JsonKey(name: "numberOfUnit")
    String? numberOfUnit,
    @JsonKey(name: "supplierId")
    String? supplierId,
    @JsonKey(name: "itemsWeight")
    String? itemsWeight,
    @JsonKey(name: "isBottle")
    bool? isBottle,
    @JsonKey(name: "totalWeight")
    String? totalWeight,
    @JsonKey(name: "sale")
    Sale? sale,
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "productName")
    String? productName,
    @JsonKey(name: "quantity")
    int? quantity,
    @JsonKey(name: "brandId")
    String? brandId,
    @JsonKey(name: "brandLogo")
    String? brandLogo,
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
    @JsonKey(name: "numberProductStock")
    int? numberProductStock,
    @JsonKey(name: "productPrice")
    double? productPrice,
    @JsonKey(name: "totalSale")
    int? totalSale,
    @JsonKey(name: "lowStock")
    String? lowStock,
  }) = _Datum;

  factory RelatedProductDatum.fromJson(Map<String, dynamic> json) => _$RelatedProductDatumFromJson(json);
}

@freezed
class Sale with _$Sale {
  const factory Sale({
    @JsonKey(name: "isSale")
    bool? isSale,
    @JsonKey(name: "isMixedSale")
    bool? isMixedSale,
    @JsonKey(name: "sameSaleProducts")
    List<dynamic>? sameSaleProducts,
    @JsonKey(name: "salePrice")
    String? salePrice,
    @JsonKey(name: "saleFromDate")
    String? saleFromDate,
    @JsonKey(name: "saleUntilDate")
    String? saleUntilDate,
    @JsonKey(name: "saleMaxQuantity")
    String? saleMaxQuantity,
    @JsonKey(name: "saleMinQuantity")
    String? saleMinQuantity,
    @JsonKey(name: "saleDescription")
    String? saleDescription,
  }) = _Sale;

  factory Sale.fromJson(Map<String, dynamic> json) => _$SaleFromJson(json);
}