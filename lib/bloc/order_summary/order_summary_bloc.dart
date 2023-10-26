import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/model/order_model/supplier_details_model.dart';
import '../../data/model/req_model/order_send_req_model/order_send_req_model.dart';
import '../../data/model/res_model/order_send_res_model/order_send_res_model.dart';
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
              HttpHeaders.authorizationHeader : 'Bearer ${'eyJhbGciOiJkaXIiLCJlbmMiOiJBMjU2R0NNIn0..tsF0TnOirA7IogJI.zwMSbwM78vumMusBOc0jodD8fehRm2otd_kecQqLBT5wLh9l79AbYyoygGfXFfrhi8K-_Gbi3IJuf0Y-C9wi69n7YhgeutV-vhlmNiQwaO-u1MeNGIXdBv3l00RvspyGGwT2IlEZmwDSzi1rRCTDRHQj0mdsK5ombAIzs0kPIQC0dGmjKWvPUexjB6HSxO-Z4N5tegi9R7cynK2HIs0vg9PztzLaEieX53Sm5WBMgjlorDXrQoPe-9hgJHfx-EJGnydTxd15kn1LT03kHbM5uQZlsSXiAnK9KBp4-dwJi8sKk5Zw8mwgPysqQQ9dduajY5Rnx14KbMYcugRUwnjlvQ09hfdAfiWfXK-EJLhGLs5bkvIZ8hpyBzjEb2U.dTZBGHM5h2CD-ZvMe8gbzQ'}'
            })
          );

          OrderSendResModel response = OrderSendResModel.fromJson(res);
          debugPrint('OrderSendResModel  = $response');

          if (response.status == 201) {
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
        } catch (e) {
          showSnackBar(context: event.context, title: e.toString(), bgColor: AppColors.redColor);
         // emit(state.copyWith(isLoading: false));
        }
      }
    });
  }
}
