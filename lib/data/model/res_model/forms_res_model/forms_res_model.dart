// To parse this JSON data, do
//
//     final formsResModel = formsResModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'forms_res_model.freezed.dart';

part 'forms_res_model.g.dart';

FormsResModel formsResModelFromJson(String str) =>
    FormsResModel.fromJson(json.decode(str));

String formsResModelToJson(FormsResModel data) => json.encode(data.toJson());

@freezed
class FormsResModel with _$FormsResModel {
  const factory FormsResModel({
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "data") Data? data,
    @JsonKey(name: "message") String? message,
  }) = _FormsResModel;

  factory FormsResModel.fromJson(Map<String, dynamic> json) =>
      _$FormsResModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    @JsonKey(name: "ClientForms") List<ClientForm>? clientForms,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class ClientForm with _$ClientForm {
  const factory ClientForm({
    @JsonKey(name: "_id") String? id,
    @JsonKey(name: "formName") String? formName,
    @JsonKey(name: "createdBy") String? createdBy,
    @JsonKey(name: "updatedBy") String? updatedBy,
    @JsonKey(name: "createdAt") DateTime? createdAt,
    @JsonKey(name: "updatedAt") DateTime? updatedAt,
    @JsonKey(name: "__v") int? v,
  }) = _ClientForm;

  factory ClientForm.fromJson(Map<String, dynamic> json) =>
      _$ClientFormFromJson(json);
}
