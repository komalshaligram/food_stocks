import 'package:bloc/bloc.dart';
import 'package:food_stock/data/model/wallet_model/wallet_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_event.dart';
part 'wallet_state.dart';
part 'wallet_bloc.freezed.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc() : super( WalletState.initial()) {
    on<WalletEvent>((event, emit) {
          if(event is _dropDownEvent){
            emit(state.copyWith(date: event.date));
          }
    });
  }
}
