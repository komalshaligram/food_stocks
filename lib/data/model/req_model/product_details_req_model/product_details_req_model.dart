// To parse this JSON data, do
//
//     final productDetailsReqModel = productDetailsReqModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'product_details_req_model.freezed.dart';

part 'product_details_req_model.g.dart';

ProductDetailsReqModel productDetailsReqModelFromJson(String str) =>
    ProductDetailsReqModel.fromJson(json.decode(str));

String productDetailsReqModelToJson(ProductDetailsReqModel data) =>
    json.encode(data.toJson());

@freezed
class ProductDetailsReqModel with _$ProductDetailsReqModel {
  const factory ProductDetailsReqModel({
    @JsonKey(name: "params") String? params,
  }) = _ProductDetailsReqModel;

  factory ProductDetailsReqModel.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailsReqModelFromJson(json);
}
