import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/data/model/res_model/file_upload_model/file_upload_model.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/req_model/profile_model/profile_model.dart';
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
        profileModel = event.profileModel;
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
              FileUploadModel profileImageModel =
                  FileUploadModel.fromJson(response);
              if (profileImageModel.profileImgFileName != '') {
                imgUrl = profileImageModel.profileImgFileName ?? '';
              }
              emit(state.copyWith(
                  image: File(croppedImage?.path ?? pickedFile.path),
                  isImagePick: true));
            } on ServerException {
              showSnackBar(event.context, AppStrings.imageNotSetString,
                  AppColors.redColor);
            }
          } else {
            showSnackBar(event.context, AppStrings.fileSizeLimit500KBString,
                AppColors.redColor);
          }
        }
      } else if (event is _navigateToOperationTimeScreenEvent) {
        ProfileModel newProfileModel = ProfileModel(
            updatedBy: profileModel.updatedBy,
            statusId: profileModel.statusId,
            profileImage: profileModel.profileImage,
            phoneNumber: profileModel.phoneNumber,
            logo: imgUrl,
            lastName: '',
            firstName: '',
            createdBy: profileModel.createdBy,
            cityId: profileModel.cityId,
            contactName: profileModel.contactName,
            address: state.addressController.text,
            email: state.emailController.text,
            clientDetail: ClientDetail(
              fax: state.faxController.text,
              clientTypeId: profileModel.clientDetail?.clientTypeId,
              applicationVersion: profileModel.clientDetail?.applicationVersion,
              ownerName: profileModel.clientDetail?.ownerName,
              bussinessName: profileModel.clientDetail?.bussinessName,
              bussinessId: profileModel.clientDetail?.bussinessId,
              deviceType: profileModel.clientDetail?.deviceType,
              israelId: profileModel.clientDetail?.israelId,
              lastSeen: DateTime.now(),
              monthlyCredits: profileModel.clientDetail?.monthlyCredits,
              operationTime: OperationTime(),
              tokenId: profileModel.clientDetail?.tokenId,
            ));
        Navigator.pushNamed(event.context, RouteDefine.operationTimeScreen.name,
            arguments: {AppStrings.profileParamString: newProfileModel});
      }
    });
  }
}
