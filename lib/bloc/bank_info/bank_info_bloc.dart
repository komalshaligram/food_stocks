import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bank_info_event.dart';
part 'bank_info_state.dart';
part 'bank_info_bloc.freezed.dart';


class BankInfoBloc extends Bloc<BankInfoEvent, BankInfoState> {
  BankInfoBloc() : super(BankInfoState.initial()) {
    on<BankInfoEvent>((event, emit) async {

    });
  }
}