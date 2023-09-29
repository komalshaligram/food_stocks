part of 'file_upload_bloc.dart';

@freezed
class FileUploadEvent with _$FileUploadEvent {
 factory FileUploadEvent.pickDocumentEvent({
  required int fileIndex,
 required int imageSourceIndex,
}) = _pickDocumentEvent;

 factory FileUploadEvent.uploadApiEvent({
  required BuildContext context,
 }) = _uploadApiEvent;

 factory FileUploadEvent.deleteFileEvent({
  required String documentPath,
  required int fileIndex,
 }) = _deleteFileEvent;


}