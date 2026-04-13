import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../data/model/req_model/profile_details_req_model/profile_details_req_model.dart';
import '../../data/model/res_model/profile_details_res_model/profile_details_res_model.dart';
import '../../data/model/res_model/setting_res_model/setting_res_model.dart';
import '../../data/model/res_model/status_info_res_model/status_info_res_model.dart';
import '../../data/model/res_model/supplier_payment_type_res_model/supplier_payment_type_res_model.dart';
import '../../ui/screens/product_details_screen.dart';
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
import '../../data/model/res_model/get_order_by_id/get_order_by_id_model.dart' as orderbyidmodel;
import '../../ui/widget/common_dialog_with_one_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'basket_summary_event.dart';
part 'basket_summary_state.dart';
part 'basket_summary_bloc.freezed.dart';

class BasketSummaryBloc extends Bloc<BasketSummaryEvent, BasketSummaryState> {
  BasketSummaryBloc() : super(BasketSummaryState.initial()) {
    on<BasketSummaryEvent>((event, emit) async {
      SharedPreferencesHelper preferences = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

      if (event is _getDataEvent) {
        emit(state.copyWith(cartItemList: event.cartItemList, language: preferences.getAppLanguage()));
        try {
          final res = await DioClient(event.context).post('${AppUrlEndPoints.listingCartProductsSupplierUrl}${preferences.getCartId()}');
          CartProductsSupplierResModel response = CartProductsSupplierResModel.fromJson(res);

          if (response.status == AppConstants.code_200) {
            add(BasketSummaryEvent.getProfileDetailsEvent(context: event.context));
            if (event.isSupplierSingle == 'No' && (response.data?.data?.any((supplier) => supplier.id == event.orderBySupplierId) ?? false)) {
              final filteredList = response.data?.data?.where((supplier) => supplier.id == event.orderBySupplierId).toList();
              emit(state.copyWith(orderSummaryList: response, tempList: filteredList ?? [], totalSupplier: event.totalSupplier!));
            } else {
              emit(state.copyWith(orderSummaryList: response, tempList: response.data?.data ?? []));
            }
          } else {
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
              type: SnackBarType.failure,
            );
          }
        } catch (_) {}
      } else if (event is _generalSettings) {
        try {
          emit(state.copyWith(retryLoading: event.isRetryLoading));
          final res = await DioClient(event.context).get(path: AppUrlEndPoints.generalSettingUrl);
          SettingResModel response = SettingResModel.fromJson(res);
          if (response.status == AppConstants.code_200) {
            if (preferences.getAppOnMaintenance() && !(response.data?.isAppOnMaintenance ?? false)) {
              add(BasketSummaryEvent.updateMaintenanceEvent(context: event.context));
              Navigator.pop(event.dialogContext);
              preferences.setIsAppOnMaintenance(isAppOnMaintenance: false);
              emit(state.copyWith(isDialogOpen: false, isAppOnMaintenance: false, retryLoading: false, updatePaymentMethod: false));
              return;
            } else {
              if (!state.isDialogOpen && !(response.data?.isAppOnMaintenance ?? false)) {
                emit(state.copyWith(isDialogOpen: true));
              } else {
                emit(state.copyWith(isDialogOpen: false));
              }
            }
            preferences.setIsSaleOn(isSaleOn: response.data?.isSaleOn ?? false);
            preferences.setIsIncludedVat(isIncludedVat: (response.data?.showVatApplication?.contains(AppStrings.appName) ?? false) ? true : false);
            preferences.setBottleTax(bottleDeposit: response.data?.bottlePrice ?? 0.0);
            preferences.setIsAppOnMaintenance(isAppOnMaintenance: response.data?.isAppOnMaintenance ?? false);

            emit(state.copyWith(
              language: preferences.getAppLanguage(),
              isSubUserCanCreateOrder: preferences.getCanCreateOrder(),
              isIncludedVat: preferences.getIsIncludedVat(),
              isSaleOn: preferences.getShowSale(),
              retryLoading: false,
              bankTransferInfo: preferences.getBankTransferDetail(),
              isAppOnMaintenance: preferences.getAppOnMaintenance(),
            ));
          }
        } catch (e) {
          CustomSnackBar.showSnackBar(context: event.context, title: e.toString(), type: SnackBarType.failure);
        }
      }

      if (event is _orderSendEvent) {
        if (state.isLoading) return;
        emit(state.copyWith(isLoading: true));
        List<Product> productReqMap = [];

        state.tempList[state.index].productDetails?.forEach((product) {
          productReqMap.add(Product(productId: product.id, supplierId: state.tempList[state.index].suppliers?.id, quantity: product.quantity ?? 0));
        });

        List<CartProductDataResModel> tempList = [];
        tempList = [...state.tempList];
        tempList[state.index] = tempList[state.index].copyWith(isProcess: true);
        emit(state.copyWith(showPopUp: false, cartItemList: state.cartItemList, tempList: tempList));

        try {
          OrderSendReqModel reqMap = OrderSendReqModel(products: productReqMap, paymentMethod: event.paymentMethod.isNotEmpty ? event.paymentMethod : preferences.getPaymentMethod());
          final res = await DioClient(event.context).post(AppUrlEndPoints.createOrderUrl, data: reqMap);
          OrderSendResModel response = OrderSendResModel.fromJson(res);

          if (response.status == AppConstants.code_201) {
            try {
              tempList[state.index] = tempList[state.index].copyWith(isProcess: false);
              tempList.removeAt(state.index);
              emit(state.copyWith(tempList: tempList));
              if (tempList.isEmpty) {
                emit(state.copyWith(totalSupplier: state.totalSupplier - 1));
                Navigator.pushNamed(event.context, RouteDefine.orderSuccessfulScreen.name, arguments: {
                  AppStrings.showPreviousBtn: state.totalSupplier == 0 || state.totalSupplier == -1 ? false : true,
                  AppStrings.totalSupplier: state.totalSupplier,
                });
              } else {
                final res = await DioClient(event.context).post('${AppUrlEndPoints.getAllCartUrl}${preferences.getCartId()}');
                GetAllCartResModel response = GetAllCartResModel.fromJson(res);
                emit(state.copyWith(cartItemList: response));
                Navigator.pushNamed(event.context, RouteDefine.orderSuccessfulScreen.name, arguments: {AppStrings.showPreviousBtn: true});
              }
            } catch (_) {}
          } else if (response.status == AppConstants.code_402) {
            emit(state.copyWith(
                isRemoveProcess: false,
                isPaymentFail: true,
                isWalletRelatedError: true,
                isLoading: false,
                errorString: response.message!.contains('MESSAGE')
                    ? AppStrings.getLocalizedStrings(
                        response.message?.toLocalization() ?? response.message!,
                        event.context,
                      )
                    : response.message!));
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
              type: SnackBarType.failure,
            );
          } else if (response.status == AppConstants.code_403) {
            tempList[state.index] = tempList[state.index].copyWith(isProcess: false);
            emit(state.copyWith(isLoading: false, tempList: tempList));
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
              type: SnackBarType.failure,
            );
          } else if (response.status == AppConstants.code_405) {
            emit(state.copyWith(isLoading: false, isOrderPending: true, isPaymentFail: false));
            showDialog(
                context: event.context,
                builder: (context1) {
                  return CustomOneButtonDialog(
                      title: AppLocalizations.of(event.context)!.order_sign_dialog,
                      directionality: state.language,
                      positiveOnTap: () async {
                        SharedPreferencesHelper preferences = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
                        try {
                          final res = await DioClient(event.context).get(path: '${AppUrlEndPoints.getLatestOnthewayOrderUrl}${preferences.getUserId()}');
                          orderbyidmodel.GetOrderByIdModel response = orderbyidmodel.GetOrderByIdModel.fromJson(res);
                          final String statusData = preferences.getOrderStatusInfo();
                          final List<StatusData> statusList = StatusData.decode(statusData);
                          Navigator.pop(context1);
                          Navigator.push(
                              event.context,
                              PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => ProductDetailsScreen(
                                        statusList: statusList,
                                        orderNumber: response.data?.orderData?[0].orderNumber.toString() ?? '',
                                        orderId: response.data?.orderData?[0].id ?? '',
                                        isNavigateToProductDetailString: false,
                                        productData: response.data!.ordersBySupplier![0],
                                        orderData: response.data!.orderData![0],
                                      ),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    const begin = Offset(0.0, 1.0);
                                    const end = Offset.zero;
                                    const curve = Curves.bounceIn;
                                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                    return SlideTransition(position: animation.drive(tween), child: child);
                                  }));
                        } catch (e) {
                          CustomSnackBar.showSnackBar(context: event.context, title: e.toString(), type: SnackBarType.failure);
                        }
                      },
                      positiveTitle: AppLocalizations.of(event.context)!.show_order,
                      width: 150,
                      paymentType: 'creditCard');
                });
          } else if (response.status == AppConstants.code_424) {
            emit(state.copyWith(
                isRemoveProcess: false,
                isPaymentFail: true,
                isWalletRelatedError: false,
                isLoading: false,
                errorString: response.message!.contains('MESSAGE')
                    ? AppStrings.getLocalizedStrings(
                        response.message?.toLocalization() ?? response.message!,
                        event.context,
                      )
                    : response.message!));
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
              type: SnackBarType.failure,
            );
          } else {
            tempList[state.index] = tempList[state.index].copyWith(isProcess: false);
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
              type: SnackBarType.failure,
            );
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
          final res = await DioClient(event.context).get(path: '${AppUrlEndPoints.getSupplierPaymentTypesUrl}${event.id}');
          SupplierPaymentTypeResModel response = SupplierPaymentTypeResModel.fromJson(res);
          if (response.status == AppConstants.code_200) {
            tempList[event.index] = tempList[event.index].copyWith(isProcess: false);

            emit(state.copyWith(
              paymentTypesList: response.data?.paymentDetails?.paymentTypes ?? [],
              bankTransferInfo: response.data!.paymentDetails?.bankTransferPopupText ?? '',
              tempList: tempList,
              isDialogOpen: true,
              orderSummaryList: state.orderSummaryList,
              showPopUp: true,
              isLoading: false,
              index: event.index,
            ));
          } else {
            tempList[state.index] = tempList[state.index].copyWith(isProcess: false);
            emit(state.copyWith(isLoading: false, tempList: tempList));
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
              type: SnackBarType.failure,
            );
          }
        } catch (_) {}
      } else if (event is _refreshEvent) {
        emit(state.copyWith(isOrderPending: false, isPaymentFail: false, updatePaymentMethod: false));
      } else if (event is _getProfileDetailsEvent) {
        try {
          final res = await DioClient(event.context).post(AppUrlEndPoints.getProfileDetailsUrl,
              data: ProfileDetailsReqModel(id: preferences.getUserId()).toJson(),
              options: Options(
                headers: {HttpHeaders.authorizationHeader: 'Bearer ${preferences.getAuthToken()}'},
              ));
          ProfileDetailsResModel response = ProfileDetailsResModel.fromJson(res);
          if (response.status == AppConstants.code_200) {
            emit(state.copyWith(
              clubAgentId: preferences.getClubAgentId(),
              isAvailableAllPayments: response.data?.clients?.first.clientDetail?.isAvailableAllPayments ?? false,
            ));
          }
        } catch (_) {}
      }
    });
  }
}
