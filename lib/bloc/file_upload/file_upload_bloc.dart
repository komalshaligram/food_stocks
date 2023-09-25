import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';

part 'file_upload_state.dart';
part 'file_upload_event.dart';
part 'file_upload_bloc.freezed.dart';

class FileUploadBloc extends Bloc<FileUploadEvent, FileUploadState> {
  FileUploadBloc() : super(FileUploadState.initial()) {
    on<FileUploadEvent>((event, emit) async {
      if (event is _uploadFromCameraEvent) {
        File? image;
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: ImageSource.camera);
        if (pickedFile != null) {
          image = File(pickedFile.path);
          if (event.fileIndex == 1) {
            emit(state.copyWith(promissoryNote: image));
          }
          if (event.fileIndex == 2) {
            emit(state.copyWith(personalGuarantee: image));
          }
          if (event.fileIndex == 3) {
            emit(state.copyWith(photoOfTZ: image));
          }
          if (event.fileIndex == 4) {
            emit(state.copyWith(businessCertificate: image));
          }
        }
      }
      if (event is _uploadFromGalleryEvent) {
        File? image;
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          image = File(pickedFile.path);
          if (event.fileIndex == 1) {
            emit(state.copyWith(promissoryNote: image));
          }
          if (event.fileIndex == 2) {
            emit(state.copyWith(personalGuarantee: image));
          }
          if (event.fileIndex == 3) {
            emit(state.copyWith(photoOfTZ: image));
          }
          if (event.fileIndex == 4) {
            emit(state.copyWith(businessCertificate: image));
          }
        }
      }
    });
  }
}
