import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/data/model/req_model/profile_model/profile_model.dart';
import 'package:food_stock/data/model/res_model/business_type_model/business_type_model.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_cropper/image_cropper.dart';
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
              showSnackBar(event.context, AppStrings.imageNotSetString,
                  AppColors.redColor);
            }
          } else {
            showSnackBar(event.context, AppStrings.fileSizeLimit500KBString,
                AppColors.redColor);
          }
        }
      } else if (event is _getBusinessTypeListEvent) {
        try {
          final response =
              await DioClient().get(path: AppUrls.businessTypesUrl);
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
