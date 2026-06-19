import 'package:freezed_annotation/freezed_annotation.dart';

part 'guest_user_login_res_model.freezed.dart';
part 'guest_user_login_res_model.g.dart';

@freezed
class GuestUserLoginResModel with _$GuestUserLoginResModel {
  const factory GuestUserLoginResModel({
    int? status,
    String? message,
    GuestUserLoginData? data,
  }) = _GuestUserLoginResModel;

  factory GuestUserLoginResModel.fromJson(Map<String, dynamic> json) =>
      _$GuestUserLoginResModelFromJson(json);
}

@freezed
class GuestUserLoginData with _$GuestUserLoginData {
  const factory GuestUserLoginData({
    required bool isGuestUser,
    required TokenData tokenData,
  }) = _GuestUserLoginData;

  factory GuestUserLoginData.fromJson(Map<String, dynamic> json) =>
      _$GuestUserLoginDataFromJson(json);
}

@freezed
class TokenData with _$TokenData {
  const factory TokenData({
    required String accessToken,
    required String refreshToken,
  }) = _TokenData;

  factory TokenData.fromJson(Map<String, dynamic> json) =>
      _$TokenDataFromJson(json);
}