part of 'file_upload_bloc.dart';

@freezed
class FileUploadEvent with _$FileUploadEvent {
 factory FileUploadEvent.uploadDocumentEvent({
  required int fileIndex,
 required int imageSourceIndex,
}) = _uploadDocumentEvent;

/*
 factory FileUploadEvent.uploadFromGalleryEvent({
  required int fileIndex,
}) = _uploadFromGalleryEvent;
*/

 factory FileUploadEvent.uploadApiEvent({
  required String documentPath,
 }) = _uploadApiEvent;

 factory FileUploadEvent.deleteFileEvent({
  required String documentPath,
  required int fileIndex,
 }) = _deleteFileEvent;


}