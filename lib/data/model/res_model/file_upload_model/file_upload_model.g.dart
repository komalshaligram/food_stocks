// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_upload_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_FileUploadModel _$$_FileUploadModelFromJson(Map<String, dynamic> json) =>
    _$_FileUploadModel(
      baseUrl: json['BaseURL'] as String?,
      formsFileName: json['formsFileName'] as String?,
      businessCertificateFileName:
          json['business_certificateFileName'] as String?,
      israelIdImageFileName: json['israel_id_imageFileName'] as String?,
      fullLogoFileName: json['full_logoFileName'] as String?,
      documentFileName: json['documentFileName'] as String?,
      logoFileName: json['logoFileName'] as String?,
      profileImgFileName: json['profile_imgFileName'] as String?,
    );

Map<String, dynamic> _$$_FileUploadModelToJson(_$_FileUploadModel instance) =>
    <String, dynamic>{
      'BaseURL': instance.baseUrl,
      'formsFileName': instance.formsFileName,
      'business_certificateFileName': instance.businessCertificateFileName,
      'israel_id_imageFileName': instance.israelIdImageFileName,
      'full_logoFileName': instance.fullLogoFileName,
      'documentFileName': instance.documentFileName,
      'logoFileName': instance.logoFileName,
      'profile_imgFileName': instance.profileImgFileName,
    };
