part of 'file_upload_bloc.dart';

@freezed
class FileUploadState with _$FileUploadState{

  const factory FileUploadState({
    required File promissoryNote,
    required File personalGuarantee,
    required File photoOfTZ,
    required File businessCertificate,

  }) = _FileUploadState;

  factory FileUploadState.initial()=>  FileUploadState(
    photoOfTZ: File(''),
    promissoryNote: File(''),
    personalGuarantee: File(''),
    businessCertificate: File(''),

  );

}