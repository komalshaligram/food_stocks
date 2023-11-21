// To parse this JSON data, do
//
//     final getAppContentDetailsResModel = getAppContentDetailsResModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'get_app_content_details_res_model.freezed.dart';

part 'get_app_content_details_res_model.g.dart';

GetAppContentDetailsResModel getAppContentDetailsResModelFromJson(String str) =>
    GetAppContentDetailsResModel.fromJson(json.decode(str));

String getAppContentDetailsResModelToJson(GetAppContentDetailsResModel data) =>
    json.encode(data.toJson());

@freezed
class GetAppContentDetailsResModel with _$GetAppContentDetailsResModel {
  const factory GetAppContentDetailsResModel({
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "message") String? message,
    @JsonKey(name: "data") List<Datum>? data,
  }) = _GetAppContentDetailsResModel;

  factory GetAppContentDetailsResModel.fromJson(Map<String, dynamic> json) =>
      _$GetAppContentDetailsResModelFromJson(json);
}

@freezed
class Datum with _$Datum {
  const factory Datum({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "contentName") String? contentName,
    @JsonKey(name: "title") String? title,
    @JsonKey(name: "adminType") String? adminType,
    @JsonKey(name: "subTitle") String? subTitle,
    @JsonKey(name: "textForButton1") String? textForButton1,
    @JsonKey(name: "textForButton2") String? textForButton2,
    @JsonKey(name: "fullText") String? fullText,
    @JsonKey(name: "isDeleted") bool? isDeleted,
    @JsonKey(name: "createdAt") DateTime? createdAt,
    @JsonKey(name: "updatedAt") DateTime? updatedAt,
    @JsonKey(name: "__v") int? v,
  }) = _Datum;

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
}
