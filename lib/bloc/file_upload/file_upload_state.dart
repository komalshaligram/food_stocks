part of 'file_upload_bloc.dart';

@freezed
class FileUploadState with _$FileUploadState {
  const factory FileUploadState({
    required List<FormAndFileModel> formsAndFilesList,
    required File promissoryNote,
    required bool isUpdate,
    required bool isPromissoryNoteDocument,
    required File personalGuarantee,
    required bool isPersonalGuaranteeDocument,
    required File photoOfTZ,
    required bool isPhotoOfTZDocument,
    required File businessCertificate,
    required bool isBusinessCertificateDocument,
  }) = _FileUploadState;

  factory FileUploadState.initial() => FileUploadState(
    formsAndFilesList: <FormAndFileModel>[],
        photoOfTZ: File(''),
        isUpdate: false,
        promissoryNote: File(''),
        personalGuarantee: File(''),
        businessCertificate: File(''),
        isPromissoryNoteDocument: false,
        isPersonalGuaranteeDocument: false,
        isPhotoOfTZDocument: false,
        isBusinessCertificateDocument: false,
      );
}
