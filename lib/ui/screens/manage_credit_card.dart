import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_detector/focus_detector.dart';
import '../../bloc/manage_credit_card/manage_credit_card_bloc.dart';
import '../../ui/utils/app_utils.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../../ui/utils/constants/app_img_path.dart';
import '../../ui/widget/custom_button_widget.dart';
import '../../ui/widget/sized_box_widget.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_strings.dart';
import '../utils/constants/app_styles.dart';
import '../widget/common_app_bar.dart';
import '../widget/custom_form_field_widget.dart';
import '../widget/manage_credit_card_shimmer.dart';

class ManageCreditCardRoute {
  static Widget get route => const ManageCreditCard();
}

class ManageCreditCard extends StatelessWidget {
  const ManageCreditCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ManageCreditCardBloc()
        ..add(ManageCreditCardEvent.getCreditCardInfoEvent(context: context)),
      child: const ManageCreditCardWidget(),
    );
  }
}

class ManageCreditCardWidget extends StatelessWidget {
  const ManageCreditCardWidget({super.key});

  static const double _horizontalPadding = 16;
  static const double _fieldRadius = 12;

  @override
  Widget build(BuildContext context) {
    ManageCreditCardBloc bloc = context.read<ManageCreditCardBloc>();
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<ManageCreditCardBloc, ManageCreditCardState>(
        builder: (context, state) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.pageColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
          child: CommonAppBar(
            bgColor: AppColors.pageColor,
            title: l10n.manage_credit_card,
            iconData: Icons.arrow_back_ios_new_rounded,
            trailingWidget: _buildAppBarIcon(),
            onTap: () => Navigator.pop(context),
          ),
        ),
        body: FocusDetector(
          onFocusGained: () => bloc.add(
              ManageCreditCardEvent.getCreditCardInfoEvent(context: context)),
          child: state.isLoading
              ? const ManageCreditCardShimmer()
              : SafeArea(
                  child: state.isCreditCardExist
                      ? _buildExistingCardView(context, bloc, state, l10n)
                      : _buildEmptyCardView(context, bloc, l10n),
                ),
        ),
      );
    });
  }

  Widget _buildAppBarIcon() {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: AppColors.mainColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(Icons.credit_card_outlined,
          size: 21, color: AppColors.mainColor),
    );
  }

  Widget _buildExistingCardView(BuildContext context, ManageCreditCardBloc bloc,
      ManageCreditCardState state, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
          _horizontalPadding, 8, _horizontalPadding, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildCreditCardPreview(state),
          20.height,
          _buildFormCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFieldLabel(l10n.credit_card_number),
                _buildReadOnlyField(context, state.creditCardNumberController,
                    AppStrings.creditCardNumberString, TextInputAction.next),
                14.height,
                _buildFieldLabel(l10n.validity),
                _buildReadOnlyField(
                    context,
                    state.validityController,
                    formatExpiryDate(state.validityController.text.toString()),
                    TextInputAction.done),
              ],
            ),
          ),
          24.height,
          CustomButtonWidget(
            buttonText: l10n.change_credit_card,
            bGColor: AppColors.mainColor,
            isLoading: state.isLoading,
            radius: 14,
            onPressed: () => bloc.add(
                ManageCreditCardEvent.addCreditCardEvent(context: context)),
            fontColors: AppColors.whiteColor,
          ),
          12.height,
          _buildDeleteButton(context, bloc, state, l10n),
        ],
      ),
    );
  }

  Widget _buildEmptyCardView(
      BuildContext context, ManageCreditCardBloc bloc, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(_horizontalPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              color: AppColors.mainColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(Icons.credit_card_outlined,
                size: 32, color: AppColors.mainColor),
          ),
          20.height,
          Text(
            l10n.credit_card_not_found,
            textAlign: TextAlign.center,
            style: AppStyles.rkRegularTextStyle(
                size: AppConstants.font_15,
                color: AppColors.blackColor.withValues(alpha: 0.55)),
          ),
          28.height,
          CustomButtonWidget(
            buttonText: l10n.add_credit_card,
            bGColor: AppColors.mainColor,
            radius: 14,
            onPressed: () => bloc.add(
                ManageCreditCardEvent.addCreditCardEvent(context: context)),
            fontColors: AppColors.whiteColor,
          ),
        ],
      ),
    );
  }

  Widget _buildCreditCardPreview(ManageCreditCardState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.appMainGradientColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.mainColor.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Image.asset(AppImagePath.chipIcon,
                height: 44,
                width: 44,
                color: AppColors.whiteColor.withValues(alpha: 0.9)),
          ),
          16.height,
          Text(
            state.creditCardNumberController.text,
            style: AppStyles.rkBoldTextStyle(
                size: AppConstants.font_22, color: AppColors.whiteColor),
          ),
          12.height,
          Text(
            state.validityController.text,
            style: AppStyles.rkRegularTextStyle(
                size: AppConstants.font_15,
                color: AppColors.whiteColor.withValues(alpha: 0.85)),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: AppStyles.rkRegularTextStyle(
          size: AppConstants.font_13,
          color: AppColors.blackColor.withValues(alpha: 0.55),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(
      BuildContext context,
      TextEditingController controller,
      String validator,
      TextInputAction action) {
    return CustomFormField(
      context: context,
      controller: controller,
      keyboardType: TextInputType.text,
      hint: '',
      isEnabled: false,
      fillColor: AppColors.pageColor,
      textInputAction: action,
      validator: validator,
      border: _fieldRadius,
      cursorColor: AppColors.mainColor,
    );
  }

  Widget _buildDeleteButton(BuildContext context, ManageCreditCardBloc bloc,
      ManageCreditCardState state, AppLocalizations l10n) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: state.isDeleteLoading
            ? null
            : () => bloc.add(
                ManageCreditCardEvent.deleteCreditCardEvent(context: context)),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: AppConstants.buttonHeight,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(14),
            border:
                Border.all(color: AppColors.redColor.withValues(alpha: 0.3)),
          ),
          child: state.isDeleteLoading
              ? SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.redColor.withValues(alpha: 0.75)),
                )
              : Text(
                  l10n.delete_credit_card,
                  style: AppStyles.rkRegularTextStyle(
                    size: AppConstants.font_14,
                    color: AppColors.redColor.withValues(alpha: 0.75),
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
      ),
    );
  }
}
