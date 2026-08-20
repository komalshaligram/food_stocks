import 'package:freezed_annotation/freezed_annotation.dart';
part 'company_products_req_model.freezed.dart';

part 'company_products_req_model.g.dart';

@freezed
class CompanyProductsReqModel with _$CompanyProductsReqModel {
  const factory CompanyProductsReqModel({
    String? brandId,
    String? categoryId,
    String? subCategoryId,
    int? pageNum,
    int? pageLimit,
    String? sortField,
    String? sortOrder,
  }) = _CompanyProductsReqModel;

  factory CompanyProductsReqModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyProductsReqModelFromJson(json);
}
