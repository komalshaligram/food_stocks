// To parse this JSON data, do
//
//     final suppliersReqModel = suppliersReqModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'suppliers_req_model.freezed.dart';

part 'suppliers_req_model.g.dart';

SuppliersReqModel suppliersReqModelFromJson(String str) =>
    SuppliersReqModel.fromJson(json.decode(str));

String suppliersReqModelToJson(SuppliersReqModel data) =>
    json.encode(data.toJson());

@freezed
class SuppliersReqModel with _$SuppliersReqModel {
  const factory SuppliersReqModel({
    @JsonKey(name: "pageNum") int? pageNum,
    @JsonKey(name: "pageLimit") int? pageLimit,
    @JsonKey(name: "search") String? search,
  }) = _SuppliersReqModel;

  factory SuppliersReqModel.fromJson(Map<String, dynamic> json) =>
      _$SuppliersReqModelFromJson(json);
}
