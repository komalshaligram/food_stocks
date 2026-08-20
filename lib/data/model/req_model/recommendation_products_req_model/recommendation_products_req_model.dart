import 'package:freezed_annotation/freezed_annotation.dart';
part 'recommendation_products_req_model.freezed.dart';

part 'recommendation_products_req_model.g.dart';

@freezed
class RecommendationProductsReqModel with _$RecommendationProductsReqModel {
  const factory RecommendationProductsReqModel({
    @JsonKey(name: "pageNum") int? pageNum,
    @JsonKey(name: "pageLimit") int? pageLimit,
  }) = _RecommendationProductsReqModel;

  factory RecommendationProductsReqModel.fromJson(Map<String, dynamic> json) => _$RecommendationProductsReqModelFromJson(json);
}
