import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../data/model/res_model/get_all_cart_res_model/get_all_cart_res_model.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/themes/app_constants.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/req_model/get_order_count/get_order_count_req_model.dart';
import '../../data/model/req_model/wallet_record_req/wallet_record_req_model.dart';
import '../../data/model/res_model/order_count/get_order_count_res_model.dart';
import '../../data/model/res_model/wallet_record_res/wallet_record_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../../ui/utils/themes/app_urls.dart';

part 'order_successful_event.dart';

part 'order_successful_state.dart';

part 'order_successful_bloc.freezed.dart';

class OrderSuccessfulBloc extends Bloc<OrderSuccessfulEvent, OrderSuccessfulState> {
  OrderSuccessfulBloc() : super(OrderSuccessfulState.initial()) {
    on<OrderSuccessfulEvent>((event, emit) async {
      if (event is _getDataEvent) {
        emit(state.copyWith(seePreviousBtn: event.showPreviousBtn));
      }

      if (event is _celebrationEvent) {
        await Future.delayed(const Duration(milliseconds: 2000));
        emit(state.copyWith(duringCelebration: false));
      }
    });
  }
}
