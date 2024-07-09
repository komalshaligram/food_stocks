

import 'package:freezed_annotation/freezed_annotation.dart';


part 'verify_client_res_model.freezed.dart';
part 'verify_client_res_model.g.dart';


@freezed
class VerifyClientResModel with _$VerifyClientResModel {
  const factory VerifyClientResModel({
    @JsonKey(name: "status")
    int? status,
    @JsonKey(name: "message")
    String? message,
    @JsonKey(name: "data")
    Data? data,
  }) = _VerifyClientResModel;

  factory VerifyClientResModel.fromJson(Map<String, dynamic> json) => _$VerifyClientResModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    @JsonKey(name: "isRegisterForm")
    bool? isRegisterForm,
    @JsonKey(name: "isUploadedFiles")
    bool? isUploadedFiles,
    @JsonKey(name: "isFilledForms")
    bool? isFilledForms,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}
