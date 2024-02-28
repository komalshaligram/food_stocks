import 'package:freezed_annotation/freezed_annotation.dart';


part 'get_sub_categories_product_req_model.freezed.dart';
part 'get_sub_categories_product_req_model.g.dart';



@freezed
class GetSubCategoriesProductReqModel with _$GetSubCategoriesProductReqModel {
  const factory GetSubCategoriesProductReqModel({
    @JsonKey(name: "subCategoryId")
    String? subCategoryId,
    @JsonKey(name: "pageLimit")
    int? pageLimit,
    @JsonKey(name: "pageNum")
    int? pageNum,
  }) = _GetSubCategoriesProductReqModel;

  factory GetSubCategoriesProductReqModel.fromJson(Map<String, dynamic> json) => _$GetSubCategoriesProductReqModelFromJson(json);
}