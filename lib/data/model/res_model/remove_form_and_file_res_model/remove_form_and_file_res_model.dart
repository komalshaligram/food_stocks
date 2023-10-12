import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'remove_form_and_file_res_model.freezed.dart';

part 'remove_form_and_file_res_model.g.dart';

RemoveFormAndFileResModel removeFormAndFileResModelFromJson(String str) =>
    RemoveFormAndFileResModel.fromJson(json.decode(str));

String removeFormAndFileResModelToJson(RemoveFormAndFileResModel data) =>
    json.encode(data.toJson());

@freezed
class RemoveFormAndFileResModel with _$RemoveFormAndFileResModel {
  const factory RemoveFormAndFileResModel({
    int? status,
    String? message,
  }) = _RemoveFormAndFileResModel;

  factory RemoveFormAndFileResModel.fromJson(Map<String, dynamic> json) =>
      _$RemoveFormAndFileResModelFromJson(json);
}
