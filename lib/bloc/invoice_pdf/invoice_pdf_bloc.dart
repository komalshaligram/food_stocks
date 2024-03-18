import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/model/invoice_model/invoice_model.dart';

part 'invoice_pdf_state.dart';
part 'invoice_pdf_event.dart';
part 'invoice_pdf_bloc.freezed.dart';


class InvoicePdfBloc extends Bloc<InvoicePdfEvent, InvoicePdfState> {
  InvoicePdfBloc() : super(InvoicePdfState.initial()) {
    on<InvoicePdfEvent>((event, emit) async {
       if(event is _getArgumentEvent){
         emit(state.copyWith(invoiceDetailsList: event.invoiceDetailsList));
       }
    });
  }
}