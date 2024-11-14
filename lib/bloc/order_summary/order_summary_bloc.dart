import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/req_model/order_send_req_model/order_send_req_model.dart';
import '../../data/model/res_model/cart_product_supplier/cart_products_supplier_res_model.dart';
import '../../data/model/res_model/get_all_cart_res_model/get_all_cart_res_model.dart';
import '../../data/model/res_model/order_send_res_model/order_send_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../../ui/utils/themes/app_urls.dart';

part 'order_summary_event.dart';

part 'order_summary_state.dart';

part 'order_summary_bloc.freezed.dart';

class OrderSummaryBloc extends Bloc<OrderSummaryEvent, OrderSummaryState> {
  OrderSummaryBloc() : super(OrderSummaryState.initial()) {
    on<OrderSummaryEvent>((event, emit) async {
      SharedPreferencesHelper preferencesHelper =
          SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
      printData('cart id =  ${preferencesHelper.getCartId()}');

      if (event is _getDataEvent) {
        emit(state.copyWith(
            CartItemList: event.cartItemList,
            language: preferencesHelper.getAppLanguage()));
        try {
          final res = await DioClient(event.context).post(
            '${AppUrls.listingCartProductsSupplierUrl}${preferencesHelper.getCartId()}',
          );
          CartProductsSupplierResModel response =
              CartProductsSupplierResModel.fromJson(res);

          if (response.status == AppConstants.code_200) {
            emit(state.copyWith(orderSummaryList: response));
          } else {
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(
                    response.message?.toLocalization() ??
                        response.message!,
                    event.context),
                type: SnackBarType.failure);
          }
        } on ServerException {}
      }

      if (event is _orderSendEvent) {
        List<Product> productReqMap = [];
        emit(state.copyWith(isLoading: true));

        state.CartItemList.data?.data?.forEach((element) {
          productReqMap.add(Product(
            supplierId: element.suppliers?.first.id ?? '',
            productId: element.productDetails?.id ?? '',
            quantity: element.totalQuantity,
          saleId: element.id,

          ));
        });

        try {
          OrderSendReqModel reqMap = OrderSendReqModel(products: productReqMap,paymentMethod: preferencesHelper.getPaymentMethod());
          final res = await DioClient(event.context).post(
            AppUrls.createOrderUrl,
            data: reqMap,
          );

          OrderSendResModel response = OrderSendResModel.fromJson(res);

          if (response.status == AppConstants.code_201) {
            try {
              final res = await DioClient(event.context).post(
                '${AppUrls.clearCartUrl}${preferencesHelper.getCartId()}',
              );
              if (res[AppStrings.statusString] == AppConstants.code_201) {
                preferencesHelper.setCartCount(count: 0);
                Navigator.pushNamed(
                    event.context, RouteDefine.orderSuccessfulScreen.name);
              }
            } on ServerException {}
          } else if (response.status == AppConstants.code_403) {
           CustomSnackBar.showSnackBar(
                context: event.context,
             title: AppStrings.getLocalizedStrings(
                 response.message?.toLocalization() ??
                     response.message!,
                 event.context),
                type: SnackBarType.failure,
           );
            emit(state.copyWith(isLoading: false));
          } else {
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(
                    response.message?.toLocalization() ??
                        response.message!,
                    event.context),
                type: SnackBarType.failure);
            emit(state.copyWith(isLoading: false));
          }
        } on ServerException {
          emit(state.copyWith(isLoading: false));
        }
      }
    });
  }
}
