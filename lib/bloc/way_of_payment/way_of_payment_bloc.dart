import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'way_of_payment_state.dart';
part 'way_of_payment_event.dart';
part 'way_of_payment_bloc.freezed.dart';


class WayOfPaymentBloc extends Bloc<WayOfPaymentEvent, WayOfPaymentState> {
  WayOfPaymentBloc() : super(WayOfPaymentState.initial()) {
    on<WayOfPaymentEvent>((event, emit) async {
      if(event is _radioButtonEvent){
        emit(state.copyWith(selectRadioTile: event.selectRadioTile));
      }

    });
  }
}