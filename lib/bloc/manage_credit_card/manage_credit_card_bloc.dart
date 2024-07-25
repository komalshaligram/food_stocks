import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'manage_credit_card_event.dart';
part 'manage_credit_card_state.dart';
part 'manage_credit_card_bloc.freezed.dart';


class ManageCreditCardBloc extends Bloc<ManageCreditCardEvent, ManageCreditCardState> {
  ManageCreditCardBloc() : super(ManageCreditCardState.initial()) {
    on<ManageCreditCardEvent>((event, emit) async {
      if(event is _getCreditCardInfoEvent){

      }
    });
  }
}