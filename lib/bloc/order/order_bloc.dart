import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/req_model/get_all_order_req_model/get_all_order_req_model.dart';
import '../../data/model/res_model/get_all_order_res_model/get_all_order_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_constants.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../../ui/utils/themes/app_urls.dart';

part 'order_event.dart';
part 'order_state.dart';
part 'order_bloc.freezed.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super( OrderState.initial()) {
    on<OrderEvent>((event, emit) async {
      SharedPreferencesHelper preferencesHelper =
      SharedPreferencesHelper(
          prefs: await SharedPreferences.getInstance());
      debugPrint('[token]   ${preferencesHelper.getAuthToken()}');
      //  emit(state.copyWith(isShimmering: true));
      if(event is _getAllOrderEvent){
        if (state.isLoadMore) {
          return;
        }
        if (state.isBottomOfProducts) {
          return;
        }
        try {
          emit(state.copyWith(
              isShimmering: state.pageNum == 0 ? true : false,
              isLoadMore: state.pageNum == 0 ? false : true));

          GetAllOrderReqModel reqMap = GetAllOrderReqModel(
            pageNum: state.pageNum + 1,
            pageLimit: AppConstants.oderPageLimit,
          );
          debugPrint('[getAllOrder req] = $reqMap}');
          final res = await DioClient(event.context).post(
              AppUrls.getAllOrderUrl,
              data: reqMap.toJson(),
          );

          debugPrint('[getAllOrder url]  = ${AppUrls.getAllOrderUrl}');
          GetAllOrderResModel response = GetAllOrderResModel.fromJson(res);
          debugPrint('[getAllOrder res] = $response');

          if (response.status == 200) {
            List<Datum> orderList = state.orderDetailsList.toList(growable: true);
            if ((response.metaData?.totalFilteredCount ?? 1) >
                state.orderDetailsList.length) {
              orderList.addAll(response.data ?? []);
              emit(state.copyWith(orderDetailsList: orderList,
                  isShimmering: false,
                  pageNum: state.pageNum + 1,
                  isLoadMore: false,
                  orderList: response
              ));

              emit(state.copyWith(
                  isBottomOfProducts: orderList.length ==
                          (response.metaData?.totalFilteredCount ?? 0)
                      ? true
                      : false));
            } else {
              emit(state.copyWith(isShimmering: false, isLoadMore: false));
            }

          } else {
            emit(state.copyWith(isLoadMore: false, isShimmering: false));
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(
                    response.message?.toLocalization() ??
                        'something_is_wrong_try_again',
                    event.context),
                type: SnackBarType.FAILURE);
          }
        }  on ServerException {
          emit(state.copyWith(isLoadMore: false));
        }
        state.refreshController.refreshCompleted();
        state.refreshController.loadComplete();
      } else if (event is _RefreshListEvent) {
        emit(state.copyWith(
            pageNum: 0, orderDetailsList: [], isBottomOfProducts: false));
        add(OrderEvent.getAllOrderEvent(context: event.context));
      }

    });
  }

}
