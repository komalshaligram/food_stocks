// To parse this JSON data, do
//
//     final companyProductsReqModel = companyProductsReqModelFromJson(jsonString);

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
    @JsonKey(name: "brandId") String? brandId,
    @JsonKey(name: "pageNum") int? pageNum,
    @JsonKey(name: "pageLimit") int? pageLimit,
  }) = _CompanyProductsReqModel;

  factory CompanyProductsReqModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyProductsReqModelFromJson(json);
}
