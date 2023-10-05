import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'store_event.dart';
part 'store_state.dart';
part 'store_bloc.freezed.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  StoreBloc() : super(const StoreState.initial()) {
    on<StoreEvent>((event, emit) {
    });
  }
}
