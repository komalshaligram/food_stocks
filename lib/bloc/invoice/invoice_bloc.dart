import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/model/invoice_model/invoice_model.dart';

part 'invoice_state.dart';
part 'invoice_event.dart';
part 'invoice_bloc.freezed.dart';


class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  InvoiceBloc() : super(InvoiceState.initial()) {
    on<InvoiceEvent>((event, emit) async {

    });
  }
}