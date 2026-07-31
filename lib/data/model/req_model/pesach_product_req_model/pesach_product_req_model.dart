import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'pesach_product_req_model.freezed.dart';

part 'pesach_product_req_model.g.dart';

PesachProductReqModel pesachProductReqModelFromJson(String str) => PesachProductReqModel.fromJson(json.decode(str));

String pesachProductReqModelToJson(PesachProductReqModel data) => json.encode(data.toJson());

@freezed
class PesachProductReqModel with _$PesachProductReqModel {
  const factory PesachProductReqModel({
    int? pageLimit,
    int? pageNum,
    bool? onlySearch,
    bool? isPesach,
    String? sortField,
    String? sortOrder,
  }) = _PesachProductReqModel;

  factory PesachProductReqModel.fromJson(Map<String, dynamic> json) => _$PesachProductReqModelFromJson(json);
}
