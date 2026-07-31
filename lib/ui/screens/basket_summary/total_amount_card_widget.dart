import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widget/custom_button_widget.dart';
import '../../widget/common_divider_widget.dart';
import '../../../bloc/basket_summary/basket_summary_bloc.dart';
import 'basket_summary_agent_dialog.dart';
import '../../utils/app_utils.dart';
import '../../utils/constants/app_colors.dart';
import '../../utils/constants/app_constants.dart';
import '../../utils/constants/app_strings.dart';
import '../../utils/constants/app_styles.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../../widget/sized_box_widget.dart';

Widget totalAmountCard(BasketSummaryState state, BuildContext context, int index) {
  BasketSummaryBloc bloc = context.read<BasketSummaryBloc>();

  double remainingRefund = 0.0;
  final isHebrew = Localizations.localeOf(context).languageCode == 'he';
  final rawRefundAmount = state.orderSummaryList.data?.openRefundTotalAmount ?? 0.0;

  final totalOrderAmount = vatCalculation(
      price: double.parse(state.tempList[index].totalAmount.toString()),
      vat: state.tempList[index].vatPercentage ?? 0,
      qty: (state.tempList[index].bottleQuantities ?? 0).toDouble(),
      deposit: (state.tempList[index].bottleTax ?? 0).toDouble());

  final double totalAmount = double.tryParse(state.tempList[index].totalAmount.toString()) ?? 0;
  final adjustedAmount = totalOrderAmount.abs() < rawRefundAmount.abs() ? totalOrderAmount : rawRefundAmount;
  final double refundAmount1 = adjustedAmount.abs();
  final bool isRefundGreater = refundAmount1 > totalAmount;
  final double finalAmount = isRefundGreater ? 0.0 : totalAmount - refundAmount1;
  final double usedDisplayRefund = isRefundGreater ? totalAmount : refundAmount1;
  remainingRefund = isRefundGreater ? rawRefundAmount - totalAmount : 0.0;
  final displayAmount = usedDisplayRefund == 0.0 ? '${usedDisplayRefund.toStringAsFixed(2)}₪' : ' -${usedDisplayRefund.toStringAsFixed(2)}₪';

  return Container(
    alignment: state.language == AppStrings.englishString ? Alignment.centerLeft : Alignment.centerRight,
    padding: const EdgeInsets.only(
        left: AppConstants.padding_10, right: AppConstants.padding_10, top: AppConstants.padding_3, bottom: AppConstants.padding_10),
    margin: const EdgeInsets.symmetric(vertical: AppConstants.padding_5, horizontal: AppConstants.padding_10),
    decoration: BoxDecoration(color: AppColors.whiteColor, borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_5))),
    child: Column(children: [
      state.tempList[index].bottleQuantities! > 0
          ? basketRow(
              state.language == AppStrings.englishString
                  ? '${AppLocalizations.of(context)!.bottle_deposit}${'X'}'
                      '${state.tempList[index].bottleQuantities.toString()}'
                  : '${AppLocalizations.of(context)!.bottle_deposit}${state.tempList[index].bottleQuantities.toString()}${'X'}',
              state.isIncludedVat
                  ? (formatNumber(
                      value: bottleDepositCalculationWithVat(
                              deposit: state.tempList[index].bottleTax!,
                              vatPercentage: state.tempList[index].vatPercentage!,
                              qty: state.tempList[index].bottleQuantities?.toDouble() ?? 0)
                          .toStringAsFixed(2),
                      local: AppStrings.hebrewLocal))
                  : (formatNumber(
                      value: bottleDepositCalculation(
                              deposit: state.tempList[index].bottleTax!, qty: state.tempList[index].bottleQuantities?.toDouble() ?? 0)
                          .toStringAsFixed(2),
                      local: AppStrings.hebrewLocal)))
          : 0.height,
      state.tempList[index].bottleQuantities! > 0 ? const DividerWidget(height: 8.0) : 0.height,
      state.isIncludedVat
          ? const SizedBox()
          : basketRow(
              AppLocalizations.of(context)!.total_amount_subject_to_vat,
              formatNumber(
                  value: double.parse(state.tempList[index].totalAmountSubjectToVat!.toString()).toStringAsFixed(2), local: AppStrings.hebrewLocal)),
      state.isIncludedVat ? const SizedBox() : const DividerWidget(height: 8.0),
      state.isIncludedVat
          ? const SizedBox()
          : basketRow(
              AppLocalizations.of(context)!.total_amount_not_subject_to_vat,
              formatNumber(
                  value: double.parse(state.tempList[index].totalAmountNotSubjectToVat!.toString()).toStringAsFixed(2),
                  local: AppStrings.hebrewLocal)),
      state.isIncludedVat ? const SizedBox() : const DividerWidget(height: 8.0),
      state.isIncludedVat
          ? const SizedBox()
          : basketRow(AppLocalizations.of(context)!.vat, double.parse(state.tempList[index].vatAmount.toString()).toStringAsFixed(2)),
      state.isIncludedVat ? const SizedBox() : const DividerWidget(height: 8.0),
      state.isIncludedVat ? const SizedBox() : basketRow(AppLocalizations.of(context)!.total_refunds, displayAmount),
      state.isIncludedVat ? const SizedBox() : const DividerWidget(height: 8.0),
      state.isIncludedVat
          ? basketRow(AppLocalizations.of(context)!.total_price_with_vat, finalAmount.toStringAsFixed(2), isTitle: true)
          : basketRow(AppLocalizations.of(context)!.total, finalAmount.toStringAsFixed(2), isTitle: true),
      state.isIncludedVat ? const SizedBox() : const DividerWidget(height: 8.0),
      if (remainingRefund > 0)
        Wrap(alignment: WrapAlignment.center, spacing: 4, children: [
          Text(
              isHebrew
                  ? AppLocalizations.of(context)!.refund_amount_1
                  : '${AppLocalizations.of(context)!.refund_amount_1} '
                      '${remainingRefund.toStringAsFixed(2)}${'₪'}',
              style: AppStyles.rkBoldTextStyle(size: AppConstants.font_15, color: AppColors.notificationColor)),
          Text(
              isHebrew
                  ? '${AppLocalizations.of(context)!.refund_amount_2} ${remainingRefund.toStringAsFixed(2)}${'₪'}'
                  : AppLocalizations.of(context)!.refund_amount_2,
              style: AppStyles.rkBoldTextStyle(size: AppConstants.font_15, color: AppColors.notificationColor)),
        ]),
      30.height,
      Text('${AppLocalizations.of(context)!.note} : ${AppLocalizations.of(context)!.not_include_surfaces_price}',
          style: AppStyles.rkRegularTextStyle(size: AppConstants.font_12, color: AppColors.redColor)),
      2.height,
      CustomButtonWidget(
          buttonText: AppLocalizations.of(context)!.submit,
          bGColor: AppColors.mainColor,
          height: 45,
          onPressed: () async {
            if (state.tempList[index].draftReturnExists!) {
              await showDialog(
                  context: context,
                  builder: (_) => BasketSummaryCallAgentDialog(
                      language: state.language, id: state.tempList[index].suppliers?.id ?? '', index: index, bloc: bloc));
            } else {
              bloc.add(BasketSummaryEvent.getSupplierPaymentTypeEvent(context: context, id: state.tempList[index].suppliers?.id ?? '', index: index));
            }
          },
          fontColors: AppColors.whiteColor),
      10.height
    ]),
  );
}

Widget basketRow(String title, String amount, {bool isTitle = false, double fontSize = 15}) {
  return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Text(title, style: AppStyles.rkRegularTextStyle(size: AppConstants.font_15, color: AppColors.blackColor)),
    Directionality(
      textDirection: TextDirection.ltr,
      child: Text(amount,
          style: AppStyles.rkRegularTextStyle(size: fontSize, color: AppColors.blackColor, fontWeight: isTitle ? FontWeight.w700 : FontWeight.w300),
          overflow: TextOverflow.ellipsis),
    ),
  ]);
}


