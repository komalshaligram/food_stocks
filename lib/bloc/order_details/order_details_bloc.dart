import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_details_event.dart';
part 'order_details_state.dart';
part 'order_details_bloc.freezed.dart';

class OrderDetailsBloc extends Bloc<OrderDetailsEvent, OrderDetailsState> {
  OrderDetailsBloc() : super(const OrderDetailsState.initial()) {
    on<OrderDetailsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
