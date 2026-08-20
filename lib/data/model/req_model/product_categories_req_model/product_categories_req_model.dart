import 'package:freezed_annotation/freezed_annotation.dart';
part 'product_categories_req_model.freezed.dart';

part 'product_categories_req_model.g.dart';

@freezed
class ProductCategoriesReqModel with _$ProductCategoriesReqModel {
  const factory ProductCategoriesReqModel({
    @JsonKey(name: "pageNum") int? pageNum,
    @JsonKey(name: "pageLimit") int? pageLimit,
    @JsonKey(name: "search") String? search,
  }) = _ProductCategoriesReqModel;

  factory ProductCategoriesReqModel.fromJson(Map<String, dynamic> json) => _$ProductCategoriesReqModelFromJson(json);
}
