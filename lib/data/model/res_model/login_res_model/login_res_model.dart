
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../req_model/activity_time/activity_time_req_model.dart';
part 'login_res_model.freezed.dart';
part 'login_res_model.g.dart';


@freezed
class LoginResModel with _$LoginResModel {
  const factory LoginResModel({

    int? status,

    String? message,

    User? user,

    bool? success,
  }) = _LoginResModel;

  factory LoginResModel.fromJson(Map<String, dynamic> json) => _$LoginResModelFromJson(json);
}

@freezed
class User with _$User {
  const factory User({

    bool? isDeleted,
    @JsonKey(name: "_id")
    String? id,

    String? email,

    String? password,

    String? firstName,

    String? lastName,

    String? phoneNumber,

    String? address,

    String? cityId,

    String? contactName,

    String? statusId,

    String? logo,

    String? adminTypeId,
    @JsonKey(name: "clientDetail")
    ClientDetail? clientDetail,

    String? createdBy,

    String? updatedBy,

    DateTime? createdAt,

    DateTime? updatedAt,
    @JsonKey(name: "__v")
    int? v,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
class ClientDetail with _$ClientDetail {
  const factory ClientDetail({

    int? bussinessId,

    String? bussinessName,

    String? ownerName,

    String? clientTypeId,

    String? israelId,

    String? tokenId,

    String? fax,

    DateTime? lastSeen,

    int? monthlyCredits,

    String? applicationVersion,

    String? deviceType,

    List<OperationTime>? operationTime,
    @JsonKey(name: "_id")
    String? id,

    DateTime? createdAt,

    DateTime? updatedAt,
  }) = _ClientDetail;

  factory ClientDetail.fromJson(Map<String, dynamic> json) => _$ClientDetailFromJson(json);
}


