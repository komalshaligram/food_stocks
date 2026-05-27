import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../bloc/order_summary/order_summary_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../routes/app_routes.dart';
import '../../ui/widget/custom_button_widget.dart';
import '../../ui/widget/sized_box_widget.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_strings.dart';
import '../utils/constants/app_styles.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_order_content_widget.dart';
import '../widget/common_shimmer_widget.dart';
import '../widget/order_summary_screen_shimmer_widget.dart';

class OrderSummaryRoute {
  static Widget get route => const OrderSummaryScreen();
}

class OrderSummaryScreen extends StatelessWidget {
  const OrderSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
      create: (context) => OrderSummaryBloc()
        ..add(OrderSummaryEvent.getDataEvent(
          context: context,
          cartItemList: args?[AppStrings.getCartListString],
          totalAmount: args?[AppStrings.totalAmountString],
          backString: args?[AppStrings.isbackString],
        )),
      child: const OrderSummaryScreenWidget(),
    );
  }
}

class OrderSummaryScreenWidget extends StatelessWidget {
  const OrderSummaryScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    OrderSummaryBloc bloc = context.read<OrderSummaryBloc>();
    return BlocListener<OrderSummaryBloc, OrderSummaryState>(
      listener: (context, state) {},
      child: BlocBuilder<OrderSummaryBloc, OrderSummaryState>(builder: (context, state) {
        final refundAmount = state.orderSummaryList.data?.openRefundTotalAmount ?? 0.0;
        final isHebrew = Localizations.localeOf(context).languageCode == 'he';

        return Stack(children: [
          Scaffold(
            backgroundColor: AppColors.pageColor,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
              child: CommonAppBar(
                  trailingWidget: Container(
                    padding: const EdgeInsets.all(AppConstants.padding_2),
                    decoration: BoxDecoration(
                      color: AppColors.greyColor,
                      border: Border.all(color: AppColors.whiteColor, width: 3),
                      borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_20)),
                    ),
                    child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_8, vertical: AppConstants.padding_3),
                        decoration: BoxDecoration(
                          color: AppColors.greyColor,
                          borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_20)),
                        ),
                        child: Text('${AppLocalizations.of(context)!.total} :${state.total}', style: TextStyle(color: AppColors.whiteColor))),
                  ),
                  bgColor: AppColors.pageColor,
                  title: AppLocalizations.of(context)!.order_summary,
                  iconData: Icons.arrow_back_ios_sharp,
                  onTap: () {
                    if (state.backString == 'Basket') {
                      Navigator.pushReplacementNamed(context, RouteDefine.bottomNavScreen.name, arguments: {AppStrings.isBasketScreenString: 'true'});
                    }
                  }),
            ),
            body: SafeArea(
              child: Column(children: [
                state.tempList.isEmpty
                    ? const OrderSummaryScreenShimmerWidget()
                    : AnimationLimiter(
                        child: ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          itemCount: state.tempList.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_5),
                          itemBuilder: (context, index) => AnimationConfiguration.staggeredList(
                            duration: const Duration(seconds: 1),
                            position: index,
                            child: SlideAnimation(child: FadeInAnimation(child: orderListItem(index: index, context: context, bloc: bloc))),
                          ),
                        ),
                      ),
                5.height,
                state.tempList.isEmpty
                    ? refundShimmer()
                    : Wrap(alignment: WrapAlignment.center, spacing: 4, children: [
                        Text(
                          isHebrew
                              ? '${AppLocalizations.of(context)!.refund_amount_3}'
                                  ' ${refundAmount.abs().toStringAsFixed(2)}${'₪'}'
                              : AppLocalizations.of(context)!.refund_amount_3,
                          style: AppStyles.rkBoldTextStyle(size: AppConstants.font_15, color: AppColors.notificationColor),
                        ),
                        Text(
                          isHebrew
                              ? AppLocalizations.of(context)!.refund_amount_4
                              : '${refundAmount.abs().toStringAsFixed(2)}${'₪'} '
                                  '${AppLocalizations.of(context)!.refund_amount_4} ',
                          style: AppStyles.rkBoldTextStyle(size: AppConstants.font_15, color: AppColors.notificationColor),
                        ),
                      ])
              ]),
            ),
          ),
        ]);
      }),
    );
  }

  Widget refundShimmer() => CommonShimmerWidget(
        child: Container(
          margin: const EdgeInsets.all(AppConstants.padding_10),
          padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_10, horizontal: AppConstants.padding_10),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            boxShadow: [BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.15), blurRadius: AppConstants.blur_10)],
            borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_5)),
          ),
          child: Container(height: 10),
        ),
      );

  Widget orderListItem({required int index, required BuildContext context, required OrderSummaryBloc bloc}) {
    return BlocBuilder<OrderSummaryBloc, OrderSummaryState>(builder: (context, state) {
      final totalSavingsValue = double.tryParse(state.tempList[index].totalSavings.toString()) ?? 0.0;
      final savingsSalesValue = totalSavingsValue < 0 ? '\u200E-${totalSavingsValue.abs().toStringAsFixed(2)}₪' : '\u200E${totalSavingsValue.toStringAsFixed(2)}₪';

      return Container(
        margin: const EdgeInsets.all(AppConstants.padding_10),
        padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_10, horizontal: AppConstants.padding_10),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          boxShadow: [BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.15), blurRadius: AppConstants.blur_10)],
          borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_5)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(state.tempList[index].suppliers?.contactName! ?? '', style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: AppColors.blackColor)),
          ]),
          10.height,
          Row(children: [
            CommonOrderContentWidget(
              backGroundColor: AppColors.iconBGColor,
              borderCoder: AppColors.lightBorderColor,
              flexValue: 3,
              title: AppLocalizations.of(context)!.products,
              value: state.tempList[index].totalQuantity?.toString() ?? '',
              titleColor: AppColors.mainColor,
              valueColor: AppColors.blackColor,
              valueTextWeight: FontWeight.w700,
              valueTextSize: AppConstants.smallFont,
            ),
            5.width,
            CommonOrderContentWidget(
              backGroundColor: AppColors.iconBGColor,
              borderCoder: AppColors.lightBorderColor,
              flexValue: 5,
              title: AppLocalizations.of(context)!.savings_for_sales,
              value: savingsSalesValue,
              titleColor: AppColors.orangeColor,
              valueColor: AppColors.blackColor,
              valueTextWeight: FontWeight.w700,
              valueTextSize: AppConstants.smallFont,
            ),
            5.width,
            CommonOrderContentWidget(
                backGroundColor: AppColors.iconBGColor,
                borderCoder: AppColors.lightBorderColor,
                flexValue: 7,
                title: AppLocalizations.of(context)!.total_order,
                value: double.parse(state.tempList[index].totalAmount.toString()).toStringAsFixed(2),
                // value: formatNumber(
                //     value: vatCalculation(
                //       price: double.parse(state.tempList[index].totalAmount ?? '0'),
                //       vat: state.tempList[index].vatPercentage ?? 0,
                //       qty: state.tempList[index].bottleQuantities!.toDouble(),
                //       deposit: state.tempList[index].bottleTax!.toDouble(),
                //     ).toStringAsFixed(2),
                //     local: AppStrings.hebrewLocal),
                titleColor: AppColors.mainColor,
                valueColor: AppColors.blackColor,
                valueTextWeight: FontWeight.w500,
                valueTextSize: AppConstants.smallFont),
          ]),
          5.height,
          Container(
            padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_5, horizontal: AppConstants.padding_10),
            decoration: BoxDecoration(color: AppColors.pesachBGColor, borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_50))),
            child: Text(
              '${AppLocalizations.of(context)!.minimum_order} ${state.tempList[index].minOrderAmount} ₪',
              style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: AppColors.blackColor),
            ),
          ),
          state.tempList[index].notMinimumOrder == false
              ? Text(AppLocalizations.of(context)!.you_can_send_the_order, style: TextStyle(color: AppColors.notificationColor))
              : Text(
                  AppLocalizations.of(context)!.you_cant_send_the_order,
                  style: TextStyle(color: AppColors.redColor),
                ),
          8.height,
          CustomButtonWidget(
            buttonText: AppLocalizations.of(context)!.continues,
            bGColor: AppColors.mainColor,
            height: 40,
            onPressed: () async {
              Navigator.pushNamed(context, RouteDefine.basketSummaryScreen.name, arguments: {
                AppStrings.getCartListString: state.cartItemList,
                AppStrings.orderBySupplierId: state.tempList[index].id,
                AppStrings.isSupplierSingle: 'No',
                AppStrings.totalSupplier: state.tempList.length,
              });
            },
            fontColors: AppColors.whiteColor,
          ),
        ]),
      );
    });
  }
}
