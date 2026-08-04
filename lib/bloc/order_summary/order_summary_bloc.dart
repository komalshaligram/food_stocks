import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../ui/utils/constants/app_constants.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/model/res_model/cart_product_supplier/cart_products_supplier_res_model.dart';
import '../../data/model/res_model/get_all_cart_res_model/get_all_cart_res_model.dart';
import '../../data/model/res_model/setting_res_model/setting_res_model.dart';
import '../../data/model/res_model/supplier_city_delivery_schedule_res_model/supplier_city_delivery_schedule_res_model.dart';
import '../../data/services/supplier_delivery_schedule_service.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/utils/constants/app_urls.dart';

part 'order_summary_event.dart';
part 'order_summary_state.dart';
part 'order_summary_bloc.freezed.dart';

class OrderSummaryBloc extends Bloc<OrderSummaryEvent, OrderSummaryState> {
  OrderSummaryBloc() : super(OrderSummaryState.initial()) {
    on<OrderSummaryEvent>((event, emit) async {
      SharedPreferencesHelper preferences = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

      if (event is _getDataEvent) {
        emit(state.copyWith(
            cartItemList: event.cartItemList, language: preferences.getAppLanguage(), total: event.totalAmount, backString: event.backString));
        try {
          final results = await Future.wait([
            DioClient(event.context).post('${AppUrlEndPoints.listingCartProductsSupplierUrl}${preferences.getCartId()}'),
            DioClient(event.context).get(path: AppUrlEndPoints.generalSettingUrl),
          ]);
          CartProductsSupplierResModel response = CartProductsSupplierResModel.fromJson(results[0]);
          if (response.status == AppConstants.code_200) {
            final settingsResponse = SettingResModel.fromJson(results[1]);
            final supplierList = response.data?.data ?? [];
            final supplierIds = supplierList.map((supplier) => supplier.suppliers?.id ?? supplier.id ?? '').toList();
            emit(state.copyWith(
              orderSummaryList: response,
              tempList: supplierList,
              firstSupplierOrderMessageTemplate: settingsResponse.data?.firstSupplierOrderMessageTemplate ?? '',
              isDeliveryScheduleLoading: supplierIds.any((id) => id.isNotEmpty),
            ));
            if (!event.context.mounted) return;
            final schedules = await SupplierDeliveryScheduleService.loadForSuppliers(
              context: event.context,
              supplierIds: supplierIds,
            );
            emit(state.copyWith(
              deliverySchedules: schedules,
              isDeliveryScheduleLoading: false,
            ));
          } else {
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
              type: SnackBarType.failure,
            );
          }
        } catch (_) {}
      }
    });
  }
}
