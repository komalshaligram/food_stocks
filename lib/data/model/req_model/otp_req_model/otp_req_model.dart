// To parse this JSON data, do
//
//     final otpReqModel = otpReqModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'otp_req_model.freezed.dart';

part 'otp_req_model.g.dart';

OtpReqModel otpReqModelFromJson(String str) =>
    OtpReqModel.fromJson(json.decode(str));

String otpReqModelToJson(OtpReqModel data) => json.encode(data.toJson());

@freezed
class OtpReqModel with _$OtpReqModel {
  const factory OtpReqModel({
    String? contact,
    String? otp,
    String? tokenId,
  }) = _OtpReqModel;

  factory OtpReqModel.fromJson(Map<String, dynamic> json) => _$OtpReqModelFromJson(json);
}
