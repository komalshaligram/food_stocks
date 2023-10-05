import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/data/model/req_model/profile_req_model/profile_model.dart';
import 'package:food_stock/data/model/res_model/file_upload_res_model/file_upload_res_model.dart';
import 'package:food_stock/data/model/req_model/profile_details_req_model/profile_details_req_model.dart'
    as req;
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/error/exceptions.dart';

import '../../data/model/res_model/profile_details_res_model/profile_details_res_model.dart'
    as resGet;
import '../../data/model/res_model/profile_details_update_res_model/profile_details_update_res_model.dart'
    as reqUpdate;
import '../../repository/dio_client.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_colors.dart';
import '../../ui/utils/themes/app_strings.dart';

part 'more_details_bloc.freezed.dart';

part 'more_details_event.dart';

part 'more_details_state.dart';

class MoreDetailsBloc extends Bloc<MoreDetailsEvent, MoreDetailsState> {
  ProfileModel profileModel = ProfileModel();
  String imgUrl = '';

  MoreDetailsBloc() : super(MoreDetailsState.initial()) {
    on<MoreDetailsEvent>((event, emit) async {
      if (event is _getProfileModelEvent) {
        if (!state.isUpdate) {
          profileModel = event.profileModel;
        }
        debugPrint('get contact name = ${profileModel.contactName}');
      } else if (event is _pickLogoImageEvent) {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(
            source:
                event.isFromCamera ? ImageSource.camera : ImageSource.gallery);
        if (pickedFile != null) {
          CroppedFile? croppedImage = await cropImage(
              path: pickedFile.path, shape: CropStyle.rectangle, quality: 100);
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
              FileUploadResModel profileImageModel =
                  FileUploadResModel.fromJson(response);
              // if (profileImageModel.profileImgFileName != '') {
              //   imgUrl = profileImageModel.profileImgFileName ?? '';
              // }
              emit(state.copyWith(
                  image: File(croppedImage?.path ?? pickedFile.path),
                  isImagePick: true));
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
      } else if (event is _navigateToOperationTimeScreenEvent) {
        if (state.isUpdate) {
          ProfileModel updatedProfileModel = ProfileModel(
            // cityId: state.selectCity,
            address: state.addressController.text,
            email: state.emailController.text,
            clientDetail: ClientDetail(fax: state.faxController.text),
            // logo: imgUrl,
          );
          try {
            final res = await DioClient().put(
                path: AppUrls.updateProfileDetailsUrl +
                    "/651bb2f9d2c8a6d5b1c1ff84",
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
        } else {
          ProfileModel newProfileModel = ProfileModel(
              //      statusId: profileModel.statusId,
              profileImage: profileModel.profileImage,
              phoneNumber: profileModel.phoneNumber,
              logo: imgUrl,
              //   lastName: '',
              //  firstName: '',
              cityId: profileModel.cityId,
              contactName: profileModel.contactName,
              address: state.addressController.text,
              email: state.emailController.text,
              clientDetail: ClientDetail(
                fax: state.faxController.text,
                applicationVersion:
                    profileModel.clientDetail?.applicationVersion,
                ownerName: profileModel.clientDetail?.ownerName,
                bussinessName: profileModel.clientDetail?.bussinessName,
                bussinessId: profileModel.clientDetail?.bussinessId,
                deviceType: profileModel.clientDetail?.deviceType,
                israelId: profileModel.clientDetail?.israelId,
                lastSeen: DateTime.now(),
                operationTime: OperationTime(),
                tokenId: profileModel.clientDetail?.tokenId,
              ));
          Navigator.pushNamed(
              event.context, RouteDefine.operationTimeScreen.name,
              arguments: {AppStrings.profileParamString: newProfileModel});
        }
      } else if (event is _addFilterListEvent) {
        emit(state.copyWith(filterList: state.cityList));
      } else if (event is _citySearchEvent) {
        List<String> list = state.cityList.where((city) => city.contains(event.search))
          .toList();
        print(list.length);
        emit(state.copyWith(
            filterList: list));
      } else if (event is _selectCityEvent) {
        emit(state.copyWith(selectCity: event.city));
      } else if (event is _getProfileMoreDetailsEvent) {
        emit(state.copyWith(isUpdate: event.isUpdate));
        if (state.isUpdate) {
          try {
            final res = await DioClient().post(AppUrls.getProfileDetailsUrl,
                data: req.ProfileDetailsReqModel(id: "651bb2f9d2c8a6d5b1c1ff84")
                    .toJson());
            resGet.ProfileDetailsResModel response =
                resGet.ProfileDetailsResModel.fromJson(res);
            debugPrint(
                'update city : ${response.data?.clients?.first.city?.cityName}');
            if (response.status == 200) {
              emit(state.copyWith(
                // selectCity: response.data?.clients?.first.city?.cityName ??
                //     state.selectCity,
                addressController: TextEditingController(
                    text: response.data?.clients?.first.address),
                emailController: TextEditingController(
                    text: response.data?.clients?.first.email),
                faxController: TextEditingController(
                    text: response.data?.clients?.first.clientDetail?.fax),
                // image: File(response.data?.clients?.first.logo ?? ''),
              ));
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
