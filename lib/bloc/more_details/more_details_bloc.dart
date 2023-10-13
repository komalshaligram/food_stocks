import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/data/model/req_model/profile_req_model/profile_model.dart';
import 'package:food_stock/data/model/res_model/city_list_model/city_list_res_model.dart';
import 'package:food_stock/data/model/res_model/file_upload_model/file_upload_model.dart';
import 'package:food_stock/data/model/req_model/profile_details_req_model/profile_details_req_model.dart'
    as req;
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/error/exceptions.dart';

import '../../data/model/res_model/profile_details_res_model/profile_details_res_model.dart'
    as resGet;
import '../../data/model/res_model/profile_details_update_res_model/profile_details_update_res_model.dart'
    as reqUpdate;
import '../../data/model/res_model/profile_res_model/profile_res_model.dart'
    as res;
import '../../data/storage/shared_preferences_helper.dart';
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
      SharedPreferencesHelper preferences =
          SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

      if (event is _getProfileModelEvent) {
        profileModel = event.profileModel;
        try {
          final response = await DioClient().get(path: AppUrls.cityListUrl);
          CityListResModel cityListResModel =
              CityListResModel.fromJson(response);
          if (cityListResModel.status == 200) {
            List<String> temp = [];
            cityListResModel.data!.cities!.forEach((element) {
              temp.add(element.cityName.toString());
            });
            emit(state.copyWith(cityList: temp));
            emit(state.copyWith(
                filterList: temp,
                cityListResModel: cityListResModel,
                selectCity:
                    cityListResModel.data!.cities!.first.cityName.toString()));
          } else {
            debugPrint('cityListResModel____${cityListResModel}');
          }
        } catch (e) {
          debugPrint(e.toString());
          showSnackBar(
              context: event.context,
              title: e.toString(),
              bgColor: AppColors.redColor);
        }
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
              if (profileImageModel.filepath != '') {
                imgUrl = profileImageModel.filepath ?? '';
                emit(state.copyWith(
                    image: File(croppedImage?.path ?? pickedFile.path),
                    isImagePick: true,
                    companyLogo: profileImageModel.filepath ?? ''));
              }
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
        if (state.isUpdate) {
          ProfileModel updatedProfileModel = ProfileModel(
            cityId: state.cityListResModel?.data?.cities
                ?.firstWhere((city) => city.cityName == state.selectCity)
                .id,
            address: state.addressController.text,
            email: state.emailController.text,
            clientDetail: ClientDetail(fax: state.faxController.text),
            logo: state.companyLogo,
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
            debugPrint(
                'more profile req = ${/*updatedProfileModel.toJson()*/ req}');
            emit(state.copyWith(isLoading: true));
            final res = await DioClient().post(
                "${AppUrls.updateProfileDetailsUrl}/${preferences.getUserId()}",
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
        } else {
          ProfileModel reqMap = ProfileModel(
              profileImage: profileModel.profileImage,
              phoneNumber: profileModel.phoneNumber,
              logo: imgUrl,
              cityId: state.cityListResModel?.data?.cities
                  ?.firstWhere(
                      (element) => element.cityName == state.selectCity)
                  .id,
              contactName: profileModel.contactName,
              address: state.addressController.text,
              email: state.emailController.text,
              clientDetail: ClientDetail(
                fax: state.faxController.text,
                ownerName: profileModel.clientDetail?.ownerName,
                clientTypeId: profileModel.clientDetail?.clientTypeId,
                bussinessName: profileModel.clientDetail?.bussinessName,
                bussinessId: profileModel.clientDetail?.bussinessId,
                deviceType: profileModel.clientDetail?.deviceType,
                israelId: profileModel.clientDetail?.israelId,
                lastSeen: DateTime.now(),
              ));

          debugPrint('profile reqMap + $reqMap');
          try {
            emit(state.copyWith(isLoading: true));
            final response =
                await DioClient().post(AppUrls.RegistrationUrl, data: reqMap);

            res.ProfileResModel profileResModel =
                res.ProfileResModel.fromJson(response);

            debugPrint('profile response --- ${profileResModel}');
            if (profileResModel.status == 200) {
              preferences.setUserImageUrl(
                  imageUrl:
                      profileResModel.data!.client!.profileImage.toString());
              preferences.setUserCompanyLogoUrl(
                  logoUrl: profileResModel.data!.client!.logo.toString());
              preferences.setUserName(
                  name: profileResModel.data!.client!.clientDetail!.ownerName
                      .toString());
              preferences.setUserId(
                  id: profileResModel.data!.client!.id.toString());
              emit(state.copyWith(isLoading: false));
              Navigator.pushNamed(
                event.context,
                RouteDefine.operationTimeScreen.name,
              );
            } else {
              emit(state.copyWith(isLoading: false));
              showSnackBar(
                  context: event.context,
                  title: response['message'],
                  bgColor: AppColors.redColor);
            }
          } catch (e) {
            debugPrint(e.toString());
            emit(state.copyWith(isLoading: false));
            showSnackBar(
                context: event.context,
                title: e.toString(),
                bgColor: AppColors.redColor);
          }
        }
      } else if (event is _addFilterListEvent) {
        emit(state.copyWith(filterList: state.cityList));
      } else if (event is _citySearchEvent) {
        List<String> list = state.cityList
            .where((city) => city.contains(event.search))
            .toList();
        print(list.length);
        emit(state.copyWith(filterList: list));
      } else if (event is _selectCityEvent) {
        debugPrint('new city = ${event.city}');
        emit(state.copyWith(selectCity: event.city));
      } else if (event is _getProfileMoreDetailsEvent) {
        emit(state.copyWith(isUpdate: event.isUpdate));
        if (state.isUpdate) {
          try {
            emit(state.copyWith(
                companyLogo: preferences.getUserCompanyLogoUrl()));
            final res = await DioClient().post(AppUrls.getProfileDetailsUrl,
                data: req.ProfileDetailsReqModel(id: preferences.getUserId())
                    .toJson());
            resGet.ProfileDetailsResModel response =
                resGet.ProfileDetailsResModel.fromJson(res);
            if (response.status == 200) {
              debugPrint(
                  'update city : ${response.data?.clients?.first.city?.cityName}');
              emit(state.copyWith(
                selectCity: response.data?.clients?.first.city!.cityName ?? '',
                addressController: TextEditingController(
                    text: response.data?.clients?.first.address),
                emailController: TextEditingController(
                    text: response.data?.clients?.first.email),
                faxController: TextEditingController(
                    text: response.data?.clients?.first.clientDetail?.fax),
                companyLogo: response.data?.clients?.first.logo ?? '',
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
