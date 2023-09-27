part of 'file_upload_bloc.dart';

@freezed
class FileUploadEvent with _$FileUploadEvent {
 factory FileUploadEvent.uploadFromCameraEvent({
  required int fileIndex,
}) = _uploadFromCameraEvent;
 factory FileUploadEvent.uploadFromGalleryEvent({
  required int fileIndex,
}) = _uploadFromGalleryEvent;
}