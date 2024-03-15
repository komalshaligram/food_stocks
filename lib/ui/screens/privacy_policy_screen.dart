import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import '../../bloc/privacy_policy/privacy_policy_bloc.dart';
import '../../routes/app_routes.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_styles.dart';
import '../widget/custom_button_widget.dart';


class PrivacyPolicyRoute {
  static Widget get route => PrivacyPolicyScreen();
}


class PrivacyPolicyScreen extends StatelessWidget {
  PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PrivacyPolicyBloc(),
      child: PrivacyPolicyWidget(),
    );
  }
}

class PrivacyPolicyWidget extends StatefulWidget {
  PrivacyPolicyWidget({super.key});

  @override
  State<PrivacyPolicyWidget> createState() => _PrivacyPolicyWidgetState();
}

class _PrivacyPolicyWidgetState extends State<PrivacyPolicyWidget> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  final PdfViewerController _pdfViewerController = PdfViewerController();

  List<PdfFormField>? _formFields;

  ui.Image? image;

  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        surfaceTintColor: AppColors.whiteColor,
        leading: GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                  context, RouteDefine.activityTimeScreen.name);
            },
            child: const Icon(Icons.arrow_back_ios, color: Colors.black)),
        title: Align(
          alignment:
          context.rtl ? Alignment.centerRight : Alignment.centerLeft,
          child: Text(
            AppLocalizations.of(context)!.privacy_policy,
            style: AppStyles.rkRegularTextStyle(
              size: AppConstants.smallFont,
              color: Colors.black,
            ),
          ),
        ),
        backgroundColor: AppColors.whiteColor,
        titleSpacing: 0,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: AppColors.whiteColor,
              height: getScreenHeight(context) - 170,
              child: SfPdfViewer.network(
                'https://5.imimg.com/data5/SELLER/Doc/2021/4/QI/LK/YD/7115850/pdf-conversion-services.pdf',
                key: _pdfViewerKey,
                controller: _pdfViewerController,
                onFormFieldFocusChange: onFormFieldFocusChange,
                onDocumentLoaded: onDocumentLoaded,
                canShowSignaturePadDialog: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: CustomButtonWidget(
                buttonText: AppLocalizations.of(context)!
                    .next
                    .toUpperCase(),
                bGColor: AppColors.whiteColor,
                onPressed: () {
                  if (image != null) {
                    Navigator.pushNamed(
                        context, RouteDefine.fileUploadScreen.name);
                  }
                },
                fontColors: AppColors.whiteColor,
              ),
            ),
          ],
        ),
      ),

    );
  }

  void onDocumentLoaded(PdfDocumentLoadedDetails details) {
    _formFields = _pdfViewerController.getFormFields();
  }

  Future<void> onFormFieldFocusChange(
      PdfFormFieldFocusChangeDetails details) async {
    final PdfFormField formField = details.formField;
    print('formField.name:${formField.name}');
    if (details.hasFocus) {
      final PdfSignatureFormField signatureFormField =
      details.formField as PdfSignatureFormField;
      showCustomSignaturePadDialog(signatureFormField, context);

      if (formField is PdfTextFormField && formField.name == 'Fordm Date') {
        final DateTime? selectedDate = await showDatePicker(
          context: context,
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

  /// Saves the image from the signature pad to the form field.
  Future<void> _saveSignature(PdfSignatureFormField formField,
      BuildContext context) async {
    image =
    await _signaturePadKey.currentState!.toImage(pixelRatio: 3.0);
    final ByteData? imageBytes =
    await image?.toByteData(format: ui.ImageByteFormat.png);
    if (imageBytes != null) {
      final Uint8List data = imageBytes.buffer.asUint8List();
      formField.signature = data;
    }
  }
}

