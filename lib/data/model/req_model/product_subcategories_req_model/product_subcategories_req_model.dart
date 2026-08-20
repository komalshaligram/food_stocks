import 'package:freezed_annotation/freezed_annotation.dart';
part 'product_subcategories_req_model.freezed.dart';

part 'product_subcategories_req_model.g.dart';

@freezed
class ProductSubcategoriesReqModel with _$ProductSubcategoriesReqModel {
  const factory ProductSubcategoriesReqModel({
    @JsonKey(name: "parentCategoryId") String? parentCategoryId,
    @JsonKey(name: "pageNum") int? pageNum,
    @JsonKey(name: "pageLimit") int? pageLimit,
  }) = _ProductSubcategoriesReqModel;

  factory ProductSubcategoriesReqModel.fromJson(Map<String, dynamic> json) => _$ProductSubcategoriesReqModelFromJson(json);
}
