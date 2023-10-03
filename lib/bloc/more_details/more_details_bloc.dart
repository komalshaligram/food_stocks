import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/data/model/req_model/profile_req_model/profile_model.dart';
import 'package:food_stock/data/model/res_model/file_upload_model/file_upload_model.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/error/exceptions.dart';

import '../../repository/dio_client.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_colors.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../../ui/utils/themes/app_styles.dart';

part 'more_details_bloc.freezed.dart';

part 'more_details_event.dart';

part 'more_details_state.dart';

class MoreDetailsBloc extends Bloc<MoreDetailsEvent, MoreDetailsState> {
  ProfileModel profileModel = ProfileModel();
  String imgUrl = '';

  MoreDetailsBloc() : super(MoreDetailsState.initial()) {
    on<MoreDetailsEvent>((event, emit) async {
      void showSnackBar(BuildContext context, String title) {
        final snackBar = SnackBar(
          content: Text(
            title,
            style: AppStyles.rkRegularTextStyle(
                size: AppConstants.smallFont,
                color: AppColors.whiteColor,
                fontWeight: FontWeight.w400),
          ),
          backgroundColor: AppColors.redColor,
          padding: EdgeInsets.all(20),
          behavior: SnackBarBehavior.floating,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      if (event is _getProfileModelEvent) {
        profileModel = event.profileModel;
        debugPrint('get contact name = ${profileModel.contactName}');
      } else if (event is _textFieldValidateEvent) {
        if (event.city.isEmpty) {
          showSnackBar(event.context, 'enter city');
        } else if (event.address.isEmpty) {
          showSnackBar(event.context, 'enter address');
        } else if (event.email.isEmpty) {
          showSnackBar(event.context, 'enter email');
        } else if (event.fax.isEmpty) {
          showSnackBar(event.context, 'enter fax');
        } else if (event.image.path == '') {
          showSnackBar(event.context, 'upload photo');
        } else {
          Navigator.pushNamed(
              event.context, RouteDefine.operationTimeScreen.name);
        }
      } else if (event is _logoFromCameraEvent) {
        File? image;
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: ImageSource.camera);
        if (pickedFile != null) {
          image = File(pickedFile.path);
          try {
            final response = await DioClient().uploadFileProgressWithFormData(
              path: '/v1/auth/upload',
              formData: FormData.fromMap(
                {
                  AppStrings.profileImageString: await MultipartFile.fromFile(
                      image.path,
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
            emit(state.copyWith(image: image, isImagePick: true));
          } on ServerException {
            SnackBarShow(event.context, 'image not upload', AppColors.redColor);
          }
        }
      } else if (event is _logoFromGalleryEvent) {
        File? image;
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          image = File(pickedFile.path);
          try {
            final response = await DioClient().uploadFileProgressWithFormData(
              path: '/v1/auth/upload',
              formData: FormData.fromMap(
                {
                  AppStrings.profileImageString: await MultipartFile.fromFile(
                      image.path,
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
            emit(state.copyWith(image: image, isImagePick: true));
          } on ServerException {
            SnackBarShow(event.context, 'image not upload', AppColors.redColor);
          }
        }
      } else if (event is _navigateToOperationTimeScreenEvent) {
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
              applicationVersion: profileModel.clientDetail?.applicationVersion,
              ownerName: profileModel.clientDetail?.ownerName,
              bussinessName: profileModel.clientDetail?.bussinessName,
              bussinessId: profileModel.clientDetail?.bussinessId,
              deviceType: profileModel.clientDetail?.deviceType,
              israelId: profileModel.clientDetail?.israelId,
              lastSeen: DateTime.now(),
              operationTime: OperationTime(),
              tokenId: profileModel.clientDetail?.tokenId,
            ));
        Navigator.pushNamed(event.context, RouteDefine.operationTimeScreen.name,
            arguments: {AppStrings.profileParamString: newProfileModel});
      }
   else if(event is _addFilterListEvent){
         emit(state.copyWith(filterList: state.cityList));
      }
   else if(event is _citySearchEvent){
    var filter = List<String>.of(state.cityList);
    filter.retainWhere((e) => e.startsWith(event.search));
     emit(state.copyWith(filterList: filter));

      }
      else if(event is _selectCityEvent){
        emit(state.copyWith(city: event.city ,filterList: state.cityList ,isRefresh: !state.isRefresh));
        state.cityController.clear();
        Navigator.pop(event.context);

      }


    });
  }
}
