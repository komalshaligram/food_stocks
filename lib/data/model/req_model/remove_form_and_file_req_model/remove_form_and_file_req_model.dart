import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'remove_form_and_file_req_model.freezed.dart';

part 'remove_form_and_file_req_model.g.dart';

RemoveFormAndFileReqModel removeFormAndFileReqModelFromJson(String str) =>
    RemoveFormAndFileReqModel.fromJson(json.decode(str));

String removeFormAndFileReqModelToJson(RemoveFormAndFileReqModel data) =>
    json.encode(data.toJson());

@freezed
class RemoveFormAndFileReqModel with _$RemoveFormAndFileReqModel {
  const factory RemoveFormAndFileReqModel({
    String? path,
  }) = _RemoveFormAndFileReqModel;

  factory RemoveFormAndFileReqModel.fromJson(Map<String, dynamic> json) =>
      _$RemoveFormAndFileReqModelFromJson(json);
}
