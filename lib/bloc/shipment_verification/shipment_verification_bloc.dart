import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../ui/utils/constants/app_strings.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

class ShipmentVerificationBloc extends Bloc<ShipmentVerificationEvent, ShipmentVerificationState> {
  ShipmentVerificationBloc() : super(ShipmentVerificationState.initial()) {
    on<ShipmentVerificationEvent>((event, emit) async {
      SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

      if (event is _signatureEvent) {
        emit(state.copyWith(isSignaturePadActive: true, isDelete: false));
      } else if (event is _driverSignatureEvent) {
        emit(state.copyWith(isDriverSignaturePadActive: true, isDelete: false));
      } else if (event is _signDeleteEvent) {
        emit(state.copyWith(isDelete: true));
      } else if (event is _deliveryConfirmEvent) {
        emit(state.copyWith(isLoading: true));

        String signUrl = '';
        String driverSignUrl = '';

        try {
          // 1. Upload supplier signature
          if (event.signPath.isNotEmpty) {
            final response = await DioClient(event.context).uploadFileProgressWithFormData(
              path: AppUrlEndPoints.fileUploadUrl,
              formData: FormData.fromMap({
                AppStrings.signatureString: await MultipartFile.fromFile(
                  event.signPath,
                  contentType: MediaType('image', 'png'),
                ),
              }),
            );

            final signModel = FileUploadModel.fromJson(response);
            signUrl = signModel.filepath ?? '';
          }

          // 2. Upload driver signature
          if (event.driverSignPath.isNotEmpty) {
            final response = await DioClient(event.context).uploadFileProgressWithFormData(
              path: AppUrlEndPoints.fileUploadUrl,
              formData: FormData.fromMap({
                AppStrings.signatureString: await MultipartFile.fromFile(
                  event.driverSignPath,
                  contentType: MediaType('image', 'png'),
                ),
              }),
            );

            final driverSignModel = FileUploadModel.fromJson(response);
            driverSignUrl = driverSignModel.filepath ?? '';
          }

          // 3. Validate uploaded URLs
          if (signUrl.isEmpty) {
            emit(state.copyWith(isLoading: false));
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppLocalizations.of(event.context)!.signature_missing,
              type: SnackBarType.failure,
            );
            return;
          }

          if (driverSignUrl.isEmpty) {
            emit(state.copyWith(isLoading: false));
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppLocalizations.of(event.context)!.driver_signature_missing,
              type: SnackBarType.failure,
            );
            return;
          }

          printData("check here ${event.orderIssueReturnId}");

          // 4. Construct request payload
          final deliveryConfirmRequest = DeliveryConfirmReqModel(
            supplierId: event.supplierId,
            signature: signUrl,
            driverSignature: driverSignUrl,
            returningSurface: int.tryParse(state.surfacesController.text) ?? 0,
            driverDeliveryDocumentsImages: event.driverDeliveryDocumentsImages,
            sentReturnData: event.sentReturnData,
            orderIssueReturnId: event.orderIssueReturnId ?? '',
            driverName: state.driverNameController.text ?? ''
          );

          // 5. Make the delivery confirmation API call
          final response = await DioClient(event.context).post(
            '${AppUrlEndPoints.deliveryConfirmUrl}${event.orderId}',
            data: deliveryConfirmRequest,
          );
          //
          // // 6. Handle response
          if (response[AppStrings.statusString] == 200) {
            emit(state.copyWith(isLoading: false));

            Navigator.pushReplacementNamed(
              event.context,
              RouteDefine.orderScreen.name,
              arguments: {
                AppStrings.pushNavigationString: 'profileScreen',
              },
              // (route) => route.isFirst,
            );

            CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppStrings.getLocalizedStrings(
                response[AppStrings.messageString].toString().toLocalization(),
                event.context,
              ),
              type: SnackBarType.success,
            );
          } else {
            emit(state.copyWith(isLoading: false));
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppStrings.getLocalizedStrings(
                response[AppStrings.messageString].toString().toLocalization(),
                event.context,
              ),
              type: SnackBarType.failure,
            );
          }
        } catch (e) {
          emit(state.copyWith(isLoading: false));
        }
      }
    });
  }
}
