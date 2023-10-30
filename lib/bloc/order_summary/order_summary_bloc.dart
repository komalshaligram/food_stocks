import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/order_model/supplier_details_model.dart';
import '../../data/model/req_model/order_send_req_model/order_send_req_model.dart';
import '../../data/model/res_model/order_send_res_model/order_send_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_colors.dart';
import '../../ui/utils/themes/app_urls.dart';

part 'order_summary_event.dart';

part 'order_summary_state.dart';

part 'order_summary_bloc.freezed.dart';

class OrderSummaryBloc extends Bloc<OrderSummaryEvent, OrderSummaryState> {
  OrderSummaryBloc() : super(OrderSummaryState.initial()) {
    on<OrderSummaryEvent>((event, emit) async {
      SharedPreferencesHelper preferencesHelper =
      SharedPreferencesHelper(
          prefs: await SharedPreferences.getInstance());
      if(event is _getDataEvent){
        emit(state.copyWith(isShimmering: true));
      }
      if(event is _orderSendEvent){
        try {
          OrderSendReqModel reqMap = OrderSendReqModel(
           products: [
             Product(
             productId: '653a299466a6f5add6e023a7',
             quantity: 1,
             supplierId: '6538f51c31864888fcd99ca6',
           ),
           ],
          );
          debugPrint('OrderSendReqModel = $reqMap}');
          final res = await DioClient(event.context).post(
            AppUrls.createOrderUrl,
            data: reqMap,
            options:Options(
                headers: {
              HttpHeaders.authorizationHeader : 'Bearer ${preferencesHelper.getAuthToken()}'
            })
          );

          OrderSendResModel response = OrderSendResModel.fromJson(res);
          debugPrint('OrderSendResModel  = $response');

          if (response.status == 201) {
            preferencesHelper.setOrderId(orderId: response.data!.id!);
            showSnackBar(context: event.context, title: response.message!, bgColor: AppColors.mainColor);
             Navigator.pushNamed(event.context, RouteDefine.orderSuccessfulScreen.name);
         //   emit(state.copyWith(isLoginSuccess: true, isLoading: false));
          } else {
            showSnackBar(context: event.context, title: response.message!, bgColor: AppColors.mainColor);
         /*   emit(state.copyWith(
              isLoading: false,
            )*/
          //  );
          }
        }  on ServerException {}
      }
    });
  }
}
