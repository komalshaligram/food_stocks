// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_upload_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_FileUploadModel _$$_FileUploadModelFromJson(Map<String, dynamic> json) =>
    _$_FileUploadModel(
      baseUrl: json['BaseURL'] as String?,
      personalGuaranteeFileName: json['personalGuaranteeFileName'] as String?,
      promissoryNoteFileName: json['promissoryNoteFileName'] as String?,
      businessCertificateFileName:
          json['businessCertificateFileName'] as String?,
      israelIdImageFileName: json['israelIdImageFileName'] as String?,
      fullLogoFileName: json['full_logoFileName'] as String?,
      documentFileName: json['documentFileName'] as String?,
      logoFileName: json['logoFileName'] as String?,
      profileImgFileName: json['profile_imgFileName'] as String?,
    );

Map<String, dynamic> _$$_FileUploadModelToJson(_$_FileUploadModel instance) =>
    <String, dynamic>{
      'BaseURL': instance.baseUrl,
      'personalGuaranteeFileName': instance.personalGuaranteeFileName,
      'promissoryNoteFileName': instance.promissoryNoteFileName,
      'businessCertificateFileName': instance.businessCertificateFileName,
      'israelIdImageFileName': instance.israelIdImageFileName,
      'full_logoFileName': instance.fullLogoFileName,
      'documentFileName': instance.documentFileName,
      'logoFileName': instance.logoFileName,
      'profile_imgFileName': instance.profileImgFileName,
    };
