

import 'package:freezed_annotation/freezed_annotation.dart';

part 'terms_condition_res_model.freezed.dart';
part 'terms_condition_res_model.g.dart';



@freezed
class TermsConditionResModel with _$TermsConditionResModel {
  const factory TermsConditionResModel({
    @JsonKey(name: "status")
    int? status,
    @JsonKey(name: "data")
    String? data,
    @JsonKey(name: "message")
    String? message,
  }) = _TermsConditionResModel;

  factory TermsConditionResModel.fromJson(Map<String, dynamic> json) => _$TermsConditionResModelFromJson(json);
}
