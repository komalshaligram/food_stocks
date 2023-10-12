// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_BusinessTypeModel _$$_BusinessTypeModelFromJson(Map<String, dynamic> json) =>
    _$_BusinessTypeModel(
      status: json['status'] as int?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$_BusinessTypeModelToJson(
        _$_BusinessTypeModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
      'message': instance.message,
    };

_$_Data _$$_DataFromJson(Map<String, dynamic> json) => _$_Data(
      clientTypes: (json['ClientTypes'] as List<dynamic>?)
          ?.map((e) => ClientType.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$_DataToJson(_$_Data instance) => <String, dynamic>{
      'ClientTypes': instance.clientTypes,
    };

_$_ClientType _$$_ClientTypeFromJson(Map<String, dynamic> json) =>
    _$_ClientType(
      id: json['_id'] as String?,
      businessType: json['businessType'] as String?,
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

Map<String, dynamic> _$$_ClientTypeToJson(_$_ClientType instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'businessType': instance.businessType,
      'createdBy': instance.createdBy,
      'updatedBy': instance.updatedBy,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      '__v': instance.v,
    };
