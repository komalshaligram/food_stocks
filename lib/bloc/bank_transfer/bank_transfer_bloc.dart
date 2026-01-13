import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/storage/shared_preferences_helper.dart';
part 'bank_transfer_state.dart';
part 'bank_transfer_event.dart';
part 'bank_transfer_bloc.freezed.dart';

class BankTransferBloc extends Bloc<BankTransferEvent, BankTransferState> {
  BankTransferBloc() : super(BankTransferState.initial()) {
    on<BankTransferEvent>((event, emit) async {
      SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
      if (event is _getBankTransferInfoEvent) {
        emit(state.copyWith(
          bankTransferDetails: preferencesHelper.getBankTransferDetail(),
          isLoading: false,
        ));
      }
    });
  }
}
