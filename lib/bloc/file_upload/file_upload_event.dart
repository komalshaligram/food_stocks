part of 'file_upload_bloc.dart';

@freezed
class FileUploadEvent with _$FileUploadEvent {
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
  // required String documentPath,
    required int fileIndex,
 }) = _deleteFileEvent;


}