part of 'file_upload_bloc.dart';

@freezed
class FileUploadEvent with _$FileUploadEvent {
  factory FileUploadEvent.getFilesListEvent({
    required BuildContext context,
  }) = _getFilesListEvent;

  factory FileUploadEvent.getFormsListEvent({
    required BuildContext context,
  }) = _getFormsListEvent;

  factory FileUploadEvent.pickDocumentEvent({
    required BuildContext context,
    required int fileIndex,
    required bool isFromCamera,
    required bool isDocument,
  }) = _pickDocumentEvent;

  factory FileUploadEvent.uploadApiEvent({
    required BuildContext context,
  }) = _uploadApiEvent;

  factory FileUploadEvent.deleteFileEvent({
    required int index,
    required BuildContext context,
  }) = _deleteFileEvent;

  factory FileUploadEvent.downloadFileEvent({
    required BuildContext context,
    required int fileIndex,
  }) = _downloadFileEvent;

  factory FileUploadEvent.getProfileFilesAndFormsEvent({required BuildContext context,
    required bool isUpdate}) = _getProfileFilesAndFormsEvent;
}