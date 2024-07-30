
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smartlook/flutter_smartlook.dart';
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
        if(!state.isUpdate){
          emit(state.copyWith(
            image : File(preferencesHelper.getLogo()),
            streetNameController: TextEditingController(text: preferencesHelper.getStreetName()),
            streetNumberController: TextEditingController(text: preferencesHelper.getStreetNumber()),
            emailController: TextEditingController(text: preferencesHelper.getEmailId()),
            faxController: TextEditingController(text: preferencesHelper.getFax()),
            zipController: TextEditingController(text: preferencesHelper.getZip()),
            selectCity:  preferencesHelper.getCity(),
          ));
        }
        profileModel = event.profileModel;
        try {
          emit(state.copyWith(isShimmering: true ,language: preferencesHelper.getAppLanguage()));
          final response =
              await DioClient(event.context).get(path: AppUrls.cityListUrl);
          CityListResModel cityListResModel =
              CityListResModel.fromJson(response);
          if (cityListResModel.status == 200) {
            List<String> temp = [];
            cityListResModel.data?.cities?.forEach((element) {
              temp.add(element.cityName.toString());
            });
            debugPrint('city_____${preferencesHelper.getCity()}');
            emit(state.copyWith(
                isShimmering: false,
                cityList: temp,
                filterList: temp,
                cityListResModel: cityListResModel,
            ));
          } else {
            emit(state.copyWith(isShimmering: false));
            debugPrint('cityListResModel____${cityListResModel}');
          }
        } on ServerException {
          emit(state.copyWith(isShimmering: false));
        } catch (e) {
          emit(state.copyWith(isShimmering: false));
        }
      }

      else if (event is _pickLogoImageEvent) {
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
      //    else {
            try {
           emit(state.copyWith(isUploadProcess: true));

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
                emit(state.copyWith(isUploadProcess: false));
                emit(state.copyWith(
                    image: File(croppedImage?.path ?? pickedFile.path),
                    companyLogo: profileImageModel.filepath ?? ''));
              }
            } on ServerException {
              emit(state.copyWith(isUploadProcess: false));
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: '${AppLocalizations.of(event.context)!.image_not_set}',
                  type: SnackBarType.FAILURE);
            }
            catch(e){
              emit(state.copyWith(isUploadProcess: false));
            }
          }
        }
    //  }
      else if (event is _registrationApiEvent) {
        if (state.isUpdate) {

          ProfileModel updatedProfileModel = ProfileModel(
            logo: (state.image.path != '') ? imgUrl : state.companyLogo,
            cityId: state.cityListResModel?.data?.cities
                ?.firstWhere((city) => city.cityName == state.selectCity)
                .id,
            email: state.emailController.text,
            clientDetail: ClientDetail(
                fax: state.faxController.text.isNotEmpty ? state.faxController.text : '',
                zip: state.zipController.text.trim(),
              streetNumber: state.streetNumberController.text.trim(),
              streetName: state.streetNameController.text.trim()
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
              emit(state.copyWith(isLoading: false,companyLogo:response.data?.client?.logo ?? ''));
              Smartlook.instance.user.setEmail(response.data?.client?.email ?? '');
              preferencesHelper.setEmailId(
                  userEmailId: response.data?.client?.email ?? '');
              if(!preferencesHelper.getSubUser()){
              preferencesHelper.setUserName(
                  name: response
                      .data?.client?.clientDetail?.ownerName ??
                      '');
              }

              Navigator.pop(event.context);
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title:
                      '${AppLocalizations.of(event.context)!.updated_successfully}',
                  type: SnackBarType.SUCCESS,

              );
            } else {
              emit(state.copyWith(isLoading: false));
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppStrings.getLocalizedStrings(
                      response.message?.toLocalization() ??
                          response.message!,
                      event.context),
                  type: SnackBarType.FAILURE,
              );
            }
          } on ServerException {
            emit(state.copyWith(isLoading: false));

          }
        } else {
          PackageInfo packageInfo = await PackageInfo.fromPlatform();
          String version = packageInfo.version;
           debugPrint('version____${version}');
           debugPrint('imgUrl____${preferencesHelper.getUserCompanyLogoUrl()}');
           debugPrint('imgUrl 1____${imgUrl}');
          ProfileModel reqMap = ProfileModel(
              profileImage: profileModel.profileImage,
              phoneNumber: profileModel.phoneNumber,
              logo: imgUrl.isEmpty ? preferencesHelper.getUserCompanyLogoUrl(): imgUrl,
              cityId: state.cityListResModel?.data?.cities
                  ?.firstWhere(
                      (element) => element.cityName == state.selectCity)
                  .id,
              statusId: AppStrings.pendingString,
              contactName: profileModel.contactName,
              address: state.streetNumberController.text.trim(),
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
                applicationVersion: version,
                streetName: state.streetNameController.text.trim(),
                streetNumber: state.streetNumberController.text.trim(),
                zip:state.zipController.text.trim(),
                applicationName: AppStrings.appName,
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
              print('logo___${profileResModel.data?.client?.clientData?.logo ?? ''}');
              String? businessName = await Smartlook.instance.user.properties.getString("User business name");
              String? phoneNumber = await Smartlook.instance.user.properties.getString("User phone number");
              preferencesHelper.setUserId(
                  id: profileResModel.data?.client?.clientData?.id ?? '');
              preferencesHelper.setEmailId(
                  userEmailId: profileResModel.data?.client?.clientData?.email ?? '');
              preferencesHelper.setCartId(
                  cartId: profileResModel.data?.client?.cartId ?? '');
              preferencesHelper.setAuthToken(
                  accToken: profileResModel.data?.authToken?.accessToken ?? '');
              preferencesHelper.setRefreshToken(
                  refToken: profileResModel.data?.authToken?.refreshToken ?? '');
              if(Platform.isAndroid){
                print('businessname___${profileResModel.data?.client?.clientData?.clientDetail?.bussinessName ?? ''}');
                print('phonenumber___${profileResModel.data?.client?.clientData?.phoneNumber ?? ''}');
                if(businessName != '' || businessName != null  ){
                  Smartlook.instance.user.properties.removeString('User business name');
                }
                if(phoneNumber != '' || phoneNumber != null ){
                  Smartlook.instance.user.properties.removeString('User phone number');
                }
                Smartlook.instance.user.properties.putString('User phone number' ,value:profileResModel.data?.client?.clientData?.phoneNumber ?? '');
                Smartlook.instance.user.properties.putString('User business name' ,value:profileResModel.data?.client?.clientData?.clientDetail?.bussinessName ?? '');
              }

              else{

                if(businessName == '' || businessName == null  ){
                  Smartlook.instance.user.properties.putString('User business name' ,value:profileResModel.data?.client?.clientData?.clientDetail?.bussinessName ?? '');
                }
                else if(phoneNumber == '' || phoneNumber == null ){
                  Smartlook.instance.user.properties.putString('User phone number' ,value:profileResModel.data?.client?.clientData?.phoneNumber ?? '');
                }
              }

              Smartlook.instance.user.setIdentifier(profileResModel.data?.client?.clientData?.id ?? '');
              Smartlook.instance.user.setEmail(profileResModel.data?.client?.clientData?.email ?? '');
              Smartlook.instance.user.setName(profileResModel.data?.client?.clientData?.clientDetail?.ownerName ?? '');




              if(!preferencesHelper.getSubUser()){
                preferencesHelper.setUserName(
                    name: profileResModel
                        .data?.client?.clientData?.clientDetail?.ownerName ??
                        '');
                if ((profileResModel.data?.client?.clientData?.profileImage ??
                    '') !=
                    '') {
                  preferencesHelper.setUserImageUrl(
                      imageUrl: profileResModel
                          .data?.client?.clientData?.profileImage ??
                          '');
                }
              }


              emit(state.copyWith(isLoading: false));
              Navigator.pushNamed(
                event.context,
                RouteDefine.activityTimeScreen.name,
              );
            }
            else {
              emit(state.copyWith(isLoading: false));
              debugPrint('imageurl_____${imgUrl}');
              if(profileResModel.message == AppStrings.rivchitclienterrorString){
                preferencesHelper.setEmailId(userEmailId: state.emailController.text);
                preferencesHelper.setStreetName(streetName: state.streetNameController.text);
                preferencesHelper.setStreetNumber(streetNumber: state.streetNumberController.text);
                preferencesHelper.setFaxNumber(faxNumber: state.faxController.text);
                preferencesHelper.setZipCode(zipCode: state.zipController.text);
                preferencesHelper.setUserLogo(logoImage: state.image.path);
                preferencesHelper.setCity(city: state.selectCity);
                if(imgUrl != ''){
                preferencesHelper.setUserCompanyLogoUrl(logoUrl: imgUrl);
                }

                CustomSnackBar.showSnackBar(
                    context: event.context,
                    title: AppLocalizations.of(event.context)!.israel_id_or_business_id_number_error,
                    type: SnackBarType.FAILURE);
                Navigator.pop(event.context);
              }
              else{
                CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppStrings.getLocalizedStrings(
                      response.message?.toLocalization() ??
                          response.message!,
                      event.context),
                  type: SnackBarType.FAILURE,
                );
              }
            }
          } catch (e) {
            debugPrint("data2 = ${e.toString()}");
            emit(state.copyWith(isLoading: false));
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: e.toString(),

              type: SnackBarType.FAILURE,
            );
          }
        }
      }
      else if (event is _citySearchEvent) {
        List<String> list = state.cityList
            .where((city) => city.contains(event.search))
            .toList();
        emit(state.copyWith(filterList: list));
      }
      else if (event is _selectCityEvent) {
        debugPrint('new city = ${event.city}');
        emit(state.copyWith(selectCity: event.city));
      }
      else if (event is _getProfileMoreDetailsEvent) {
        emit(state.copyWith(isUpdate: event.isUpdate));
        if (state.isUpdate) {
          try {
            emit(state.copyWith(

                isUpdating: true));
            final res = await DioClient(event.context).post(
                AppUrls.getProfileDetailsUrl,
                data: req.ProfileDetailsReqModel(
                        id: preferencesHelper.getUserId())
                    .toJson(),
         );
            resGet.ProfileDetailsResModel response =
                resGet.ProfileDetailsResModel.fromJson(res);
             debugPrint('ProfileDetails Response     =   ${response}');


            if (response.status == 200) {

              debugPrint(
                  'update city : ${response.data?.clients?.first.city?.cityName}');
              emit(state.copyWith(
                isUpdating: false,
                selectCity: response.data?.clients?.first.city?.cityName ?? '',
                emailController: TextEditingController(
                    text: response.data?.clients?.first.email),
                faxController: TextEditingController(
                    text: response.data?.clients?.first.clientDetail?.fax),
                companyLogo: response.data?.clients?.first.logo ?? '',
                  streetNumberController: TextEditingController(
                      text: response.data?.clients?.first.clientDetail?.streetNumber),
                      streetNameController: TextEditingController(
                          text: response.data?.clients?.first.clientDetail?.streetName),
                      zipController:TextEditingController(
                          text: response.data?.clients?.first.clientDetail?.zip)
                  ));
            } else {

              emit(state.copyWith(isUpdating: false));
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppStrings.getLocalizedStrings(
                      response.message?.toLocalization() ??
                          response.message!,
                      event.context),
                  type: SnackBarType.FAILURE);
            }
          } on ServerException {
            emit(state.copyWith(isUpdating: false));


          } catch (e) {
            emit(state.copyWith(isUpdating: false));
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: e.toString(),
                type: SnackBarType.SUCCESS);
          }
        }
      }

      else if (event is _deleteFileEvent) {
        try {
          if (state.companyLogo.isEmpty) {
            return;
          } else if (state.companyLogo.contains(AppStrings.tempString)) {
            preferencesHelper.removeCompanyLogo();
            emit(state.copyWith(companyLogo: '', image: File('')));
            CustomSnackBar.showSnackBar(
                context: event.context,
                title:
                    '${AppLocalizations.of(event.context)!.removed_successfully}',
                type: SnackBarType.SUCCESS);
            return;
          }
          emit(state.copyWith(isUploadProcess: true));
          ProfileModel updatedProfileModel = ProfileModel(
              logo: '',
              clientDetail: ClientDetail()
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
          debugPrint('profile req = ${req}');
          final res = await DioClient(event.context).post(
            AppUrls.updateProfileDetailsUrl + "/" + preferencesHelper.getUserId(),
            data: req,
          );
          reqUpdate.ProfileDetailsUpdateResModel response =
          reqUpdate.ProfileDetailsUpdateResModel.fromJson(res);

          if (response.status == 200) {
            await preferencesHelper.removeCompanyLogo();
            emit(state.copyWith(
                isLoading: false, companyLogo: '', image: File(''),isUploadProcess: false));
            CustomSnackBar.showSnackBar(
                context: event.context,
                title:
                    '${AppLocalizations.of(event.context)!.removed_successfully}',
                type: SnackBarType.SUCCESS);
          } else {
            emit(state.copyWith(isLoading: false,isUploadProcess: false));
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(
                    response.message?.toLocalization() ??
                        response.message!,
                    event.context),
                type: SnackBarType.FAILURE);
          }
        } catch (e) {
          emit(state.copyWith(isLoading: false,isUploadProcess: false));
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
