// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_res_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_LoginResModel _$$_LoginResModelFromJson(Map<String, dynamic> json) =>
    _$_LoginResModel(
      status: json['status'] as int?,
      message: json['message'] as String?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      success: json['success'] as bool?,
    );

Map<String, dynamic> _$$_LoginResModelToJson(_$_LoginResModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'user': instance.user,
      'success': instance.success,
    };

_$_User _$$_UserFromJson(Map<String, dynamic> json) => _$_User(
      isDeleted: json['isDeleted'] as bool?,
      id: json['_id'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      address: json['address'] as String?,
      cityId: json['cityId'] as String?,
      contactName: json['contactName'] as String?,
      statusId: json['statusId'] as String?,
      logo: json['logo'] as String?,
      adminTypeId: json['adminTypeId'] as String?,
      clientDetail: json['clientDetail'] == null
          ? null
          : ClientDetail.fromJson(json['clientDetail'] as Map<String, dynamic>),
      createdBy: json['createdBy'] as String?,
      updatedBy: json['updatedBy'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      v: json['__v'] as int?,
    );

Map<String, dynamic> _$$_UserToJson(_$_User instance) => <String, dynamic>{
      'isDeleted': instance.isDeleted,
      '_id': instance.id,
      'email': instance.email,
      'password': instance.password,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phoneNumber': instance.phoneNumber,
      'address': instance.address,
      'cityId': instance.cityId,
      'contactName': instance.contactName,
      'statusId': instance.statusId,
      'logo': instance.logo,
      'adminTypeId': instance.adminTypeId,
      'clientDetail': instance.clientDetail,
      'createdBy': instance.createdBy,
      'updatedBy': instance.updatedBy,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      '__v': instance.v,
    };

_$_ClientDetail _$$_ClientDetailFromJson(Map<String, dynamic> json) =>
    _$_ClientDetail(
      bussinessId: json['bussinessId'] as int?,
      bussinessName: json['bussinessName'] as String?,
      ownerName: json['ownerName'] as String?,
      clientTypeId: json['clientTypeId'] as String?,
      israelId: json['israelId'] as String?,
      tokenId: json['tokenId'] as String?,
      fax: json['fax'] as String?,
      lastSeen: json['lastSeen'] == null
          ? null
          : DateTime.parse(json['lastSeen'] as String),
      monthlyCredits: json['monthlyCredits'] as int?,
      applicationVersion: json['applicationVersion'] as String?,
      deviceType: json['deviceType'] as String?,
      operationTime: (json['operationTime'] as List<dynamic>?)
          ?.map((e) => OperationTime.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: json['_id'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$_ClientDetailToJson(_$_ClientDetail instance) =>
    <String, dynamic>{
      'bussinessId': instance.bussinessId,
      'bussinessName': instance.bussinessName,
      'ownerName': instance.ownerName,
      'clientTypeId': instance.clientTypeId,
      'israelId': instance.israelId,
      'tokenId': instance.tokenId,
      'fax': instance.fax,
      'lastSeen': instance.lastSeen?.toIso8601String(),
      'monthlyCredits': instance.monthlyCredits,
      'applicationVersion': instance.applicationVersion,
      'deviceType': instance.deviceType,
      'operationTime': instance.operationTime,
      '_id': instance.id,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$_OperationTime _$$_OperationTimeFromJson(Map<String, dynamic> json) =>
    _$_OperationTime(
      monday: (json['Monday'] as List<dynamic>?)
          ?.map((e) => Monday.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$_OperationTimeToJson(_$_OperationTime instance) =>
    <String, dynamic>{
      'Monday': instance.monday,
    };

_$_Monday _$$_MondayFromJson(Map<String, dynamic> json) => _$_Monday(
      from: json['from'] as String?,
      unitl: json['unitl'] as String?,
    );

Map<String, dynamic> _$$_MondayToJson(_$_Monday instance) => <String, dynamic>{
      'from': instance.from,
      'unitl': instance.unitl,
    };
