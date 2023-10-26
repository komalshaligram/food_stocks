import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/data/model/form_and_file_model.dart';
import 'package:food_stock/data/model/req_model/remove_form_and_file_req_model/remove_form_and_file_req_model.dart';
import 'package:food_stock/data/model/res_model/file_update_res_model/file_update_res_model.dart';
import 'package:food_stock/data/model/res_model/file_upload_res_model/file_upload_res_model.dart';
import 'package:food_stock/data/model/res_model/files_res_model/files_res_model.dart';
import 'package:food_stock/data/model/res_model/forms_res_model/forms_res_model.dart';
import 'package:food_stock/data/model/res_model/profile_details_res_model/profile_details_res_model.dart';
import 'package:food_stock/data/model/res_model/remove_form_and_file_res_model/remove_form_and_file_res_model.dart';
import 'package:food_stock/data/storage/shared_preferences_helper.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/error/exceptions.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_colors.dart';
import '../../ui/utils/themes/app_constants.dart';
import '../../ui/utils/themes/app_urls.dart';

part 'file_upload_state.dart';

part 'file_upload_event.dart';

part 'file_upload_bloc.freezed.dart';

class FileUploadBloc extends Bloc<FileUploadEvent, FileUploadState> {
  FileUploadBloc() : super(FileUploadState.initial()) {
    on<FileUploadEvent>((event, emit) async {
      if (event is _getFormsListEvent) {
        emit(state.copyWith(
            isLoading: true, isShimmering: true, isUpdate: event.isUpdate));
        try {
          final res =
              await DioClient(event.context).get(path: AppUrls.formsListUrl);
          FormsResModel response = FormsResModel.fromJson(res);
          if (response.status == 200) {
            List<FormAndFileModel> formsList =
                state.formsAndFilesList.toList(growable: true);
            int len = response.data?.clientForms?.toList().length ?? 0;
            for (int i = 0; i < len; i++) {
              formsList.add(FormAndFileModel(
                  id: response.data?.clientForms?[i].id,
                  isForm: true,
                  isDownloadable: true,
                  name: response.data?.clientForms?[i].formName));
              debugPrint('formList[$i] = ${formsList[i].name}');
            }
            emit(state.copyWith(formsAndFilesList: formsList));
            try {
              final res = await DioClient(event.context)
                  .get(path: AppUrls.filesListUrl);
              FilesResModel response = FilesResModel.fromJson(res);
              if (response.status == 200) {
                List<FormAndFileModel> filesList =
                    state.formsAndFilesList.toList(growable: true);
                int len = response.data?.clientFiles?.toList().length ?? 0;
                for (int i = 0; i < len; i++) {
                  filesList.add(FormAndFileModel(
                      id: response.data?.clientFiles?[i].id,
                      isForm: false,
                      // isDownloadable: true,
                      name: response.data?.clientFiles?[i].fileName));
                  debugPrint('fileList[$i] = ${filesList[i].name}');
                }
                emit(state.copyWith(
                    formsAndFilesList: filesList,
                    isLoading: false,
                    isShimmering: false));
                if (state.isUpdate) {
                  try {
                    emit(state.copyWith(isShimmering: true));
                    SharedPreferencesHelper preferencesHelper =
                        SharedPreferencesHelper(
                            prefs: await SharedPreferences.getInstance());
                    final res = await DioClient(event.context)
                        .post(AppUrls.getProfileDetailsUrl, data: {
                      AppStrings.idParamString: preferencesHelper.getUserId()
                    });
                    ProfileDetailsResModel response =
                        ProfileDetailsResModel.fromJson(res);
                    Map<String, dynamic> newModel =
                        res['data']['clients'][0]['clientDetail'];
                    debugPrint('data1 = ${newModel}');

                    debugPrint('files = ${newModel[AppStrings.filesString]}');
                    debugPrint('forms = ${newModel[AppStrings.formsString]}');

                    if (response.status == 200) {
                      if (newModel[AppStrings.formsString] != null ||
                          newModel[AppStrings.filesString] != null) {
                        List<FormAndFileModel> formsAndFilesList =
                            state.formsAndFilesList.toList(growable: true);
                        for (int i = 0; i < formsAndFilesList.length; i++) {
                          if (newModel[AppStrings.filesString] != null &&
                              (newModel[AppStrings.filesString]
                                      .containsKey(formsAndFilesList[i].id) ??
                                  false)) {
                            formsAndFilesList[i].url =
                                newModel[AppStrings.filesString]
                                    [formsAndFilesList[i].id];
                          } else if (newModel[AppStrings.formsString] != null &&
                              (newModel[AppStrings.formsString]
                                      .containsKey(formsAndFilesList[i].id) ??
                                  false)) {
                            formsAndFilesList[i].url =
                                newModel[AppStrings.formsString]
                                    [formsAndFilesList[i].id];
                          }
                          debugPrint(
                              'url(${formsAndFilesList[i].id}) = ${formsAndFilesList[i].url}');
                        }
                        emit(state.copyWith(
                            formsAndFilesList: [], isShimmering: false));
                        emit(state.copyWith(
                            formsAndFilesList: formsAndFilesList));
                      } else {
                        emit(state.copyWith(isShimmering: false));
                      }
                    } else {
                      showSnackBar(
                          context: event.context,
                          title: response.message ??
                              AppStrings.somethingWrongString,
                          bgColor: AppColors.redColor);
                    }
                  } on ServerException {
                    // showSnackBar(
                    //     context: event.context,
                    //     title: AppStrings.somethingWrongString,
                    //     bgColor: AppColors.redColor);
                  }
                }
              } else {
                showSnackBar(
                    context: event.context,
                    title: response.message ?? AppStrings.somethingWrongString,
                    bgColor: AppColors.redColor);
                emit(state.copyWith(isLoading: false));
              }
            } on ServerException {
              // showSnackBar(
              //     context: event.context,
              //     title: AppStrings.somethingWrongString,
              //     bgColor: AppColors.redColor);
              emit(state.copyWith(isLoading: false));
            }
          } else {
            showSnackBar(
                context: event.context,
                title: response.message ?? AppStrings.somethingWrongString,
                bgColor: AppColors.redColor);
            emit(state.copyWith(isLoading: false));
          }
        } on ServerException {
          emit(state.copyWith(isLoading: false));
          showSnackBar(
              context: event.context,
              title: AppStrings.somethingWrongString,
              bgColor: AppColors.redColor);
        }
      } else if (event is _getFilesListEvent) {
        emit(state.copyWith(isLoading: true));
        try {
          final res =
              await DioClient(event.context).get(path: AppUrls.filesListUrl);
          FilesResModel response = FilesResModel.fromJson(res);
          if (response.status == 200) {
            List<FormAndFileModel> filesList =
                state.formsAndFilesList.toList(growable: true);
            int len = response.data?.clientFiles?.toList().length ?? 0;
            for (int i = 0; i < len; i++) {
              filesList.add(FormAndFileModel(
                  id: response.data?.clientFiles?[i].id,
                  isForm: false,
                  // isDownloadable: true,
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
          pickedFile = await ImagePicker()
              .pickMedia(imageQuality: AppConstants.fileQuality);
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
              fileType.contains('jpeg') ||
              fileType.contains('heic')) {
            croppedImage = await cropImage(
                path: pickedFile.path,
                shape: CropStyle.rectangle,
                quality: AppConstants.fileQuality);
            if (croppedImage?.path.isEmpty ?? true) {
              return;
            }
          } else {
            showSnackBar(
                context: event.context,
                title: AppStrings.selectValidDocumentFormatString,
                bgColor: AppColors.redColor);
            return;
          }
          String fileSize = getFileSizeString(
              bytes: croppedImage?.path.isNotEmpty ?? false
                  ? await File(croppedImage!.path).length()
                  : await pickedFile.length());
          debugPrint('file SIze = $fileSize');
          if (int.parse(fileSize.split(' ').first) == 0) {
            return;
          }
          if (int.parse(fileSize.split(' ').first) <=
                  AppConstants.fileSizeCap &&
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
            try {
              emit(state.copyWith(
                  isUploadLoading: true, uploadIndex: event.fileIndex));
              final res =
                  await DioClient(event.context).uploadFileProgressWithFormData(
                path: AppUrls.fileUploadUrl,
                formData: formData,
              );
              FileUploadResModel response = FileUploadResModel.fromJson(res);
              if (response.baseUrl?.isNotEmpty ?? false) {
                emit(state.copyWith(isUploadLoading: false));
                formAndFileList[event.fileIndex].url = response.filepath;
                formAndFileList[event.fileIndex].localUrl =
                    croppedImage?.path ?? pickedFile.path;
                debugPrint(
                    'new Url [${event.fileIndex}] = ${formAndFileList[event.fileIndex].url}');
                emit(state.copyWith(formsAndFilesList: []));
                emit(state.copyWith(formsAndFilesList: formAndFileList));
              } else {
                emit(state.copyWith(isUploadLoading: false));
                showSnackBar(
                    context: event.context,
                    title: res[AppStrings.messageString] ??
                        AppStrings.fileSizeLimitString,
                    bgColor: AppColors.redColor);
              }
            } catch (e) {
              emit(state.copyWith(isUploadLoading: false));
              showSnackBar(
                  context: event.context,
                  title: AppStrings.somethingWrongString,
                  bgColor: AppColors.redColor);
            }
          } else {
            emit(state.copyWith(
                isUploadLoading: false, isFileSizeExceeds: true));
            emit(state.copyWith(isFileSizeExceeds: false));
            // showSnackBar(
            //     context: event.context,
            //     title: AppStrings.fileSizeLimitString,
            //     bgColor: AppColors.redColor);
          }
        }
      } else if (event is _uploadApiEvent) {
        try {
          emit(state.copyWith(isApiLoading: true));
          Map<String, Map<String, dynamic>> formsAndFiles = {
            AppStrings.formsString: {},
            AppStrings.filesString: {}
          };
          state.formsAndFilesList.forEach((formAndFile) {
            debugPrint('url = ${formAndFile.url}');
            if (formAndFile.url?.isNotEmpty ?? false) {
              if ((formAndFile.isForm ??
                      false) /*&&
                  (state.formsAndFilesList[i].url
                          ?.contains(AppStrings.tempString) ??
                      false)*/
              ) {
                formsAndFiles[AppStrings.formsString]?[formAndFile.id ?? ''] =
                    formAndFile.url ?? '';
              } else if ((formAndFile.isForm ==
                  false) /*&&
                  (state.formsAndFilesList[i].url
                      ?.contains(AppStrings.tempString) ??
                      false)*/
                  ) {
                formsAndFiles[AppStrings.filesString]?[formAndFile.id ?? ''] =
                    formAndFile.url ?? '';
              }
            }
          });
          debugPrint('update urls list = ${formsAndFiles}');
          if (!state.isUpdate) {
            if ((formsAndFiles[AppStrings.formsString]?.isEmpty ?? true) &&
                (formsAndFiles[AppStrings.filesString]?.isEmpty ?? true)) {
              emit(state.copyWith(isApiLoading: false));
              showSnackBar(
                  context: event.context,
                  title: AppStrings.registerSuccessString,
                  bgColor: AppColors.mainColor);
              Navigator.popUntil(event.context,
                  (route) => route.name == RouteDefine.connectScreen.name);
              Navigator.pushNamed(
                  event.context, RouteDefine.bottomNavScreen.name);
              return;
            }
          }
          SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(
              prefs: await SharedPreferences.getInstance());

          final res = await DioClient(event.context).post(
            "${AppUrls.fileUpdateUrl}/${preferencesHelper.getUserId()}",
            data: formsAndFiles,
          );
          FileUpdateResModel response = FileUpdateResModel.fromJson(res);
          debugPrint("file update res = $res");
          if (response.status == 200) {
            emit(state.copyWith(isApiLoading: false));
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
            emit(state.copyWith(isApiLoading: false));
            showSnackBar(
                context: event.context,
                title: response.message ?? AppStrings.somethingWrongString,
                bgColor: AppColors.redColor);
          }
        } on ServerException {
          emit(state.copyWith(isApiLoading: false));
        }
      } else if (event is _deleteFileEvent) {
        List<FormAndFileModel> formsAndFilesList =
            state.formsAndFilesList.toList(growable: true);
        try {
          if (formsAndFilesList[event.index].url?.isEmpty ?? true) {
            return;
          }
          emit(state.copyWith(isUploadLoading: true, uploadIndex: event.index));
          RemoveFormAndFileReqModel reqModel = RemoveFormAndFileReqModel(
              path: formsAndFilesList[event.index].url);
          debugPrint('delete file req = ${reqModel.path}');
          final res = await DioClient(event.context)
              .post(AppUrls.removeFileUrl, data: reqModel);
          RemoveFormAndFileResModel response =
              RemoveFormAndFileResModel.fromJson(res);
          debugPrint('delete file res = ${response.message}');
          if (response.status == 200) {
            emit(state.copyWith(isUploadLoading: false));
            formsAndFilesList[event.index].localUrl = '';
            formsAndFilesList[event.index].url = '';
            emit(state.copyWith(formsAndFilesList: []));
            emit(state.copyWith(formsAndFilesList: formsAndFilesList));
            // showSnackBar(
            //     context: event.context,
            //     title: response.message ?? AppStrings.removeSuccessString,
            //     bgColor: AppColors.mainColor);
            add(FileUploadEvent.uploadApiEvent(context: event.context));
          } else {
            emit(state.copyWith(isUploadLoading: false));
            showSnackBar(
                context: event.context,
                title: response.message ?? AppStrings.somethingWrongString,
                bgColor: AppColors.redColor);
          }
        } catch (e) {
          emit(state.copyWith(isUploadLoading: false));
          showSnackBar(
              context: event.context,
              title: AppStrings.somethingWrongString,
              bgColor: AppColors.redColor);
        }
      } else if (event is _downloadFileEvent) {
        try {
          Map<Permission, PermissionStatus> statuses = await [
            Permission.storage,
          ].request();

          PackageInfo packageInfo = await PackageInfo.fromPlatform();

          String buildNumber = packageInfo.buildNumber;
          debugPrint('build number $buildNumber');
          // if (statuses[Permission.storage]!.isGranted) {
          File file;
          Directory dir;
          if (defaultTargetPlatform == TargetPlatform.android) {
            dir = Directory('/storage/emulated/0/Documents');
          } else {
            dir = await getApplicationDocumentsDirectory();
          }
          if (state.formsAndFilesList[event.fileIndex].url
                  ?.contains(AppStrings.tempString) ??
              false) {
            file =
                File(state.formsAndFilesList[event.fileIndex].localUrl ?? '');
            Uint8List fileBytes = file.readAsBytesSync();
            File newFile = File('${dir.path}/${p.basename(file.path)}');
            await newFile.writeAsBytes(fileBytes).then(
              (value) {
                showSnackBar(
                    context: event.context,
                    title: AppStrings.downloadString,
                    bgColor: AppColors.mainColor);
              },






            );
          } else {
            HttpClient httpClient = new HttpClient();
            String filePath = '';
            try {
              var request = await httpClient.getUrl(Uri.parse(
                  "${AppUrls.baseFileUrl}${state.formsAndFilesList[event.fileIndex].url}"));
              var response = await request.close();
              if (response.statusCode == 200) {
                Uint8List fileBytes =
                    await consolidateHttpClientResponseBytes(response);
                filePath =
                    '${dir.path}/${state.formsAndFilesList[event.fileIndex].url?.split('/').last}';
                file = File(filePath);
                await file.writeAsBytes(fileBytes).then((value) {
                  showSnackBar(
                      context: event.context,
                      title: AppStrings.downloadString,
                      bgColor: AppColors.mainColor);
                });
              } else {
                filePath = 'Error code: ' + response.statusCode.toString();
                debugPrint('download ${filePath}');
                showSnackBar(
                    context: event.context,
                    title: AppStrings.downloadFailedString,
                    bgColor: AppColors.redColor);
              }
            } catch (ex) {
              filePath = 'Can not fetch url';
            }
          }
          // } else {
          //   showSnackBar(
          //       context: event.context,
          //       title: AppStrings.docDownloadAllowPermissionString,
          //       bgColor: AppColors.redColor);
          // }
        } catch (e) {
          showSnackBar(
              context: event.context,
              title: AppStrings.somethingWrongString,
              bgColor: AppColors.redColor);
        }
      } else if (event is _getProfileFilesAndFormsEvent) {
        emit(state.copyWith(isUpdate: event.isUpdate));
        if (state.isUpdate) {
          try {
            SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(
                prefs: await SharedPreferences.getInstance());
            final res = await DioClient(event.context)
                .post(AppUrls.getProfileDetailsUrl, data: {
              AppStrings.idParamString: /*'651bb2f9d2c8a6d5b1c1ff84'*/
                  preferencesHelper.getUserId()
            });
            ProfileDetailsResModel response =
                ProfileDetailsResModel.fromJson(res);
            Map<String, dynamic> newModel =
                res['data']['clients'][0]['clientDetail'];
            debugPrint('data1 = ${newModel}');

            debugPrint(
                'files = ${response.data?.clients?.first.clientDetail?.files?.toJson().keys}}');
            debugPrint(
                'forms = ${response.data?.clients?.first.clientDetail?.forms?.toJson().keys}}');

            if (response.status == 200) {
              List<FormAndFileModel> formsAndFilesList =
                  state.formsAndFilesList.toList(growable: true);
              for (int i = 0; i < formsAndFilesList.length; i++) {
                if (newModel[AppStrings.filesString]
                        .containsKey(formsAndFilesList[i].id) ??
                    false) {
                  formsAndFilesList[i].url =
                      newModel[AppStrings.filesString][formsAndFilesList[i].id];
                } else if (newModel[AppStrings.formsString]
                        .containsKey(formsAndFilesList[i].id) ??
                    false) {
                  formsAndFilesList[i].url =
                      newModel[AppStrings.formsString][formsAndFilesList[i].id];
                }
                debugPrint(
                    'url(${formsAndFilesList[i].id}) = ${formsAndFilesList[i].url}');
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
