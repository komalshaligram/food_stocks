// To parse this JSON data, do
//
//     final profileModel = profileModelFromMap(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';



@freezed
class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    @JsonKey(name: "email")
    String? email,
    @JsonKey(name: "phoneNumber")
    String? phoneNumber,
    @JsonKey(name: "address")
    String? address,
    @JsonKey(name: "cityId") String? cityId,
   String? statusId,
    @JsonKey(name: "logo") String? logo,
    @JsonKey(name: "profileImage") String? profileImage,
    @JsonKey(name: "contactName") String? contactName,
    @JsonKey(name: "clientDetail") ClientDetail? clientDetail,
    // @JsonKey(name: "createdBy")
    // String? createdBy,
    // @JsonKey(name: "updatedBy")
    // String? updatedBy,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => _$ProfileModelFromJson(json);
}

@freezed
class ClientDetail with _$ClientDetail {
  const factory ClientDetail({
    @JsonKey(name: "bussinessId") int? bussinessId,
    @JsonKey(name: "bussinessName") String? bussinessName,
    @JsonKey(name: "ownerName") String? ownerName,
    @JsonKey(name: "clientTypeId") String? clientTypeId,
    @JsonKey(name: "israelId") String? israelId,
    @JsonKey(name: "tokenId") String? tokenId,
    @JsonKey(name: "fax") String? fax,
    @JsonKey(name: "lastSeen") DateTime? lastSeen,
    // @JsonKey(name: "monthlyCredits") int? monthlyCredits,
     @JsonKey(name: "applicationVersion") String? applicationVersion,
    @JsonKey(name: "deviceType") String? deviceType,
    @JsonKey(name: "forms") Forms? forms,
    @JsonKey(name: "files") Files? files,
  }) = _ClientDetail;

  factory ClientDetail.fromJson(Map<String, dynamic> json) => _$ClientDetailFromJson(json);

}

@freezed
class Forms with _$Forms {
  const factory Forms({
    @JsonKey(name: "651e7c0b30429b3f49e65f03")
    String? the651E7C0B30429B3F49E65F03,
    @JsonKey(name: "651e7c8130429b3f49e65f06")
    String? the651E7C8130429B3F49E65F06,
  }) = _Forms;

  factory Forms.fromJson(Map<String, dynamic> json) => _$FormsFromJson(json);
}
@freezed
class Files with _$Files {
  const factory Files({
    @JsonKey(name: "651e7ccf30429b3f49e65f08")
    String? the651E7Ccf30429B3F49E65F08,
    @JsonKey(name: "651e7cec30429b3f49e65f0a")
    String? the651E7Cec30429B3F49E65F0A,
  }) = _Files;

  factory Files.fromJson(Map<String, dynamic> json) => _$FilesFromJson(json);
}
