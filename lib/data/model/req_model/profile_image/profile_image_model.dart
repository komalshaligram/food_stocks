import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'profile_image_model.freezed.dart';
part 'profile_image_model.g.dart';

ProfileImageModel profileImageModelFromJson(String str) => ProfileImageModel.fromJson(json.decode(str));

String profileImageModelToJson(ProfileImageModel data) => json.encode(data.toJson());

@freezed
class ProfileImageModel with _$ProfileImageModel {
  const factory ProfileImageModel({
    @JsonKey(name: "BaseURL")
    String? baseUrl,
    @JsonKey(name: "profile_imgFileName")
    String? profileImgFileName,
  }) = _ProfileImageModel;

  factory ProfileImageModel.fromJson(Map<String, dynamic> json) => _$ProfileImageModelFromJson(json);
}
