import 'package:freezed_annotation/freezed_annotation.dart';

part 'form_and_file_model.freezed.dart';

part 'form_and_file_model.g.dart';

@freezed
class FormAndFileModel with _$FormAndFileModel {
  const factory FormAndFileModel({
    String? id,
    String? name,
    String? url,
    String? localUrl,
    bool? isForm,
    String? sampleUrl,
    // bool? isDownloadable,
  }) = _FormAndFileModel;

  factory FormAndFileModel.fromJson(Map<String, dynamic> json) =>
      _$FormAndFileModelFromJson(json);
}
// class FormAndFileModel {
//   String? id;
//   String? name;
//   String? url;
//   String? localUrl;
//   bool? isForm;
//   bool? isDownloadable;
//
//   FormAndFileModel({
//     this.id,
//     this.name,
//     this.url = '',
//     this.localUrl = '',
//     this.isForm = false,
//     this.isDownloadable = false,
//   });
// }
