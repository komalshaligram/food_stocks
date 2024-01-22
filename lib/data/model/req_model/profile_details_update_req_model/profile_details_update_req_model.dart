import 'package:freezed_annotation/freezed_annotation.dart';

import '../activity_time/activity_time_req_model.dart';

part 'profile_details_update_req_model.freezed.dart';

part 'profile_details_update_req_model.g.dart';

@freezed
class ProfileDetailsUpdateReqModel with _$ProfileDetailsUpdateReqModel {
  const factory ProfileDetailsUpdateReqModel({
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "phoneNumber") String? phoneNumber,
    @JsonKey(name: "address") String? address,
    @JsonKey(name: "cityId") String? cityId,
    @JsonKey(name: "logo") String? logo,
    @JsonKey(name: "profileImage") String? profileImage,
    @JsonKey(name: "contactName") String? contactName,
    @JsonKey(name: "clientDetail") ClientDetail? clientDetail,
  }) = _ProfileDetailsUpdateReqModel;

  factory ProfileDetailsUpdateReqModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileDetailsUpdateReqModelFromJson(json);
}

@freezed
class ClientDetail with _$ClientDetail {
  const factory ClientDetail({
    @JsonKey(name: "bussinessId")
    int? bussinessId,
    @JsonKey(name: "bussinessName")
    String? bussinessName,
    @JsonKey(name: "ownerName")
    String? ownerName,
    @JsonKey(name: "clientTypeId")
    String? clientTypeId,
    @JsonKey(name: "israelId")
    String? israelId,
    @JsonKey(name: "tokenId")
    String? tokenId,
    @JsonKey(name: "fax")
    String? fax,
    @JsonKey(name: "lastSeen")
    String? lastSeen,
    @JsonKey(name: "monthlyCredits")
    int? monthlyCredits,
    @JsonKey(name: "applicationVersion")
    String? applicationVersion,
    @JsonKey(name: "deviceType")
    String? deviceType,
    @JsonKey(name: "operationTime")
    OperationTime? operationTime,
  }) = _ClientDetail;

  factory ClientDetail.fromJson(Map<String, dynamic> json) => _$ClientDetailFromJson(json);
}

@freezed
class OperationTime with _$OperationTime {
  const factory OperationTime({
    List<Day>? Sunday,
    List<Day>? Monday,
    List<Day>? Tuesday,
    List<Day>? Wednesday,
    List<Day>? Thursday,
    List<Day>? Friday,
    List<Day>? Saturday,
  }) = _OperationTime;

  factory OperationTime.fromJson(Map<String, dynamic> json) => _$OperationTimeFromJson(json);
}