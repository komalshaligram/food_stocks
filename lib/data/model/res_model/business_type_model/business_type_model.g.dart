// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BusinessTypeModelImpl _$$BusinessTypeModelImplFromJson(
        Map<String, dynamic> json) =>
    _$BusinessTypeModelImpl(
      status: json['status'] as int?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$BusinessTypeModelImplToJson(
        _$BusinessTypeModelImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
      'message': instance.message,
    };

_$DataImpl _$$DataImplFromJson(Map<String, dynamic> json) => _$DataImpl(
      clientTypes: (json['ClientTypes'] as List<dynamic>?)
          ?.map((e) => ClientType.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$DataImplToJson(_$DataImpl instance) =>
    <String, dynamic>{
      'ClientTypes': instance.clientTypes,
    };

_$ClientTypeImpl _$$ClientTypeImplFromJson(Map<String, dynamic> json) =>
    _$ClientTypeImpl(
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

Map<String, dynamic> _$$ClientTypeImplToJson(_$ClientTypeImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'businessType': instance.businessType,
      'createdBy': instance.createdBy,
      'updatedBy': instance.updatedBy,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      '__v': instance.v,
    };
