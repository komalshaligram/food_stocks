// To parse this JSON data, do
//
//     final PesachProductReqModel = PesachProductReqModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'pesach_product_req_model.freezed.dart';

part 'pesach_product_req_model.g.dart';

PesachProductReqModel PesachProductReqModelFromJson(String str) =>
    PesachProductReqModel.fromJson(json.decode(str));

String PesachProductReqModelToJson(PesachProductReqModel data) =>
    json.encode(data.toJson());

@freezed
class PesachProductReqModel with _$PesachProductReqModel {
  const factory PesachProductReqModel({
    @JsonKey(name: "pageLimit") int? pageLimit,
    @JsonKey(name: "pageNum") int? pageNum,
    @JsonKey(name:"onlySearch") bool? onlySearch,
    @JsonKey(name:"isPesach") bool? isPesach,
    String? sortField,
    String? sortOrder,


  }) = _PesachProductReqModel;

  factory PesachProductReqModel.fromJson(Map<String, dynamic> json) =>
      _$PesachProductReqModelFromJson(json);
}
