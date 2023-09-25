import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'login_res_model.freezed.dart';
part 'login_res_model.g.dart';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

@freezed
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    Data? data,
    bool? success,
    String? message,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    UserProfile? userProfile,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}


@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    int? userId,
    String? firstName,
    String? lastName,
    String? emailId,
    String? mobileNo,
    DateTime? dateOfBirth,
    int? gender,
    int? lookingFor,
    bool? isActive,
    bool? isEdited,
    int? roleId,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);
}