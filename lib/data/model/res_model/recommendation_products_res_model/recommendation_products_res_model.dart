// To parse this JSON data, do
//
//     final recommendationProductsResModel = recommendationProductsResModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'recommendation_products_res_model.freezed.dart';

part 'recommendation_products_res_model.g.dart';

RecommendationProductsResModel recommendationProductsResModelFromJson(
        String str) =>
    RecommendationProductsResModel.fromJson(json.decode(str));

String recommendationProductsResModelToJson(
        RecommendationProductsResModel data) =>
    json.encode(data.toJson());

@freezed
class RecommendationProductsResModel with _$RecommendationProductsResModel {
  const factory RecommendationProductsResModel({
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "message") String? message,
    @JsonKey(name: "data") List<RecommendationData>? data,
    @JsonKey(name: "metaData") MetaData? metaData,
  }) = _RecommendationProductsResModel;

  factory RecommendationProductsResModel.fromJson(Map<String, dynamic> json) =>
      _$RecommendationProductsResModelFromJson(json);
}

@freezed
class RecommendationData with _$RecommendationData {
  const factory RecommendationData({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "productStock") int? productStock,
    @JsonKey(name: "totalSale") int? totalSale,
    @JsonKey(name: "productPrice") double? productPrice,
    @JsonKey(name: "mainImage") String? mainImage,
    @JsonKey(name: "productName") String? productName,
    String? lowStock,
  }) = _RecommendationData;

  factory RecommendationData.fromJson(Map<String, dynamic> json) =>
      _$RecommendationDataFromJson(json);
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
