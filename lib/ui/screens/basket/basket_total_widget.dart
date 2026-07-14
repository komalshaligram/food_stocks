import '../../widget/custom_button_widget.dart';
import '../../utils/basket_navigation_helper.dart';
import '../../widget/common_divider_widget.dart';
import '../../widget/dialogs/call_agent_dialog.dart';
import '../../widget/dialogs/remove_out_of_stock_product_dialog.dart';
import '../../utils/constants/app_strings.dart';
import '../../utils/constants/app_styles.dart';
import 'package:flutter/material.dart';
import '../../../bloc/basket/basket_bloc.dart';
import '../../utils/app_utils.dart';
import '../../utils/constants/app_constants.dart';
import '../../utils/constants/app_colors.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../../widget/sized_box_widget.dart';

Widget totalAmountCard(
    BasketState state, BuildContext context, BasketBloc bloc) {
  final grandTotal = basketGrandTotal(state);
  final formattedTotal = formatNumber(
    value: state.isIncludedVat
        ? grandTotal.toString()
        : grandTotal.toStringAsFixed(2),
    local: AppStrings.hebrewLocal,
  );

  return Container(
      alignment: state.language == AppStrings.englishString
          ? Alignment.centerLeft
          : Alignment.centerRight,
      padding: const EdgeInsets.only(
          left: AppConstants.padding_10,
          right: AppConstants.padding_10,
          top: AppConstants.padding_3,
          bottom: AppConstants.padding_10),
      margin: const EdgeInsets.symmetric(
          vertical: AppConstants.padding_5,
          horizontal: AppConstants.padding_10),
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius:
          const BorderRadius.all(Radius.circular(AppConstants.radius_5))),
      child: Column(children: [
        const DividerWidget(height: 10.0),
        state.isIncludedVat
            ? basketRow(AppLocalizations.of(context)!.total_price_with_vat,
            formattedTotal, isTitle: true)
            : basketRow(AppLocalizations.of(context)!.total, formattedTotal,
            isTitle: true),
        const DividerWidget(height: 10.0),
        5.height,
        state.isSubUserCanCreateOrder
            ? CustomButtonWidget(
          buttonText: AppLocalizations.of(context)!.continues,
          bGColor: AppColors.mainColor,
          height: 45,
          onPressed: () async {
            List<double> basketProductStockList = [];
            for (var element in state.basketProductList) {
              basketProductStockList.add(element.productStock ?? 0);
            }
            basketProductStockList.sort();
            if (basketProductStockList.first == 0.0 ||
                basketProductStockList.first == 0) {
              removeOutOfStockProductDialog(context: context);
            } else {
              if (!state.isRemoveProcess &&
                  !state.isLoading &&
                  !state.isShimmering) {
                if (state.draftReturnExists) {
                  await showDialog(
                      context: context,
                      builder: (_) => CallAgentDialog(
                          language: state.language,
                          state: state,
                          context1: context,
                          bloc: bloc));
                } else {
                  await navigateFromBasketContinue(
                    context: context,
                    state: state,
                    formattedTotal: formattedTotal,
                  );
                }
              }
            }
          },
          fontColors: AppColors.whiteColor,
        )
            : 0.width,
        10.height
      ]));
}

double basketGrandTotal(BasketState state) {
  final products = state.cartItemList.data?.data ?? [];
  return calculateBasketGrandTotal(
    productsTotalWithVat: sumProductTotalVatAmounts(
      products.map((product) => product.totalVatAmount),
    ),
    bottleTax: state.bottleTax,
    vatPercentage: state.vatPercentage,
    bottleQuantities: state.bottleQty ?? 0,
  );
}

String formattedBasketGrandTotal(BasketState state) {
  final total = basketGrandTotal(state);
  return formatNumber(
    value: state.isIncludedVat ? total.toString() : total.toStringAsFixed(2),
    local: AppStrings.hebrewLocal,
  );
}

Widget basketRow(String title, String amount,
    {bool isTitle = false, double fontSize = 20}) {
  return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Text(title,
        style: AppStyles.rkRegularTextStyle(
            size: AppConstants.font_20,
            color: AppColors.blackColor,
            fontWeight: FontWeight.w700)),
    Text(
      amount,
      style: AppStyles.rkRegularTextStyle(
          size: fontSize,
          color: AppColors.blackColor,
          fontWeight: isTitle ? FontWeight.w700 : FontWeight.w300),
      overflow: TextOverflow.ellipsis,
    )
  ]);
}