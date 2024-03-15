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
    required String numberOfUnit,
    required String itemsWeight,
    required String totalWeightCardboard,
    required String totalWeightSurface,
    required String totalWeight,
    required String createdAt,
    required String updatedAt,
    required bool isBottle,

    @JsonKey(name:"_id")
    required String id,
    required String productName,
    required String brandId,
    required String brandLogo,
    required String manufactureName,
    required String healthAndLifestye,
    required String productDescription,
    required String component,
    required String nutritionalValue,
    required String mainImage,
    required List<dynamic> images,
    required String qrcode,
    required String sku,
    required String createdBy,
    required String updatedBy,
    required String categories,
    required String subcategories,
    required String manufacturingCountry,
    required String caseType,
    required String scale,
    required String status,
    required String productNumber,
    required String productStock,
    required double productPrice,
    required int totalSale,
    required String lowStock
  }) = _Datum;

  factory RelatedProductDatum.fromJson(Map<String, dynamic> json) => _$RelatedProductDatumFromJson(json);
}