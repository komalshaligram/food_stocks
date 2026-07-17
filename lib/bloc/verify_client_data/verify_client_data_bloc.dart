import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/error/exceptions.dart';
import '../../data/model/req_model/profile_details_req_model/profile_details_req_model.dart'
    as req;
import '../../data/model/req_model/profile_req_model/profile_model.dart';
import '../../data/model/res_model/city_list_model/city_list_res_model.dart';
import '../../data/model/res_model/file_upload_model/file_upload_model.dart';
import '../../data/model/res_model/profile_details_res_model/profile_details_res_model.dart'
    as res_get;
import '../../data/model/res_model/profile_details_update_res_model/profile_details_update_res_model.dart'
    as req_update;
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_constants.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/utils/constants/app_urls.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';

part 'verify_client_data_event.dart';
part 'verify_client_data_state.dart';
part 'verify_client_data_bloc.freezed.dart';

/// BLoC for [VerifyClientDataScreen]: loads profile, uploads delivery photo to S3,
/// saves Waze/address fields before continuing to order summary (first-order flow).
///
/// See docs/en/FIRST-ORDER-AND-CLIENT-VERIFICATION.md
class VerifyClientDataBloc
    extends Bloc<VerifyClientDataEvent, VerifyClientDataState> {
  VerifyClientDataBloc() : super(VerifyClientDataState.initial()) {
    on<VerifyClientDataEvent>((event, emit) async {
      final preferences =
          SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

      if (event is _initEvent) {
        emit(state.copyWith(
            isShimmering: true, language: preferences.getAppLanguage()));
        try {
          final cityResponse = await DioClient(event.context)
              .get(path: AppUrlEndPoints.cityListUrl);
          final cityListResModel = CityListResModel.fromJson(cityResponse);
          final cities = cityListResModel.data?.cities
                  ?.map((e) => e.cityName.toString())
                  .toList() ??
              [];

          final profileResponse = await DioClient(event.context).post(
            AppUrlEndPoints.getProfileDetailsUrl,
            data: req.ProfileDetailsReqModel(id: preferences.getUserId())
                .toJson(),
          );
          final profile =
              res_get.ProfileDetailsResModel.fromJson(profileResponse);

          if (profile.status == AppConstants.code_200 &&
              profile.data?.clients?.isNotEmpty == true) {
            final client = profile.data!.clients!.first;
            final detail = client.clientDetail;
            emit(state.copyWith(
              isShimmering: false,
              cityList: cities,
              filterList: cities,
              cityListResModel: cityListResModel,
              selectCity: client.city?.cityName ?? '',
              businessNameController:
                  TextEditingController(text: detail?.bussinessName ?? ''),
              contactNameController:
                  TextEditingController(text: client.contactName ?? ''),
              streetNameController:
                  TextEditingController(text: detail?.streetName ?? ''),
              streetNumberController:
                  TextEditingController(text: detail?.streetNumber ?? ''),
              phoneController:
                  TextEditingController(text: client.phoneNumber ?? ''),
              deliveryDescriptionController: TextEditingController(
                  text: detail?.deliveryLocationDescription ?? ''),
              wazeUrl: detail?.wazeURL ?? '',
              deliveryLocationImageUrl: detail?.deliveryLocationImage ?? '',
              nextRouteName: event.nextRouteName,
              nextRouteArgs: event.nextRouteArgs,
            ));
          } else {
            emit(state.copyWith(isShimmering: false));
          }
        } on ServerException {
          emit(state.copyWith(isShimmering: false));
        }
      } else if (event is _citySearchEvent) {
        emit(state.copyWith(
            cityList: state.filterList
                .where((city) => city.contains(event.search))
                .toList()));
      } else if (event is _selectCityEvent) {
        emit(state.copyWith(selectCity: event.city));
      } else if (event is _pickDeliveryImageEvent) {
        final pickedFile = await ImagePicker().pickImage(
          source: event.isFromCamera ? ImageSource.camera : ImageSource.gallery,
        );
        if (pickedFile == null) return;

        try {
          emit(state.copyWith(
            isImageUploading: true,
            deliveryLocationImageFile: File(pickedFile.path),
          ));
          final response =
              await DioClient(event.context).uploadFileProgressWithFormData(
            path: AppUrlEndPoints.fileUploadUrl,
            formData: FormData.fromMap({
              'deliveryLocationImage': await MultipartFile.fromFile(
                pickedFile.path,
                contentType: MediaType('image', 'jpeg'),
              ),
            }),
          );
          final uploadModel = FileUploadModel.fromJson(response);
          if (uploadModel.filepath == null || uploadModel.filepath!.isEmpty) {
            emit(state.copyWith(
                isImageUploading: false, deliveryLocationImageFile: null));
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppLocalizations.of(event.context)!
                  .something_is_wrong_try_again,
              type: SnackBarType.failure,
            );
            return;
          }
          emit(state.copyWith(
            isImageUploading: false,
            deliveryLocationImageUrl: uploadModel.filepath ?? '',
            deliveryLocationImageFile: File(pickedFile.path),
          ));
        } on ServerException {
          emit(state.copyWith(
              isImageUploading: false, deliveryLocationImageFile: null));
          CustomSnackBar.showSnackBar(
            context: event.context,
            title: AppLocalizations.of(event.context)!
                .something_is_wrong_try_again,
            type: SnackBarType.failure,
          );
        }
      } else if (event is _openWazeEvent) {
        final addressParts = [
          state.streetNameController.text.trim(),
          state.streetNumberController.text.trim(),
          state.selectCity,
        ].where((part) => part.isNotEmpty).join(' ');
        final wazeUrl = state.wazeUrl.isNotEmpty
            ? state.wazeUrl
            : 'https://waze.com/ul?q=${Uri.encodeComponent(addressParts)}&navigate=no';
        final uri = Uri.parse(wazeUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          if (state.wazeUrl.isEmpty && addressParts.isNotEmpty) {
            emit(state.copyWith(wazeUrl: wazeUrl));
          }
        }
      } else if (event is _submitEvent) {
        final hasDeliveryImage = state.deliveryLocationImageUrl.isNotEmpty ||
            state.deliveryLocationImageFile != null;
        if (state.selectCity.isEmpty) {
          CustomSnackBar.showSnackBar(
            context: event.context,
            title: AppLocalizations.of(event.context)!.please_enter_city,
            type: SnackBarType.failure,
          );
          return;
        }
        final matchedCities = state.cityListResModel?.data?.cities
                ?.where((city) => city.cityName == state.selectCity)
                .toList() ??
            [];
        if (matchedCities.isEmpty || matchedCities.first.id == null) {
          CustomSnackBar.showSnackBar(
            context: event.context,
            title: AppLocalizations.of(event.context)!.cities_not_available,
            type: SnackBarType.failure,
          );
          return;
        }
        if (state.wazeUrl.trim().isEmpty) {
          CustomSnackBar.showSnackBar(
            context: event.context,
            title: AppLocalizations.of(event.context)!.please_set_waze_location,
            type: SnackBarType.failure,
          );
          return;
        }
        if (!hasDeliveryImage) {
          CustomSnackBar.showSnackBar(
            context: event.context,
            title: AppLocalizations.of(event.context)!
                .please_upload_delivery_location_photo,
            type: SnackBarType.failure,
          );
          return;
        }

        final updatedProfile = ProfileModel(
          contactName: state.contactNameController.text.trim(),
          phoneNumber: state.phoneController.text.trim(),
          cityId: matchedCities.first.id,
          clientDetail: ClientDetail(
            bussinessName: state.businessNameController.text.trim(),
            streetName: state.streetNameController.text.trim(),
            streetNumber: state.streetNumberController.text.trim(),
            wazeURL: state.wazeUrl,
            deliveryLocationDescription:
                state.deliveryDescriptionController.text.trim(),
            deliveryLocationImage: state.deliveryLocationImageUrl.isNotEmpty
                ? state.deliveryLocationImageUrl
                : null,
          ),
        );

        final reqMap = updatedProfile.toJson();
        final clientDetail = updatedProfile.clientDetail?.toJson();
        clientDetail?.removeWhere((key, value) => value == null);
        reqMap[AppStrings.clientDetailString] = clientDetail;
        reqMap.removeWhere((key, value) => value == null);

        try {
          emit(state.copyWith(isLoading: true));
          final res = await DioClient(event.context).post(
            '${AppUrlEndPoints.updateProfileDetailsUrl}/${preferences.getUserId()}',
            data: reqMap,
          );
          final response =
              req_update.ProfileDetailsUpdateResModel.fromJson(res);
          if (response.status == AppConstants.code_200) {
            emit(state.copyWith(isLoading: false));
            if (state.nextRouteName != null &&
                state.nextRouteName!.isNotEmpty) {
              Navigator.pushNamed(event.context, state.nextRouteName!,
                  arguments: state.nextRouteArgs);
            } else {
              Navigator.pop(event.context);
            }
          } else {
            emit(state.copyWith(isLoading: false));
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppStrings.getLocalizedStrings(
                  response.message?.toLocalization() ?? response.message!,
                  event.context),
              type: SnackBarType.failure,
            );
          }
        } on ServerException {
          emit(state.copyWith(isLoading: false));
        }
      }
    });
  }
}
