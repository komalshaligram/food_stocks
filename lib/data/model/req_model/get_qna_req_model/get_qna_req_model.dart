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
    @JsonKey(name: "pageNum") int? pageNum,
    @JsonKey(name: "pageLimit") int? pageLimit,
    @JsonKey(name: "search") String? search,
    @JsonKey(name: "sortField") String? sortField,
    @JsonKey(name: "sortOrder") String? sortOrder,
  }) = _GetQnaReqModel;

  factory GetQnaReqModel.fromJson(Map<String, dynamic> json) =>
      _$GetQnaReqModelFromJson(json);
}
