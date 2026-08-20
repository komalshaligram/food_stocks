import 'package:freezed_annotation/freezed_annotation.dart';
part 'file_upload_model.freezed.dart';
part 'file_upload_model.g.dart';

@freezed
class FileUploadModel with _$FileUploadModel {
  const factory FileUploadModel({
    @JsonKey(name: "baseURL") String? baseUrl,
    @JsonKey(name: "filepath") String? filepath,
  }) = _FileUploadModel;

  factory FileUploadModel.fromJson(Map<String, dynamic> json) => _$FileUploadModelFromJson(json);
}
