import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/req_model/get_all_order_req_model/get_all_order_req_model.dart';
import '../../data/model/res_model/get_all_order_res_model/get_all_order_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_colors.dart';
import '../../ui/utils/themes/app_urls.dart';

part 'order_event.dart';
part 'order_state.dart';
part 'order_bloc.freezed.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super( OrderState.initial()) {
    on<OrderEvent>((event, emit) async {
      SharedPreferencesHelper preferencesHelper =
      SharedPreferencesHelper(
          prefs: await SharedPreferences.getInstance());
      debugPrint('token___${preferencesHelper.getAuthToken()}');

      if(event is _getAllOrderEvent){

        try {
          GetAllOrderReqModel reqMap = GetAllOrderReqModel(
      orderId: preferencesHelper.getOrderId()
          );
          debugPrint('OrderSendReqModel = $reqMap}');
          final res = await DioClient(event.context).post(
              AppUrls.getAllOrderUrl,
              data: reqMap,
              options:Options(
                  headers: {
                    HttpHeaders.authorizationHeader : 'Bearer ${preferencesHelper.getAuthToken()}'
                  })
          );

          GetAllOrderResModel response = GetAllOrderResModel.fromJson(res);
          debugPrint('OrderSendResModel  = $response');

          if (response.status == 200) {

            emit(state.copyWith(orderList: response));
            showSnackBar(context: event.context, title: response.message!, bgColor: AppColors.mainColor);
          } else {
            showSnackBar(context: event.context, title: response.message!, bgColor: AppColors.mainColor);
          }
        }  on ServerException {}
      }

    });
  }
}
