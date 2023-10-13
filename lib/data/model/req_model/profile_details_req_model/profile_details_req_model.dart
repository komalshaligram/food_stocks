// To parse this JSON data, do
//
//     final profileDetailsReqModel = profileDetailsReqModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'profile_details_req_model.freezed.dart';

part 'profile_details_req_model.g.dart';

ProfileDetailsReqModel profileDetailsReqModelFromJson(String str) =>
    ProfileDetailsReqModel.fromJson(json.decode(str));

String profileDetailsReqModelToJson(ProfileDetailsReqModel data) =>
    json.encode(data.toJson());

@freezed
class ProfileDetailsReqModel with _$ProfileDetailsReqModel {
  const factory ProfileDetailsReqModel({
   String? id,
  }) = _ProfileDetailsReqModel;

  factory ProfileDetailsReqModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileDetailsReqModelFromJson(json);
}
