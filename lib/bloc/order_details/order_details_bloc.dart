

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_stock/data/model/res_model/get_order_by_id/get_order_by_id_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/error/exceptions.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../../ui/utils/themes/app_urls.dart';

part 'order_details_event.dart';

part 'order_details_state.dart';

part 'order_details_bloc.freezed.dart';

class OrderDetailsBloc extends Bloc<OrderDetailsEvent, OrderDetailsState> {
  OrderDetailsBloc() : super(OrderDetailsState.initial()) {
    on<OrderDetailsEvent>((event, emit) async {
      SharedPreferencesHelper preferencesHelper =
          SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
      if (event is _getOrderByIdEvent) {
        debugPrint('token___${preferencesHelper.getAuthToken()}');
        debugPrint('id___${event.orderId}');
        try {
          final res = await DioClient(event.context).get(
              path: '${AppUrls.getOrderById}${event.orderId}',
       );

          debugPrint(
              'GetOrderById url   = ${AppUrls.getOrderById}${event.orderId}');
          debugPrint('GetOrderByIdModel  = $res');
          GetOrderByIdModel response = GetOrderByIdModel.fromJson(res);
          debugPrint('GetOrderByIdModel  = $response');

          if (response.status == 200) {
            emit(state.copyWith(orderByIdList: response));

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
    });
  }

}
