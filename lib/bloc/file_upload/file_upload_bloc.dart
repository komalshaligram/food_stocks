import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/data/model/form_and_file_model.dart';
import 'package:food_stock/data/model/res_model/file_update_res_model/file_update_res_model.dart';
import 'package:food_stock/data/model/res_model/file_upload_res_model/file_upload_res_model.dart';
import 'package:food_stock/data/model/res_model/files_res_model/files_res_model.dart';
import 'package:food_stock/data/model/res_model/forms_res_model/forms_res_model.dart';
import 'package:food_stock/data/model/res_model/profile_details_res_model/profile_details_res_model.dart';
import 'package:food_stock/data/storage/shared_preferences_helper.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
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
        emit(state.copyWith(isLoading: true));
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
            emit(
                state.copyWith(formsAndFilesList: formsList, isLoading: false));
          } else {
            showSnackBar(
                context: event.context,
                title: response.message ?? AppStrings.somethingWrongString,
                bgColor: AppColors.redColor);
            emit(state.copyWith(isLoading: false));
          }
        } on ServerException {
          showSnackBar(
              context: event.context,
              title: AppStrings.somethingWrongString,
              bgColor: AppColors.redColor);
          emit(state.copyWith(isLoading: false));
        }
      } else if (event is _getFilesListEvent) {
        emit(state.copyWith(isLoading: true));
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
            emit(
                state.copyWith(formsAndFilesList: filesList, isLoading: false));
          } else {
            showSnackBar(
                context: event.context,
                title: response.message ?? AppStrings.somethingWrongString,
                bgColor: AppColors.redColor);
            emit(state.copyWith(isLoading: false));
          }
        } on ServerException {
          showSnackBar(
              context: event.context,
              title: AppStrings.somethingWrongString,
              bgColor: AppColors.redColor);
          emit(state.copyWith(isLoading: false));
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
            final res = await DioClient().uploadFileProgressWithFormData(
              context: event.context,
              path: AppUrls.fileUploadUrl,
              formData: formData,
            );
            FileUploadResModel response = FileUploadResModel.fromJson(res);
            if (response.baseUrl?.isNotEmpty ?? false) {
              formAndFileList[event.fileIndex].url = response.filepath;
              formAndFileList[event.fileIndex].localUrl =
                  croppedImage?.path ?? pickedFile.path;
              debugPrint(
                  'new Url [${event.fileIndex}] = ${formAndFileList[event.fileIndex].url}');
              emit(state.copyWith(formsAndFilesList: []));
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
        try {
          Map<String, Map<String, dynamic>> formsAndFiles = {
            AppStrings.formsString: {},
            AppStrings.filesString: {}
          };
          for (int i = 0; i < state.formsAndFilesList.length; i++) {
            debugPrint('url = ${state.formsAndFilesList[i].url}');
            if (state.formsAndFilesList[i].url?.isNotEmpty ?? false) {
              if ((state.formsAndFilesList[i].isForm ?? false) &&
                  (state.formsAndFilesList[i].url
                          ?.contains(AppStrings.tempString) ??
                      false)) {
                formsAndFiles[AppStrings.formsString]
                        ?[state.formsAndFilesList[i].id ?? ''] =
                    state.formsAndFilesList[i].url ?? '';
              } else if ((state.formsAndFilesList[i].isForm == false) &&
                  (state.formsAndFilesList[i].url
                          ?.contains(AppStrings.tempString) ??
                      false)) {
                formsAndFiles[AppStrings.filesString]
                        ?[state.formsAndFilesList[i].id ?? ''] =
                    state.formsAndFilesList[i].url ?? '';
              }
            }
          }
          debugPrint('update url list = ${formsAndFiles}');
          if ((formsAndFiles[AppStrings.formsString]?.isEmpty ?? true) &&
              (formsAndFiles[AppStrings.filesString]?.isEmpty ?? true)) {
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

              SharedPreferencesHelper preferencesHelper =
              SharedPreferencesHelper(
                  prefs: await SharedPreferences.getInstance());

              preferencesHelper.setUserLoggedIn(isLoggedIn: true);
              Navigator.popUntil(event.context,
                  (route) => route.name == RouteDefine.connectScreen.name);
              Navigator.pushNamed(
                  event.context, RouteDefine.bottomNavScreen.name);
            }
            return;
          }
          SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(
              prefs: await SharedPreferences.getInstance());
          debugPrint("userId:${preferencesHelper.getUserId()}");
          debugPrint(
              "${AppUrls.fileUpdateUrl}/${preferencesHelper.getUserId()}");
          final res = await DioClient().post(
            "${AppUrls.fileUpdateUrl}/${preferencesHelper.getUserId()}",
            data: formsAndFiles,
          );
          debugPrint('res:$res');
          FileUpdateResModel response = FileUpdateResModel.fromJson(res);
          if (response.status == 200) {
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
              Navigator.popUntil(event.context,
                  (route) => route.name == RouteDefine.connectScreen.name);
              Navigator.pushNamed(
                  event.context, RouteDefine.bottomNavScreen.name);
            }
          } else {
            showSnackBar(
                context: event.context,
                title: response.message ?? AppStrings.somethingWrongString,
                bgColor: AppColors.mainColor);
          }
        } on ServerException {
          showSnackBar(
              context: event.context,
              title: AppStrings.somethingWrongString,
              bgColor: AppColors.redColor);
        }
      } else if (event is _deleteFileEvent) {
        List<FormAndFileModel> formsAndFilesList =
            state.formsAndFilesList.toList(growable: true);
        formsAndFilesList[event.index].localUrl = '';
        formsAndFilesList[event.index].url = '';
        emit(state.copyWith(formsAndFilesList: []));
        emit(state.copyWith(formsAndFilesList: formsAndFilesList));
      } else if (event is _downloadFileEvent) {
        if (true) {
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
              // Uint8List fileBytes = state.businessCertificate.readAsBytesSync();
              // File newFile = File(
              //     '${dir.path}/${p.basename(state.businessCertificate.path)}');
              // await newFile.writeAsBytes(fileBytes).then(
              //   (value) {
              //     showSnackBar(
              //         context: event.context,
              //         title: AppStrings.docDownloadString,
              //         bgColor: AppColors.mainColor);
              //   },
              // );
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
        if (state.isUpdate) {
          try {
            final res = await DioClient().post(AppUrls.getProfileDetailsUrl,
                data: {'_id': '651bb2f9d2c8a6d5b1c1ff84'});
            ProfileDetailsResModel response =
                ProfileDetailsResModel.fromJson(res);

            if (response.status == 200) {
              List<FormAndFileModel> formsAndFilesList =
                  state.formsAndFilesList.toList(growable: true);
              for (int i = 0; i < formsAndFilesList.length; i++) {
                if (res['data']['clients'][0]['clientDetail']['forms']
                        [formsAndFilesList[i].id] !=
                    null) {
                  formsAndFilesList[i].url = res['data']['clients'][0]
                      ['clientDetail']['forms'][formsAndFilesList[i].id];
                } else if (res['data']['clients'][0]['clientDetail']['files']
                        [formsAndFilesList[i].id] !=
                    null) {
                  formsAndFilesList[i].url = res['data']['clients'][0]
                      ['clientDetail']['files'][formsAndFilesList[i].id];
                }
                debugPrint('url = ${formsAndFilesList[i].url}');
              }
              emit(state.copyWith(formsAndFilesList: []));
              emit(state.copyWith(formsAndFilesList: formsAndFilesList));
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
        }
      }
    });
  }
}
