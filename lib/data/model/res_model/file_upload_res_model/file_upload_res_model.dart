

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'file_upload_res_model.freezed.dart';

part 'file_upload_res_model.g.dart';

FileUploadResModel fileUploadResModelFromJson(String str) =>
    FileUploadResModel.fromJson(json.decode(str));

String fileUploadResModelToJson(FileUploadResModel data) =>
    json.encode(data.toJson());

@freezed
class FileUploadResModel with _$FileUploadResModel {
  const factory FileUploadResModel({
    @JsonKey(name: "baseURL") String? baseUrl,
    @JsonKey(name: "filepath") String? filepath,
  }) = _FileUploadResModel;

  factory FileUploadResModel.fromJson(Map<String, dynamic> json) =>
      _$FileUploadResModelFromJson(json);
}
