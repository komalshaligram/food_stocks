import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../bloc/privacy_policy/privacy_policy_bloc.dart';
import '../../data/model/req_model/terms_condition/terms_condition_req_model.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_strings.dart';
import '../utils/themes/app_styles.dart';
import '../widget/custom_button_widget.dart';


class PrivacyPolicyRoute {
  static Widget get route => const PrivacyPolicyScreen();
}

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args =
    ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
      create: (context) => PrivacyPolicyBloc()..add(PrivacyPolicyEvent.getPdfDataEvent(
          context: context, pdfData: args?[AppStrings.privacyPolicyPdfString] ?? '',
          termsConditionReqModel: args?[AppStrings.termsConditionParamString] ?? const TermsConditionReqModel()
      )),
      child:  const PrivacyPolicyWidget(),
    );
  }
}

class PrivacyPolicyWidget extends StatefulWidget {
  const PrivacyPolicyWidget({super.key});

  @override
  State<PrivacyPolicyWidget> createState() => _PrivacyPolicyWidgetState();
}

class _PrivacyPolicyWidgetState extends State<PrivacyPolicyWidget> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  final PdfViewerController _pdfViewerController = PdfViewerController();

  ui.Image? image;
  bool isImage = false;
  PdfFormFieldFocusChangeDetails? details;

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
                    Navigator.pop(context);
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
                    height: getScreenHeight(context) - (state.isOwner2Available ?
                    getScreenHeight(context) * 0.35 : getScreenHeight(context) * 0.28
                    ),
                    child: state.pdfPath.isNotEmpty ? SfPdfViewer.memory(
                      state.pdfPath,
                      key: _pdfViewerKey,
                      controller: _pdfViewerController,
                      canShowSignaturePadDialog: true,
                    ) : const CupertinoActivityIndicator(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 3),
                    child: Row(
                      mainAxisAlignment: state.isGuarantee1Available?MainAxisAlignment.spaceBetween:MainAxisAlignment.center,
                      children: [
                        CustomButtonWidget(
                          fontSize:AppConstants.font_13,
                          buttonText: AppLocalizations.of(context)!
                              .owner1_sign
                              .toCapitalized(),
                          height: 45,
                          bGColor: AppColors.whiteColor,
                          width: getScreenWidth(context)/2.2,
                          onPressed: () {
                            bloc.add(PrivacyPolicyEvent.signatureEvent(context: context,
                                fieldName: AppStrings.owner1SignatureString,
                                fieldNameForSign: AppLocalizations.of(context)!
                                    .owner1_sign
                            ));
                          },
                          fontColors: AppColors.whiteColor,
                        ),
                        state.isGuarantee1Available?CustomButtonWidget(
                          fontSize:AppConstants.font_13,
                          buttonText: AppLocalizations.of(context)!
                              .guarantee1_sign
                              .toCapitalized(),
                          height: 45,
                          bGColor: AppColors.whiteColor,
                          width: getScreenWidth(context)/2.2,
                          onPressed: () {
                            bloc.add(PrivacyPolicyEvent.signatureEvent(context: context,
                                fieldName: AppStrings.guarantee1SignatureString,
                                fieldNameForSign: AppLocalizations.of(context)!.guarantee1_sign
                            ));
                          },
                          fontColors: AppColors.whiteColor,
                        ):const SizedBox(),
                      ],
                    ),
                  ),
                  state.isOwner2Available ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButtonWidget(
                          fontSize:AppConstants.font_13,
                          buttonText: AppLocalizations.of(context)!
                              .owner2_sign
                              .toCapitalized(),
                          height: 45,
                          bGColor: AppColors.whiteColor,
                          width: getScreenWidth(context)/2.2,
                          onPressed: () {
                            bloc.add(PrivacyPolicyEvent.signatureEvent(context: context,
                                fieldName: AppStrings.owner2SignatureString,
                                fieldNameForSign: AppLocalizations.of(context)!
                                    .owner2_sign
                            ));
                          },
                          fontColors: AppColors.whiteColor,
                        ),
                        CustomButtonWidget(
                          fontSize:AppConstants.font_13,
                          buttonText: AppLocalizations.of(context)!
                              .guarantee2_sign
                              .toCapitalized(),
                          height: 45,
                          bGColor: AppColors.whiteColor,
                          width: getScreenWidth(context)/2.2,
                          onPressed: () {
                            bloc.add(PrivacyPolicyEvent.signatureEvent(context: context,
                                fieldName: AppStrings.guarantee2SignatureString,
                                fieldNameForSign: AppLocalizations.of(context)!
                                    .guarantee2_sign
                            ));
                          },
                          fontColors: AppColors.whiteColor,
                        ),

                      ],
                    ),
                  ) : const SizedBox(),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: CustomButtonWidget(
                      height: 50,
                      buttonText: AppLocalizations.of(context)!
                          .next
                          .toUpperCase(),
                      bGColor: AppColors.whiteColor,
                      enable: state.isNextEnable,
                      isLoading: state.isShimmering,
                      onPressed: () {
                        bloc.add(PrivacyPolicyEvent.navigationEvent(context: context,
                        ));
                      },
                      fontColors: AppColors.whiteColor,
                    ),
                  ) ,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}