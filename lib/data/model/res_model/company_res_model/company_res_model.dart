// To parse this JSON data, do
//
//     final companyResModel = companyResModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'company_res_model.freezed.dart';

part 'company_res_model.g.dart';

CompanyResModel companyResModelFromJson(String str) =>
    CompanyResModel.fromJson(json.decode(str));

String companyResModelToJson(CompanyResModel data) =>
    json.encode(data.toJson());

@freezed
class CompanyResModel with _$CompanyResModel {
  const factory CompanyResModel({
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "data") Data? data,
    @JsonKey(name: "message") String? message,
  }) = _CompanyResModel;

  factory CompanyResModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyResModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    @JsonKey(name: "BrandList") List<Brand>? brandList,
    @JsonKey(name: "totalRecords") int? totalRecords,
    @JsonKey(name: "totalPages") int? totalPages,
    @JsonKey(name: "currentPage") int? currentPage,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class Brand with _$Brand {
  const factory Brand({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "brandName") String? brandName,
    @JsonKey(name: "brandLogo") String? brandLogo,
    @JsonKey(name: "isHomePreference") bool? isHomePreference,
    @JsonKey(name: "order") int? order,
    @JsonKey(name: "createdAt") DateTime? createdAt,
    @JsonKey(name: "updatedAt") DateTime? updatedAt,
    @JsonKey(name: "__v") int? v,
  }) = _Brand;

  factory Brand.fromJson(Map<String, dynamic> json) => _$BrandFromJson(json);
}
