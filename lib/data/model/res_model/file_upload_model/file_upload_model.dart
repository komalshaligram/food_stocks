

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'file_upload_model.freezed.dart';
part 'file_upload_model.g.dart';

FileUploadModel fileUploadModelFromJson(String str) => FileUploadModel.fromJson(json.decode(str));

String fileUploadModelToJson(FileUploadModel data) => json.encode(data.toJson());

@freezed
class FileUploadModel with _$FileUploadModel {
  const factory FileUploadModel({

    String? baseUrl,

    String? formsFileName,

    String? businessCertificateFileName,

    String? israelIdImageFileName,

    String? fullLogoFileName,

    String? documentFileName,

    String? logoFileName,

    String? profileImgFileName,
  }) = _FileUploadModel;

  factory FileUploadModel.fromJson(Map<String, dynamic> json) => _$FileUploadModelFromJson(json);
}
