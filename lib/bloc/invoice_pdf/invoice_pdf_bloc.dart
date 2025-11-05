import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/model/res_model/invoices_res/invoices_res_model.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_strings.dart';

part 'invoice_pdf_state.dart';
part 'invoice_pdf_event.dart';
part 'invoice_pdf_bloc.freezed.dart';


class InvoicePdfBloc extends Bloc<InvoicePdfEvent, InvoicePdfState> {
  String screenTitleName = '';
  InvoicePdfBloc() : super(InvoicePdfState.initial()) {

    on<InvoicePdfEvent>((event, emit) async {


       if(event is _getArgumentEvent){


         final args = ModalRoute.of(event.context)!.settings.arguments as Map<String, dynamic>;
         screenTitleName = args[AppStrings.invoiceTitleNameString ] as String;

         emit(state.copyWith(invoiceDetailsList: event.invoiceDetailsList));
       }
       }
    );
  }
}