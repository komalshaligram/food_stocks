
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../ui/utils/constants/app_strings.dart';
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
import '../../ui/utils/constants/app_urls.dart';
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
            final response =
                await DioClient(event.context).uploadFileProgressWithFormData(
              path: AppUrlEndPoints.fileUploadUrl,
              formData: FormData.fromMap(
                {
                  AppStrings.signatureString: await MultipartFile.fromFile(
                      event.signPath,
                      contentType: MediaType('image', 'png'))
                },
              ),
            );
            FileUploadModel signModel = FileUploadModel.fromJson(response);
            if (signModel.filepath != '') {
              signUrl = signModel.filepath ?? '';

            }
          } on ServerException {}

         if (signUrl.isNotEmpty) {
            try {
              DeliveryConfirmReqModel reqMap = DeliveryConfirmReqModel(
                supplierId: event.supplierId,
                signature: signUrl,
                returningSurface: int.parse(state.surfacesController.text)
              );

             final response = await DioClient(event.context).post(
                  '${AppUrlEndPoints.deliveryConfirmUrl}${event.orderId}',
                  data: reqMap,
                );


             if (response[AppStrings.statusString] == 200) {
               emit(state.copyWith(isLoading: true));
                Navigator.pushNamedAndRemoveUntil(
                    event.context,
                    RouteDefine.orderScreen.name,
                    (Route<dynamic>route) =>route.isFirst);

                CustomSnackBar.showSnackBar(
                    context: event.context,
                    title: AppStrings.getLocalizedStrings(
                        response[AppStrings.messageString]
                            .toString()
                            .toLocalization(),
                        event.context),
                    type: SnackBarType.success);
              } else {
               emit(state.copyWith(isLoading: false));
                CustomSnackBar.showSnackBar(
                    context: event.context,
                    title: AppStrings.getLocalizedStrings(
                        response[AppStrings.messageString]
                            .toString()
                            .toLocalization(),
                        event.context),
                    type: SnackBarType.failure);
              }
            } on ServerException { emit(state.copyWith(isLoading: false));}
          } else {
           emit(state.copyWith(isLoading: false));
            CustomSnackBar.showSnackBar(
                context: event.context,
                title:
                    AppLocalizations.of(event.context)!.signature_missing,
                type: SnackBarType.failure);
          }
        }
      }
    });
  }
}