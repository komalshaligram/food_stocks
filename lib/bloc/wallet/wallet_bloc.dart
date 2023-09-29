import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_event.dart';
part 'wallet_state.dart';
part 'wallet_bloc.freezed.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc() : super(const WalletState.initial()) {
    on<WalletEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
