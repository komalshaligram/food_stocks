// To parse this JSON data, do
//
//     final invoicesReqModel = invoicesReqModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'invoices_req_model.freezed.dart';
part 'invoices_req_model.g.dart';

InvoicesReqModel invoicesReqModelFromJson(String str) => InvoicesReqModel.fromJson(json.decode(str));

String invoicesReqModelToJson(InvoicesReqModel data) => json.encode(data.toJson());

@freezed
class InvoicesReqModel with _$InvoicesReqModel {
  const factory InvoicesReqModel({
    @JsonKey(name: "id")
    String? id,
    @JsonKey(name: "pageNum")
    int? pageNum,
    @JsonKey(name: "pageLimit")
    int? pageLimit,
  }) = _InvoicesReqModel;

  factory InvoicesReqModel.fromJson(Map<String, dynamic> json) => _$InvoicesReqModelFromJson(json);
}
