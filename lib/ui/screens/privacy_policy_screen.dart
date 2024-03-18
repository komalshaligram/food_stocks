import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
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


  @override
  Widget build(BuildContext context) {
    PrivacyPolicyBloc bloc= context.read<PrivacyPolicyBloc>();
    return BlocListener<PrivacyPolicyBloc, PrivacyPolicyState>(
      listener: (context, state) {

      },
      child: BlocBuilder<PrivacyPolicyBloc, PrivacyPolicyState>(
        builder: (context, state) {
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
                       bloc.add(PrivacyPolicyEvent.navigationEvent(context: context)) ;
                      },
                      fontColors: AppColors.whiteColor,
                    ),
                  ),
                ],
              ),
            ),

          );
        },
      ),
    );
  }

  void onDocumentLoaded(PdfDocumentLoadedDetails details) {
    _formFields = _pdfViewerController.getFormFields();
  }

  Future<void> onFormFieldFocusChange(
      PdfFormFieldFocusChangeDetails details) async {
    context.read<PrivacyPolicyBloc>().add(
        PrivacyPolicyEvent.onFormFieldFocusChangeEvent(
            context: context, details: details));
  }


}

