import 'package:freezed_annotation/freezed_annotation.dart';
part 'login_otp_res_model.freezed.dart';
part 'login_otp_res_model.g.dart';

@freezed
class LoginOtpResModel with _$LoginOtpResModel {
  const factory LoginOtpResModel({
    @JsonKey(name: "data")
    Data? data,
    @JsonKey(name: "status")
    int? status,
    @JsonKey(name: "message")
    String? message,
  }) = _LoginOtpResModel;

  factory LoginOtpResModel.fromJson(Map<String, dynamic> json) => _$LoginOtpResModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    @JsonKey(name: "user")
    User? user,
    @JsonKey(name: "authToken")
    AuthToken? authToken,
    @JsonKey(name: "cartId")
    String? cartId,

  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class AuthToken with _$AuthToken {
  const factory AuthToken({
    @JsonKey(name: "accessToken")
    String? accessToken,
    @JsonKey(name: "refreshToken")
    String? refreshToken,
  }) = _AuthToken;

  factory AuthToken.fromJson(Map<String, dynamic> json) => _$AuthTokenFromJson(json);
}

@freezed
class User with _$User {
  const factory User({
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "email")
    String? email,
    @JsonKey(name: "phoneNumber")
    String? phoneNumber,
    @JsonKey(name: "logo")
    String? logo,
    @JsonKey(name: "profileImage")
    String? profileImage,
    @JsonKey(name: "clientDetail")
    ClientDetail? clientDetail,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
class ClientDetail with _$ClientDetail {
  const factory ClientDetail({
    @JsonKey(name: "bussinessName")
    String? bussinessName,
    @JsonKey(name: "ownerName")
    String? ownerName,
    @JsonKey(name: "lastSeen")
    String? lastSeen,
    @JsonKey(name: "monthlyCredits")
    int? monthlyCredits,
  }) = _ClientDetail;

  factory ClientDetail.fromJson(Map<String, dynamic> json) => _$ClientDetailFromJson(json);
}
