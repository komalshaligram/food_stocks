
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/model/req_model/terms_condition/terms_condition_req_model.dart';

part 'way_of_payment_state.dart';
part 'way_of_payment_event.dart';
part 'way_of_payment_bloc.freezed.dart';


class WayOfPaymentBloc extends Bloc<WayOfPaymentEvent, WayOfPaymentState> {
  WayOfPaymentBloc() : super(WayOfPaymentState.initial()) {
    on<WayOfPaymentEvent>((event, emit) async {

      if(event is _radioButtonEvent){
        emit(state.copyWith(selectRadioTile: event.selectRadioTile));
      }
      else if(event is _getArgumentEvent){
        debugPrint('event.termsReqModel:${event.termsReqModel}');
        emit(state.copyWith(isUpdate: event.isUpdate,termsReqModel: event.termsReqModel));
      }

    });
  }
}