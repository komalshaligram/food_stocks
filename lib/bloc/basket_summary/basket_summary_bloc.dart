import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/model/res_model/setting_res_model/setting_res_model.dart';
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

part 'basket_summary_event.dart';

part 'basket_summary_state.dart';

part 'basket_summary_bloc.freezed.dart';

class BasketSummaryBloc extends Bloc<BasketSummaryEvent, BasketSummaryState> {
  BasketSummaryBloc() : super(BasketSummaryState.initial()) {
    on<BasketSummaryEvent>((event, emit) async {
      SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

      if (event is _getDataEvent) {
        emit(state.copyWith(cartItemList: event.cartItemList, language: preferencesHelper.getAppLanguage()));
        try {
          final res = await DioClient(event.context).post(
            '${AppUrlEndPoints.listingCartProductsSupplierUrl}${preferencesHelper.getCartId()}',
          );
          CartProductsSupplierResModel response = CartProductsSupplierResModel.fromJson(res);

          if (response.status == AppConstants.code_200) {
            if (event.isSupplierSingle == 'No' && (response.data?.data?.any((supplier) => supplier.id == event.orderBySupplierId) ?? false)) {
              final filteredList = response.data?.data?.where((supplier) => supplier.id == event.orderBySupplierId).toList();

              emit(
                state.copyWith(orderSummaryList: response, tempList: filteredList ?? [], totalSupplier: event.totalSupplier!),
              );
            } else {
              emit(state.copyWith(
                orderSummaryList: response,
                tempList: response.data?.data ?? [],
              ));
            }
          } else {
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
              type: SnackBarType.failure,
            );
          }
        } on ServerException {}
      } else if (event is _generalSettings) {
        try {
          emit(state.copyWith(retryLoading: event.isRetryLoading));
          final res = await DioClient(event.context).get(path: AppUrlEndPoints.generalSettingUrl);
          SettingResModel response = SettingResModel.fromJson(res);
          if (response.status == AppConstants.code_200) {
            if (preferencesHelper.getAppOnMaintenance() && !(response.data?.isAppOnMaintenance ?? false)) {
              add(BasketSummaryEvent.updateMaintenanceEvent(context: event.context));
              Navigator.pop(event.dialogContext);
              preferencesHelper.setIsAppOnMaintenance(isAppOnMaintenance: false);
              emit(state.copyWith(isDialogOpen: false, isAppOnMaintenance: false, retryLoading: false, updatePaymentMethod: false));
              return;
            } else {
              if (!state.isDialogOpen && !(response.data?.isAppOnMaintenance ?? false)) {
                emit(state.copyWith(isDialogOpen: true));
              } else {
                emit(state.copyWith(isDialogOpen: false));
              }
            }
            preferencesHelper.setIsSaleOn(isSaleOn: response.data?.isSaleOn ?? false);
            preferencesHelper.setIsIncludedVat(isIncludedVat: (response.data?.showVatApplication?.contains(AppStrings.appName) ?? false) ? true : false);
            preferencesHelper.setBottleTax(bottleDeposit: response.data?.bottlePrice ?? 0.0);
            preferencesHelper.setIsAppOnMaintenance(isAppOnMaintenance: response.data?.isAppOnMaintenance ?? false);

            emit(state.copyWith(language: preferencesHelper.getAppLanguage(), isSubUserCanCreateOrder: preferencesHelper.getCanCreateOrder(), isIncludedVat: preferencesHelper.getIsIncludedVat(), isSaleOn: preferencesHelper.getShowSale(), retryLoading: false, bankTransferInfo: preferencesHelper.getBankTransferDetail(), isAppOnMaintenance: preferencesHelper.getAppOnMaintenance()));
          } else {}
        } catch (e) {
          CustomSnackBar.showSnackBar(context: event.context, title: e.toString(), type: SnackBarType.failure);
        }
      }

      if (event is _orderSendEvent) {
        List<Product> productReqMap = [];

        state.tempList[state.index].productDetails?.forEach((product) {
          productReqMap.add(Product(productId: product.id, supplierId: state.tempList[state.index].suppliers?.id, quantity: product.quantity ?? 0));
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
                printData("come here if");

                emit(state.copyWith(totalSupplier: state.totalSupplier - 1));

                Navigator.pushNamed(event.context, RouteDefine.orderSuccessfulScreen.name, arguments: {
                  AppStrings.showPreviousBtn: state.totalSupplier == 0 || state.totalSupplier == -1 ? false : true,
                  AppStrings.totalSupplier: state.totalSupplier,
                });
              } else {
                printData("come here else");
                final res = await DioClient(event.context).post(
                  '${AppUrlEndPoints.getAllCartUrl}${preferencesHelper.getCartId()}',
                );
                GetAllCartResModel response = GetAllCartResModel.fromJson(res);
                emit(state.copyWith(cartItemList: response));
                Navigator.pushNamed(event.context, RouteDefine.orderSuccessfulScreen.name, arguments: {AppStrings.showPreviousBtn: true});
              }
            } on ServerException {}
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
        add(BasketSummaryEvent.orderSendEvent(context: event.context, paymentMethod: AppStrings.bankTransfer, failPayment: false));
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
        } on ServerException {}
      } else if (event is _refreshEvent) {
        emit(state.copyWith(isOrderPending: false, isPaymentFail: false, updatePaymentMethod: false));
      }
    });
  }
}
