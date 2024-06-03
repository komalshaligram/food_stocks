import 'package:meta/meta.dart';
import 'package:freezed_annotation/freezed_annotation.dart';


part 'recommendation_products_res_model.freezed.dart';
part 'recommendation_products_res_model.g.dart';

@freezed
class RecommendationProductsResModel with _$RecommendationProductsResModel {
  const factory RecommendationProductsResModel({
    @JsonKey(name: "status")
    required int status,
    @JsonKey(name: "message")
    required String message,
    @JsonKey(name: "data")
    required List<RecommendationData> data,
    @JsonKey(name: "metaData")
    required MetaData metaData,
  }) = _RecommendationProductsResModel;

  factory RecommendationProductsResModel.fromJson(Map<String, dynamic> json) => _$RecommendationProductsResModelFromJson(json);
}

@freezed
class RecommendationData with _$RecommendationData {
  const factory RecommendationData({
    @JsonKey(name: "_id")
    required String id,
    @JsonKey(name: "productStock")
    required int productStock,
    @JsonKey(name: "totalSale")
    required int totalSale,
    @JsonKey(name: "productPrice")
    required double productPrice,
    @JsonKey(name: "boxes")
    required double boxes,
    @JsonKey(name: "lowStock")
    required String lowStock,
    @JsonKey(name: "mainImage")
    required String mainImage,
    @JsonKey(name: "isPesach")
    required bool isPesach,
    @JsonKey(name: "nmMashlim")
    required String nmMashlim,
    @JsonKey(name: "productName")
    required String productName,
    @JsonKey(name: "numberOfUnit")
    required int numberOfUnit,
    @JsonKey(name: "sale")
    required Sale sale,
  }) = _RecommendationData;

  factory RecommendationData.fromJson(Map<String, dynamic> json) => _$RecommendationDataFromJson(json);
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
    required int currentPage,
    @JsonKey(name: "totalFilteredCount")
    required int totalFilteredCount,
    @JsonKey(name: "totalFilteredPage")
    required int totalFilteredPage,
  }) = _MetaData;

  factory MetaData.fromJson(Map<String, dynamic> json) => _$MetaDataFromJson(json);
}
