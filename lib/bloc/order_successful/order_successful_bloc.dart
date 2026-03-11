import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/model/res_model/get_all_cart_res_model/get_all_cart_res_model.dart';
import '../../data/model/res_model/setting_res_model/setting_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_constants.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/utils/constants/app_urls.dart';

part 'order_successful_event.dart';
part 'order_successful_state.dart';
part 'order_successful_bloc.freezed.dart';

class OrderSuccessfulBloc extends Bloc<OrderSuccessfulEvent, OrderSuccessfulState> {
  String message = '';
  OrderSuccessfulBloc() : super(OrderSuccessfulState.initial()) {
    on<OrderSuccessfulEvent>((event, emit) async {
      SharedPreferencesHelper preferences = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

      message = preferences.getMessage();

      if (event is _getDataEvent) {
        emit(state.copyWith(
          seePreviousBtn: event.showPreviousBtn,
          totalSupplier: event.totalSupplier!,
        ));

        add(OrderSuccessfulEvent.getAllCartEvent(
          context: event.context,
        ));
      } else if (event is _generalSettings) {
        try {
          final res = await DioClient(event.context).get(path: AppUrlEndPoints.generalSettingUrl);
          SettingResModel response = SettingResModel.fromJson(res);
          if (response.status == AppConstants.code_200) {
            if (preferences.getAppOnMaintenance() && !(response.data?.isAppOnMaintenance ?? false)) {
              preferences.setIsAppOnMaintenance(isAppOnMaintenance: false);

              return;
            }

            preferences.setIsIncludedVat(isIncludedVat: (response.data?.showVatApplication?.contains(AppStrings.appName) ?? false) ? true : false);
          }
        } catch (e) {
          CustomSnackBar.showSnackBar(context: event.context, title: e.toString(), type: SnackBarType.failure);
        }
      }

      if (event is _celebrationEvent) {
        await Future.delayed(const Duration(milliseconds: 2000));
        emit(state.copyWith(duringCelebration: false));
      }

      if (event is _getAllCartEvent) {
        try {
          final res = await DioClient(event.context).post(
            '${AppUrlEndPoints.getAllCartUrl}${preferences.getCartId()}',
          );

          GetAllCartResModel response = GetAllCartResModel.fromJson(res);
          if (response.status == AppConstants.code_200) {
            emit(state.copyWith(
              cartItemList: response,
            ));

            emit(state.copyWith(
              vatPercentage: response.data!.vatPercentage?.toDouble() ?? 0.0,
              bottleQty: response.data?.cart?.first.bottleQuantities,
              bottleTax: response.data?.bottleTax ?? 0,
              totalPayment: response.data?.cart?.first.totalAmount!.toDouble() ?? 0,
            ));
          }
        } catch(_) {}
      }

      if (event is _goToOrderEvent) {
        if (state.totalSupplier != 1 || state.totalSupplier != 0 || state.totalSupplier != -1) {
          Navigator.pushReplacementNamed(
            event.context,
            RouteDefine.orderSummaryScreen.name,
            arguments: {
              AppStrings.getCartListString: state.cartItemList,
              AppStrings.totalAmountString: state.isIncludedVat
                  ? formatNumber(
                      value: (state.totalPayment +
                              (bottleDepositCalculationWithVat(
                                deposit: state.bottleTax,
                                qty: state.bottleQty?.toDouble() ?? 0,
                                vatPercentage: state.vatPercentage,
                              )))
                          .toString(),
                      local: AppStrings.hebrewLocal,
                    )
                  : (formatNumber(
                      value: vatCalculation(
                        price: state.totalPayment,
                        vat: state.vatPercentage,
                        qty: state.bottleQty?.toDouble() ?? 0,
                        deposit: state.bottleTax,
                      ).toStringAsFixed(2),
                      local: AppStrings.hebrewLocal,
                    )),
              AppStrings.isbackString: 'Basket'
            },
          );
        } else {
          Navigator.pushReplacementNamed(
            event.context,
            RouteDefine.bottomNavScreen.name,
            arguments: {
              AppStrings.pushNavigationString: 'basketScreen',
            },
          );
        }
      }
    });
  }
}
