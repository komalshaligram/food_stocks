import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/data/model/form_and_file_model/form_and_file_model.dart';
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
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/error/exceptions.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_constants.dart';
import '../../ui/utils/themes/app_urls.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                  sampleUrl: response.data?.clientForms?[i].sample,
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
                        .post(AppUrls.getProfileDetailsUrl,
                            data: {
                              AppStrings.idParamString:
                                  preferencesHelper.getUserId(),
                            },
                            options: Options(
                              headers: {
                                HttpHeaders.authorizationHeader:
                                    'Bearer ${preferencesHelper.getAuthToken()}',
                              },
                            ));
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
                            formsAndFilesList[i] = formsAndFilesList[i]
                                .copyWith(
                                    url: newModel[AppStrings.filesString]
                                        [formsAndFilesList[i].id]);
                          } else if (newModel[AppStrings.formsString] != null &&
                              (newModel[AppStrings.formsString]
                                      .containsKey(formsAndFilesList[i].id) ??
                                  false)) {
                            formsAndFilesList[i] = formsAndFilesList[i]
                                .copyWith(
                                    url: newModel[AppStrings.formsString]
                                        [formsAndFilesList[i].id]);
                          }
                          debugPrint(
                              'url(${formsAndFilesList[i].id}) = ${formsAndFilesList[i].url}');
                        }
                        emit(state.copyWith(
                            formsAndFilesList: formsAndFilesList,
                            isShimmering: false));
                      } else {
                        emit(state.copyWith(isShimmering: false));
                      }
                    } else {
                      CustomSnackBar.showSnackBar(
                          context: event.context,
                          title: AppStrings.getLocalizedStrings(
                              response.message?.toLocalization() ??
                                  'something_is_wrong_try_again',
                              event.context),
                          type: SnackBarType.FAILURE);
                    }
                  } on ServerException {
                    // CustomSnackBar.CustomSnackBar.CustomSnackBar.showSnackBar(
                    //     context: event.context,
                    //     title: AppStrings.somethingWrongString,
                    //     type: SnackBarType.FAILURE);
                  }
                }
              } else {
                CustomSnackBar.showSnackBar(
                    context: event.context,
                    title: AppStrings.getLocalizedStrings(
                        response.message?.toLocalization() ??
                            'something_is_wrong_try_again',
                        event.context),
                    type: SnackBarType.FAILURE);
                emit(state.copyWith(isLoading: false));
              }
            } on ServerException {
              // CustomSnackBar.CustomSnackBar.CustomSnackBar.showSnackBar(
              //     context: event.context,
              //     title: AppStrings.somethingWrongString,
              //     type: SnackBarType.FAILURE);
              emit(state.copyWith(isLoading: false));
            }
          } else {
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(
                    response.message?.toLocalization() ??
                        'something_is_wrong_try_again',
                    event.context),
                type: SnackBarType.FAILURE);
            emit(state.copyWith(isLoading: false));
          }
        } on ServerException {
          emit(state.copyWith(isLoading: false));
          CustomSnackBar.showSnackBar(
              context: event.context,
              title:
                  '${AppLocalizations.of(event.context)!.something_is_wrong_try_again}',
              type: SnackBarType.FAILURE);
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
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(
                    response.message?.toLocalization() ??
                        'something_is_wrong_try_again',
                    event.context),
                type: SnackBarType.FAILURE);
            emit(state.copyWith(isLoading: false));
          }
        } on ServerException {
          CustomSnackBar.showSnackBar(
              context: event.context,
              title:
                  '${AppLocalizations.of(event.context)!.something_is_wrong_try_again}',
              type: SnackBarType.FAILURE);
          emit(state.copyWith(isLoading: false));
        }
      } else if (event is _pickDocumentEvent) {
        if (state.isUploadLoading) {
          return;
        }
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
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: '${AppLocalizations.of(event.context)!.select_valid_document_format}',
                type: SnackBarType.FAILURE);
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
            debugPrint(
                'file upload = ${pickedFile.path}\n${croppedImage?.path}');
            debugPrint('file = ${croppedImage?.path == null}');
            List<FormAndFileModel> formAndFileList =
                state.formsAndFilesList.toList(growable: true);
            FormData formData = FormData.fromMap({
              formAndFileList[event.fileIndex].isForm ?? false
                  ? AppStrings.formString
                  : AppStrings.fileString: await MultipartFile.fromFile(
                croppedImage?.path ?? pickedFile.path,
                filename:
                    "${formAndFileList[event.fileIndex].name}_${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}_${DateTime.now().hour}-${DateTime.now().minute}-${DateTime.now().second}${p.extension(croppedImage?.path == null ? pickedFile.path : pickedFile.path)}",
                contentType: MediaType('application', 'pdf'),
              )
            });
            debugPrint(
                'file upload = ${formData.files.first.key}/${formData.files.first.value.filename /*.contentType?.parameters*/}');
            try {
              emit(state.copyWith(
                  isUploadLoading: true, uploadIndex: event.fileIndex));
              final res =
                  await DioClient(event.context).uploadFileProgressWithFormData(
                path: AppUrls.fileUploadUrl,
                formData: formData,
              );
              FileUploadResModel response = FileUploadResModel.fromJson(res);
              debugPrint('file upload =  ${res}');
              if (response.baseUrl?.isNotEmpty ?? false) {
                emit(state.copyWith(isUploadLoading: false));
                formAndFileList[event.fileIndex] =
                    formAndFileList[event.fileIndex]
                        .copyWith(url: response.filepath);
                formAndFileList[event.fileIndex] =
                    formAndFileList[event.fileIndex].copyWith(
                        localUrl: croppedImage?.path ?? pickedFile.path);
                debugPrint(
                    'new Url [${event.fileIndex}] = ${formAndFileList[event.fileIndex].url}');
                emit(state.copyWith(formsAndFilesList: formAndFileList));
              } else {
                emit(state.copyWith(isUploadLoading: false));
                CustomSnackBar.showSnackBar(
                    context: event.context,
                    title: AppStrings.getLocalizedStrings(
                        res[AppStrings.messageString]
                            .toString()
                            .toLocalization(),
                        event.context),
                    type: SnackBarType.FAILURE);
              }
            } catch (e) {
              emit(state.copyWith(isUploadLoading: false));
              // CustomSnackBar.CustomSnackBar.CustomSnackBar.showSnackBar(
              //     context: event.context,
              //     title: AppStrings.somethingWrongString,
              //     type: SnackBarType.FAILURE);
            }
          } else {
            emit(state.copyWith(
                isUploadLoading: false, isFileSizeExceeds: true));
            emit(state.copyWith(isFileSizeExceeds: false));
            // CustomSnackBar.CustomSnackBar.CustomSnackBar.showSnackBar(
            //     context: event.context,
            //     title: AppStrings.fileSizeLimitString,
            //     type: SnackBarType.FAILURE);
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
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title:
                      '${AppLocalizations.of(event.context)!.registered_successfully}',
                  type: SnackBarType.SUCCESS);
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
              if (event.isFromDelete ?? false) {
                CustomSnackBar.showSnackBar(
                    context: event.context,
                    title:
                        '${AppLocalizations.of(event.context)!.removed_successfully}',
                    type: SnackBarType.SUCCESS);
              } else {
                Navigator.pop(event.context);
                CustomSnackBar.showSnackBar(
                    context: event.context,
                    title:
                        '${AppLocalizations.of(event.context)!.updated_successfully}',
                    type: SnackBarType.SUCCESS);
              }
            } else {
              Navigator.popUntil(event.context,
                  (route) => route.name == RouteDefine.connectScreen.name);
              Navigator.pushNamed(
                  event.context, RouteDefine.bottomNavScreen.name);
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title:
                      '${AppLocalizations.of(event.context)!.registered_successfully}',
                  type: SnackBarType.SUCCESS);
            }
          } else {
            emit(state.copyWith(isApiLoading: false));
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(
                    response.message?.toLocalization() ??
                        'something_is_wrong_try_again',
                    event.context),
                type: SnackBarType.FAILURE);
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
          } else if (formsAndFilesList[event.index]
                  .url
                  ?.contains(AppStrings.tempString) ??
              false) {
            formsAndFilesList[event.index] =
                formsAndFilesList[event.index].copyWith(localUrl: '', url: '');
            emit(state.copyWith(formsAndFilesList: formsAndFilesList));
            CustomSnackBar.showSnackBar(
                context: event.context,
                title:
                    '${AppLocalizations.of(event.context)!.removed_successfully}',
                type: SnackBarType.SUCCESS);
            // add(FileUploadEvent.uploadApiEvent(
            //     context: event.context, isFromDelete: true));
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
            formsAndFilesList[event.index] =
                formsAndFilesList[event.index].copyWith(localUrl: '');
            formsAndFilesList[event.index] =
                formsAndFilesList[event.index].copyWith(url: '');
            emit(state.copyWith(formsAndFilesList: formsAndFilesList));
            // CustomSnackBar.CustomSnackBar.CustomSnackBar.showSnackBar(
            //     context: event.context,
            //     title: response.message ?? AppStrings.removeSuccessString,
            //     type: SnackBarType.SUCCESS);
            add(FileUploadEvent.uploadApiEvent(
                context: event.context, isFromDelete: true));
          } else {
            emit(state.copyWith(isUploadLoading: false));
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(
                    response.message?.toLocalization() ??
                        'something_is_wrong_try_again',
                    event.context),
                type: SnackBarType.FAILURE);
          }
        } catch (e) {
          emit(state.copyWith(isUploadLoading: false));
          CustomSnackBar.showSnackBar(
              context: event.context,
              title:
                  '${AppLocalizations.of(event.context)!.something_is_wrong_try_again}',
              type: SnackBarType.FAILURE);
        }
      } else if (event is _downloadFileEvent) {
        try {
          emit(state.copyWith(isDownloading: true));
          // PackageInfo packageInfo = await PackageInfo.fromPlatform();
          //
          // String buildNumber = packageInfo.buildNumber;
          // debugPrint('build number $buildNumber');
          // if(statuses[Permission.storage]!.isGranted) {
          // File file;
          Directory? dir;
          if (defaultTargetPlatform == TargetPlatform.android) {
            // dir = await getApplicationDocumentsDirectory();
            dir = Directory('/storage/emulated/0/Documents');
            debugPrint('dir = ${await dir.stat()}');
            // return;
          } else {
            dir = await getApplicationDocumentsDirectory();
          }
          debugPrint(
              'download url = ${AppUrls.baseFileUrl}${state.formsAndFilesList[event.fileIndex].sampleUrl}');
          //'https://filesamples.com/samples/document/pdf/sample3.pdf'
          String filePath =
              '${dir.path}/${state.formsAndFilesList[event.fileIndex].sampleUrl?.split('/').last.split('.').first}_${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}_${DateTime.now().hour}-${DateTime.now().minute}-${DateTime.now().second}${p.extension(state.formsAndFilesList[event.fileIndex].sampleUrl?.split('/').last ?? '')}';
          debugPrint('download path = $filePath');
          await Dio().download(
              "${AppUrls.baseFileUrl}${state.formsAndFilesList[event.fileIndex].sampleUrl}",
              filePath, onReceiveProgress: (received, total) {
            debugPrint('rec:${received},total:$total');
            int progress = (received * 100) ~/ total;
            emit(state.copyWith(downloadProgress: progress));
            debugPrint('download progress = ${state.downloadProgress}');
          });
          CustomSnackBar.showSnackBar(
              context: event.context,
              title:
                  AppLocalizations.of(event.context)!.downloaded_successfully,
              type: SnackBarType.SUCCESS);
          emit(state.copyWith(downloadProgress: 0, isDownloading: false));
          // HttpClient httpClient = new HttpClient();
          // String filePath = '';
          // try {
          //   var request = await httpClient.getUrl(Uri.parse(
          //       "${AppUrls.baseFileUrl}${state.formsAndFilesList[event.fileIndex].sampleUrl}"));
          //   var response = await request.close();
          //   if (response.statusCode == 200) {
          //     Uint8List fileBytes =
          //         await consolidateHttpClientResponseBytes(response);
          //     debugPrint('File bytes = $fileBytes');
          //     filePath =
          //         '${dir.path}/${state.formsAndFilesList[event.fileIndex].sampleUrl?.split('/').last}';
          //     file = File(filePath);
          //     if (file.existsSync()) {
          //       debugPrint('File exist');
          //       file.deleteSync();
          //       // file = File(filePath);
          //     }
          //     await file
          //         .writeAsBytes(fileBytes, mode: FileMode.writeOnly)
          //         .then((value) {
          //       CustomSnackBar.CustomSnackBar.CustomSnackBar.showSnackBar(
          //           context: event.context,
          //           title: AppStrings.downloadString,
          //           type: SnackBarType.SUCCESS);
          //     });
          //     emit(state.copyWith(isDownloading: false));
          //   } else {
          //     emit(state.copyWith(isDownloading: false));
          //     filePath = 'Error code: ' + response.statusCode.toString();
          //     debugPrint('download ${filePath}');
          //     CustomSnackBar.CustomSnackBar.CustomSnackBar.showSnackBar(
          //         context: event.context,
          //         title: AppStrings.downloadFailedString,
          //         type: SnackBarType.FAILURE);
          //   }
          // } catch (e) {
          //   emit(state.copyWith(isDownloading: false));
          //   filePath = 'Can not fetch url';
          //   debugPrint('file error = ${e}');
          //   CustomSnackBar.CustomSnackBar.CustomSnackBar.showSnackBar(
          //       context: event.context,
          //       title: AppStrings.downloadFailedString,
          //       type: SnackBarType.FAILURE);
          // }
          // } else {
          //   emit(state.copyWith(isDownloading: false));
          //   CustomSnackBar.CustomSnackBar.showSnackBar(
          //       context: event.context,
          //       title: AppStrings.docDownloadAllowPermissionString,
          //       type: SnackBarType.FAILURE);
          // }
        } catch (e) {
          emit(state.copyWith(isDownloading: false));
          CustomSnackBar.showSnackBar(
              context: event.context,
              title: '${AppLocalizations.of(event.context)!.failed_download}',
              type: SnackBarType.FAILURE);
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
                  formsAndFilesList[i] = formsAndFilesList[i].copyWith(
                      url: newModel[AppStrings.filesString]
                          [formsAndFilesList[i].id]);
                } else if (newModel[AppStrings.formsString]
                        .containsKey(formsAndFilesList[i].id) ??
                    false) {
                  formsAndFilesList[i] = formsAndFilesList[i].copyWith(
                      url: newModel[AppStrings.formsString]
                          [formsAndFilesList[i].id]);
                }
                debugPrint(
                    'url(${formsAndFilesList[i].id}) = ${formsAndFilesList[i].url}');
              }
              emit(state.copyWith(formsAndFilesList: formsAndFilesList));
            } else {
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppStrings.getLocalizedStrings(
                      response.message?.toLocalization() ??
                          'something_is_wrong_try_again',
                      event.context),
                  type: SnackBarType.FAILURE);
            }
          } on ServerException {
            CustomSnackBar.showSnackBar(
                context: event.context,
                title:
                    '${AppLocalizations.of(event.context)!.something_is_wrong_try_again}',
                type: SnackBarType.FAILURE);
          }
        }
      }
    });
  }
}
