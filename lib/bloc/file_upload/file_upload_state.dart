part of 'file_upload_bloc.dart';

@freezed
class FileUploadState with _$FileUploadState {
  const factory FileUploadState({
    required List<FormAndFileModel> formsAndFilesList,
    required bool isLoading,
    required bool isApiLoading,
    required bool isUploadLoading,
    required int uploadIndex,
    required bool isUpdate,
    required bool isShimmering,
    required bool isDownloading,
    required int downloadProgress,
    required bool isFileSizeExceeds,
  }) = _FileUploadState;

  factory FileUploadState.initial() => FileUploadState(
    formsAndFilesList: <FormAndFileModel>[],
        isUpdate: false,
        isLoading: false,
        isApiLoading: false,
        uploadIndex: -1,
        isUploadLoading: false,
        isFileSizeExceeds: false,
        isShimmering: false,
        isDownloading: false,
        downloadProgress: 0,
      );
}
