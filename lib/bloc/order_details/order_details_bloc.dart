import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/model/res_model/get_order_by_id/get_order_by_id_model.dart';
import '../../data/model/res_model/status_info_res_model/status_info_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../ui/utils/constants/app_constants.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/utils/constants/app_urls.dart';

part 'order_details_event.dart';

part 'order_details_state.dart';

part 'order_details_bloc.freezed.dart';

class OrderDetailsBloc extends Bloc<OrderDetailsEvent, OrderDetailsState> {
  OrderDetailsBloc() : super(OrderDetailsState.initial()) {
    on<OrderDetailsEvent>((event, emit) async {
      SharedPreferencesHelper preferences = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

      if (event is _getOrderByIdEvent) {
        try {
          final res = await DioClient(event.context).get(
            path: '${AppUrlEndPoints.getOrderById}${event.orderId}',
          );

          GetOrderByIdModel response = GetOrderByIdModel.fromJson(res);

          final String statusData = preferences.getOrderStatusInfo();
          final List<StatusData> statusList = StatusData.decode(statusData);
          emit(state.copyWith(statusData: statusList, language: preferences.getAppLanguage()));
          if (response.status == AppConstants.code_200) {
            emit(state.copyWith(orderByIdList: response));
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
