// To parse this JSON data, do
//
//     final getAppContentResModel = getAppContentResModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'get_app_content_res_model.freezed.dart';

part 'get_app_content_res_model.g.dart';

GetAppContentResModel getAppContentResModelFromJson(String str) =>
    GetAppContentResModel.fromJson(json.decode(str));

String getAppContentResModelToJson(GetAppContentResModel data) =>
    json.encode(data.toJson());

@freezed
class GetAppContentResModel with _$GetAppContentResModel {
  const factory GetAppContentResModel({
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "contents") List<Content>? contents,
    @JsonKey(name: "metaData") MetaData? metaData,
    @JsonKey(name: "message") String? message,
  }) = _GetAppContentResModel;

  factory GetAppContentResModel.fromJson(Map<String, dynamic> json) =>
      _$GetAppContentResModelFromJson(json);
}

@freezed
class Content with _$Content {
  const factory Content({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "contentName") String? contentName,
    @JsonKey(name: "updatedBy") String? updatedBy,
    @JsonKey(name: "updatedAt") String? updatedAt,
    @JsonKey(name: "createdAt") String? createdAt,
    @JsonKey(name: "createdBy") String? createdBy,
  }) = _Content;

  factory Content.fromJson(Map<String, dynamic> json) =>
      _$ContentFromJson(json);
}

@freezed
class MetaData with _$MetaData {
  const factory MetaData({
    @JsonKey(name: "currentPage") int? currentPage,
    @JsonKey(name: "totalPages") int? totalPages,
    @JsonKey(name: "totalRecords") int? totalRecords,
  }) = _MetaData;

  factory MetaData.fromJson(Map<String, dynamic> json) =>
      _$MetaDataFromJson(json);
}
