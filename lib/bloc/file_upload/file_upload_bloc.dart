import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/data/model/res_model/file_upload_model/file_upload_model.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/error/exceptions.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_colors.dart';
import '../../ui/utils/themes/app_urls.dart';

part 'file_upload_state.dart';

part 'file_upload_event.dart';

part 'file_upload_bloc.freezed.dart';

class FileUploadBloc extends Bloc<FileUploadEvent, FileUploadState> {
  FileUploadBloc() : super(FileUploadState.initial()) {
    on<FileUploadEvent>((event, emit) async {
      if (event is _pickDocumentEvent) {
        File? image;
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(
            source: event.imageSourceIndex == 1
                ? ImageSource.camera
                : ImageSource.gallery);
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
      } else if (event is _uploadApiEvent) {
        try {
          Map<String, MultipartFile> files = {};
          if (state.promissoryNote.path != '' ||
              state.promissoryNote.path.isNotEmpty) {
            files[AppStrings.promissoryNoteString] =
            await MultipartFile.fromFile(
              state.promissoryNote.path,
              contentType: MediaType('image', 'png'),
            );
          }
          if (state.personalGuarantee.path != '' ||
              state.personalGuarantee.path.isNotEmpty) {
            files[AppStrings.personalGuaranteeString] =
            await MultipartFile.fromFile(
              state.personalGuarantee.path,
              contentType: MediaType('image', 'png'),
            );
          }
          if (state.photoOfTZ.path != '' || state.photoOfTZ.path.isNotEmpty) {
            files[AppStrings.israelIdImageString] =
            await MultipartFile.fromFile(
              state.photoOfTZ.path,
              contentType: MediaType('image', 'png'),
            );
          }
          if (state.businessCertificate.path != '' ||
              state.businessCertificate.path.isNotEmpty) {
            files[AppStrings.businessCertificateString] =
            await MultipartFile.fromFile(
              state.businessCertificate.path,
              contentType: MediaType('image', 'png'),
            );
          }
          FormData formData = FormData.fromMap(files);
          final response = await DioClient().uploadFileProgressWithFormData(
            path: AppUrls.FileUploadUrl,
            formData: formData,
          );
          FileUploadModel fileUploadModel = FileUploadModel.fromJson(response);
          if (fileUploadModel.baseUrl?.isNotEmpty ?? false) {
            SnackBarShow(event.context, AppStrings.registerSuccessString, AppColors.mainColor);
            Navigator.pushNamed(
                event.context, RouteDefine.bottomNavScreen.name);
          } else {

          }
        } on ServerException {
          SnackBarShow(event.context, AppStrings.registerSuccessString, AppColors.redColor);
        }
      } else if (event is _deleteFileEvent) {
        if (event.fileIndex == 1) {
          emit(state.copyWith(promissoryNote: File('')));
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
