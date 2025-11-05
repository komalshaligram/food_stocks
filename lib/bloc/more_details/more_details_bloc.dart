import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smartlook/flutter_smartlook.dart';
import '../../data/model/req_model/profile_req_model/profile_model.dart';
import '../../data/model/res_model/city_list_model/city_list_res_model.dart';
import '../../data/model/req_model/profile_details_req_model/profile_details_req_model.dart' as req;
import '../../ui/utils/constants/app_urls.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/res_model/profile_details_res_model/profile_details_res_model.dart' as res_get;
import '../../data/model/res_model/profile_details_update_res_model/profile_details_update_res_model.dart' as req_update;
import '../../data/model/res_model/profile_res_model/profile_res_model.dart' as res;
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_constants.dart';
import '../../ui/utils/constants/app_strings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'more_details_bloc.freezed.dart';
part 'more_details_event.dart';
part 'more_details_state.dart';

class MoreDetailsBloc extends Bloc<MoreDetailsEvent, MoreDetailsState> {
  ProfileModel profileModel = const ProfileModel();
  String imgUrl = '';

  MoreDetailsBloc() : super(MoreDetailsState.initial()) {
    on<MoreDetailsEvent>((event, emit) async {
      SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

      if (event is _getProfileModelEvent) {
        if (!state.isUpdate) {
          emit(state.copyWith(
            streetNameController: TextEditingController(text: preferencesHelper.getStreetName()),
            streetNumberController: TextEditingController(text:  preferencesHelper.getStreetNumber()),
            emailController: TextEditingController(text: preferencesHelper.getEmailId()),
            zipController: TextEditingController(text: preferencesHelper.getZip()),
            selectCity: preferencesHelper.getCity(),

          ));
        }
        profileModel = event.profileModel;
        try {
          emit(state.copyWith(isShimmering: true, language: preferencesHelper.getAppLanguage()));
          final response = await DioClient(event.context).get(path: AppUrlEndPoints.cityListUrl);
          CityListResModel cityListResModel = CityListResModel.fromJson(response);
          if (cityListResModel.status == AppConstants.code_200) {
            List<String> temp = [];
            cityListResModel.data?.cities?.forEach((element) {
              temp.add(element.cityName.toString());
            });
            emit(state.copyWith(
              isShimmering: false,
              cityList: temp,
              filterList: temp,
              cityListResModel: cityListResModel,
            ));
          } else {
            emit(state.copyWith(isShimmering: false));
          }
        } on ServerException {
          emit(state.copyWith(isShimmering: false));
        } catch (e) {
          emit(state.copyWith(isShimmering: false));
        }
      }
      else if (event is _registrationApiEvent) {
        if (state.isUpdate) {
          ProfileModel updatedProfileModel = ProfileModel(
            cityId: state.cityListResModel?.data?.cities?.firstWhere((city) => city.cityName == state.selectCity).id,
            email: state.emailController.text,
            clientDetail: ClientDetail(approveSmsAndEmail: state.approveForSMS,zip: state.zipController.text.trim(), streetNumber: state.streetNumberController.text.trim(), streetName: state.streetNameController.text.trim()),
          );
          Map<String, dynamic> req = updatedProfileModel.toJson();
          Map<String, dynamic>? clientDetail = updatedProfileModel.clientDetail?.toJson();
          clientDetail?.removeWhere((key, value) {
            if (value != null) {
            }
            return value == null;
          });
          req[AppStrings.clientDetailString] = clientDetail;
          req.removeWhere((key, value) {
            if (value != null) {
            }
            return value == null;
          });
          try {
            emit(state.copyWith(isLoading: true));
            final res = await DioClient(event.context).post(
              "${AppUrlEndPoints.updateProfileDetailsUrl}/${preferencesHelper.getUserId()}",
              data: req,
            );

            req_update.ProfileDetailsUpdateResModel response = req_update.ProfileDetailsUpdateResModel.fromJson(res);
            if (response.status == AppConstants.code_200) {
              emit(state.copyWith(isLoading: false));
              Smartlook.instance.user.setEmail(response.data?.client?.phoneNumber ?? '');
              //Smartlook.instance.user.setEmail(response.data?.client?.email ?? '');
              preferencesHelper.setEmailId(userEmailId: response.data?.client?.email ?? '');
              if (!preferencesHelper.getSubUser()) {
                preferencesHelper.setUserName(name: response.data?.client?.clientDetail?.ownerName ?? '');
              }

              Navigator.pop(event.context);
              CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppLocalizations.of(event.context)!.updated_successfully,
                type: SnackBarType.success,
              );
            } else {
              emit(state.copyWith(isLoading: false));
              CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
                type: SnackBarType.failure,
              );
            }
          } on ServerException {
            emit(state.copyWith(isLoading: false));
          }
        } else if (preferencesHelper.getUserId().isNotEmpty) {
          emit(state.copyWith(isLoading: true));
          add(MoreDetailsEvent.checkBDIEvent(context: event.context, clientId: preferencesHelper.getUserId()));
        } else {
          PackageInfo packageInfo = await PackageInfo.fromPlatform();
          String version = packageInfo.version;
          ProfileModel reqMap = ProfileModel(
              profileImage: profileModel.profileImage,
              phoneNumber: profileModel.phoneNumber,
              cityId: state.cityListResModel?.data?.cities?.firstWhere((element) => element.cityName == state.selectCity).id,
              statusId: AppStrings.pendingString,
              contactName: profileModel.contactName,
              address: state.streetNumberController.text.trim(),
              email: state.emailController.text,
              clientDetail: ClientDetail(
                ownerName: '${profileModel.clientDetail!.ownerFirstName} ${profileModel.clientDetail?.ownerLastName}',
                ownerFirstName: profileModel.clientDetail?.ownerFirstName,
                ownerLastName: profileModel.clientDetail?.ownerLastName,
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
                zip: state.zipController.text.trim(),
                applicationName: AppStrings.appName,
                approveSmsAndEmail: state.approveForSMS,
              ));

          try {
            emit(state.copyWith(isLoading: true));
            final response = await DioClient(event.context).post(AppUrlEndPoints.registrationUrl, data: reqMap);

            res.ProfileResModel profileResModel = res.ProfileResModel.fromJson(response);

            if (profileResModel.status == AppConstants.code_200) {
              String? businessName = await Smartlook.instance.user.properties.getString(AppStrings.userBusinessName);
              String? phoneNumber = await Smartlook.instance.user.properties.getString(AppStrings.userPhoneNum);
              preferencesHelper.setUserId(id: profileResModel.data?.client?.clientData?.id ?? '');
              preferencesHelper.setEmailId(userEmailId: profileResModel.data?.client?.clientData?.email ?? '');
              preferencesHelper.setCartId(cartId: profileResModel.data?.client?.cartId ?? '');
              preferencesHelper.setAuthToken(accToken: profileResModel.data?.authToken?.accessToken ?? '');
              preferencesHelper.setRefreshToken(refToken: profileResModel.data?.authToken?.refreshToken ?? '');
              if (Platform.isAndroid) {
                if (businessName != '' || businessName != null) {
                  Smartlook.instance.user.properties.removeString(AppStrings.userBusinessName);
                }
                if (phoneNumber != '' || phoneNumber != null) {
                  Smartlook.instance.user.properties.removeString(AppStrings.userPhoneNum);
                }
                Smartlook.instance.user.properties.putString(AppStrings.userPhoneNum, value: profileResModel.data?.client?.clientData?.phoneNumber ?? '');
                Smartlook.instance.user.properties.putString(AppStrings.userBusinessName, value: profileResModel.data?.client?.clientData?.clientDetail?.bussinessName ?? '');
              } else {
                if (businessName == '' || businessName == null) {
                  Smartlook.instance.user.properties.putString(AppStrings.userBusinessName, value: profileResModel.data?.client?.clientData?.clientDetail?.bussinessName ?? '');
                } else if (phoneNumber == '' || phoneNumber == null) {
                  Smartlook.instance.user.properties.putString(AppStrings.userPhoneNum, value: profileResModel.data?.client?.clientData?.phoneNumber ?? '');
                }
              }
              Smartlook.instance.user.setIdentifier(profileResModel.data?.client?.clientData?.id ?? '');
              Smartlook.instance.user.setEmail(profileResModel.data?.client?.clientData?.phoneNumber.toString() ?? '');
             // Smartlook.instance.user.setEmail(profileResModel.data?.client?.clientData?.email ?? '');
              Smartlook.instance.user.setName(profileResModel.data?.client?.clientData?.clientDetail?.ownerName ?? '');
              if (!preferencesHelper.getSubUser()) {
                preferencesHelper.setUserName(name: profileResModel.data?.client?.clientData?.clientDetail?.ownerName ?? '');
                if ((profileResModel.data?.client?.clientData?.profileImage ?? '') != '') {
                  preferencesHelper.setUserImageUrl(imageUrl: profileResModel.data?.client?.clientData?.profileImage ?? '');
                }
              }
              add(MoreDetailsEvent.checkBDIEvent(context: event.context, clientId: profileResModel.data?.client?.clientData?.id ?? ''));
            } else {
              emit(state.copyWith(isLoading: false));
              if (profileResModel.message == AppStrings.rivchitClientErrorString) {
                preferencesHelper.setEmailId(userEmailId: state.emailController.text);
                preferencesHelper.setStreetName(streetName: state.streetNameController.text);
                preferencesHelper.setStreetNumber(streetNumber: state.streetNumberController.text);
                preferencesHelper.setZipCode(zipCode: state.zipController.text);
                preferencesHelper.setCity(city: state.selectCity);

                CustomSnackBar.showSnackBar(context: event.context, title: AppLocalizations.of(event.context)!.israel_id_or_business_id_number_error, type: SnackBarType.failure);
                Navigator.pop(event.context);
              } else {
                CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppStrings.getLocalizedStrings(profileResModel.message?.toLocalization() ?? profileResModel.message!, event.context),
                  type: SnackBarType.failure,
                );
              }
            }
          } catch (e) {
            emit(state.copyWith(isLoading: false));
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: e.toString(),
              type: SnackBarType.failure,
            );
          }
        }
      } else if (event is _citySearchEvent) {
        List<String> list = state.cityList.where((city) => city.contains(event.search)).toList();
        emit(state.copyWith(filterList: list));
      } else if (event is _selectCityEvent) {
        emit(state.copyWith(selectCity: event.city));
      } else if (event is _getProfileMoreDetailsEvent) {
        emit(state.copyWith(isUpdate: event.isUpdate));
        if (state.isUpdate) {
          try {
            emit(state.copyWith(isUpdating: true));
            final res = await DioClient(event.context).post(
              AppUrlEndPoints.getProfileDetailsUrl,
              data: req.ProfileDetailsReqModel(id: preferencesHelper.getUserId()).toJson(),
            );
            res_get.ProfileDetailsResModel response = res_get.ProfileDetailsResModel.fromJson(res);
            if (response.status == AppConstants.code_200) {
              preferencesHelper.setPaymentMethod(method: response.data?.clients?.first.clientDetail?.paymentType ?? '');
              preferencesHelper.setPaymentMethodCount(count: response.data?.clients?.first.clientDetail?.availablePaymentTypes.length.toString() ?? '0');
              preferencesHelper.setPaymentMethodTypes(methods:response.data?.clients?.first.clientDetail?.availablePaymentTypes??[]);
              emit(state.copyWith(isUpdating: false, selectCity: response.data?.clients?.first.city?.cityName ?? '', emailController: TextEditingController(text: response.data?.clients?.first.email), streetNumberController: TextEditingController(text: response.data?.clients?.first.clientDetail?.streetNumber), streetNameController: TextEditingController(text: response.data?.clients?.first.clientDetail?.streetName), zipController: TextEditingController(text: response.data?.clients?.first.clientDetail?.zip)));
            } else {
              emit(state.copyWith(isUpdating: false));
              CustomSnackBar.showSnackBar(context: event.context, title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context), type: SnackBarType.failure);
            }
          } on ServerException {
            emit(state.copyWith(isUpdating: false));
          } catch (e) {
            emit(state.copyWith(isUpdating: false));
            CustomSnackBar.showSnackBar(context: event.context, title: e.toString(), type: SnackBarType.success);
          }
        }
      } else if (event is _setApprovalSMSSwitchEvent) {
        emit(state.copyWith(approveForSMS: event.updatedVal));
      } else if (event is _checkBDIEvent) {
        try {
          Map reqMap = {AppStrings.idString: event.clientId};
          final res = await DioClient(event.context).post(AppUrlEndPoints.bdiUrl, data: reqMap);
          if (res[AppStrings.statusString] == AppConstants.code_200) {
            preferencesHelper.setAvailableAllPayment(isAvailableAllPayment: res['data']['isAvailableAllPayment']);
          } else {
            preferencesHelper.setAvailableAllPayment(isAvailableAllPayment: false);
          }
          emit(state.copyWith(isLoading: false));
          Navigator.pushNamed(
            event.context,
            RouteDefine.formDataScreen.name,
          );
        } catch (e) {
          CustomSnackBar.showSnackBar(
            context: event.context,
            title: AppLocalizations.of(event.context)!.internal_server_error,
            type: SnackBarType.failure,
          );
          emit(state.copyWith(isLoading: false));
        }
      }
    });
  }
}