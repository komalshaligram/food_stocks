import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'company_products_req_model.freezed.dart';

part 'company_products_req_model.g.dart';

CompanyProductsReqModel companyProductsReqModelFromJson(String str) =>
    CompanyProductsReqModel.fromJson(json.decode(str));

String companyProductsReqModelToJson(CompanyProductsReqModel data) =>
    json.encode(data.toJson());

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
