// To parse this JSON data, do
//
//     final globalSearchReqModel = globalSearchReqModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'global_search_req_model.freezed.dart';

part 'global_search_req_model.g.dart';

GlobalSearchReqModel globalSearchReqModelFromJson(String str) =>
    GlobalSearchReqModel.fromJson(json.decode(str));

String globalSearchReqModelToJson(GlobalSearchReqModel data) =>
    json.encode(data.toJson());

@freezed
class GlobalSearchReqModel with _$GlobalSearchReqModel {
  const factory GlobalSearchReqModel({
    @JsonKey(name: "search") String? search,
  }) = _GlobalSearchReqModel;

  factory GlobalSearchReqModel.fromJson(Map<String, dynamic> json) =>
      _$GlobalSearchReqModelFromJson(json);
}
