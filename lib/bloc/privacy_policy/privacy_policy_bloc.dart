import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

part 'privacy_policy_state.dart';
part 'privacy_policy_event.dart';
part 'privacy_policy_bloc.freezed.dart';


class PrivacyPolicyBloc extends Bloc<PrivacyPolicyEvent, PrivacyPolicyState> {
  PrivacyPolicyBloc() : super(PrivacyPolicyState.initial()) {
    on<PrivacyPolicyEvent>((event, emit) async {
      if(event is _onFormFieldFocusChangeEvent){
        Future<void>  onFormFieldFocusChange(PdfFormFieldFocusChangeDetails details) async {

          final PdfFormField formField = details.formField;
          print('formField.name:${formField.name}');
          if (details.hasFocus) {
            final PdfSignatureFormField signatureFormField =
            details.formField as PdfSignatureFormField;
            emit(state.copyWith(SignaturePadDialog: true));
          //  showCustomSignaturePadDialog(signatureFormField);

            if (formField is PdfTextFormField && formField.name == 'Fordm Date') {
              final DateTime? selectedDate = await showDatePicker(
                context: event.context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1950),
                lastDate: DateTime.now(),
              );

              if (selectedDate != null) {
                formField.text =
                '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
              }

              FocusManager.instance.primaryFocus?.unfocus();
            }else if(formField.name=='signature'){
              print('signature');
              // _showCustomSignaturePadDialog(formField);
            }
          }
        }
      }

    /*  else if(event is _onDocumentLoadedEvent){
        final PdfFormField formField = details.formField;
        print('formField.name:${formField.name}');
        if (details.hasFocus) {
          final PdfSignatureFormField signatureFormField =
          details.formField as PdfSignatureFormField;
         // showCustomSignaturePadDialog(signatureFormField);

          if (formField is PdfTextFormField && formField.name == 'Fordm Date') {
            final DateTime? selectedDate = await showDatePicker(
              context: event.context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1950),
              lastDate: DateTime.now(),
            );

            if (selectedDate != null) {
              formField.text =
              '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
            }

            FocusManager.instance.primaryFocus?.unfocus();
          } else if (formField.name == 'signature') {
            print('signature');
            // _showCustomSignaturePadDialog(formField);
          }
        }
      }*/

    });
  }
}