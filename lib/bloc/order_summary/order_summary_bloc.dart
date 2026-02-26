import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/model/res_model/supplier_payment_type_res_model/supplier_payment_type_res_model.dart';
import '../../ui/utils/constants/app_constants.dart';
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
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/utils/constants/app_urls.dart';

part 'order_summary_event.dart';

part 'order_summary_state.dart';

part 'order_summary_bloc.freezed.dart';

class OrderSummaryBloc extends Bloc<OrderSummaryEvent, OrderSummaryState> {
  OrderSummaryBloc() : super(OrderSummaryState.initial()) {
    on<OrderSummaryEvent>((event, emit) async {
      SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

      if (event is _getDataEvent) {
        emit(state.copyWith(cartItemList: event.cartItemList, language: preferencesHelper.getAppLanguage(), total: event.totalAmount, backString: event.backString));
        try {
          final res = await DioClient(event.context).post(
            '${AppUrlEndPoints.listingCartProductsSupplierUrl}${preferencesHelper.getCartId()}',
          );
          CartProductsSupplierResModel response = CartProductsSupplierResModel.fromJson(res);

          if (response.status == AppConstants.code_200) {
            emit(state.copyWith(
              orderSummaryList: response,
              tempList: response.data?.data ?? [],
            ));
          } else {
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
              type: SnackBarType.failure,
            );
          }
        } catch(_) {}
      }

      if (event is _orderSendEvent) {
        List<Product> productReqMap = [];

        state.tempList[state.index].productDetails?.forEach((product) {
          productReqMap.add(Product(productId: product.id, supplierId: state.tempList[state.index].suppliers?.id, quantity: int.parse(state.tempList[state.index].totalQuantity.toString() ?? '0')));
        });

        List<CartProductDataResModel> tempList = [];
        tempList = [...state.tempList];
        tempList[state.index] = tempList[state.index].copyWith(isProcess: true);
        emit(state.copyWith(isLoading: true, showPopUp: false, cartItemList: state.cartItemList, tempList: tempList));

        try {
          OrderSendReqModel reqMap = OrderSendReqModel(products: productReqMap, paymentMethod: event.paymentMethod.isNotEmpty ? event.paymentMethod : preferencesHelper.getPaymentMethod());
          final res = await DioClient(event.context).post(
            AppUrlEndPoints.createOrderUrl,
            data: reqMap,
          );

          OrderSendResModel response = OrderSendResModel.fromJson(res);

          if (response.status == AppConstants.code_201) {
            try {
              tempList[state.index] = tempList[state.index].copyWith(isProcess: false);
              tempList.removeAt(state.index);
              emit(state.copyWith(tempList: tempList));
              if (tempList.isEmpty) {
                final res = await DioClient(event.context).post(
                  '${AppUrlEndPoints.clearCartUrl}${preferencesHelper.getCartId()}',
                );
                if (res[AppStrings.statusString] == AppConstants.code_201) {
                  preferencesHelper.setCartCount(count: 0);
                  Navigator.pushNamed(event.context, RouteDefine.orderSuccessfulScreen.name, arguments: {AppStrings.showPreviousBtn: false});
                }
              } else {
                final res = await DioClient(event.context).post(
                  '${AppUrlEndPoints.getAllCartUrl}${preferencesHelper.getCartId()}',
                );
                GetAllCartResModel response = GetAllCartResModel.fromJson(res);
                emit(state.copyWith(cartItemList: response));
                Navigator.pushNamed(event.context, RouteDefine.orderSuccessfulScreen.name, arguments: {AppStrings.showPreviousBtn: true});
              }
            } catch(_) {}
          } else if (response.status == AppConstants.code_403) {
            tempList[state.index] = tempList[state.index].copyWith(isProcess: false);
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
              type: SnackBarType.failure,
            );
            emit(state.copyWith(isLoading: false, tempList: tempList));
          } else if (response.status == AppConstants.code_405) {
            emit(state.copyWith(isLoading: false, isOrderPending: true, isPaymentFail: false));
          } else {
            tempList[state.index] = tempList[state.index].copyWith(isProcess: false);
            CustomSnackBar.showSnackBar(context: event.context, title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context), type: SnackBarType.failure);
            emit(state.copyWith(isLoading: false, tempList: tempList));
          }
        } on ServerException {
          tempList[state.index] = tempList[state.index].copyWith(isProcess: false);
          emit(state.copyWith(isLoading: false, tempList: tempList));
        }
      } else if (event is _payWithBankTransferEvent) {
        add(OrderSummaryEvent.orderSendEvent(context: event.context, paymentMethod: AppStrings.bankTransfer, failPayment: false));
      } else if (event is _getSupplierPaymentTypeEvent) {
        try {
          List<CartProductDataResModel> tempList = [];
          tempList = [...state.tempList];
          if (tempList.isEmpty) {
            tempList = [...state.orderSummaryList.data?.data ?? []];
          }

          tempList[event.index] = tempList[event.index].copyWith(isProcess: true);

          emit(state.copyWith(tempList: tempList, showPopUp: false));
          final res = await DioClient(event.context).get(
            path: '${AppUrlEndPoints.getSupplierPaymentTypesUrl}${event.id}',
          );
          SupplierPaymentTypeResModel response = SupplierPaymentTypeResModel.fromJson(res);
          if (response.status == AppConstants.code_200) {
            tempList[event.index] = tempList[event.index].copyWith(isProcess: false);

            emit(state.copyWith(paymentTypesList: response.data?.paymentDetails?.paymentTypes ?? [], bankTransferInfo: response.data!.paymentDetails?.bankTransferPopupText ?? '', tempList: tempList, isDialogOpen: true, orderSummaryList: state.orderSummaryList, showPopUp: true, isLoading: false, index: event.index));
          } else {
            tempList[state.index] = tempList[state.index].copyWith(isProcess: false);
            emit(state.copyWith(isLoading: false, tempList: tempList));
            CustomSnackBar.showSnackBar(context: event.context, title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context), type: SnackBarType.failure);
          }
        } catch(_) {}
      } else if (event is _refreshEvent) {
        emit(state.copyWith(isOrderPending: false, isPaymentFail: false, updatePaymentMethod: false));
      }
    });
  }
}
