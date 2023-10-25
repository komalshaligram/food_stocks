import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/model/order_model/supplier_details_model.dart';

part 'order_summary_event.dart';

part 'order_summary_state.dart';

part 'order_summary_bloc.freezed.dart';

class OrderSummaryBloc extends Bloc<OrderSummaryEvent, OrderSummaryState> {
  OrderSummaryBloc() : super(OrderSummaryState.initial()) {
    on<OrderSummaryEvent>((event, emit) {});
  }
}
