// To parse this JSON data, do
//
//     final insertCartResModel = insertCartResModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'insert_cart_res_model.freezed.dart';

part 'insert_cart_res_model.g.dart';

InsertCartResModel insertCartResModelFromJson(String str) =>
    InsertCartResModel.fromJson(json.decode(str));

String insertCartResModelToJson(InsertCartResModel data) =>
    json.encode(data.toJson());

@freezed
class InsertCartResModel with _$InsertCartResModel {
  const factory InsertCartResModel({
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "message") String? message,
    @JsonKey(name: "data") Data? data,
  }) = _InsertCartResModel;

  factory InsertCartResModel.fromJson(Map<String, dynamic> json) =>
      _$InsertCartResModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data() = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}
