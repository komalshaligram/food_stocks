// To parse this JSON data, do
//
//     final getQnaResModel = getQnaResModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'get_qna_res_model.freezed.dart';

part 'get_qna_res_model.g.dart';

GetQnaResModel getQnaResModelFromJson(String str) =>
    GetQnaResModel.fromJson(json.decode(str));

String getQnaResModelToJson(GetQnaResModel data) => json.encode(data.toJson());

@freezed
class GetQnaResModel with _$GetQnaResModel {
  const factory GetQnaResModel({
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "data") Data? data,
    @JsonKey(name: "message") String? message,
  }) = _GetQnaResModel;

  factory GetQnaResModel.fromJson(Map<String, dynamic> json) =>
      _$GetQnaResModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    @JsonKey(name: "data") List<Datum>? data,
    @JsonKey(name: "totalRecords") int? totalRecords,
    @JsonKey(name: "totalPages") int? totalPages,
    @JsonKey(name: "currentPage") int? currentPage,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class Datum with _$Datum {
  const factory Datum({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "question") String? question,
    @JsonKey(name: "answer") String? answer,
    @JsonKey(name: "createdAt") String? createdAt,
    @JsonKey(name: "updatedAt") String? updatedAt,
  }) = _Datum;

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
}
