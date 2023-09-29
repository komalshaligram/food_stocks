// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_res_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ProfileResModel _$$_ProfileResModelFromJson(Map<String, dynamic> json) =>
    _$_ProfileResModel(
      status: json['status'] as int?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$_ProfileResModelToJson(_$_ProfileResModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
      'message': instance.message,
    };

_$_Data _$$_DataFromJson(Map<String, dynamic> json) => _$_Data(
      clientData: json['clientData'] == null
          ? null
          : ClientData.fromJson(json['clientData'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_DataToJson(_$_Data instance) => <String, dynamic>{
      'clientData': instance.clientData,
    };

_$_ClientData _$$_ClientDataFromJson(Map<String, dynamic> json) =>
    _$_ClientData(
      email: json['email'] as String?,
      password: json['password'],
      phoneNumber: json['phoneNumber'] as String?,
      address: json['address'] as String?,
      cityId: json['cityId'] as String?,
      contactName: json['contactName'] as String?,
      statusId: json['statusId'] as String?,
      logo: json['logo'] as String?,
      adminTypeId: json['adminTypeId'] as String?,
      clientDetail: json['clientDetail'] == null
          ? null
          : ClientDetailRes.fromJson(
              json['clientDetail'] as Map<String, dynamic>),
      isDeleted: json['isDeleted'] as bool?,
      id: json['_id'] as String?,
      v: json['__v'] as int?,
    );

Map<String, dynamic> _$$_ClientDataToJson(_$_ClientData instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'phoneNumber': instance.phoneNumber,
      'address': instance.address,
      'cityId': instance.cityId,
      'contactName': instance.contactName,
      'statusId': instance.statusId,
      'logo': instance.logo,
      'adminTypeId': instance.adminTypeId,
      'clientDetail': instance.clientDetail,
      'isDeleted': instance.isDeleted,
      '_id': instance.id,
      '__v': instance.v,
    };

_$_ClientDetailRes _$$_ClientDetailResFromJson(Map<String, dynamic> json) =>
    _$_ClientDetailRes(
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
          ?.map((e) => OperationTimeRes.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: json['_id'] as String?,
      createdBy: json['createdBy'] as String?,
      updatedBy: json['updatedBy'] as String?,
    );

Map<String, dynamic> _$$_ClientDetailResToJson(_$_ClientDetailRes instance) =>
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
      'createdBy': instance.createdBy,
      'updatedBy': instance.updatedBy,
    };

_$_OperationTimeRes _$$_OperationTimeResFromJson(Map<String, dynamic> json) =>
    _$_OperationTimeRes(
      monday: (json['monday'] as List<dynamic>?)
          ?.map((e) => MondayRes.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$_OperationTimeResToJson(_$_OperationTimeRes instance) =>
    <String, dynamic>{
      'monday': instance.monday,
    };

_$_MondayRes _$$_MondayResFromJson(Map<String, dynamic> json) => _$_MondayRes(
      from: json['from'] as String?,
      unitl: json['unitl'] as String?,
    );

Map<String, dynamic> _$$_MondayResToJson(_$_MondayRes instance) =>
    <String, dynamic>{
      'from': instance.from,
      'unitl': instance.unitl,
    };
