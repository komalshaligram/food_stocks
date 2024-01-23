import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/data/model/req_model/profile_details_req_model/profile_details_req_model.dart'
    as req;
import 'package:food_stock/data/model/res_model/business_type_model/business_type_model.dart';
import 'package:food_stock/data/model/res_model/profile_details_res_model/profile_details_res_model.dart'
    as resGet;
import 'package:food_stock/data/model/res_model/profile_details_update_res_model/profile_details_update_res_model.dart'
    as reqUpdate;
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/req_model/profile_req_model/profile_model.dart';
import '../../data/model/req_model/remove_form_and_file_req_model/remove_form_and_file_req_model.dart';
import '../../data/model/res_model/file_update_res_model/file_update_res_model.dart'
    as file;
import '../../data/model/res_model/file_upload_model/file_upload_model.dart';
import '../../data/model/res_model/remove_form_and_file_res_model/remove_form_and_file_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/themes/app_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'profile_bloc.freezed.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileModel profileModel = ProfileModel();
  String imgUrl = '';
  String mobileNo = '';

  ProfileBloc() : super(ProfileState.initial()) {
    on<ProfileEvent>((event, emit) async {
      SharedPreferencesHelper preferences =
          SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

      if (event is _pickProfileImageEvent) {
        final pickedFile = await ImagePicker().pickImage(
            source:
                event.isFromCamera ? ImageSource.camera : ImageSource.gallery);
        if (pickedFile != null) {
          debugPrint("compress after size = ${await pickedFile.length()}");
          // Directory? dir;
          // if (defaultTargetPlatform == TargetPlatform.android) {
          //   dir = await getApplicationDocumentsDirectory();
          // } else {
          //   dir = await getApplicationDocumentsDirectory();
          // }
          CroppedFile? croppedImage = await cropImage(
              path: pickedFile.path,
              shape: CropStyle.circle,
              quality: AppConstants.fileQuality);
          if (croppedImage?.path.isEmpty ?? true) {
            return;
          }
          String imageSize = getFileSizeString(
              bytes: croppedImage?.path.isNotEmpty ?? false
                  ? await File(croppedImage!.path).length()
                  : await pickedFile.length());
          debugPrint('data1 final size = ${imageSize}');

          if (int.parse(imageSize.split(' ').first) == 0) {
            return;
          }
          if (int.parse(imageSize.split(' ').first) <=
                  AppConstants.fileSizeCap &&
              imageSize.split(' ').last == 'KB') {
            try {
              emit(state.copyWith(isFileUploading: true,isUploadingProcess: true));
              debugPrint("image1 = ${croppedImage?.path ?? pickedFile.path}");
              final response =
                  await DioClient(event.context).uploadFileProgressWithFormData(
                path: AppUrls.fileUploadUrl,
                formData: FormData.fromMap(
                  {
                    AppStrings.profileImageString: await MultipartFile.fromFile(
                        croppedImage?.path ?? pickedFile.path,
                        contentType: MediaType('image', 'png'))
                  },
                ),
              );
              FileUploadModel profileImageModel =
                  FileUploadModel.fromJson(response);
              debugPrint('img url = ${profileImageModel.filepath}');
              if (profileImageModel.filepath != '') {
                imgUrl = profileImageModel.filepath ?? '';
                debugPrint("image1 = ${imgUrl}\n${profileImageModel.filepath}");
                emit(state.copyWith(
                    isUploadingProcess: false,
                    isFileUploading: false,
                    image: File(croppedImage?.path ?? pickedFile.path),
                    UserImageUrl: profileImageModel.filepath ?? ''));
                debugPrint(
                    "image1 = ${croppedImage?.path}\n${pickedFile.path}");
                debugPrint("image1 = ${state.image}");
              }
            } on ServerException {
              emit(state.copyWith(isFileUploading: false,isUploadingProcess: false));
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title:
                      '${AppLocalizations.of(event.context)!.please_enter_email}',
                  type: SnackBarType.FAILURE);
            } catch (e) {
              emit(state.copyWith(isFileUploading: false,isUploadingProcess: false));
            }
          } else {
            emit(state.copyWith(
                isFileSizeExceeds: true, isFileUploading: false,isUploadingProcess: false));
            emit(state.copyWith(isFileSizeExceeds: false));
            // CustomSnackBar.showSnackBar(
            //     context: event.context,
            //     title: AppStrings.fileSizeLimit500KBString,
            //     type: SnackBarType.FAILURE);
          }
        }
      } else if (event is _getBusinessTypeListEvent) {
        try {
          emit(state.copyWith(isShimmering: true,language: preferences.getAppLanguage()));
          final res = await DioClient(event.context)
              .get(path: AppUrls.businessTypesUrl);
          debugPrint('business type list res = $res');
          BusinessTypeModel response = BusinessTypeModel.fromJson(res);
          if (response.status == 200) {
            emit(state.copyWith(
                isShimmering: false,
                businessTypeList: response,
                selectedBusinessType:
                    response.data?.clientTypes?[0].businessType ?? ''));
          } else {
            debugPrint('business types not found.\n${response.message}');
          }
        } on ServerException {
        } catch (e) { emit(state.copyWith(isShimmering: false));}
      } else if (event is _ChangeBusinessTypeEventEvent) {
        emit(state.copyWith(selectedBusinessType: event.newBusinessType));
      } else if (event is _navigateToMoreDetailsScreenEvent) {
        profileModel = ProfileModel(
          phoneNumber: mobileNo.trim(),
          profileImage: state.UserImageUrl,
          clientDetail: ClientDetail(
            bussinessId: int.tryParse(state.idController.text) ?? 0,
            bussinessName: state.businessNameController.text.trim(),
            ownerName: state.ownerNameController.text.trim(),
            clientTypeId: state.businessTypeList.data?.clientTypes
                ?.firstWhere((businessType) =>
                    businessType.businessType == state.selectedBusinessType)
                .id,
            // applicationVersion: '1.0.0',
            israelId: state.hpController.text,
            deviceType: Platform.isAndroid
                ? AppStrings.androidString
                : AppStrings.iosString,
          ),
          contactName: state.contactController.text.trim(),
        );
        Navigator.pushNamed(event.context, RouteDefine.moreDetailsScreen.name,
            arguments: {AppStrings.profileParamString: profileModel});
      }
      else if (event is _getProfileDetailsEvent) {
        mobileNo = event.mobileNo;
        emit(state.copyWith(isUpdate: event.isUpdate));
        if (state.isUpdate) {
          emit(state.copyWith(isUpdating: true));
          try {
            debugPrint('req = ${preferences.getUserId()}');
            final res = await DioClient(event.context).post(
                AppUrls.getProfileDetailsUrl,
                data: req.ProfileDetailsReqModel(id: preferences.getUserId())
                    .toJson(),
                options: Options(
                  headers: {
                    HttpHeaders.authorizationHeader:
                        'Bearer ${preferences.getAuthToken()}',
                  },
                ));
            debugPrint('res = ${res}');
            resGet.ProfileDetailsResModel response =
                resGet.ProfileDetailsResModel.fromJson(res);
            if (response.status == 200) {
              debugPrint(
                  'image = ${response.data?.clients?.first.profileImage}');
              emit(
                state.copyWith(
                  isUpdating: false,
                  UserImageUrl:
                      response.data?.clients?.first.profileImage ?? '',
                  selectedBusinessType: state.businessTypeList.data?.clientTypes
                          ?.firstWhere((businessType) =>
                              businessType.id ==
                              response.data?.clients?.first.clientDetail
                                  ?.clientTypeId)
                          .businessType ??
                      state.selectedBusinessType,
                  businessNameController: TextEditingController(
                      text: response
                          .data?.clients?.first.clientDetail?.bussinessName),
                  hpController: TextEditingController(
                      text:
                          response.data?.clients?.first.clientDetail?.israelId),
                  ownerNameController: TextEditingController(
                      text: response
                          .data?.clients?.first.clientDetail?.ownerName),
                  idController: TextEditingController(
                      text: response
                          .data?.clients?.first.clientDetail?.bussinessId
                          .toString()),
                  contactController: TextEditingController(
                      text: response.data?.clients?.first.contactName),
                ),
              );
            } else {
              emit(state.copyWith(isUpdating: false));
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppStrings.getLocalizedStrings(
                      response.message?.toLocalization() ??
                          'something_is_wrong_try_again',
                      event.context),
                  type: SnackBarType.FAILURE);
            }
          } on ServerException {
            emit(state.copyWith(isUpdating: false));
          } catch (e) {
            emit(state.copyWith(isUpdating: false));
          }
        }
      } else if (event is _updateProfileDetailsEvent) {
        /* if (state.image.path != '') {
          Map<String, dynamic> req1 = {AppStrings.profileUpdateString: imgUrl};
          try {
            final res = await DioClient(event.context).post(
              "${AppUrls.fileUpdateUrl}/${preferences.getUserId()}",
              data: req1,
            );
            debugPrint('update profile image req_______${req1}');
            file.FileUpdateResModel response =
                file.FileUpdateResModel.fromJson(res);

            if (response.status == 200) {
              preferences.setUserImageUrl(
                  imageUrl: response.data!.client!.profileImage.toString());
              debugPrint('update profile image req________${response}');
              imgUrl = response.data!.client!.profileImage.toString();
            } else {
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppStrings.getLocalizedStrings(
                      response.message?.toLocalization() ??
                          'something_is_wrong_try_again',
                      event.context),
                  type: SnackBarType.FAILURE);
              return;
            }
          } on ServerException {
            CustomSnackBar.showSnackBar(
                context: event.context,
                title:
                    '${AppLocalizations.of(event.context)!.something_is_wrong_try_again}',
                type: SnackBarType.FAILURE);
            return;
          } catch (e) {
            CustomSnackBar.showSnackBar(
                context: event.context,
                title:
                    '${AppLocalizations.of(event.context)!.something_is_wrong_try_again}',
                type: SnackBarType.FAILURE);
            return;
          }
        }*/

        debugPrint('imageurl_____$imgUrl');
        ProfileModel updatedProfileModel = ProfileModel(
          profileImage: state.image.path != '' ? imgUrl : state.UserImageUrl,
          contactName: state.contactController.text,
          clientDetail: ClientDetail(
            clientTypeId: state.businessTypeList.data?.clientTypes
                ?.firstWhere((businessType) =>
                    businessType.businessType == state.selectedBusinessType)
                .id,
            bussinessId: int.tryParse(state.idController.text) ?? 0,
            bussinessName: state.businessNameController.text,
            ownerName: state.ownerNameController.text,
            israelId: state.hpController.text,
          ),
        );
        Map<String, dynamic> req = updatedProfileModel.toJson();
        Map<String, dynamic>? clientDetail =
            updatedProfileModel.clientDetail?.toJson();
        debugPrint("update before Model = ${req}");
        clientDetail?.removeWhere((key, value) {
          if (value != null) {
            debugPrint("[$key] = $value");
          }
          return value == null;
        });
        req[AppStrings.clientDetailString] = clientDetail;
        req.removeWhere((key, value) {
          if (value != null) {
            debugPrint("[$key] = $value");
          }
          return value == null;
        });
        try {
          debugPrint('profile req = ${/*updatedProfileModel.toJson()*/ req}');
          emit(state.copyWith(isLoading: true));
          final res = await DioClient(event.context).post(
              AppUrls.updateProfileDetailsUrl + "/" + preferences.getUserId(),
              data: /*updatedProfileModel.toJson()*/ req,
              options: Options(
                headers: {
                  HttpHeaders.authorizationHeader:
                      'Bearer ${preferences.getAuthToken()}',
                },
              ));

          reqUpdate.ProfileDetailsUpdateResModel response =
              reqUpdate.ProfileDetailsUpdateResModel.fromJson(res);
          if (response.status == 200) {
            await preferences.setUserName(name: state.ownerNameController.text);
            preferences.setUserImageUrl(
                imageUrl: response.data?.client?.profileImage.toString() ?? '');
            emit(state.copyWith(isLoading: false));
            emit(state.copyWith(UserImageUrl: response.data?.client?.profileImage.toString() ?? ''));
            Navigator.pop(event.context);
            CustomSnackBar.showSnackBar(
              context: event.context,
              title:
                  '${AppLocalizations.of(event.context)!.updated_successfully}',
              type: SnackBarType.SUCCESS,
            );
          } else {
            emit(state.copyWith(isLoading: false));
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: response.message ??
                    '${AppLocalizations.of(event.context)!.something_is_wrong_try_again}',
                type: SnackBarType.FAILURE);
          }
        } on ServerException {
          emit(state.copyWith(isLoading: false));
          CustomSnackBar.showSnackBar(
              context: event.context,
              title:
                  '${AppLocalizations.of(event.context)!.something_is_wrong_try_again}',
              type: SnackBarType.FAILURE);
        }
      } else if (event is _deleteFileEvent) {
        try {
          if (state.UserImageUrl.isEmpty) {
            return;
          } else if (state.UserImageUrl.contains(AppStrings.tempString)) {
            emit(state.copyWith(UserImageUrl: '', image: File('')));
            await preferences.removeProfileImage();
            CustomSnackBar.showSnackBar(
                context: event.context,
                title:
                    '${AppLocalizations.of(event.context)!.removed_successfully}',
                type: SnackBarType.SUCCESS);
            return;
          }
          emit(state.copyWith(isFileUploading: true));
    /*      RemoveFormAndFileReqModel reqModel =
              RemoveFormAndFileReqModel(path: state.UserImageUrl);
          debugPrint('delete file req = ${reqModel.path}');
          final res = await DioClient(event.context)
              .post(AppUrls.removeFileUrl, data: reqModel);
          RemoveFormAndFileResModel response =
              RemoveFormAndFileResModel.fromJson(res);
          debugPrint('delete file res = ${response.message}');*/

          ProfileModel updatedProfileModel = ProfileModel(
            profileImage: '',
            clientDetail: ClientDetail()
          );
          Map<String, dynamic> req = updatedProfileModel.toJson();
          Map<String, dynamic>? clientDetail =
          updatedProfileModel.clientDetail?.toJson();
          debugPrint("update before Model = ${req}");
          clientDetail?.removeWhere((key, value) {
            if (value != null) {
              debugPrint("[$key] = $value");
            }
            return value == null;
          });
          req[AppStrings.clientDetailString] = clientDetail;
          req.removeWhere((key, value) {
            if (value != null) {
              debugPrint("[$key] = $value");
            }
            return value == null;
          });
          debugPrint('profile req = ${/*updatedProfileModel.toJson()*/ req}');
          final res = await DioClient(event.context).post(
              AppUrls.updateProfileDetailsUrl + "/" + preferences.getUserId(),
              data: req,
          );
          reqUpdate.ProfileDetailsUpdateResModel response =
          reqUpdate.ProfileDetailsUpdateResModel.fromJson(res);
          if (response.status == 200) {
            await preferences.removeProfileImage();
            emit(state.copyWith(isFileUploading: false));
            emit(state.copyWith(UserImageUrl: '', image: File('')));
            CustomSnackBar.showSnackBar(
                context: event.context,
                title:
                    '${AppLocalizations.of(event.context)!.removed_successfully}',
                type: SnackBarType.SUCCESS);
          } else {
            emit(state.copyWith(isFileUploading: false));
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: response.message ??
                    '${AppLocalizations.of(event.context)!.something_is_wrong_try_again}',
                type: SnackBarType.FAILURE);
          }
        } catch (e) {
          emit(state.copyWith(isFileUploading: false));
          CustomSnackBar.showSnackBar(
              context: event.context,
              title:
                  '${AppLocalizations.of(event.context)!.something_is_wrong_try_again}',
              type: SnackBarType.FAILURE);
        }
      }
    });
  }
}
