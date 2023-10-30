import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'otp_req_model.freezed.dart';
part 'otp_req_model.g.dart';

OtpReqModel otpRequestFromJson(String str) => OtpReqModel.fromJson(json.decode(str));

String otpRequestToJson(OtpReqModel data) => json.encode(data.toJson());

@freezed
class OtpReqModel with _$OtpReqModel {
  const factory OtpReqModel({
    required String contact,
    required String otp,
  }) = _OtpReqModel;

  factory OtpReqModel.fromJson(Map<String, dynamic> json) => _$OtpReqModelFromJson(json);
}

