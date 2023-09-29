import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/themes/app_urls.dart';

part 'file_upload_state.dart';
part 'file_upload_event.dart';
part 'file_upload_bloc.freezed.dart';

class FileUploadBloc extends Bloc<FileUploadEvent, FileUploadState> {
  FileUploadBloc() : super(FileUploadState.initial()) {
    on<FileUploadEvent>((event, emit) async {


      if (event is _uploadDocumentEvent) {
        File? image;
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: event.imageSourceIndex == 1 ? ImageSource.camera : ImageSource.gallery);
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

          await Future.delayed(const Duration(seconds: 2));
          if(image.path.isNotEmpty){
            MultipartFile m = await MultipartFile.fromFile(image.path,filename: image.path.split('/').last,contentType: MediaType('image','png'),);
            FormData formData = FormData.fromMap({
              'israel_id_image' : m ,
            });

            final response = await DioClient().uploadFileProgressWithFormData(
              path: AppUrls.FileUploadUrl, formData: formData,
            );

            debugPrint(response.toString());
          }
          else{
            debugPrint('image path is empty');
          }
        }
      }

       if(event is _uploadApiEvent){

       MultipartFile m = await MultipartFile.fromFile(event.documentPath,filename: event.documentPath.split('/').last,contentType: MediaType('image','png'),);
         FormData formData = FormData.fromMap({
           'israel_id_image' : m ,
         });
         print('api');

         final response = await DioClient().uploadFileProgressWithFormData(
           path: '/v1/auth/upload', formData: formData,
         );
       print('apifhfh');
         print(response);
       }



      if(event is _deleteFileEvent){
        if (event.fileIndex == 1) {
          emit(state.copyWith(promissoryNote: File('') ));
        }
        if (event.fileIndex == 2) {
          emit(state.copyWith(personalGuarantee: File('')));
        }
        if (event.fileIndex == 3) {
          emit(state.copyWith(photoOfTZ: File('')));
        }
        if (event.fileIndex == 4) {
          emit(state.copyWith(businessCertificate: File('')));
        }
      }



    });
  }
}


/* if (event is _uploadFromGalleryEvent) {
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
      }*/