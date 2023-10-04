import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/data/model/res_model/file_upload_model/file_upload_model.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
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
        XFile? pickedFile;
        if (event.isDocument) {
          pickedFile = await ImagePicker().pickMedia(imageQuality: 100);
        } else {
          pickedFile = await ImagePicker().pickImage(
              source: event.isFromCamera
                  ? ImageSource.camera
                  : ImageSource.gallery);
        }
        if (pickedFile != null) {
          debugPrint(
              "mime ${p.extension(pickedFile.path)}\n${pickedFile.path}");
          String fileType = p.extension(pickedFile.path);
          CroppedFile? croppedImage;
          if (fileType.contains('pdf') ||
              fileType.contains('doc') ||
              fileType.contains('docx')) {
          } else if (fileType.contains('jpg') ||
              fileType.contains('png') ||
              fileType.contains('jpeg')) {
            croppedImage = await cropImage(
                path: pickedFile.path,
                shape: CropStyle.rectangle,
                quality: 100);
          } else {
            showSnackBar(
                context: event.context,
                title: AppStrings.selectValidDocumentFormatString,
                bgColor: AppColors.redColor);
            return;
          }
          String fileSize = getFileSizeString(
              bytes:
                  await File(croppedImage?.path ?? pickedFile.path).length());
          if (int.parse(fileSize.split(' ').first) <= 500 &&
              fileSize.split(' ').last == 'KB') {
            if (event.fileIndex == 1) {
              emit(state.copyWith(
                  promissoryNote: File(croppedImage?.path ?? pickedFile.path),
                  isPromissoryNoteDocument:
                      croppedImage == null ? true : false));
            }
            if (event.fileIndex == 2) {
              emit(state.copyWith(
                  personalGuarantee:
                      File(croppedImage?.path ?? pickedFile.path),
                  isPersonalGuaranteeDocument:
                      croppedImage == null ? true : false));
            }
            if (event.fileIndex == 3) {
              emit(state.copyWith(
                  photoOfTZ: File(croppedImage?.path ?? pickedFile.path),
                  isPhotoOfTZDocument: croppedImage == null ? true : false));
            }
            if (event.fileIndex == 4) {
              emit(state.copyWith(
                  businessCertificate:
                      File(croppedImage?.path ?? pickedFile.path),
                  isBusinessCertificateDocument:
                      croppedImage == null ? true : false));
            }
          } else {
            showSnackBar(
                context: event.context,
                title: AppStrings.fileSizeLimit500KBString,
                bgColor: AppColors.redColor);
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
          if (files.isEmpty) {
            if (state.isUpdate) {
              showSnackBar(
                  context: event.context,
                  title: AppStrings.updateSuccessString,
                  bgColor: AppColors.mainColor);
              Navigator.pop(event.context);
            } else {
              showSnackBar(
                  context: event.context,
                  title: AppStrings.registerSuccessString,
                  bgColor: AppColors.mainColor);
              Navigator.pushNamed(
                  event.context, RouteDefine.bottomNavScreen.name);
            }
            return;
          }
          FormData formData = FormData.fromMap(files);
          final response = await DioClient().uploadFileProgressWithFormData(
            path: AppUrls.FileUploadUrl,
            formData: formData,
          );
          FileUploadModel fileUploadModel = FileUploadModel.fromJson(response);
          if (fileUploadModel.baseUrl?.isNotEmpty ?? false) {
            if (state.isUpdate) {
              showSnackBar(
                  context: event.context,
                  title: AppStrings.updateSuccessString,
                  bgColor: AppColors.mainColor);
              Navigator.pop(event.context);
            } else {
              showSnackBar(
                  context: event.context,
                  title: AppStrings.registerSuccessString,
                  bgColor: AppColors.mainColor);
              Navigator.pushNamed(
                  event.context, RouteDefine.bottomNavScreen.name);
            }
          } else {
            showSnackBar(
                context: event.context,
                title: AppStrings.filesNotUploadString,
                bgColor: AppColors.mainColor);
          }
        } on ServerException {
          showSnackBar(
              context: event.context,
              title: AppStrings.registerSuccessString,
              bgColor: AppColors.redColor);
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
      } else if (event is _downloadFileEvent) {
        if (state.businessCertificate.path != '') {
          try {
            Map<Permission, PermissionStatus> statuses = await [
              Permission.storage,
            ].request();

            if (statuses[Permission.storage]!.isGranted) {
              Directory dir;
              if (defaultTargetPlatform == TargetPlatform.android) {
                dir = Directory('/storage/emulated/0/Documents');
              } else {
                dir = await getApplicationDocumentsDirectory();
              }
              Uint8List fileBytes = state.businessCertificate.readAsBytesSync();
              File newFile = File(
                  '${dir.path}/${p.basename(state.businessCertificate.path)}');
              await newFile.writeAsBytes(fileBytes).then(
                (value) {
                  showSnackBar(
                      context: event.context,
                      title: AppStrings.docDownloadString,
                      bgColor: AppColors.mainColor);
                },
              );
            } else {
              showSnackBar(
                  context: event.context,
                  title: AppStrings.docDownloadAllowPermissionString,
                  bgColor: AppColors.redColor);
            }
          } catch (e) {
            showSnackBar(
                context: event.context,
                title: AppStrings.somethingWrongString,
                bgColor: AppColors.redColor);
          }
        } else {
          showSnackBar(
              context: event.context,
              title: AppStrings.uploadDocumentFirstString,
              bgColor: AppColors.redColor);
        }
      } else if (event is _getProfileFilesAndFormsEvent) {
        emit(state.copyWith(isUpdate: event.isUpdate));
        //api call
        // try {
        //
        //   final res = await DioClient().put(
        //       path: AppUrls.updateProfileDetailsUrl,
        //       data: {});
        //
        //
        // } on ServerException {
        //   showSnackBar(
        //       context: event.context,
        //       title: AppStrings.somethingWrongString,
        //       bgColor: AppColors.redColor);
        // }
      }
    });
  }
}
