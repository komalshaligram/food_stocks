import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'credit_card_details_state.dart';
part 'credit_card_details_event.dart';
part 'credit_card_details_bloc.freezed.dart';


class CreditCardDetailsBloc extends Bloc<CreditCardDetailsEvent, CreditCardDetailsState> {
  CreditCardDetailsBloc() : super(CreditCardDetailsState.initial()) {
    on<CreditCardDetailsEvent>((event, emit) async {
  if(event is _getArgumentEvent){
    emit(state.copyWith(isPaymentFail: event.isPaymentFail));
  }
    });
  }
}