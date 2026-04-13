import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/model/res_model/status_info_res_model/status_info_res_model.dart';
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

part 'order_summary_event.dart';
part 'order_summary_state.dart';
part 'order_summary_bloc.freezed.dart';

class OrderSummaryBloc extends Bloc<OrderSummaryEvent, OrderSummaryState> {
  OrderSummaryBloc() : super(OrderSummaryState.initial()) {
    on<OrderSummaryEvent>((event, emit) async {
      SharedPreferencesHelper preferences = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

      if (event is _getDataEvent) {
        emit(state.copyWith(cartItemList: event.cartItemList, language: preferences.getAppLanguage(), total: event.totalAmount, backString: event.backString));
        try {
          final res = await DioClient(event.context).post('${AppUrlEndPoints.listingCartProductsSupplierUrl}${preferences.getCartId()}');
          CartProductsSupplierResModel response = CartProductsSupplierResModel.fromJson(res);
          if (response.status == AppConstants.code_200) {
            emit(state.copyWith(orderSummaryList: response, tempList: response.data?.data ?? []));
          } else {
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
              type: SnackBarType.failure,
            );
          }
        } catch (_) {}
      }

      if (event is _refreshEvent) {
        emit(state.copyWith(isOrderPending: false, isPaymentFail: false, updatePaymentMethod: false));
      }
    });
  }
}
