// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ProfileModel _$$_ProfileModelFromJson(Map<String, dynamic> json) =>
    _$_ProfileModel(
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      address: json['address'] as String?,
      cityId: json['cityId'] as String?,
      logo: json['logo'] as String?,
      contactName: json['contactName'] as String?,
      profileImage: json['profileImage'] as String?,
      clientDetail: json['clientDetail'] == null
          ? null
          : ClientDetail.fromJson(json['clientDetail'] as Map<String, dynamic>),
      createdBy: json['createdBy'] as String?,
      updatedBy: json['updatedBy'] as String?,
    );

Map<String, dynamic> _$$_ProfileModelToJson(_$_ProfileModel instance) =>
    <String, dynamic>{
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'address': instance.address,
      'cityId': instance.cityId,
      'logo': instance.logo,
      'contactName': instance.contactName,
      'profileImage': instance.profileImage,
      'clientDetail': instance.clientDetail,
      'createdBy': instance.createdBy,
      'updatedBy': instance.updatedBy,
    };

_$_ClientDetail _$$_ClientDetailFromJson(Map<String, dynamic> json) =>
    _$_ClientDetail(
      bussinessId: json['bussinessId'] as int?,
      bussinessName: json['bussinessName'] as String?,
      ownerName: json['ownerName'] as String?,
      clientTypeId: json['clientTypeId'] as String?,
      israelId: json['israelId'] as bool?,
      tokenId: json['tokenId'] as String?,
      fax: json['fax'] as String?,
      lastSeen: json['lastSeen'] == null
          ? null
          : DateTime.parse(json['lastSeen'] as String),
      monthlyCredits: json['monthlyCredits'] as int?,
      applicationVersion: json['applicationVersion'] as String?,
      deviceType: json['deviceType'] as String?,
      operationTime: json['operationTime'] == null
          ? null
          : OperationTime.fromJson(
              json['operationTime'] as Map<String, dynamic>),
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
