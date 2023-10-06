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
  /*  @JsonKey(name: "BaseURL") String? baseUrl,
    @JsonKey(name: "personalGuaranteeFileName")
    String? personalGuaranteeFileName,
    @JsonKey(name: "promissoryNoteFileName") String? promissoryNoteFileName,
    @JsonKey(name: "businessCertificateFileName")
    String? businessCertificateFileName,
    @JsonKey(name: "israelIdImageFileName") String? israelIdImageFileName,
    @JsonKey(name: "full_logoFileName") String? fullLogoFileName,
    @JsonKey(name: "documentFileName") String? documentFileName,
    @JsonKey(name: "logoFileName") String? logoFileName,
    @JsonKey(name: "profile_imgFileName") String? profileImgFileName,*/
    @JsonKey(name: "baseURL")
    String? baseUrl,
    @JsonKey(name: "filepath")
    String? filepath,
  }) = _FileUploadModel;

  factory FileUploadModel.fromJson(Map<String, dynamic> json) => _$FileUploadModelFromJson(json);
}
