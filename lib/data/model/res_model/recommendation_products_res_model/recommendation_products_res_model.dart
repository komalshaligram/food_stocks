import 'package:freezed_annotation/freezed_annotation.dart';


part 'recommendation_products_res_model.freezed.dart';
part 'recommendation_products_res_model.g.dart';

@freezed
class RecommendationProductsResModel with _$RecommendationProductsResModel {
  const factory RecommendationProductsResModel({
    @JsonKey(name: "status")
    int? status,
    @JsonKey(name: "message")
    String? message,
    @JsonKey(name: "data")
    List<RecommendationData>? data,
    @JsonKey(name: "metaData")
    MetaData? metaData,
  }) = _RecommendationProductsResModel;

  factory RecommendationProductsResModel.fromJson(Map<String, dynamic> json) => _$RecommendationProductsResModelFromJson(json);
}

@freezed
class RecommendationData with _$RecommendationData {
  const factory RecommendationData({
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "productStock")
    double? productStock,
    @JsonKey(name: "totalSale")
    int? totalSale,
    @JsonKey(name: "productPrice")
    double? productPrice,
    @JsonKey(name: "boxes")
    double? boxes,
    @JsonKey(name: "lowStock")
    String? lowStock,
    @JsonKey(name: "mainImage")
    String? mainImage,
    @JsonKey(name: "isPesach")
    bool? isPesach,
    @JsonKey(name: "nmMashlim")
    String? nmMashlim,
    @JsonKey(name: "productName")
    String? productName,
    @JsonKey(name: "numberOfUnit")
    int? numberOfUnit,
    @JsonKey(name: "sale")
    Sale? sale,
  }) = _RecommendationData;

  factory RecommendationData.fromJson(Map<String, dynamic> json) => _$RecommendationDataFromJson(json);
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
    @JsonKey(name: "saleMinQuantity")
    String? saleMinQuantity,
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
