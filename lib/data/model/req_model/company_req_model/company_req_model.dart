
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';
part 'company_req_model.freezed.dart';

part 'company_req_model.g.dart';

CompanyReqModel companyReqModelFromJson(String str) =>
    CompanyReqModel.fromJson(json.decode(str));

String companyReqModelToJson(CompanyReqModel data) =>
    json.encode(data.toJson());

@freezed
class CompanyReqModel with _$CompanyReqModel {
  const factory CompanyReqModel({
  int? pageNum,
  int? pageLimit,
  String? search,
  }) = _CompanyReqModel;

  factory CompanyReqModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyReqModelFromJson(json);
}
