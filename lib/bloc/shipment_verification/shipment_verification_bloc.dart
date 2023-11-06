import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/error/exceptions.dart';
import '../../data/model/req_model/delivery_confirm/delivery_confirm_req_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/themes/app_urls.dart';
part 'shipment_verification_event.dart';
part 'shipment_verification_state.dart';
part 'shipment_verification_bloc.freezed.dart';


class ShipmentVerificationBloc extends Bloc<ShipmentVerificationEvent, ShipmentVerificationState> {
  ShipmentVerificationBloc() : super(ShipmentVerificationState.initial()) {
    on<ShipmentVerificationEvent>((event, emit) async {
      SharedPreferencesHelper preferencesHelper =
      SharedPreferencesHelper(
          prefs: await SharedPreferences.getInstance());
      debugPrint('token___${preferencesHelper.getAuthToken()}');

      if(event is _signatureEvent){
         emit(state.copyWith(isSignaturePadActive: true));
       }

       if(event is _deliveryConfirmEvent){
         try {
           DeliveryConfirmReqModel reqMap = DeliveryConfirmReqModel(
           supplierId: event.supplierId,
             signature: '',
           );
           debugPrint('OrderSendReqModel = $reqMap}');
           final res = await DioClient(event.context).post(
               AppUrls.deliveryConfirmUrl,
               data: reqMap,
               options:Options(
                   headers: {
                     HttpHeaders.authorizationHeader : 'Bearer ${preferencesHelper.getAuthToken()}'
                   })
           );

           debugPrint('OrderSendResModel  = $res');
         //  GetAllOrderResModel response = GetAllOrderResModel.fromJson(res);
         //  debugPrint('OrderSendResModel  = $response');
/*
           if (response.status == 200) {
            // emit(state.copyWith(orderList: response,isShimmering: false));
            // showSnackBar(context: event.context, title: response.message!, bgColor: AppColors.mainColor);
           } else {

           //  showSnackBar(context: event.context, title: response.message!, bgColor: AppColors.mainColor);
           }*/
         }  on ServerException {}
       }
    });
  }
}