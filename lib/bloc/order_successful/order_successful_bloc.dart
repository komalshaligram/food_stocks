import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/storage/shared_preferences_helper.dart';

part 'order_successful_event.dart';

part 'order_successful_state.dart';

part 'order_successful_bloc.freezed.dart';

class OrderSuccessfulBloc extends Bloc<OrderSuccessfulEvent, OrderSuccessfulState> {
  String message = '';
  OrderSuccessfulBloc() : super(OrderSuccessfulState.initial()) {
    on<OrderSuccessfulEvent>((event, emit) async {

      SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

      message = preferencesHelper.getMessage();

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
