// To parse this JSON data, do
//
//     final filesResModel = filesResModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'files_res_model.freezed.dart';

part 'files_res_model.g.dart';

FilesResModel filesResModelFromJson(String str) =>
    FilesResModel.fromJson(json.decode(str));

String filesResModelToJson(FilesResModel data) => json.encode(data.toJson());

@freezed
class FilesResModel with _$FilesResModel {
  const factory FilesResModel({
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "data") Data? data,
    @JsonKey(name: "message") String? message,
  }) = _FilesResModel;

  factory FilesResModel.fromJson(Map<String, dynamic> json) =>
      _$FilesResModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    @JsonKey(name: "ClientFiles") List<ClientFile>? clientFiles,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class ClientFile with _$ClientFile {
  const factory ClientFile({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "fileName") String? fileName,
    @JsonKey(name: "createdAt") DateTime? createdAt,
    @JsonKey(name: "updatedAt") DateTime? updatedAt,
    @JsonKey(name: "__v") int? v,
  }) = _ClientFile;

  factory ClientFile.fromJson(Map<String, dynamic> json) =>
      _$ClientFileFromJson(json);
}
