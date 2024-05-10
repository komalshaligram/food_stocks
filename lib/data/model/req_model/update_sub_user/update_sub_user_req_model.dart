// To parse this JSON data, do
//
//     final updateSubUserReqModel = updateSubUserReqModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
part 'update_sub_user_req_model.freezed.dart';
part 'update_sub_user_req_model.g.dart';


@freezed
class UpdateSubUserReqModel with _$UpdateSubUserReqModel {
  const factory UpdateSubUserReqModel({
    @JsonKey(name: "_id")
    String? id,
    @JsonKey(name: "contactName")
    String? contactName,
    @JsonKey(name: "israelId")
    String? israelId,
    @JsonKey(name: "profileImage")
    String? profileImage,
    @JsonKey(name: "email")
    String? email,
    @JsonKey(name: "phoneNumber")
    String? phoneNumber,
    @JsonKey(name: "applicationVersion")
    String? applicationVersion,
    @JsonKey(name: "deviceType")
    String? deviceType,
    @JsonKey(name: "lastSeen")
    DateTime? lastSeen,
  }) = _UpdateSubUserReqModel;

  factory UpdateSubUserReqModel.fromJson(Map<String, dynamic> json) => _$UpdateSubUserReqModelFromJson(json);
}
