import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/data/model/req_model/profile_req_model/profile_model.dart';
import 'package:food_stock/data/model/res_model/file_upload_model/file_upload_model.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/error/exceptions.dart';
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
      } else if (event is _registrationApiEvent) {
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


        debugPrint('operation time reqMap + $newProfileModel');
        try {
          final response = await DioClient().post(
              '/v1/clients/operationTime/65142f55c891fb10e5301f0e',
              data: newProfileModel);

          // res.ProfileModel operationTimeResModel =
          // res.OperationTimeResModel.fromJson(response);

        //  debugPrint('operation time response --- ${operationTimeResModel}');

          if (response['status'] == 200) {
            /*   emit(state.copyWith(isRegisterSuccess: true));

              emit(state.copyWith(
                isRegisterSuccess: false,
              ));*/
            Navigator.pushNamed(
                event.context, RouteDefine.fileUploadScreen.name);
          } else {
            showSnackBar(
                context: event.context,
                title: response['message'],
                bgColor: AppColors.redColor);
            /*   emit(state.copyWith(
                  isRegisterFail: true, errorMessage: response['message']));

              emit(state.copyWith(
                isRegisterFail: false,
              ));*/
          }
        } catch (e) {
          debugPrint(e.toString());
          /*emit(state.copyWith(
              isRegisterFail: true, errorMessage: e.toString()));
          emit(state.copyWith(
            isRegisterFail: false,
          ));*/
        }













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
