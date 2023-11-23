import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/req_model/order_send_req_model/order_send_req_model.dart';
import '../../data/model/res_model/cart_product_supplier/cart_products_supplier_res_model.dart';
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
      debugPrint('cart id =  ${preferencesHelper.getCartId()}');

      if(event is _getDataEvent){
        try {
          final res = await DioClient(event.context).post(
              '${AppUrls.listingCartProductsSupplierUrl}${preferencesHelper.getCartId()}',

          );
          debugPrint('CartProductsSupplier url   = ${AppUrls.listingCartProductsSupplierUrl}${preferencesHelper.getCartId()}');
          CartProductsSupplierResModel response = CartProductsSupplierResModel.fromJson(res);
          debugPrint('CartProductsSupplierRes  = $response');

          if (response.status == 200) {
          //  showSnackBar(context: event.context, title: response.message!, bgColor: AppColors.mainColor);
           emit(state.copyWith(orderSummaryList: response));
          } else {
            showSnackBar(context: event.context, title: response.message!, bgColor: AppColors.mainColor);
          }
        }  on ServerException {}
      }


      if(event is _orderSendEvent){
        List<Product> ProductReqMap = [];
        state.orderSummaryList.data!.data!.forEach((element) {
          debugPrint('supplierId_____${element.suppliers!.id}');
          debugPrint('product id_____${element.productDetails!.first.id}');
          ProductReqMap.add(Product(
            supplierId: element.suppliers!.id,
            productId: element.productDetails!.first.id,
             quantity: element.totalQuantity,
          ));
        });


        try {
          OrderSendReqModel reqMap = OrderSendReqModel(
           products: ProductReqMap
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

          debugPrint('Order create url  = ${AppUrls.baseUrl}${AppUrls.createOrderUrl}');
          OrderSendResModel response = OrderSendResModel.fromJson(res);
          debugPrint('OrderSendResModel  = $response');

          if (response.status == 201) {
            try {
              final res = await DioClient(event.context).post(
                  '${AppUrls.clearCartUrl}${preferencesHelper.getCartId()}',
                  options:Options(
                      headers: {
                        HttpHeaders.authorizationHeader : 'Bearer ${preferencesHelper.getAuthToken()}'
                      })
              );
              debugPrint('clear cart response_______${res}');
              if (res["status"] == 201) {
                Navigator.pushNamed(event.context, RouteDefine.orderSuccessfulScreen.name);
              }
              else{
                showSnackBar(context: event.context, title: response.message!, bgColor: AppColors.mainColor);
              }

            }  on ServerException {}

          }
          else if(response.status == 403){
            showSnackBar(context: event.context, title: response.message!, bgColor: AppColors.redColor);
          }
          else {
            showSnackBar(context: event.context, title: response.message!, bgColor: AppColors.redColor);
          }
        }  on ServerException {}
      }
    });
  }
}
