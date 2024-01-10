import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      debugPrint('cart id =  ${preferencesHelper.getCartId()}');

      if (event is _getDataEvent) {
        emit(state.copyWith(
            CartItemList: event.CartItemList,
            language: preferencesHelper.getAppLanguage()));
        try {
          final res = await DioClient(event.context).post(
            '${AppUrls.listingCartProductsSupplierUrl}${preferencesHelper.getCartId()}',
          );
          debugPrint(
              'CartProductsSupplier url   = ${AppUrls.listingCartProductsSupplierUrl}${preferencesHelper.getCartId()}');
          CartProductsSupplierResModel response =
              CartProductsSupplierResModel.fromJson(res);
          debugPrint('CartProductsSupplierRes  = $response');

          if (response.status == 200) {
            emit(state.copyWith(orderSummaryList: response));
          } else {
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(
                    response.message?.toLocalization() ??
                        'something_is_wrong_try_again',
                    event.context),
                type: SnackBarType.FAILURE);
          }
        } on ServerException {}
      }

      if (event is _orderSendEvent) {
        List<Product> ProductReqMap = [];
        emit(state.copyWith(isLoading: true));

        state.CartItemList.data?.data?.forEach((element) {
          ProductReqMap.add(Product(
            supplierId: element.suppliers?.first.id ?? '',
            productId: element.productDetails?.id ?? '',
            quantity: element.totalQuantity,
            saleId: (element.sales?.length == 0)
                ? ''
                : (element.sales?.first.id ?? ''),
          ));
        });

        try {
          OrderSendReqModel reqMap = OrderSendReqModel(products: ProductReqMap);
          debugPrint('OrderSendReqModel = $reqMap}');
          final res = await DioClient(event.context).post(
            AppUrls.createOrderUrl,
            data: reqMap,
          );

          debugPrint(
              'Order create url  = ${AppUrls.baseUrl}${AppUrls.createOrderUrl}');
          OrderSendResModel response = OrderSendResModel.fromJson(res);
          debugPrint('OrderSendResModel  = $response');

          if (response.status == 201) {
            try {
              final res = await DioClient(event.context).post(
                '${AppUrls.clearCartUrl}${preferencesHelper.getCartId()}',
              );
              debugPrint('clear cart response_______${res}');
              if (res["status"] == 201) {
                preferencesHelper.setCartCount(count: 0);
                Navigator.pushNamed(
                    event.context, RouteDefine.orderSuccessfulScreen.name);
              }
            } on ServerException {}
          } else if (response.status == 403) {
           CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(
                    response.message?.toLocalization() ??
                        'something_is_wrong_try_again',
                    event.context),
                type: SnackBarType.FAILURE,
           );
            emit(state.copyWith(isLoading: false));
          } else {
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(
                    response.message?.toLocalization() ??
                        'something_is_wrong_try_again',
                    event.context),
                type: SnackBarType.FAILURE);
            emit(state.copyWith(isLoading: false));
          }
        } on ServerException {
          emit(state.copyWith(isLoading: false));
        }
      }
    });
  }
}
