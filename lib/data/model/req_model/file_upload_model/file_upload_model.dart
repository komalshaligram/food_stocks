// To parse this JSON data, do
//
//     final fileUploadModel = fileUploadModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'file_upload_model.freezed.dart';
part 'file_upload_model.g.dart';

FileUploadModel fileUploadModelFromJson(String str) => FileUploadModel.fromJson(json.decode(str));

String fileUploadModelToJson(FileUploadModel data) => json.encode(data.toJson());

@freezed
class FileUploadModel with _$FileUploadModel {
  const factory FileUploadModel({
    @JsonKey(name: "BaseURL")
    String? baseUrl,
    @JsonKey(name: "formsFileName")
    String? formsFileName,
    @JsonKey(name: "business_certificateFileName")
    String? businessCertificateFileName,
    @JsonKey(name: "israel_id_imageFileName")
    String? israelIdImageFileName,
    @JsonKey(name: "full_logoFileName")
    String? fullLogoFileName,
    @JsonKey(name: "documentFileName")
    String? documentFileName,
    @JsonKey(name: "logoFileName")
    String? logoFileName,
    @JsonKey(name: "profile_imgFileName")
    String? profileImgFileName,
  }) = _FileUploadModel;

  factory FileUploadModel.fromJson(Map<String, dynamic> json) => _$FileUploadModelFromJson(json);
}
