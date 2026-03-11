import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/req_model/update_sub_user/update_sub_user_req_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/req_model/get_sub_user/get_sub_user_req_model.dart';
import '../../data/model/req_model/sub_user/sub_user_req_model.dart';
import '../../data/model/req_model/sub_user_delete/sub_user_delete_req_model.dart';
import '../../data/model/res_model/file_upload_model/file_upload_model.dart';
import '../../data/model/res_model/get_all_sub_user/get_sub_user_res_model.dart';
import '../../data/model/res_model/sub_user/sub_user_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../repository/dio_client.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_constants.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/utils/constants/app_urls.dart';
import 'package:http_parser/http_parser.dart';
part 'sub_users_profile_event.dart';
part 'sub_users_profile_state.dart';
part 'sub_users_profile_bloc.freezed.dart';

class SubUsersProfileBloc extends Bloc<SubUsersProfileEvent, SubUsersProfileState> {
  SubUsersProfileBloc() : super(SubUsersProfileState.initial()) {
    String imgUrl = '';
    on<SubUsersProfileEvent>((event, emit) async {
      SharedPreferencesHelper preferences = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

      if (event is _getAppLanguageEvent) {
        emit(state.copyWith(language: preferences.getAppLanguage()));
      } else if (event is _pickProfileImageEvent) {
        final pickedFile = await ImagePicker().pickImage(source: event.isFromCamera ? ImageSource.camera : ImageSource.gallery);
        if (pickedFile != null) {
          CroppedFile? croppedImage = await cropImage(path: pickedFile.path, shape: CropStyle.circle, quality: AppConstants.fileQuality);
          if (croppedImage?.path.isEmpty ?? true) {
            return;
          }
          String imageSize = getFileSizeString(
            bytes: croppedImage?.path.isNotEmpty ?? false ? await File(croppedImage!.path).length() : await pickedFile.length(),
          );

          if (int.parse(imageSize.split(' ').first) == 0) {
            return;
          }
          try {
            emit(state.copyWith(isFileUploading: true, isUploadingProcess: true));
            final response = await DioClient(event.context).uploadFileProgressWithFormData(
              path: AppUrlEndPoints.fileUploadUrl,
              formData: FormData.fromMap(
                {
                  AppStrings.profileImageString: await MultipartFile.fromFile(
                    croppedImage?.path ?? pickedFile.path,
                    contentType: MediaType('image', 'png'),
                  )
                },
              ),
            );
            FileUploadModel profileImageModel = FileUploadModel.fromJson(response);

            if (profileImageModel.filepath != '') {
              imgUrl = profileImageModel.filepath ?? '';
              emit(state.copyWith(
                isUploadingProcess: false,
                image: File(croppedImage?.path ?? pickedFile.path),
                subUserProfileImage: profileImageModel.filepath ?? '',
              ));
            }
          } on ServerException {
            emit(state.copyWith(isFileUploading: false, isUploadingProcess: false));
          } catch (e) {
            emit(state.copyWith(isFileUploading: false, isUploadingProcess: false));
          }
        }
      } else if (event is _createSubUserEvent) {
        emit(state.copyWith(isLoading: true));

        try {
          SubUserReqModel req = SubUserReqModel(
            israelId: state.israelIdController.text.trim(),
            contactName: state.nameController.text.trim(),
            clientId: preferences.getUserId(),
            email: state.emailController.text.trim(),
            phoneNumber: state.phoneNumberController.text.trim(),
            profileImage: state.subUserProfileImage,
          );
          Map<String, dynamic> subUserReqModel = req.toJson();

          subUserReqModel.removeWhere((key, value) {
            if (value != null) {}
            return value == null;
          });

          final res = await DioClient(event.context).post(
            AppUrlEndPoints.createSubUserUrl,
            data: req,
          );

          SubUserResModel response = SubUserResModel.fromJson(res);
          if (response.status == AppConstants.code_200) {
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
              type: SnackBarType.success,
            );
            emit(
              state.copyWith(isLoading: false, isEnable: true, subUserId: response.data?.id ?? ''),
            );
          } else {
            emit(state.copyWith(isLoading: false));
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
              type: SnackBarType.failure,
            );
          }
        } on ServerException {
          emit(state.copyWith(isLoading: false));
        } catch (e) {
          emit(state.copyWith(isLoading: false));
        }
      } else if (event is _deleteAccountEvent) {
        emit(state.copyWith(isDeleteProcess: true));
        try {
          SubUserDeleteReqModel req = SubUserDeleteReqModel(
            clientId: preferences.getUserId(),
            ids: [state.subUserId],
          );

          final res = await DioClient(event.context).post(AppUrlEndPoints.deleteClientSubUserUrl, data: req);

          if (res[AppStrings.statusString] == AppConstants.code_200) {
            emit(state.copyWith(isDeleteProcess: false));
            Navigator.pop(event.dialogContext);
            Navigator.pushNamed(event.context, RouteDefine.subUsersScreen.name);
            CustomSnackBar.showSnackBar(context: event.context, title: AppLocalizations.of(event.context)!.success_message, type: SnackBarType.success);
          } else {
            emit(state.copyWith(isDeleteProcess: false));
          }
        } on ServerException {
          emit(state.copyWith(isDeleteProcess: false));
        } catch (e) {
          emit(state.copyWith(isDeleteProcess: false));
          CustomSnackBar.showSnackBar(context: event.context, title: e.toString(), type: SnackBarType.failure);
        }
      } else if (event is _updateSubUserEvent) {
        try {
          emit(state.copyWith(isLoading: true));

          PackageInfo packageInfo = await PackageInfo.fromPlatform();
          String version = packageInfo.version;

          UpdateSubUserReqModel req = UpdateSubUserReqModel(
            id: state.subUserId,
            email: state.emailController.text,
            israelId: state.israelIdController.text,
            contactName: state.nameController.text,
            phoneNumber: state.phoneNumberController.text,
            profileImage: state.subUserProfileImage,
            applicationVersion: version,
            deviceType: Platform.isAndroid ? AppStrings.androidString : AppStrings.iosString,
            lastSeen: DateTime.now(),
          );

          Map<String, dynamic> updateSubUserReq = req.toJson();

          updateSubUserReq.removeWhere((key, value) {
            if (value != null) {}
            return value == null;
          });

          final response = await DioClient(event.context).put(path: AppUrlEndPoints.updateSubUserUrl, data: updateSubUserReq);

          if (response[AppStrings.statusString] == AppConstants.code_200) {
            emit(state.copyWith(isLoading: false));
            CustomSnackBar.showSnackBar(context: event.context, title: AppLocalizations.of(event.context)!.success_message, type: SnackBarType.success);
          } else {
            emit(state.copyWith(isLoading: false));
          }
        } on ServerException {
          emit(state.copyWith(isLoading: false));
        } catch (e) {
          emit(state.copyWith(isLoading: false));
        }
      } else if (event is _deleteFileEvent) {
        try {
          if (state.subUserProfileImage.isEmpty) {
            return;
          } else if (state.subUserProfileImage.contains(AppStrings.tempString)) {
            emit(state.copyWith(subUserProfileImage: '', image: File('')));
            await preferences.removeProfileImage();
            CustomSnackBar.showSnackBar(context: event.context, title: AppLocalizations.of(event.context)!.removed_successfully, type: SnackBarType.success);
            return;
          }
          emit(state.copyWith(isFileUploading: true));
          UpdateSubUserReqModel updatedSubUserModel = UpdateSubUserReqModel(
            profileImage: '',
            id: state.subUserId,
          );
          Map<String, dynamic> req = updatedSubUserModel.toJson();

          req.removeWhere((key, value) {
            if (value != null) {}
            return value == null;
          });
          final res = await DioClient(event.context).post(
            AppUrlEndPoints.updateSubUserUrl,
            data: req,
          );

          if (res[AppStrings.statusString] == AppConstants.code_200) {
            emit(state.copyWith(isFileUploading: false));
            emit(state.copyWith(subUserProfileImage: '', image: File('')));
            CustomSnackBar.showSnackBar(context: event.context, title: AppLocalizations.of(event.context)!.removed_successfully, type: SnackBarType.success);
          } else {
            emit(state.copyWith(isFileUploading: false));
          }
        } catch (e) {
          emit(state.copyWith(isFileUploading: false));
          CustomSnackBar.showSnackBar(
            context: event.context,
            title: AppLocalizations.of(event.context)!.something_is_wrong_try_again,
            type: SnackBarType.failure,
          );
        }
      } else if (event is _getSubUserByIdEvent) {
        emit(state.copyWith(
          isUpdate: event.isUpdate,
          subUserId: event.subUserId,
          isEnable: event.isUpdate ? true : false,
        ));
        if (event.isUpdate) {
          try {
            emit(state.copyWith(isShimmering: true));

            GetSubUserReqModel req = GetSubUserReqModel(clientId: preferences.getUserId(), subuserId: event.subUserId);

            Map<String, dynamic> getSubUserReq = req.toJson();

            getSubUserReq.removeWhere((key, value) {
              if (value != null) {}
              return value == null;
            });

            final res = await DioClient(event.context).post(
              AppUrlEndPoints.getAllSubUserUrl,
              data: getSubUserReq,
            );

            GetSubUserResModel response = GetSubUserResModel.fromJson(res);

            if (response.status == AppConstants.code_200) {
              emit(state.copyWith(
                emailController: TextEditingController(text: response.data?.users?.first.email ?? ''),
                phoneNumberController: TextEditingController(text: response.data?.users?.first.phoneNumber ?? ''),
                nameController: TextEditingController(text: response.data?.users?.first.contactName ?? ''),
                israelIdController: TextEditingController(text: response.data?.users?.first.israelId ?? ''),
                subUserProfileImage: response.data?.users?.first.profileImage ?? '',
                isShimmering: false,
              ));
            } else {
              emit(state.copyWith(isShimmering: false));
              CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
                type: SnackBarType.failure,
              );
            }
          } on ServerException {
            emit(state.copyWith(isShimmering: false));
          } catch (e) {
            emit(state.copyWith(isShimmering: false));
          }
        }
      }
    });
  }
}
