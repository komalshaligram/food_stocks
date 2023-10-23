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
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/req_model/profile_req_model/profile_model.dart';
import '../../data/model/res_model/file_update_res_model/file_update_res_model.dart' as file;
import '../../data/model/res_model/file_upload_model/file_upload_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/themes/app_constants.dart';

part 'profile_bloc.freezed.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileModel profileModel = ProfileModel();
  String imgUrl = '';
  String mobileNo = '';

  ProfileBloc() : super(ProfileState.initial()) {
    on<ProfileEvent>((event, emit) async {
      SharedPreferencesHelper preferencesHelper =
          SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

      if (event is _pickProfileImageEvent) {
        final pickedFile = await ImagePicker().pickImage(
            source:
                event.isFromCamera ? ImageSource.camera : ImageSource.gallery);
        if (pickedFile != null) {
          debugPrint("compress after size = ${await pickedFile.length()}");
          Directory? dir;
          if (defaultTargetPlatform == TargetPlatform.android) {
            dir = await getApplicationDocumentsDirectory();
          } else {
            dir = await getApplicationDocumentsDirectory();
          }
          CroppedFile? croppedImage = await cropImage(
              path: pickedFile.path,
              shape: CropStyle.circle,
              quality: AppConstants.fileQuality);
          String imageSize = getFileSizeString(
              bytes: croppedImage?.path.isNotEmpty ?? false
                  ? await File(croppedImage!.path).length()
                  : 0);
          debugPrint('data1 final size = ${imageSize}');

          if (int.parse(imageSize.split(' ').first) == 0) {
            return;
          }
          if (int.parse(imageSize.split(' ').first) <=
                  AppConstants.fileSizeCap &&
              imageSize.split(' ').last == 'KB') {
            try {
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
                    image: File(croppedImage?.path ?? pickedFile.path),
                    UserImageUrl: profileImageModel.filepath ?? ''));
              }
            } on ServerException {
              showSnackBar(
                  context: event.context,
                  title: AppStrings.imageNotSetString,
                  bgColor: AppColors.redColor);
            }
          } else {
            emit(state.copyWith(isFileSizeExceeds: true));
            emit(state.copyWith(isFileSizeExceeds: false));
            // showSnackBar(
            //     context: event.context,
            //     title: AppStrings.fileSizeLimit500KBString,
            //     bgColor: AppColors.redColor);
          }
        }
      } else if (event is _getBusinessTypeListEvent) {
        try {
          final res = await DioClient(event.context)
              .get(path: AppUrls.businessTypesUrl);
          debugPrint('business type list res = $res');
          BusinessTypeModel response = BusinessTypeModel.fromJson(res);
          emit(state.copyWith(
              businessTypeList: response,
              selectedBusinessType:
                  response.data?.clientTypes?[0].businessType ?? ''));
        } on ServerException {
          showSnackBar(
              context: event.context,
              title: AppStrings.somethingWrongString,
              bgColor: AppColors.mainColor);
        }
      } else if (event is _ChangeBusinessTypeEventEvent) {
        emit(state.copyWith(selectedBusinessType: event.newBusinessType));
      } else if (event is _navigateToMoreDetailsScreenEvent) {
        profileModel = ProfileModel(
          phoneNumber: mobileNo,
          profileImage: state.UserImageUrl,
          clientDetail: ClientDetail(
            bussinessId: int.tryParse(state.idController.text) ?? 0,
            bussinessName: state.businessNameController.text,
            ownerName: state.ownerNameController.text,
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
          contactName: state.contactController.text,
        );
        Navigator.pushNamed(event.context, RouteDefine.moreDetailsScreen.name,
            arguments: {AppStrings.profileParamString: profileModel});
      } else if (event is _getProfileDetailsEvent) {
        mobileNo = event.mobileNo;
        emit(state.copyWith(isUpdate: event.isUpdate));
        if (state.isUpdate) {
          try {
            debugPrint('mobile = ${preferencesHelper.getUserId()}');
            // emit(state.copyWith(UserImageUrl: preferences.getUserImageUrl()));
            final res = await DioClient(event.context).post(
                AppUrls.getProfileDetailsUrl,
                data: req.ProfileDetailsReqModel(id: preferencesHelper.getUserId())
                    .toJson());
            resGet.ProfileDetailsResModel response =
                resGet.ProfileDetailsResModel.fromJson(res);
            if (response.status == 200) {
              debugPrint('image = ${response.data?.clients?.first.profileImage}');
              emit(
                state.copyWith(UserImageUrl: response.data?.clients?.first.profileImage ?? '',
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
              showSnackBar(
                  context: event.context,
                  title: response.message ?? AppStrings.somethingWrongString,
                  bgColor: AppColors.redColor);
            }
          } on ServerException {
            // showSnackBar(
            //     context: event.context,
            //     title: AppStrings.somethingWrongString,
            //     bgColor: AppColors.redColor);
          }
        }
      } else if (event is _updateProfileDetailsEvent) {
        if(state.image.path != ''){
          Map<String, dynamic> req1 = {
           AppStrings.profileUpdateString : imgUrl
          };
          try{
            final res = await DioClient(event.context).post(
              "${AppUrls.fileUpdateUrl}/${preferencesHelper.getUserId()}",
              data: req1,
            );
            debugPrint('update profile image req_______${req1}');
            file.FileUpdateResModel response = file.FileUpdateResModel.fromJson(res);

            if(response.status == 200){
              preferencesHelper.removeProfileImage();
              preferencesHelper.setUserImageUrl(imageUrl: response.data!.client!.profileImage.toString());
              debugPrint('update profile image req________${response}');
              imgUrl = response.data!.client!.profileImage.toString();
            }
            else{
              showSnackBar(
                  context: event.context,
                  title: AppStrings.somethingWrongString,
                  bgColor: AppColors.redColor);

            }
          }
          on ServerException {
            showSnackBar(
                context: event.context,
                title: AppStrings.somethingWrongString,
                bgColor: AppColors.redColor);
          }
        }

        ProfileModel updatedProfileModel = ProfileModel(
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
              AppUrls.updateProfileDetailsUrl + "/" + preferencesHelper.getUserId(),
              data: /*updatedProfileModel.toJson()*/ req);

          reqUpdate.ProfileDetailsUpdateResModel response =
              reqUpdate.ProfileDetailsUpdateResModel.fromJson(res);
          if (response.status == 200) {
            emit(state.copyWith(isLoading: false));
            showSnackBar(
                context: event.context,
                title: AppStrings.updateSuccessString,
                bgColor: AppColors.mainColor);
            Navigator.pop(event.context);
          } else {
            emit(state.copyWith(isLoading: false));
            showSnackBar(
                context: event.context,
                title: response.message ?? AppStrings.somethingWrongString,
                bgColor: AppColors.redColor);
          }
        } on ServerException {
          emit(state.copyWith(isLoading: false));
          showSnackBar(
              context: event.context,
              title: AppStrings.somethingWrongString,
              bgColor: AppColors.redColor);
        }
      }
    });
  }
}
