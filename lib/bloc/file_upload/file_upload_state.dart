part of 'file_upload_bloc.dart';

@freezed
class FileUploadState with _$FileUploadState {
  const factory FileUploadState({
    required List<FormAndFileModel> formsAndFilesList,
    required bool isLoading,
    required bool isUpdate,
  }) = _FileUploadState;

  factory FileUploadState.initial() => FileUploadState(
    formsAndFilesList: <FormAndFileModel>[],
        isUpdate: false,
        isLoading: false,
      );
}
