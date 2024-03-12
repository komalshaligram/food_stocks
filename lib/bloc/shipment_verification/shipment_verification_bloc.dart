import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/req_model/delivery_confirm/delivery_confirm_req_model.dart';
import '../../data/model/res_model/file_upload_model/file_upload_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_urls.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
part 'shipment_verification_event.dart';

part 'shipment_verification_state.dart';

part 'shipment_verification_bloc.freezed.dart';

class ShipmentVerificationBloc
    extends Bloc<ShipmentVerificationEvent, ShipmentVerificationState> {
  ShipmentVerificationBloc() : super(ShipmentVerificationState.initial()) {
    on<ShipmentVerificationEvent>((event, emit) async {
      SharedPreferencesHelper preferencesHelper =
          SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
      debugPrint('token___${preferencesHelper.getAuthToken()}');

      if (event is _signatureEvent) {
        emit(state.copyWith(isSignaturePadActive: true , isDelete: false));
      }

      else if(event is _signDeleteEvent){
        emit(state.copyWith(isDelete: true));
      }

    else  if (event is _deliveryConfirmEvent) {
        String signUrl = '';
        emit(state.copyWith(isLoading: true));
        if (event.signPath.isNotEmpty) {
          try {
            debugPrint('sign path____${event.signPath}');
            final response =
                await DioClient(event.context).uploadFileProgressWithFormData(
              path: AppUrls.fileUploadUrl,
              formData: FormData.fromMap(
                {
                  AppStrings.signatureString: await MultipartFile.fromFile(
                      event.signPath,
                      contentType: MediaType('image', 'png'))
                },
              ),
            );
            debugPrint('fileUpload url = ${DioClient.baseUrl}${AppUrls.fileUploadUrl}');
            FileUploadModel signModel = FileUploadModel.fromJson(response);
            debugPrint('img url = ${signModel.filepath}');
            if (signModel.filepath != '') {
              signUrl = signModel.filepath ?? '';
              debugPrint("image = ${signUrl}");
            }
          } on ServerException {}

         if (signUrl.isNotEmpty) {
            try {
              DeliveryConfirmReqModel reqMap = DeliveryConfirmReqModel(
                supplierId: event.supplierId,
                signature: signUrl,
              );
              debugPrint('delivery Confirm ReqModel = $reqMap}');
             final response = await DioClient(event.context).post(
                  '${AppUrls.deliveryConfirmUrl}${event.orderId}',
                  data: reqMap,
                  options: Options(headers: {
                    HttpHeaders.authorizationHeader: 'Bearer ${preferencesHelper.getAuthToken()}'
                  }));

              debugPrint('delivery Confirm url  = ${DioClient.baseUrl}${AppUrls.deliveryConfirmUrl}${event.orderId}');
             debugPrint('delivery Confirm response model  = $response');

             if (response['status'] == 200) {
             /*   Navigator.pushNamed(
                    event.context, RouteDefine.bottomNavScreen.name);*/
               emit(state.copyWith(isLoading: true));
                Navigator.pushNamedAndRemoveUntil(
                    event.context,
                    RouteDefine.orderScreen.name,
                    (Route route) =>
                        route.settings.name == RouteDefine.menuScreen.name);

                CustomSnackBar.showSnackBar(
                    context: event.context,
                    title: AppStrings.getLocalizedStrings(
                        response[AppStrings.messageString]
                            .toString()
                            .toLocalization(),
                        event.context),
                    type: SnackBarType.SUCCESS);
              } else {
               emit(state.copyWith(isLoading: true));
                CustomSnackBar.showSnackBar(
                    context: event.context,
                    title: AppStrings.getLocalizedStrings(
                        response[AppStrings.messageString]
                            .toString()
                            .toLocalization(),
                        event.context),
                    type: SnackBarType.SUCCESS);
              }
            } on ServerException { emit(state.copyWith(isLoading: true));}
          } else {
           emit(state.copyWith(isLoading: true));
            CustomSnackBar.showSnackBar(
                context: event.context,
                title:
                    '${AppLocalizations.of(event.context)!.signature_missing}',
                type: SnackBarType.FAILURE);
          }
        }
      }
    });
  }
}
