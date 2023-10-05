import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/data/model/form_and_file_model.dart';
import 'package:food_stock/data/model/res_model/file_upload_res_model/file_upload_res_model.dart';
import 'package:food_stock/data/model/res_model/files_res_model/files_res_model.dart';
import 'package:food_stock/data/model/res_model/forms_res_model/forms_res_model.dart';
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
      if (event is _getFormsListEvent) {
        try {
          final res = await DioClient().get(path: AppUrls.formsListUrl);
          FormsResModel response = FormsResModel.fromJson(res);
          if (response.status == 200) {
            List<FormAndFileModel> formsList =
                state.formsAndFilesList.toList(growable: true);
            int len = response.data?.clientForms?.toList().length ?? 0;
            for (int i = 0; i < len; i++) {
              formsList.add(FormAndFileModel(
                  id: response.data?.clientForms?[i].id,
                  isForm: true,
                  name: response.data?.clientForms?[i].formName));
              debugPrint('formList[$i] = ${formsList[i].name}');
            }
            emit(state.copyWith(formsAndFilesList: formsList));
          } else {
            showSnackBar(
                context: event.context,
                title: response.message ?? AppStrings.somethingWrongString,
                bgColor: AppColors.redColor);
          }
        } on ServerException {
          showSnackBar(
              context: event.context,
              title: AppStrings.somethingWrongString,
              bgColor: AppColors.redColor);
        }
      } else if (event is _getFilesListEvent) {
        try {
          final res = await DioClient().get(path: AppUrls.filesListUrl);
          FilesResModel response = FilesResModel.fromJson(res);
          if (response.status == 200) {
            List<FormAndFileModel> filesList =
                state.formsAndFilesList.toList(growable: true);
            int len = response.data?.clientFiles?.toList().length ?? 0;
            for (int i = 0; i < len; i++) {
              filesList.add(FormAndFileModel(
                  id: response.data?.clientFiles?[i].id,
                  isForm: false,
                  name: response.data?.clientFiles?[i].fileName));
              debugPrint('fileList[$i] = ${filesList[i].name}');
            }
            emit(state.copyWith(formsAndFilesList: filesList));
          } else {
            showSnackBar(
                context: event.context,
                title: response.message ?? AppStrings.somethingWrongString,
                bgColor: AppColors.redColor);
          }
        } on ServerException {
          showSnackBar(
              context: event.context,
              title: AppStrings.somethingWrongString,
              bgColor: AppColors.redColor);
        }
      } else if (event is _pickDocumentEvent) {
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
            List<FormAndFileModel> formAndFileList =
                state.formsAndFilesList.toList(growable: true);
            FormData formData = FormData.fromMap({
              formAndFileList[event.fileIndex].isForm ?? false
                  ? AppStrings.formString
                  : AppStrings.fileString: await MultipartFile.fromFile(
                croppedImage?.path ?? pickedFile.path,
                contentType: MediaType('image', 'png'),
              )
            });
            debugPrint('file name = ${formAndFileList[event.fileIndex].name}');
            final res = await DioClient().uploadFileProgressWithFormData(
              path: AppUrls.FileUploadUrl,
              formData: formData,
            );
            FileUploadResModel response = FileUploadResModel.fromJson(res);
            if (response.baseUrl?.isNotEmpty ?? false) {
              formAndFileList[event.fileIndex].url = response.filepath;
              formAndFileList[event.fileIndex].localUrl =
                  croppedImage?.path ?? pickedFile.path;
              debugPrint(
                  'new Url [${event.fileIndex}] = ${formAndFileList[event.fileIndex].url}');
              emit(state.copyWith(formsAndFilesList: formAndFileList));
            } else {
              showSnackBar(
                  context: event.context,
                  title: res[AppStrings.messageString] ??
                      AppStrings.fileSizeLimit500KBString,
                  bgColor: AppColors.redColor);
            }
          } else {
            showSnackBar(
                context: event.context,
                title: AppStrings.fileSizeLimit500KBString,
                bgColor: AppColors.redColor);
          }
        }
      } else if (event is _uploadApiEvent) {
        // try {
        //   Map<String, MultipartFile> files = {};
        //   if (state.promissoryNote.path != '' ||
        //       state.promissoryNote.path.isNotEmpty) {
        //     files[AppStrings.promissoryNoteString] =
        //         await MultipartFile.fromFile(
        //       state.promissoryNote.path,
        //       contentType: MediaType('image', 'png'),
        //     );
        //   }
        //   if (state.personalGuarantee.path != '' ||
        //       state.personalGuarantee.path.isNotEmpty) {
        //     files[AppStrings.personalGuaranteeString] =
        //         await MultipartFile.fromFile(
        //       state.personalGuarantee.path,
        //       contentType: MediaType('image', 'png'),
        //     );
        //   }
        //   if (state.photoOfTZ.path != '' || state.photoOfTZ.path.isNotEmpty) {
        //     files[AppStrings.israelIdImageString] =
        //         await MultipartFile.fromFile(
        //       state.photoOfTZ.path,
        //       contentType: MediaType('image', 'png'),
        //     );
        //   }
        //   if (state.businessCertificate.path != '' ||
        //       state.businessCertificate.path.isNotEmpty) {
        //     files[AppStrings.businessCertificateString] =
        //         await MultipartFile.fromFile(
        //       state.businessCertificate.path,
        //       contentType: MediaType('image', 'png'),
        //     );
        //   }
        //   if (files.isEmpty) {
        //     if (state.isUpdate) {
        //       showSnackBar(
        //           context: event.context,
        //           title: AppStrings.updateSuccessString,
        //           bgColor: AppColors.mainColor);
        //       Navigator.pop(event.context);
        //     } else {
        //       showSnackBar(
        //           context: event.context,
        //           title: AppStrings.registerSuccessString,
        //           bgColor: AppColors.mainColor);
        //       Navigator.popUntil(event.context,
        //           (route) => route.name == RouteDefine.connectScreen.name);
        //       Navigator.pushNamed(
        //           event.context, RouteDefine.bottomNavScreen.name);
        //     }
        //     return;
        //   }
        //   FormData formData = FormData.fromMap(files);
        //   final response = await DioClient().uploadFileProgressWithFormData(
        //     path: AppUrls.FileUploadUrl,
        //     formData: formData,
        //   );
        //   FileUploadModel fileUploadModel = FileUploadModel.fromJson(response);
        //   if (fileUploadModel.baseUrl?.isNotEmpty ?? false) {
        //     if (state.isUpdate) {
        //       showSnackBar(
        //           context: event.context,
        //           title: AppStrings.updateSuccessString,
        //           bgColor: AppColors.mainColor);
        //       Navigator.pop(event.context);
        //     } else {
        //       showSnackBar(
        //           context: event.context,
        //           title: AppStrings.registerSuccessString,
        //           bgColor: AppColors.mainColor);
        //       Navigator.popUntil(event.context,
        //           (route) => route.name == RouteDefine.connectScreen.name);
        //       Navigator.pushNamed(
        //           event.context, RouteDefine.bottomNavScreen.name);
        //     }
        //   } else {
        //     showSnackBar(
        //         context: event.context,
        //         title: AppStrings.filesNotUploadString,
        //         bgColor: AppColors.mainColor);
        //   }
        // } on ServerException {
        //   showSnackBar(
        //       context: event.context,
        //       title: AppStrings.registerSuccessString,
        //       bgColor: AppColors.redColor);
        // }
      } else if (event is _deleteFileEvent) {
        if (event.index == 1) {
          emit(state.copyWith(promissoryNote: File('')));
        }
        if (event.index == 2) {
          emit(state.copyWith(personalGuarantee: File('')));
        }
        if (event.index == 3) {
          emit(state.copyWith(photoOfTZ: File('')));
        }
        if (event.index == 4) {
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
