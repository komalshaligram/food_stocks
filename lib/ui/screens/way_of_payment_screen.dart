import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../../data/model/req_model/terms_condition/terms_condition_req_model.dart';
import '../../data/model/res_model/my_account_card_invoices_res_model/my_account_card_invoices_res_model.dart';
import '../../ui/widget/sized_box_widget.dart';
import '../../bloc/way_of_payment/way_of_payment_bloc.dart';
import '../../routes/app_routes.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_strings.dart';
import '../utils/constants/app_styles.dart';
import '../widget/common_app_bar.dart';
import '../widget/custom_button_widget.dart';

class WayOfPaymentRoute {
  static Widget get route => const WayOfPaymentScreen();
}

class WayOfPaymentScreen extends StatelessWidget {
  const WayOfPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map?;

    return BlocProvider(
      create: (context) => WayOfPaymentBloc()
        ..add(WayOfPaymentEvent.getArgumentEvent(
          termsReqModel: args?[AppStrings.termsConditionParamString] ??
              const TermsConditionReqModel(),
          isUpdate: args?[AppStrings.isUpdateParamString] ?? false,
        )),
      child: const WayOfPaymentScreenWidget(),
    );
  }
}

class WayOfPaymentScreenWidget extends StatelessWidget {
  const WayOfPaymentScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WayOfPaymentBloc, WayOfPaymentState>(
        builder: (context, state) {
      final WayOfPaymentBloc bloc = context.read<WayOfPaymentBloc>();
      return Scaffold(
        backgroundColor: AppColors.pageColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
          child: CommonAppBar(
            bgColor: AppColors.pageColor,
            title: AppLocalizations.of(context)!.way_of_payment,
            iconData: Icons.arrow_back_ios_new_rounded,
            trailingWidget: _buildAppBarIcon(),
            onTap: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (state.isEnablePayment) ...[
                _buildPaymentCard(
                  context: context,
                  bloc: bloc,
                  radioValue: 0,
                  selected: state.selectRadioTile == 0,
                  icon: Icons.account_balance_outlined,
                  iconColor: AppColors.mainColor,
                  title: AppLocalizations.of(context)!.payment_bank_title,
                  subtitle: AppLocalizations.of(context)!.payment_bank_subtitle,
                ),
                12.height,
                _buildPaymentCard(
                  context: context,
                  bloc: bloc,
                  radioValue: 1,
                  selected: state.selectRadioTile == 1,
                  icon: Icons.credit_card_rounded,
                  iconColor: AppColors.blueColor,
                  title: AppLocalizations.of(context)!.credit_card,
                  subtitle: AppLocalizations.of(context)!.payment_card_subtitle,
                ),
              ] else
                _buildPaymentCard(
                  context: context,
                  bloc: bloc,
                  radioValue: 0,
                  selected: state.selectRadioTile == 0,
                  icon: Icons.credit_card_rounded,
                  iconColor: AppColors.blueColor,
                  title: AppLocalizations.of(context)!.credit_card,
                  subtitle: AppLocalizations.of(context)!.payment_card_subtitle,
                ),
              18.height,
              _buildSecureNote(context),
            ],
          ),
        ),
        bottomSheet: Container(
          color: AppColors.pageColor,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: CustomButtonWidget(
            isLoading: false,
            buttonText: state.isUpdate
                ? AppLocalizations.of(context)!.save.toUpperCase()
                : AppLocalizations.of(context)!.next.toUpperCase(),
            bGColor: AppColors.mainColor,
            radius: 14,
            onPressed: () {
              if (state.isUpdate) {
                Navigator.pop(context);
              } else {
                if (state.selectRadioTile == 0 && state.isEnablePayment) {
                  Navigator.pushNamed(context, RouteDefine.bankInfoScreen.name,
                      arguments: {
                        AppStrings.termsConditionParamString:
                            state.termsReqModel,
                      });
                } else {
                  Navigator.pushNamed(
                      context, RouteDefine.creditCardDetailsScreen.name,
                      arguments: {
                        AppStrings.termsConditionParamString:
                            state.termsReqModel,
                        AppStrings.isFromRegFlow: true,
                        AppStrings.isPaymentToNext: false,
                        AppStrings.invoiceData: const MyCardInvoice(),
                      });
                }
              }
            },
            fontColors: AppColors.whiteColor,
          ),
        ),
      );
    });
  }

  Widget _buildPaymentCard({
    required BuildContext context,
    required WayOfPaymentBloc bloc,
    required int radioValue,
    required bool selected,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => bloc.add(
            WayOfPaymentEvent.radioButtonEvent(selectRadioTile: radioValue)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: selected ? AppColors.mainColor : AppColors.borderColor,
                width: selected ? 1.6 : 1),
            boxShadow: [
              BoxShadow(
                color: (selected ? AppColors.mainColor : AppColors.shadowColor)
                    .withValues(alpha: selected ? 0.12 : 0.05),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              14.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: AppStyles.rkBoldTextStyle(
                            size: AppConstants.font_17,
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w700)),
                    4.height,
                    Text(subtitle,
                        style: AppStyles.rkRegularTextStyle(
                            size: AppConstants.font_13,
                            color: AppColors.greyColor)),
                  ],
                ),
              ),
              12.width,
              _buildRadio(selected),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadio(bool selected) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
            color: selected ? AppColors.mainColor : AppColors.lightGreyColor,
            width: 2),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: AppColors.mainColor),
              ),
            )
          : null,
    );
  }

  Widget _buildSecureNote(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.blueColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.lock_outline_rounded,
              size: 18, color: AppColors.blueColor.withValues(alpha: 0.8)),
          10.width,
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.payment_secure_note,
              style: AppStyles.rkRegularTextStyle(
                  size: AppConstants.font_13,
                  color: AppColors.blueColor.withValues(alpha: 0.85)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBarIcon() {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          color: AppColors.mainColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12)),
      child:
          Icon(Icons.payments_outlined, size: 21, color: AppColors.mainColor),
    );
  }
}
