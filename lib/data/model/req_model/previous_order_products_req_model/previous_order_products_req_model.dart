// To parse this JSON data, do
//
//     final previousOrderProductsReqModel = previousOrderProductsReqModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'previous_order_products_req_model.freezed.dart';

part 'previous_order_products_req_model.g.dart';

PreviousOrderProductsReqModel previousOrderProductsReqModelFromJson(
        String str) =>
    PreviousOrderProductsReqModel.fromJson(json.decode(str));

String previousOrderProductsReqModelToJson(
        PreviousOrderProductsReqModel data) =>
    json.encode(data.toJson());

@freezed
class PreviousOrderProductsReqModel with _$PreviousOrderProductsReqModel {
  const factory PreviousOrderProductsReqModel({
    @JsonKey(name: "pageNum") int? pageNum,
    @JsonKey(name: "pageLimit") int? pageLimit,
  }) = _PreviousOrderProductsReqModel;

  factory PreviousOrderProductsReqModel.fromJson(Map<String, dynamic> json) =>
      _$PreviousOrderProductsReqModelFromJson(json);
}
