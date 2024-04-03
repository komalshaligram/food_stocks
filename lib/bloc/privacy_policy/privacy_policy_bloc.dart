import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/themes/app_colors.dart';
import '../../ui/utils/themes/app_constants.dart';
import '../../ui/utils/themes/app_styles.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
part 'privacy_policy_state.dart';
part 'privacy_policy_event.dart';
part 'privacy_policy_bloc.freezed.dart';


class PrivacyPolicyBloc extends Bloc<PrivacyPolicyEvent, PrivacyPolicyState> {
  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  ui.Image? image;


  PrivacyPolicyBloc() : super(PrivacyPolicyState.initial()) {
    final Uint8List? documentBytes;

    on<PrivacyPolicyEvent>((event, emit)   async {
      SharedPreferencesHelper preferencesHelper =
      SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
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
            }else if(formField.name=='Signature'){
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
      else if(event is _getPdfDataEvent){
        Uint8List pdf = base64.decode(event.pdfData);
        emit(state.copyWith(pdfDataBytes: pdf));
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
                 _saveSignature(formField, context);
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


  void _saveSignature(PdfSignatureFormField formField,
      BuildContext context) async {
    Uint8List? _documentBytes;
    image = await _signaturePadKey.currentState!.toImage(pixelRatio: 3.0);
    final ByteData? imageBytes =
    await image?.toByteData(format: ui.ImageByteFormat.png);

    final bytes = await image?.toByteData(format: ui.ImageByteFormat.png);
    final ByteData docBytes = await rootBundle.load("assets/images/pdf-conversion-services.pdf");
    final Uint8List documentBytes = docBytes.buffer.asUint8List();

    //ByteData certBytes = await rootBundle.load("assets/certificate.pfx");
   // final Uint8List certificateBytes = certBytes.buffer.asUint8List();

    if (imageBytes != null) {
      final Uint8List data = imageBytes.buffer.asUint8List();
      formField.signature = data;
      PdfDocument document = PdfDocument(inputBytes: documentBytes);
      PdfPage page = document.pages[0];

      PdfSignatureField _signatureField = PdfSignatureField(page, 'signature',
        borderColor:PdfColor(1,1,1,1),
        signature: PdfSignature(

        ),

         );
      PdfGraphics? graphics = _signatureField.appearance.normal.graphics;
      graphics?.drawImage(PdfBitmap(bytes!.buffer.asUint8List()),
          const Rect.fromLTWH(50, 200, 250, 200));

      //Add a signature field to the form.
       document.form.fields.add(_signatureField);
    document.form.flattenAllFields();
      _documentBytes = Uint8List.fromList(document.saveSync());
      emit(state.copyWith(documentBytes: _documentBytes));
      document.dispose();

    }
  }




}