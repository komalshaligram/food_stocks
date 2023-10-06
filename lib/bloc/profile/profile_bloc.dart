import 'dart:io';
import 'package:dio/dio.dart';
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
import '../../data/error/exceptions.dart';
import '../../data/model/req_model/profile_req_model/profile_model.dart';
import '../../data/model/res_model/file_upload_model/file_upload_model.dart';
import '../../repository/dio_client.dart';
import '../../routes/app_routes.dart';

part 'profile_bloc.freezed.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileModel profileModel = ProfileModel();
  String imgUrl = '';
  String mobileNo = '';

  ProfileBloc() : super(ProfileState.initial()) {
    on<ProfileEvent>((event, emit) async {
      if (event is _pickProfileImageEvent) {
        final pickedFile = await ImagePicker().pickImage(
            source:
                event.isFromCamera ? ImageSource.camera : ImageSource.gallery);
        if (pickedFile != null) {
          CroppedFile? croppedImage = await cropImage(
              path: pickedFile.path, shape: CropStyle.circle, quality: 100);
          String imageSize = getFileSizeString(
              bytes:
                  await File(croppedImage?.path ?? pickedFile.path).length());
          if (int.parse(imageSize.split(' ').first) <= 500 &&
              imageSize.split(' ').last == 'KB') {
            try {
              final response = await DioClient().uploadFileProgressWithFormData(
                path: AppUrls.FileUploadUrl,
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
              debugPrint('img url = ${profileImageModel.profileImgFileName}');
              if (profileImageModel.profileImgFileName != '') {
                imgUrl = profileImageModel.profileImgFileName ?? '';
              }
              emit(state.copyWith(
                  image: File(croppedImage?.path ?? pickedFile.path)));
            } on ServerException {
              showSnackBar(
                  context: event.context,
                  title: AppStrings.imageNotSetString,
                  bgColor: AppColors.redColor);
            }
          } else {
            showSnackBar(
                context: event.context,
                title: AppStrings.fileSizeLimit500KBString,
                bgColor: AppColors.redColor);
          }
        }
      } else if (event is _getBusinessTypeListEvent) {
        try {
          final res = await DioClient().get(path: AppUrls.businessTypesUrl,context: event.context);
          BusinessTypeModel response = BusinessTypeModel.fromJson(res);
          emit(state.copyWith(
              businessTypeList: response,
              selectedBusinessType:
                  response.data?.ClientTypes?[0].businessType ?? ''));
        } on ServerException {
          showSnackBar(
              context: event.context,
              title: AppStrings.somethingWrongString,
              bgColor: AppColors.mainColor);
        }
      } else if (event is _navigateToMoreDetailsScreenEvent) {
        profileModel = ProfileModel(
            address: '',
            cityId: '60abf964173234001c903a05',
            email: '',
            logo: '',
            phoneNumber: mobileNo,
            profileImage: imgUrl,
            clientDetail: ClientDetail(
              bussinessId: int.tryParse(state.idController.text) ?? 0,
              bussinessName: state.businessNameController.text,
              ownerName: state.ownerNameController.text,
              applicationVersion: '1.0.0',
              deviceType: Platform.isAndroid
                  ? AppStrings.androidString
                  : AppStrings.iosString,
              fax: '',
              israelId: true,
              lastSeen: DateTime.now(),
              operationTime: OperationTime(),
              tokenId: '60abf964173234001c903a05',

            ),
            contactName: state.contactController.text);
        Navigator.pushNamed(event.context, RouteDefine.moreDetailsScreen.name,
            arguments: {AppStrings.profileParamString: profileModel});
      } else if (event is _getProfileDetailsEvent) {
        mobileNo = event.mobileNo;
        emit(state.copyWith(isUpdate: event.isUpdate));
        if (state.isUpdate) {
          try {
            final res = await DioClient().post(AppUrls.getProfileDetailsUrl,
                data: req.ProfileDetailsReqModel(id: "651bb2f9d2c8a6d5b1c1ff84")
                    .toJson());
            resGet.ProfileDetailsResModel response =
                resGet.ProfileDetailsResModel.fromJson(res);
            if (response.status == 200) {
              emit(
                state.copyWith(
                  selectedBusinessType: response.data?.clients?.first
                          .clientDetail?.clientTypes?.first.businessType ??
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
            showSnackBar(
                context: event.context,
                title: AppStrings.somethingWrongString,
                bgColor: AppColors.redColor);
          }
        }
      } else if (event is _updateProfileDetailsEvent) {
        ProfileModel updatedProfileModel = ProfileModel(
          contactName: state.contactController.text,
          clientDetail: ClientDetail(
            clientTypeId: state.businessTypeList.data?.ClientTypes
                ?.firstWhere((businessType) =>
                    businessType.businessType == state.selectedBusinessType)
                .id,
            bussinessId: int.tryParse(state.idController.text) ?? 0,
            bussinessName: state.businessNameController.text,
            ownerName: state.ownerNameController.text,
          ),
        );
        try {
          final res = await DioClient().put(
              path:
                  AppUrls.updateProfileDetailsUrl + "/651bb2f9d2c8a6d5b1c1ff84",
              data: updatedProfileModel.toJson());

          reqUpdate.ProfileDetailsUpdateResModel response =
              reqUpdate.ProfileDetailsUpdateResModel.fromJson(res);
          if (response.status == 200) {
            showSnackBar(
                context: event.context,
                title: AppStrings.updateSuccessString,
                bgColor: AppColors.redColor);
            Navigator.pop(event.context);
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
    });
  }
}
