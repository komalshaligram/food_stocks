import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/data/model/req_model/profile_model/profile_model.dart';
import 'package:food_stock/data/model/res_model/business_type_model/business_type_model.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/res_model/file_upload_model/file_upload_model.dart';
import '../../repository/dio_client.dart';
import '../../routes/app_routes.dart';

part 'profile_bloc.freezed.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileModel profileModel = ProfileModel();
  String imgUrl = '';

  ProfileBloc() : super(ProfileState.initial()) {
    on<ProfileEvent>((event, emit) async {
      if (event is _profilePicFromCameraEvent) {
        File? image;
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: ImageSource.camera);
        if (pickedFile != null) {
          image = File(pickedFile.path);
          try {
            debugPrint('File = ${image.path}');
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
            emit(state.copyWith(image: image));
          } on ServerException {
            SnackBarShow(event.context, 'image not upload', AppColors.redColor);
          }
        }
      } else if (event is _profilePicFromGalleryEvent) {
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
            emit(state.copyWith(image: image));
          } on ServerException {
            SnackBarShow(event.context, 'image not upload', AppColors.redColor);
          }
        }
      } else if (event is _getBusinessTypeListEvent) {
        try {
          final response =
              await DioClient().get(path: '/v1/settings/clientTypes');
          BusinessTypeModel businessTypeModel =
              BusinessTypeModel.fromJson(response);
          emit(state.copyWith(
              businessTypeList: businessTypeModel,
              selectedBusinessType:
                  businessTypeModel.data?.clientTypes?[0].businessType ?? ''));
        } on ServerException {}
      } else if (event is _navigateToMoreDetailsScreenEvent) {
        final businessTypeId = state.businessTypeList.data;
        debugPrint('business type id = $businessTypeId');
        profileModel = ProfileModel(
            address: '',
            cityId: '60abf964173234001c903a05',
            createdBy: '60abf964173234001c903a05',
            email: '',
            firstName: '',
            lastName: '',
            logo: '',
            phoneNumber: '1234567890',
            profileImage: imgUrl,
            statusId: '6511399a482b14e37c254562',
            updatedBy: '60abf964173234001c903a05',
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
              monthlyCredits: 100,
              operationTime: OperationTime(),
              tokenId: '60abf964173234001c903a05',
              clientTypeId: '',
            ),
            contactName: state.contactController.text);
        Navigator.pushNamed(event.context, RouteDefine.moreDetailsScreen.name,
            arguments: {AppStrings.profileParamString: profileModel});
      }
    });
  }
}
