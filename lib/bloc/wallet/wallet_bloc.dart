import 'package:bloc/bloc.dart';
import 'package:food_stock/data/model/wallet_model/wallet_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/storage/shared_preferences_helper.dart';

part 'wallet_event.dart';

part 'wallet_state.dart';

part 'wallet_bloc.freezed.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc() : super(WalletState.initial()) {
    on<WalletEvent>((event, emit) async {
      SharedPreferencesHelper preferencesHelper =
          SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
      if (event is _dropDownEvent) {
        if (event.index == 1) {
          emit(state.copyWith(date: event.date));
        } else {
          emit(state.copyWith(date1: event.date));
        }
      } else if (event is _checkLanguage) {
        emit(state.copyWith(language: preferencesHelper.getAppLanguage()));
      }
    });
  }
}
