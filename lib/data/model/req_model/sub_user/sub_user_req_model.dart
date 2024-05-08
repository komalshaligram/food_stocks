// To parse this JSON data, do
//
//     final subUserReqModel = subUserReqModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'sub_user_req_model.freezed.dart';
part 'sub_user_req_model.g.dart';

SubUserReqModel subUserReqModelFromJson(String str) => SubUserReqModel.fromJson(json.decode(str));

String subUserReqModelToJson(SubUserReqModel data) => json.encode(data.toJson());

@freezed
class SubUserReqModel with _$SubUserReqModel {
  const factory SubUserReqModel({
    @JsonKey(name: "clientId")
    String? clientId,
    @JsonKey(name: "contactName")
    String? contactName,
    @JsonKey(name: "phoneNumber")
    String? phoneNumber,
    @JsonKey(name: "email")
    String? email,
    @JsonKey(name: "israelId")
    String? israelId,
    String? profileImage,
  }) = _SubUserReqModel;

  factory SubUserReqModel.fromJson(Map<String, dynamic> json) => _$SubUserReqModelFromJson(json);
}
