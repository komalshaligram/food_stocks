import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/basket_summary/basket_summary_bloc.dart';
import 'basket_summary_agent_dialog.dart';
import '../../utils/app_utils.dart';
import '../../utils/constants/app_colors.dart';
import '../../utils/constants/app_constants.dart';
import '../../utils/constants/app_styles.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../../widget/order_summary_card_widgets.dart';
import '../../widget/sized_box_widget.dart';

List<Widget> totalAmountCardWidget(BasketSummaryState state, BuildContext context, int index) {
  final BasketSummaryBloc bloc = context.read<BasketSummaryBloc>();
  final l10n = AppLocalizations.of(context)!;
  final isHebrew = Localizations.localeOf(context).languageCode == 'he';
  final item = state.tempList[index];

  final rawRefundAmount = state.orderSummaryList.data?.openRefundTotalAmount ?? 0.0;

  final totalOrderAmount = vatCalculation(
      price: double.parse(item.totalAmount.toString()),
      vat: item.vatPercentage ?? 0,
      qty: (item.bottleQuantities ?? 0).toDouble(),
      deposit: (item.bottleTax ?? 0).toDouble());

  final double totalAmount = double.tryParse(item.totalAmount.toString()) ?? 0;
  final adjustedAmount = totalOrderAmount.abs() < rawRefundAmount.abs() ? totalOrderAmount : rawRefundAmount;
  final double refundAmount1 = adjustedAmount.abs();
  final bool isRefundGreater = refundAmount1 > totalAmount;
  final double finalAmount = isRefundGreater ? 0.0 : totalAmount - refundAmount1;
  final double usedDisplayRefund = isRefundGreater ? totalAmount : refundAmount1;
  final double remainingRefund = isRefundGreater ? rawRefundAmount - totalAmount : 0.0;

  final double bottleQuantities = (item.bottleQuantities ?? 0).toDouble();
  final bool hasBottleDeposit = bottleQuantities > 0;
  final double bottleDepositAmount = state.isIncludedVat
      ? bottleDepositCalculationWithVat(deposit: item.bottleTax ?? 0, vatPercentage: item.vatPercentage ?? 0, qty: bottleQuantities)
      : bottleDepositCalculation(deposit: item.bottleTax ?? 0, qty: bottleQuantities);

  return [
    const SummaryHairline(),
    Padding(
      padding: const EdgeInsets.fromLTRB(SummaryStyle.gutter, 12, SummaryStyle.gutter, SummaryStyle.gutter),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
        Text(l10n.payment_details_title,
            style: AppStyles.rkBoldTextStyle(size: AppConstants.font_13, color: SummaryStyle.labelColor, fontWeight: FontWeight.w600)),
        6.height,
        if (hasBottleDeposit)
          SummaryBreakdownRow(
              label: isHebrew
                  ? '${l10n.bottle_deposit} ${bottleQuantities.toStringAsFixed(0)}X'
                  : '${l10n.bottle_deposit} X${bottleQuantities.toStringAsFixed(0)}',
              amount: summaryMoney(bottleDepositAmount),
              isMuted: true),
        if (!state.isIncludedVat) ...[
          SummaryBreakdownRow(label: l10n.total_amount_subject_to_vat, amount: summaryMoney(item.totalAmountSubjectToVat), isMuted: true),
          SummaryBreakdownRow(label: l10n.total_amount_not_subject_to_vat, amount: summaryMoney(item.totalAmountNotSubjectToVat), isMuted: true),
          SummaryBreakdownRow(label: l10n.vat, amount: summaryMoney(item.vatAmount), isMuted: true),
          SummaryBreakdownRow(
              label: l10n.total_refunds,
              amount: usedDisplayRefund == 0 ? summaryMoney(0) : '-${summaryMoney(usedDisplayRefund)}',
              amountColor: usedDisplayRefund > 0 ? AppColors.notificationColor : null)
        ],
        10.height,
        SummaryGrandTotalRow(label: state.isIncludedVat ? l10n.total_price_with_vat : l10n.total, amount: finalAmount),
        if (remainingRefund > 0) ...[
          10.height,
          SummaryCreditBanner(
              margin: EdgeInsets.zero,
              text: isHebrew
                  ? '${l10n.refund_amount_2}${summaryMoney(remainingRefund)} ${l10n.refund_amount_1}'
                  : '${l10n.refund_amount_1} ${summaryMoney(remainingRefund)} ${l10n.refund_amount_2}')
        ],
        12.height,
        SummaryNote(text: l10n.not_include_surfaces_price, color: SummaryStyle.labelColor),
        12.height,
        SummaryPrimaryButton(
            text: l10n.submit,
            icon: Icons.credit_card_rounded,
            isLoading: item.isProcess ?? false,
            onPressed: () async {
              if (item.draftReturnExists ?? false) {
                await showDialog(
                    context: context,
                    builder: (_) => BasketSummaryCallAgentDialog(language: state.language, id: item.suppliers?.id ?? '', index: index, bloc: bloc));
              } else {
                bloc.add(BasketSummaryEvent.getSupplierPaymentTypeEvent(context: context, id: item.suppliers?.id ?? '', index: index));
              }
            }),
      ]),
    )
  ];
}
