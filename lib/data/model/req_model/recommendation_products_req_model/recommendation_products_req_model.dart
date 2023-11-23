// To parse this JSON data, do
//
//     final recommendationProductsReqModel = recommendationProductsReqModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'recommendation_products_req_model.freezed.dart';

part 'recommendation_products_req_model.g.dart';

RecommendationProductsReqModel recommendationProductsReqModelFromJson(
        String str) =>
    RecommendationProductsReqModel.fromJson(json.decode(str));

String recommendationProductsReqModelToJson(
        RecommendationProductsReqModel data) =>
    json.encode(data.toJson());

@freezed
class RecommendationProductsReqModel with _$RecommendationProductsReqModel {
  const factory RecommendationProductsReqModel({
    @JsonKey(name: "pageNum") int? pageNum,
    @JsonKey(name: "pageLimit") int? pageLimit,
  }) = _RecommendationProductsReqModel;

  factory RecommendationProductsReqModel.fromJson(Map<String, dynamic> json) =>
      _$RecommendationProductsReqModelFromJson(json);
}
