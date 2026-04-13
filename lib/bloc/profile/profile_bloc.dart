import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smartlook/flutter_smartlook.dart';
import '../../data/model/req_model/profile_details_req_model/profile_details_req_model.dart' as req;
import '../../data/model/res_model/business_type_model/business_type_model.dart';
import '../../data/model/res_model/profile_details_res_model/profile_details_res_model.dart' as resGet;
import '../../data/model/res_model/profile_details_update_res_model/profile_details_update_res_model.dart' as reqUpdate;
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/utils/constants/app_urls.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/req_model/profile_req_model/profile_model.dart';
import '../../data/model/res_model/file_upload_model/file_upload_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/constants/app_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'profile_bloc.freezed.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileModel profileModel = const ProfileModel();
  String imgUrl = '';
  String mobileNo = '';

  ProfileBloc() : super(ProfileState.initial()) {
    on<ProfileEvent>((event, emit) async {
      SharedPreferencesHelper preferences = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

      if (event is _pickProfileImageEvent) {
        final pickedFile = await ImagePicker().pickImage(source: event.isFromCamera ? ImageSource.camera : ImageSource.gallery);
        if (pickedFile != null) {
          CroppedFile? croppedImage = await cropImage(path: pickedFile.path, shape: CropStyle.circle, quality: AppConstants.fileQuality);
          if (croppedImage?.path.isEmpty ?? true) {
            return;
          }
          String imageSize = getFileSizeString(bytes: croppedImage?.path.isNotEmpty ?? false ? await File(croppedImage!.path).length() : await pickedFile.length());

          if (int.parse(imageSize.split(' ').first) == 0) {
            return;
          }
          try {
            emit(state.copyWith(isFileUploading: true, isUploadingProcess: true));
            final response = await DioClient(event.context).uploadFileProgressWithFormData(
              path: AppUrlEndPoints.fileUploadUrl,
              formData: FormData.fromMap(
                {AppStrings.profileImageString: await MultipartFile.fromFile(croppedImage?.path ?? pickedFile.path, contentType: MediaType('image', 'png'))},
              ),
            );
            FileUploadModel profileImageModel = FileUploadModel.fromJson(response);
            if (profileImageModel.filepath != '') {
              imgUrl = profileImageModel.filepath ?? '';
              emit(state.copyWith(
                isUploadingProcess: false,
                isFileUploading: false,
                image: File(croppedImage?.path ?? pickedFile.path),
                UserImageUrl: profileImageModel.filepath ?? '',
              ));
            }
          } on ServerException {
            emit(state.copyWith(isFileUploading: false, isUploadingProcess: false));
            CustomSnackBar.showSnackBar(context: event.context, title: AppLocalizations.of(event.context)!.please_enter_email, type: SnackBarType.failure);
          } catch (e) {
            emit(state.copyWith(isFileUploading: false, isUploadingProcess: false));
          }
        }
      } else if (event is _DeleteAccountEvent) {
        try {
          final res = await DioClient(event.context).post('${AppUrlEndPoints.deleteAccountUrl}${state.userId}');
          if (res[AppStrings.statusString] == AppConstants.code_200) {
            final response = await DioClient(event.context).put(path: AppUrlEndPoints.logOutUrl, data: {"userId": preferences.getUserId()});
            if (response[AppStrings.statusString] == AppConstants.code_200) {
              await preferences.setUserLoggedIn();
              Navigator.pop(event.context);
              Navigator.popUntil(event.context, (route) => route.name == RouteDefine.bottomNavScreen.name);
              Navigator.pushNamed(event.context, RouteDefine.connectScreen.name);
            } else {
              CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(response[AppStrings.messageString].toString().toLocalization(), event.context),
                type: SnackBarType.success,
              );
              emit(state.copyWith());
            }
          }
        } on ServerException {
          emit(state.copyWith());
        }
      } else if (event is _getBusinessTypeListEvent) {
        try {
          emit(state.copyWith(isShimmering: true, language: preferences.getAppLanguage()));
          final res = await DioClient(event.context).get(path: AppUrlEndPoints.businessTypesUrl);
          BusinessTypeModel response = BusinessTypeModel.fromJson(res);
          List<ClientType> list = [];
          list.add(ClientType(businessType: AppLocalizations.of(event.context)!.type_of_business));
          list.addAll(response.data?.clientTypes ?? []);
          if (response.status == AppConstants.code_200) {
            emit(state.copyWith(isShimmering: false, businessTypeList: list, selectedBusinessType: list.elementAt(0).businessType ?? ''));
          }
        } catch (e) {
          emit(state.copyWith(isShimmering: false));
        }
      } else if (event is _ChangeBusinessTypeEventEvent) {
        emit(state.copyWith(selectedBusinessType: event.newBusinessType));
      } else if (event is _navigateToMoreDetailsScreenEvent) {
        preferences.setBusinessName(businessName: state.businessNameController.text.trim());
        profileModel = ProfileModel(
          phoneNumber: mobileNo.trim(),
          profileImage: state.UserImageUrl,
          clientDetail: ClientDetail(
            ownerName: '${state.ownerFirstNameController.text.toString()} ${state.ownerLastNameController.text.toString()}',
            bussinessId: int.tryParse(state.businessIdController.text) ?? 0,
            bussinessName: state.businessNameController.text.toString(),
            ownerFirstName: state.ownerFirstNameController.text.toString(),
            ownerLastName: state.ownerLastNameController.text.toString(),
            clientTypeId: state.businessTypeList.firstWhere((businessType) => businessType.businessType == state.selectedBusinessType).id,
            israelId: state.israelIdController.text,
            deviceType: Platform.isAndroid ? AppStrings.androidString : AppStrings.iosString,
          ),
          contactName: state.contactController.text.trim(),
        );
        Navigator.pushNamed(event.context, RouteDefine.moreDetailsScreen.name, arguments: {AppStrings.profileParamString: profileModel});
      } else if (event is _getProfileDetailsEvent) {
        mobileNo = event.mobileNo;
        emit(state.copyWith(isUpdate: event.isUpdate));
        if (state.isUpdate) {
          emit(state.copyWith(isUpdating: true));
          try {
            final res = await DioClient(event.context).post(AppUrlEndPoints.getProfileDetailsUrl, data: req.ProfileDetailsReqModel(id: preferences.getUserId()).toJson());
            resGet.ProfileDetailsResModel response = resGet.ProfileDetailsResModel.fromJson(res);
            if (response.status == AppConstants.code_200) {
              String? businessName = await Smartlook.instance.user.properties.getString(AppStrings.userBusinessName);

              if (businessName == '' || businessName == null) {
                Smartlook.instance.user.properties.putString(AppStrings.userBusinessName, value: response.data?.clients?.first.clientDetail?.bussinessName);
              }

              Smartlook.instance.user.setName(response.data?.clients?.first.clientDetail?.ownerName ?? '');
              preferences.setPaymentMethodCount(count: response.data?.clients?.first.clientDetail?.availablePaymentTypes.length.toString() ?? '0');
              preferences.setPaymentMethod(method: response.data?.clients?.first.clientDetail?.paymentType ?? '');
              preferences.setPaymentMethodTypes(methods: response.data?.clients?.first.clientDetail?.availablePaymentTypes ?? []);
              preferences.setAvailableAllPayment(isAvailableAllPayment: response.data?.clients?.first.clientDetail?.isAvailableAllPayments ?? false);

              emit(
                state.copyWith(
                  isShimmering: false,
                  userId: response.data?.clients?.first.id ?? '',
                  isUpdating: false,
                  UserImageUrl: response.data?.clients?.first.profileImage ?? '',
                  selectedBusinessType: state.businessTypeList.firstWhere((businessType) => businessType.id == response.data?.clients?.first.clientDetail?.clientTypeId).businessType ?? state.selectedBusinessType,
                  businessNameController: TextEditingController(text: response.data?.clients?.first.clientDetail?.bussinessName),
                  businessIdController: TextEditingController(text: response.data?.clients?.first.clientDetail?.bussinessId.toString()),
                  ownerFirstNameController: TextEditingController(text: response.data?.clients?.first.clientDetail?.ownerName),
                  ownerLastNameController: TextEditingController(text: response.data?.clients?.first.clientDetail?.ownerName),
                  israelIdController: TextEditingController(text: response.data?.clients?.first.clientDetail?.israelId.toString()),
                  contactController: TextEditingController(text: response.data?.clients?.first.contactName),
                ),
              );
            } else {
              emit(state.copyWith(isUpdating: false));
              CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
                type: SnackBarType.failure,
              );
            }
          } on ServerException {
            emit(state.copyWith(isUpdating: false));
          } catch (e) {
            emit(state.copyWith(isUpdating: false));
          }
        }
      } else if (event is _updateProfileDetailsEvent) {
        ProfileModel updatedProfileModel = ProfileModel(
          profileImage: state.image.path != '' ? imgUrl : state.UserImageUrl,
          contactName: state.contactController.text,
          clientDetail: ClientDetail(
            clientTypeId: state.businessTypeList.firstWhere((businessType) => businessType.businessType == state.selectedBusinessType).id,
            bussinessId: int.tryParse(state.businessIdController.text) ?? 0,
            bussinessName: state.businessNameController.text,
            ownerName: '${state.ownerFirstNameController.text.toString()} ${state.ownerLastNameController.text.toString()}',
            ownerFirstName: state.ownerFirstNameController.text,
            ownerLastName: state.ownerLastNameController.text,
            israelId: state.israelIdController.text,
          ),
        );
        Map<String, dynamic> req = updatedProfileModel.toJson();
        Map<String, dynamic>? clientDetail = updatedProfileModel.clientDetail?.toJson();
        clientDetail?.removeWhere((key, value) {
          if (value != null) {}
          return value == null;
        });
        req[AppStrings.clientDetailString] = clientDetail;
        req.removeWhere((key, value) {
          if (value != null) {}
          return value == null;
        });
        try {
          emit(state.copyWith(isLoading: true));
          final res = await DioClient(event.context).post("${AppUrlEndPoints.updateProfileDetailsUrl}/${preferences.getUserId()}", data: req);

          reqUpdate.ProfileDetailsUpdateResModel response = reqUpdate.ProfileDetailsUpdateResModel.fromJson(res);
          if (response.status == AppConstants.code_200) {
            emit(state.copyWith(UserImageUrl: response.data?.client?.profileImage.toString() ?? ''));

            if (!preferences.getSubUser()) {
              preferences.setUserName(name: state.ownerFirstNameController.text + state.ownerLastNameController.text);
              preferences.setUserImageUrl(imageUrl: response.data?.client?.profileImage.toString() ?? '');
              emit(state.copyWith(UserImageUrl: response.data?.client?.profileImage.toString() ?? ''));
            }

            emit(state.copyWith(isLoading: false));
            Navigator.pop(event.context);
            CustomSnackBar.showSnackBar(context: event.context, title: AppLocalizations.of(event.context)!.updated_successfully, type: SnackBarType.success);
          } else {
            emit(state.copyWith(isLoading: false));
            if (response.message == AppStrings.rivchitClientErrorString) {
              CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppLocalizations.of(event.context)!.israel_id_or_business_id_number_error,
                type: SnackBarType.failure,
              );
            } else {
              CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
                type: SnackBarType.failure,
              );
            }
          }
        } on ServerException {
          emit(state.copyWith(isLoading: false));
        }
      } else if (event is _deleteFileEvent) {
        try {
          if (state.UserImageUrl.isEmpty) {
            return;
          } else if (state.UserImageUrl.contains(AppStrings.tempString)) {
            emit(state.copyWith(UserImageUrl: '', image: File('')));
            await preferences.removeProfileImage();
            CustomSnackBar.showSnackBar(context: event.context, title: AppLocalizations.of(event.context)!.removed_successfully, type: SnackBarType.success);
            return;
          }
          emit(state.copyWith(isFileUploading: true));
          ProfileModel updatedProfileModel = const ProfileModel(profileImage: '', clientDetail: ClientDetail());
          Map<String, dynamic> req = updatedProfileModel.toJson();
          Map<String, dynamic>? clientDetail = updatedProfileModel.clientDetail?.toJson();
          clientDetail?.removeWhere((key, value) {
            if (value != null) {}
            return value == null;
          });
          req[AppStrings.clientDetailString] = clientDetail;
          req.removeWhere((key, value) {
            if (value != null) {}
            return value == null;
          });
          final res = await DioClient(event.context).post("${AppUrlEndPoints.updateProfileDetailsUrl}/${preferences.getUserId()}", data: req);
          reqUpdate.ProfileDetailsUpdateResModel response = reqUpdate.ProfileDetailsUpdateResModel.fromJson(res);
          if (response.status == AppConstants.code_200) {
            await preferences.removeProfileImage();
            emit(state.copyWith(isFileUploading: false));
            emit(state.copyWith(UserImageUrl: '', image: File('')));
            CustomSnackBar.showSnackBar(context: event.context, title: AppLocalizations.of(event.context)!.removed_successfully, type: SnackBarType.success);
          } else {
            emit(state.copyWith(isFileUploading: false));
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
              type: SnackBarType.failure,
            );
          }
        } catch (e) {
          emit(state.copyWith(isFileUploading: false));
        }
      }
    });
  }
}
