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
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/error/exceptions.dart';

import '../../data/model/req_model/remove_form_and_file_req_model/remove_form_and_file_req_model.dart';
import '../../data/model/res_model/file_update_res_model/file_update_res_model.dart'
    as file;
import '../../data/model/res_model/profile_details_res_model/profile_details_res_model.dart'
    as resGet;
import '../../data/model/res_model/profile_details_update_res_model/profile_details_update_res_model.dart'
    as reqUpdate;
import '../../data/model/res_model/profile_res_model/profile_res_model.dart'
    as res;
import '../../data/model/res_model/remove_form_and_file_res_model/remove_form_and_file_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_constants.dart';
import '../../ui/utils/themes/app_strings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
part 'more_details_bloc.freezed.dart';

part 'more_details_event.dart';

part 'more_details_state.dart';

class MoreDetailsBloc extends Bloc<MoreDetailsEvent, MoreDetailsState> {
  ProfileModel profileModel = ProfileModel();
  String imgUrl = '';

  MoreDetailsBloc() : super(MoreDetailsState.initial()) {
    on<MoreDetailsEvent>((event, emit) async {
      SharedPreferencesHelper preferencesHelper =
          SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
      if (event is _getProfileModelEvent) {
        profileModel = event.profileModel;
        try {
          emit(state.copyWith(isShimmering: true));
          final response =
              await DioClient(event.context).get(path: AppUrls.cityListUrl);
          CityListResModel cityListResModel =
              CityListResModel.fromJson(response);
          if (cityListResModel.status == 200) {
            List<String> temp = [];
            cityListResModel.data!.cities!.forEach((element) {
              temp.add(element.cityName.toString());
            });
            emit(state.copyWith(
                isShimmering: false,
                cityList: temp,
                filterList: temp,
                cityListResModel: cityListResModel,
                selectCity:
                    cityListResModel.data!.cities!.first.cityName.toString()));
          } else {
            emit(state.copyWith(isShimmering: false));
            debugPrint('cityListResModel____${cityListResModel}');
          }
        } on ServerException {
          emit(state.copyWith(isShimmering: false));
          // CustomSnackBar.CustomSnackBar.showSnackBar(
          //     context: event.context,
          //     title: e.toString(),
          //     type: SnackBarType.FAILURE);
        } catch (e) {
          emit(state.copyWith(isShimmering: false));
        }
      } else if (event is _pickLogoImageEvent) {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(
            source:
                event.isFromCamera ? ImageSource.camera : ImageSource.gallery);
        if (pickedFile != null) {
          CroppedFile? croppedImage = await cropImage(
              path: pickedFile.path,
              shape: CropStyle.rectangle,
              isLogoCrop: true,
              quality: AppConstants.fileQuality);
          if (croppedImage?.path.isEmpty ?? true) {
            return;
          }
          String imageSize = getFileSizeString(
              bytes: croppedImage?.path.isNotEmpty ?? false
                  ? await File(croppedImage!.path).length()
                  : await pickedFile.length());
          if (int.parse(imageSize.split(' ').first) == 0) {
            return;
          }
          if (int.parse(imageSize.split(' ').first) <=
                  AppConstants.fileSizeCap &&
              imageSize.split(' ').last == 'KB') {
            try {
              final response =
                  await DioClient(event.context).uploadFileProgressWithFormData(
                path: AppUrls.fileUploadUrl,
                formData: FormData.fromMap(
                  {
                    AppStrings.logoString: await MultipartFile.fromFile(
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
                    companyLogo: profileImageModel.filepath ?? ''));
              }
            } on ServerException {
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: '${AppLocalizations.of(event.context)!.image_not_set}',
                  type: SnackBarType.FAILURE);
            }
          } else {
            emit(state.copyWith(isFileSizeExceeds: true));
            emit(state.copyWith(isFileSizeExceeds: false));
            // CustomSnackBar.CustomSnackBar.showSnackBar(
            //     context: event.context,
            //     title: AppStrings.fileSizeLimitString,
            //     type: SnackBarType.FAILURE);
          }
        }
      } else if (event is _registrationApiEvent) {
        if (state.isUpdate) {
          if (state.image.path != '') {
            Map<String, dynamic> req1 = {AppStrings.logoString: imgUrl};
            try {
              final res = await DioClient(event.context).post(
                "${AppUrls.fileUpdateUrl}/${preferencesHelper.getUserId()}",
                data: req1,
              );
              debugPrint('update logo image req_______${req1}');

              file.FileUpdateResModel response =
                  file.FileUpdateResModel.fromJson(res);

              if (response.status == 200) {
                debugPrint('update logo image req________${response}');
                imgUrl = response.data!.client!.profileImage.toString();
              } else {
                CustomSnackBar.showSnackBar(
                    context: event.context,
                    title:
                        '${AppLocalizations.of(event.context)!.something_is_wrong_try_again}',
                    type: SnackBarType.FAILURE);
              }
            } on ServerException {

            }
          }

          ProfileModel updatedProfileModel = ProfileModel(
            cityId: state.cityListResModel?.data?.cities
                ?.firstWhere((city) => city.cityName == state.selectCity)
                .id,
            address: state.addressController.text.trim(),
            email: state.emailController.text,
            //  phoneNumber: preferencesHelper.getPhoneNumber(),
            clientDetail: ClientDetail(fax: state.faxController.text),
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
                'more profile req = ${ req}');
            emit(state.copyWith(isLoading: true));
            final res = await DioClient(event.context).post(
                "${AppUrls.updateProfileDetailsUrl}/${preferencesHelper.getUserId()}",
                data:  req,
        );

            reqUpdate.ProfileDetailsUpdateResModel response =
                reqUpdate.ProfileDetailsUpdateResModel.fromJson(res);
            if (response.status == 200) {
              preferencesHelper.removeCompanyLogo();
              preferencesHelper.setUserCompanyLogoUrl(
                  logoUrl: response.data!.client!.logo.toString());
              emit(state.copyWith(isLoading: false));
              Navigator.pop(event.context);
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title:
                      '${AppLocalizations.of(event.context)!.updated_successfully}',
                  type: SnackBarType.SUCCESS);
            } else {
              emit(state.copyWith(isLoading: false));
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppStrings.getLocalizedStrings(
                      response.message?.toLocalization() ??
                          'something_is_wrong_try_again',
                      event.context),
                  type: SnackBarType.FAILURE);
            }
          } on ServerException {
            emit(state.copyWith(isLoading: false));
            CustomSnackBar.showSnackBar(
                context: event.context,
                title:
                    '${AppLocalizations.of(event.context)!.something_is_wrong_try_again}',
                type: SnackBarType.FAILURE);
          }
        } else {
          PackageInfo packageInfo = await PackageInfo.fromPlatform();
          String version = packageInfo.version;
          print('version____${version}');

          ProfileModel reqMap = ProfileModel(
              profileImage: profileModel.profileImage,
              phoneNumber: profileModel.phoneNumber,
              logo: imgUrl,
              cityId: state.cityListResModel?.data?.cities
                  ?.firstWhere(
                      (element) => element.cityName == state.selectCity)
                  .id,
              contactName: profileModel.contactName,
              address: state.addressController.text.trim(),
              email: state.emailController.text,
              clientDetail: ClientDetail(
                fax: state.faxController.text.trim(),
                ownerName: profileModel.clientDetail?.ownerName,
                clientTypeId: profileModel.clientDetail?.clientTypeId,
                bussinessName: profileModel.clientDetail?.bussinessName,
                bussinessId: profileModel.clientDetail?.bussinessId,
                deviceType: profileModel.clientDetail?.deviceType,
                israelId: profileModel.clientDetail?.israelId,
                tokenId: preferencesHelper.getFCMToken(),
                lastSeen: DateTime.now(),
                applicationVersion: version
              ));
          debugPrint('token_____${preferencesHelper.getFCMToken()}');
          debugPrint('profile reqMap + $reqMap');
          try {
            emit(state.copyWith(isLoading: true));
            final response = await DioClient(event.context)
                .post(AppUrls.RegistrationUrl, data: reqMap);

            res.ProfileResModel profileResModel =
                res.ProfileResModel.fromJson(response);

            debugPrint('profile response --- ${profileResModel}');
            if (profileResModel.status == 200) {
              preferencesHelper.setCartId(
                  cartId: profileResModel.data?.client?.cartId ?? '');
              preferencesHelper.setAuthToken(
                  accToken: profileResModel.data?.authToken?.accessToken ?? '');
              preferencesHelper.setRefreshToken(
                  refToken: profileResModel.data?.authToken?.refreshToken ?? '');
              if ((profileResModel.data?.client?.clientData?.profileImage ??
                      '') !=
                  '') {
                preferencesHelper.setUserImageUrl(
                    imageUrl: profileResModel
                            .data?.client?.clientData?.profileImage ??
                        '');
              }
              if ((profileResModel.data?.client?.clientData?.logo ?? '') !=
                  '') {
                preferencesHelper.setUserCompanyLogoUrl(
                    logoUrl:
                        profileResModel.data?.client?.clientData?.logo ?? '');
              }
              preferencesHelper.setUserName(
                  name: profileResModel
                          .data?.client?.clientData?.clientDetail?.ownerName ??
                      '');
              preferencesHelper.setUserId(
                  id: profileResModel.data?.client?.clientData?.id ?? '');
              emit(state.copyWith(isLoading: false));
              Navigator.pushNamed(
                event.context,
                RouteDefine.activityTimeScreen.name,
              );
            } else {
              emit(state.copyWith(isLoading: false));
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppStrings.getLocalizedStrings(
                      profileResModel.message?.toLocalization() ??
                          'something_is_wrong_try_again',
                      event.context),
                  type: SnackBarType.FAILURE);
            }
          } catch (e) {
            debugPrint("data2 = ${e.toString()}");
            emit(state.copyWith(isLoading: false));
            CustomSnackBar.showSnackBar(
                context: event.context,
                title:
                    '${AppLocalizations.of(event.context)!.something_is_wrong_try_again}',
                type: SnackBarType.FAILURE);
          }
        }
      } else if (event is _citySearchEvent) {
        List<String> list = state.cityList
            .where((city) => city.contains(event.search))
            .toList();
        emit(state.copyWith(filterList: list));
      } else if (event is _selectCityEvent) {
        debugPrint('new city = ${event.city}');
        emit(state.copyWith(selectCity: event.city));
      } else if (event is _getProfileMoreDetailsEvent) {
        emit(state.copyWith(isUpdate: event.isUpdate));
        if (state.isUpdate) {
          try {
            emit(state.copyWith(
                /*
                companyLogo: preferences.getUserCompanyLogoUrl(),*/
                isUpdating: true));
            final res = await DioClient(event.context).post(
                AppUrls.getProfileDetailsUrl,
                data: req.ProfileDetailsReqModel(
                        id: preferencesHelper.getUserId())
                    .toJson(),
           /*     options: Options(
                  headers: {
                    HttpHeaders.authorizationHeader:
                        'Bearer ${preferencesHelper.getAuthToken()}',
                  },
                )*/);
            resGet.ProfileDetailsResModel response =
                resGet.ProfileDetailsResModel.fromJson(res);
            if (response.status == 200) {
              debugPrint(
                  'update city : ${response.data?.clients?.first.city?.cityName}');
              emit(state.copyWith(
                isUpdating: false,
                selectCity: response.data?.clients?.first.city?.cityName ?? '',
                addressController: TextEditingController(
                    text: response.data?.clients?.first.address),
                emailController: TextEditingController(
                    text: response.data?.clients?.first.email),
                faxController: TextEditingController(
                    text: response.data?.clients?.first.clientDetail?.fax),
                companyLogo: response.data?.clients?.first.logo ?? '',
              ));
            } else {
              emit(state.copyWith(isUpdating: false));
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppStrings.getLocalizedStrings(
                      response.message?.toLocalization() ??
                          'something_is_wrong_try_again',
                      event.context),
                  type: SnackBarType.FAILURE);
            }
          } on ServerException {
            emit(state.copyWith(isUpdating: false));
            CustomSnackBar.showSnackBar(
                context: event.context,
                title:
                    '${AppLocalizations.of(event.context)!.something_is_wrong_try_again}',
                type: SnackBarType.FAILURE);
          } catch (e) {
            emit(state.copyWith(isUpdating: false));
          }
        }
      } else if (event is _SetFAXFormatEvent) {
        RegExp regEx = RegExp(r'(\d)');
        String newFaxNumber = '';
        List<RegExpMatch> matches = regEx.allMatches(event.FAX).toList();
        debugPrint('FAX = ${event.FAX}');
        debugPrint('FAX len = ${matches.length}');
        for (int i = 0; i < matches.length; i++) {
          if (i == 0) {
            newFaxNumber = '(${matches[i][0]}';
          } else if (i == 2) {
            newFaxNumber += '${matches[i][0]})-';
          } else if (i == 5) {
            newFaxNumber += '${matches[i][0]}-';
          } else {
            newFaxNumber += '${matches[i][0]}';
          }
        }
        debugPrint('FAX = $newFaxNumber');
        emit(state.copyWith(
            faxController: TextEditingController(text: newFaxNumber)
              ..selection = TextSelection.fromPosition(
                  TextPosition(offset: newFaxNumber.length))));
      } else if (event is _deleteFileEvent) {
        try {
          if (state.companyLogo.isEmpty) {
            return;
          } else if (state.companyLogo.contains(AppStrings.tempString)) {
            emit(state.copyWith(companyLogo: '', image: File('')));
            CustomSnackBar.showSnackBar(
                context: event.context,
                title:
                    '${AppLocalizations.of(event.context)!.removed_successfully}',
                type: SnackBarType.SUCCESS);
            return;
          }
          emit(state.copyWith(isLoading: true));
          RemoveFormAndFileReqModel reqModel =
              RemoveFormAndFileReqModel(path: state.companyLogo);
          debugPrint('delete file req = ${reqModel.path}');
          final res = await DioClient(event.context)
              .post(AppUrls.removeFileUrl, data: reqModel);
          RemoveFormAndFileResModel response =
              RemoveFormAndFileResModel.fromJson(res);
          debugPrint('delete file res = ${response.message}');
          if (response.status == 200) {
            await preferencesHelper.removeCompanyLogo();
            emit(state.copyWith(
                isLoading: false, companyLogo: '', image: File('')));
            CustomSnackBar.showSnackBar(
                context: event.context,
                title:
                    '${AppLocalizations.of(event.context)!.removed_successfully}',
                type: SnackBarType.SUCCESS);
          } else {
            emit(state.copyWith(isLoading: false));
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(
                    response.message?.toLocalization() ??
                        'something_is_wrong_try_again',
                    event.context),
                type: SnackBarType.FAILURE);
          }
        } catch (e) {
          emit(state.copyWith(isLoading: false));
          CustomSnackBar.showSnackBar(
              context: event.context,
              title:
                  '${AppLocalizations.of(event.context)!.something_is_wrong_try_again}',
              type: SnackBarType.FAILURE);
        }
      }
    });
  }
}
