// To parse this JSON data, do
//
//     final planogramReqModel = planogramReqModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'planogram_req_model.freezed.dart';

part 'planogram_req_model.g.dart';

PlanogramReqModel planogramReqModelFromJson(String str) =>
    PlanogramReqModel.fromJson(json.decode(str));

String planogramReqModelToJson(PlanogramReqModel data) =>
    json.encode(data.toJson());

@freezed
class PlanogramReqModel with _$PlanogramReqModel {
  const factory PlanogramReqModel({
    int? pageNum,
    int? pageLimit,
    String? sortOrder,
    String? sortField,
    String? subCategoryId,
    String? categoryId,
    @JsonKey(name: "_id") String? id,
  }) = _PlanogramReqModel;

  factory PlanogramReqModel.fromJson(Map<String, dynamic> json) =>
      _$PlanogramReqModelFromJson(json);
}
