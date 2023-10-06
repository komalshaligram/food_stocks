part of 'file_upload_bloc.dart';

@freezed
class FileUploadState with _$FileUploadState {
  const factory FileUploadState({
    required List<FormAndFileModel> formsAndFilesList,
    required File promissoryNote,
    required bool isLoading,
    required bool isUpdate,
    required File personalGuarantee,
    required File photoOfTZ,
    required File businessCertificate,
  }) = _FileUploadState;

  factory FileUploadState.initial() => FileUploadState(
    formsAndFilesList: <FormAndFileModel>[],
        photoOfTZ: File(''),
        isUpdate: false,
        isLoading: false,
        promissoryNote: File(''),
        personalGuarantee: File(''),
        businessCertificate: File(''),
      );
}
