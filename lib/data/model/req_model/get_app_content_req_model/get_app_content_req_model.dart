// To parse this JSON data, do
//
//     final getAppContentReqModel = getAppContentReqModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'get_app_content_req_model.freezed.dart';

part 'get_app_content_req_model.g.dart';

GetAppContentReqModel getAppContentReqModelFromJson(String str) =>
    GetAppContentReqModel.fromJson(json.decode(str));

String getAppContentReqModelToJson(GetAppContentReqModel data) =>
    json.encode(data.toJson());

@freezed
class GetAppContentReqModel with _$GetAppContentReqModel {
  const factory GetAppContentReqModel({
    int? pageNum,
    int? pageLimit,
  }) = _GetAppContentReqModel;

  factory GetAppContentReqModel.fromJson(Map<String, dynamic> json) =>
      _$GetAppContentReqModelFromJson(json);
}
