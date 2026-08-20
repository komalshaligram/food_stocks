import 'package:freezed_annotation/freezed_annotation.dart';
part 'sub_user_req_model.freezed.dart';
part 'sub_user_req_model.g.dart';

@freezed
class SubUserReqModel with _$SubUserReqModel {
  const factory SubUserReqModel({
    @JsonKey(name: "clientId") String? clientId,
    @JsonKey(name: "contactName") String? contactName,
    @JsonKey(name: "phoneNumber") String? phoneNumber,
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "israelId") String? israelId,
    String? profileImage,
  }) = _SubUserReqModel;

  factory SubUserReqModel.fromJson(Map<String, dynamic> json) => _$SubUserReqModelFromJson(json);
}
