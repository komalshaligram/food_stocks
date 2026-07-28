import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../bloc/privacy_policy/privacy_policy_bloc.dart';
import '../../data/model/req_model/terms_condition/terms_condition_req_model.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_strings.dart';
import '../utils/constants/app_styles.dart';
import '../widget/common_app_bar.dart';
import '../widget/custom_button_widget.dart';
import '../widget/sized_box_widget.dart';

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
      create: (context) => PrivacyPolicyBloc()
        ..add(PrivacyPolicyEvent.getPdfDataEvent(
          context: context,
          pdfData: args?[AppStrings.privacyPolicyPdfString] ?? '',
          termsConditionReqModel: args?[AppStrings.termsConditionParamString] ??
              const TermsConditionReqModel(),
        )),
      child: const PrivacyPolicyWidget(),
    );
  }
}

class PrivacyPolicyWidget extends StatelessWidget {
  const PrivacyPolicyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final PrivacyPolicyBloc bloc = context.read<PrivacyPolicyBloc>();
    return BlocBuilder<PrivacyPolicyBloc, PrivacyPolicyState>(
        builder: (context, state) {
      return Scaffold(
        backgroundColor: AppColors.pageColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
          child: CommonAppBar(
            bgColor: AppColors.pageColor,
            title: AppLocalizations.of(context)!.privacy_policy,
            iconData: Icons.arrow_back_ios_new_rounded,
            trailingWidget: _buildAppBarIcon(),
            onTap: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildAgreementCard(context, state),
              22.height,
              _buildSectionTitle(
                  context, AppLocalizations.of(context)!.signatures_section),
              14.height,
              _buildSignaturesColumn(context, bloc, state),
            ],
          ),
        ),
        bottomSheet: Container(
          color: AppColors.pageColor,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: CustomButtonWidget(
            height: 50,
            radius: 14,
            buttonText: AppLocalizations.of(context)!.next.toUpperCase(),
            bGColor: AppColors.mainColor,
            enable: state.isNextEnable,
            isLoading: state.isShimmering,
            onPressed: () =>
                bloc.add(PrivacyPolicyEvent.navigationEvent(context: context)),
            fontColors: AppColors.whiteColor,
          ),
        ),
      );
    });
  }

  Widget _buildAgreementCard(BuildContext context, PrivacyPolicyState state) {
    final bool pdfReady = state.pdfPath.length > 1;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: AppColors.shadowColor.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                    color: AppColors.saleRedColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.picture_as_pdf_rounded,
                    color: AppColors.saleRedColor, size: 24),
              ),
              12.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.privacy_policy,
                      style: AppStyles.rkBoldTextStyle(
                          size: AppConstants.font_15,
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w700),
                    ),
                    4.height,
                    Text('PDF',
                        style: AppStyles.rkRegularTextStyle(
                            size: AppConstants.font_13,
                            color: AppColors.greyColor)),
                  ],
                ),
              ),
            ],
          ),
          14.height,
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: pdfReady ? () => _openFullPdf(context, state) : null,
              child: Container(
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.blueColor.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppColors.blueColor.withValues(alpha: 0.25)),
                ),
                child: Text(
                  AppLocalizations.of(context)!.read_full_agreement,
                  style: AppStyles.rkBoldTextStyle(
                      size: AppConstants.font_14,
                      color: AppColors.blueColor,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignaturesColumn(
      BuildContext context, PrivacyPolicyBloc bloc, PrivacyPolicyState state) {
    final List<Widget> cards = [
      _buildSignatureCard(
        context: context,
        bloc: bloc,
        title: '${AppLocalizations.of(context)!.owner_sign_label} 1',
        tag: '${AppLocalizations.of(context)!.owner_label} 1',
        signaturePath: state.owner1SignaturePath,
        fieldName: AppStrings.owner1SignatureString,
      ),
      if (state.isOwner2Available)
        _buildSignatureCard(
          context: context,
          bloc: bloc,
          title: '${AppLocalizations.of(context)!.owner_sign_label} 2',
          tag: '${AppLocalizations.of(context)!.owner_label} 2',
          signaturePath: state.owner2SignaturePath,
          fieldName: AppStrings.owner2SignatureString,
        ),
      if (state.isGuarantee1Available)
        _buildSignatureCard(
          context: context,
          bloc: bloc,
          title: AppLocalizations.of(context)!.guarantor_sign_label,
          tag: AppLocalizations.of(context)!.guarantor_label,
          signaturePath: state.guarantee1SignaturePath,
          fieldName: AppStrings.guarantee1SignatureString,
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < cards.length; i++) ...[
          if (i > 0) 14.height,
          cards[i],
        ],
      ],
    );
  }

  Widget _buildSignatureCard({
    required BuildContext context,
    required PrivacyPolicyBloc bloc,
    required String title,
    required String tag,
    required String signaturePath,
    required String fieldName,
  }) {
    final bool signed = signaturePath.isNotEmpty;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: AppColors.shadowColor.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(title,
                  style: AppStyles.rkBoldTextStyle(
                      size: AppConstants.font_15,
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w700)),
              const Spacer(),
              Text(tag,
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.font_13, color: AppColors.greyColor)),
            ],
          ),
          12.height,
          GestureDetector(
            onTap: () => bloc.add(PrivacyPolicyEvent.signatureEvent(
                context: context,
                fieldName: fieldName,
                fieldNameForSign: title)),
            child: signed
                ? Container(
                    height: 120,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: AppColors.mainColor, width: 1.4),
                    ),
                    child: Stack(
                      children: [
                        Center(
                            child: Image.file(File(signaturePath),
                                fit: BoxFit.contain)),
                        Positioned(
                            top: 0,
                            right: 0,
                            child: Icon(Icons.check_circle_rounded,
                                color: AppColors.mainColor, size: 20)),
                      ],
                    ),
                  )
                : DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    color: AppColors.lightGreyColor,
                    dashPattern: const [6, 4],
                    strokeWidth: 1.5,
                    padding: EdgeInsets.zero,
                    child: Container(
                      height: 120,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.tap_to_sign,
                            style: AppStyles.rkRegularTextStyle(
                                size: AppConstants.font_14,
                                color: AppColors.greyColor),
                          ),
                          8.width,
                          const Text('✍️', style: TextStyle(fontSize: 20)),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Row(
      children: [
        Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
                color: AppColors.mainColor,
                borderRadius: BorderRadius.circular(2))),
        8.width,
        Text(title,
            style: AppStyles.rkBoldTextStyle(
                size: AppConstants.smallFont,
                color: AppColors.blackColor,
                fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _buildAppBarIcon() {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          color: AppColors.mainColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12)),
      child: Icon(Icons.description_outlined,
          size: 21, color: AppColors.mainColor),
    );
  }

  void _openFullPdf(BuildContext context, PrivacyPolicyState state) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: AppColors.whiteColor,
          appBar: AppBar(
            backgroundColor: AppColors.whiteColor,
            surfaceTintColor: AppColors.whiteColor,
            elevation: 0.5,
            title: Text(
              AppLocalizations.of(context)!.privacy_policy,
              style: AppStyles.rkRegularTextStyle(
                  size: AppConstants.smallFont, color: AppColors.blackColor),
            ),
            iconTheme: IconThemeData(color: AppColors.blackColor),
          ),
          body: state.pdfPath.length > 1
              ? SfPdfViewer.memory(state.pdfPath)
              : const Center(child: CupertinoActivityIndicator()),
        ),
      ),
    );
  }
}
