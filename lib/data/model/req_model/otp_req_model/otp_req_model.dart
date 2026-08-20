import 'package:freezed_annotation/freezed_annotation.dart';
part 'otp_req_model.freezed.dart';

part 'otp_req_model.g.dart';

@freezed
class OtpReqModel with _$OtpReqModel {
  const factory OtpReqModel({
    String? contact,
    String? otp,
    String? tokenId,
    String? applicationName,
  }) = _OtpReqModel;

  factory OtpReqModel.fromJson(Map<String, dynamic> json) => _$OtpReqModelFromJson(json);
}
