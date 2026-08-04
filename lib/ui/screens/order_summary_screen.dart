import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../bloc/order_summary/order_summary_bloc.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../../routes/app_routes.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_strings.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_shimmer_widget.dart';
import '../widget/order_summary_card_widgets.dart';
import '../widget/order_summary_screen_shimmer_widget.dart';
import '../widget/supplier_delivery_schedule_widget.dart';
import '../utils/first_supplier_order_helper.dart';

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
              backString: args?[AppStrings.isbackString])),
        child: const OrderSummaryScreenWidget());
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
                  trailingWidget: SummaryTotalPill(label: AppLocalizations.of(context)!.total, amount: state.total),
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
                    ? const Expanded(child: OrderSummaryScreenShimmerWidget())
                    : Expanded(
                        child: AnimationLimiter(
                          child: ListView.builder(
                            physics: const ClampingScrollPhysics(),
                            itemCount: state.tempList.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_5),
                            itemBuilder: (context, index) => AnimationConfiguration.staggeredList(
                                duration: const Duration(seconds: 1),
                                position: index,
                                child: SlideAnimation(child: FadeInAnimation(child: orderListItem(index: index, context: context, bloc: bloc)))),
                          ),
                        ),
                      ),
                if (state.tempList.isEmpty)
                  refundShimmer()
                else if (refundAmount.abs() > 0)
                  SummaryCreditBanner(
                      text: isHebrew
                          ? '${AppLocalizations.of(context)!.refund_amount_3} '
                              '${summaryMoney(refundAmount.abs())}'
                              '${AppLocalizations.of(context)!.refund_amount_4}'
                          : '${AppLocalizations.of(context)!.refund_amount_3} '
                              '${summaryMoney(refundAmount.abs())} '
                              '${AppLocalizations.of(context)!.refund_amount_4}'),
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
                borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_5))),
            child: Container(height: 10)),
      );

  Widget orderListItem({required int index, required BuildContext context, required OrderSummaryBloc bloc}) {
    return BlocBuilder<OrderSummaryBloc, OrderSummaryState>(builder: (context, state) {
      final l10n = AppLocalizations.of(context)!;
      final supplier = state.tempList[index];
      final supplierId = supplier.suppliers?.id ?? supplier.id ?? '';
      final deliverySchedule = state.deliverySchedules[supplierId];
      final totalSavingsValue = double.tryParse(supplier.totalSavings.toString()) ?? 0.0;
      final totalAmount = double.tryParse(supplier.totalAmount.toString()) ?? 0.0;
      final minOrderAmount = supplier.minOrderAmount ?? 0;
      final isMinimumReached = supplier.notMinimumOrder == false;
      final hasDeliverySchedule = deliverySchedule?.cityName?.isNotEmpty == true && (deliverySchedule?.deliveryDays ?? []).isNotEmpty;

      return SummaryCard(children: [
        SummarySupplierHeader(
            supplierName: supplier.suppliers?.contactName ?? '',
            totalLabel: l10n.total_order,
            totalAmount: totalAmount,
            productsLabel: l10n.products,
            productsCount: supplier.totalQuantity?.toString() ?? '0',
            savings: totalSavingsValue,
            supplierLogo: supplier.suppliers?.logo),
        const SummaryHairline(),
        MinimumOrderProgress(
            minimumAmount: minOrderAmount,
            currentAmount: totalAmount,
            isReached: isMinimumReached,
            minimumLabel: l10n.minimum_order_title,
            reachedText: l10n.you_can_send_the_order,
            missingText: minOrderAmount <= 0
                ? l10n.you_cant_send_the_order
                : l10n.amount_missing_for_minimum(summaryMoney((minOrderAmount - totalAmount).clamp(0, double.infinity)))),
        if (state.isDeliveryScheduleLoading || hasDeliverySchedule) ...[
          const SummaryHairline(),
          SummaryActionTile(
              icon: Icons.local_shipping_outlined,
              flipIcon: true,
              accent: AppColors.blueColor,
              label: l10n.supplier_delivery_schedule_button,
              subLabel: deliverySchedule?.cityName,
              isLoading: state.isDeliveryScheduleLoading,
              onTap: !hasDeliverySchedule
                  ? null
                  : () => SupplierDeliveryScheduleWidget.showSheet(context,
                      cityName: deliverySchedule?.cityName ?? '', deliveryDays: deliverySchedule?.deliveryDays ?? []))
        ],
        Padding(
          padding: const EdgeInsets.fromLTRB(SummaryStyle.gutter, 6, SummaryStyle.gutter, SummaryStyle.gutter),
          child: SummaryPrimaryButton(
              text: l10n.continues,
              onPressed: () async {
                final dialogResult = await showFirstSupplierOrderDialogIfNeeded(
                    context: context,
                    language: state.language,
                    isFirstOrderFromSupplier: supplier.isFirstOrderFromSupplier ?? false,
                    supplierDisplayName: supplier.suppliers?.contactName ?? '',
                    messageTemplate: state.firstSupplierOrderMessageTemplate);
                if (!context.mounted || dialogResult == FirstOrderDialogResult.cancelled) return;

                if (dialogResult == FirstOrderDialogResult.confirmed) {
                  await navigateToVerifyClientDataScreen(context: context, nextRouteName: RouteDefine.basketSummaryScreen.name, nextRouteArgs: {
                    AppStrings.getCartListString: state.cartItemList,
                    AppStrings.orderBySupplierId: supplier.id,
                    AppStrings.isSupplierSingle: 'No',
                    AppStrings.totalSupplier: state.tempList.length
                  });
                  return;
                }

                Navigator.pushNamed(context, RouteDefine.basketSummaryScreen.name, arguments: {
                  AppStrings.getCartListString: state.cartItemList,
                  AppStrings.orderBySupplierId: supplier.id,
                  AppStrings.isSupplierSingle: 'No',
                  AppStrings.totalSupplier: state.tempList.length
                });
              }),
        ),
      ]);
    });
  }
}
