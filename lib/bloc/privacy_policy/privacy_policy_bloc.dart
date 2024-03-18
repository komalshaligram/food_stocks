import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../../routes/app_routes.dart';
import '../../ui/utils/themes/app_colors.dart';
import '../../ui/utils/themes/app_constants.dart';
import '../../ui/utils/themes/app_styles.dart';
part 'privacy_policy_state.dart';
part 'privacy_policy_event.dart';
part 'privacy_policy_bloc.freezed.dart';


class PrivacyPolicyBloc extends Bloc<PrivacyPolicyEvent, PrivacyPolicyState> {
  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  ui.Image? image;
  PrivacyPolicyBloc() : super(PrivacyPolicyState.initial()) {

    on<PrivacyPolicyEvent>((event, emit) async {
      if(event is _onFormFieldFocusChangeEvent){
          final PdfFormField formField = event.details.formField;
          print('formField.name:${formField.name}');
          if (event.details.hasFocus) {
            final PdfSignatureFormField signatureFormField =
            event.details.formField as PdfSignatureFormField;
            emit(state.copyWith(SignaturePadDialog: true));
            showCustomSignaturePadDialog(signatureFormField,event.context);

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
               showCustomSignaturePadDialog(signatureFormField ,event.context);
            }
          }

      }
      else if(event is _navigationEvent){
        if (image != null) {
          Navigator.pushNamed(
              event.context, RouteDefine.fileUploadScreen.name);
        }
      }
    });
  }



  Future<void> showCustomSignaturePadDialog(PdfSignatureFormField formField,
      BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '${AppLocalizations.of(context)!.signature}',
            textAlign: TextAlign.center,
            style: AppStyles.rkRegularTextStyle(
              size: AppConstants.smallFont,
              color: Colors.black,
            ),
          ),
          titlePadding: const EdgeInsets.all(8),
          contentPadding: const EdgeInsets.all(12),
          content: Container(
            height: 200,
            width: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            child: SfSignaturePad(
              key: _signaturePadKey,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Clears the strokes in the signature pad.
                _signaturePadKey.currentState!.clear();
              },
              child: Text('${AppLocalizations.of(context)!.close}',
                style: AppStyles.rkRegularTextStyle(
                  size: AppConstants.smallFont,
                  color: AppColors.redColor,
                ),),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await _saveSignature(formField, context);
              },
              child: Text('${AppLocalizations.of(context)!.save}',
                style: AppStyles.rkRegularTextStyle(
                  size: AppConstants.smallFont,
                  color: AppColors.mainColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveSignature(PdfSignatureFormField formField,
      BuildContext context) async {
    image = await _signaturePadKey.currentState!.toImage(pixelRatio: 3.0);
    final ByteData? imageBytes =
    await image?.toByteData(format: ui.ImageByteFormat.png);
    if (imageBytes != null) {
      final Uint8List data = imageBytes.buffer.asUint8List();
      formField.signature = data;
    }
  }
}