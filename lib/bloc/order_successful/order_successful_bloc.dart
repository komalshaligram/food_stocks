
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';



part 'order_successful_event.dart';

part 'order_successful_state.dart';

part 'order_successful_bloc.freezed.dart';

class OrderSuccessfulBloc extends Bloc<OrderSuccessfulEvent, OrderSuccessfulState> {
  OrderSuccessfulBloc() : super(OrderSuccessfulState.initial()) {
    on<OrderSuccessfulEvent>((event, emit) {

    });
  }
}

