// To parse this JSON data, do
//
//     final getQnaReqModel = getQnaReqModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'get_qna_req_model.freezed.dart';

part 'get_qna_req_model.g.dart';

GetQnaReqModel getQnaReqModelFromJson(String str) =>
    GetQnaReqModel.fromJson(json.decode(str));

String getQnaReqModelToJson(GetQnaReqModel data) => json.encode(data.toJson());

@freezed
class GetQnaReqModel with _$GetQnaReqModel {
  const factory GetQnaReqModel({
 int? pageNum,
 int? pageLimit,
  String? search,
 String? sortField,
     String? sortOrder,
  }) = _GetQnaReqModel;

  factory GetQnaReqModel.fromJson(Map<String, dynamic> json) =>
      _$GetQnaReqModelFromJson(json);
}
