import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_stock/data/model/res_model/get_order_by_id/get_order_by_id_model.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/error/exceptions.dart';
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

      if (event is _getOrderByIdEvent) {
        try {
          final res = await DioClient(event.context).get(
              path: '${AppUrlEndPoints.getOrderById}${event.orderId}',
       );

          GetOrderByIdModel response = GetOrderByIdModel.fromJson(res);

          if (response.status == AppConstants.code_200) {
            emit(state.copyWith(orderByIdList: response));

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
    });
  }

}
