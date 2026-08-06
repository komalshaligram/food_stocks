import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../bloc/order/order_bloc.dart';
import '../../data/model/res_model/get_all_order_res_model/get_all_order_res_model.dart';
import 'product_details_screen.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_colors.dart';
import '../../ui/widget/common_order_content_widget.dart';
import '../../ui/widget/sized_box_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../routes/app_routes.dart';
import '../utils/constants/app_constants.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../utils/constants/app_strings.dart';
import '../utils/constants/app_styles.dart';
import '../widget/common_app_bar.dart';
import '../widget/order_summary_screen_shimmer_widget.dart';
import '../widget/refresh_widget.dart';

class OrderRoute {
  static Widget get route => const OrderScreen();
}

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => OrderBloc()..add(OrderEvent.getAllOrderEvent(context: context)), child: const OrderScreenWidget());
  }
}

class OrderScreenWidget extends StatelessWidget {
  const OrderScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    PreferredSizeWidget appbarWidget(AppLocalizations local) => PreferredSize(
          preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
          child: CommonAppBar(
              bgColor: AppColors.pageColor,
              title: local.orders,
              iconData: Icons.arrow_back_ios_sharp,
              onTap: () {
                Navigator.pushReplacementNamed(context, RouteDefine.bottomNavScreen.name,
                    arguments: {AppStrings.pushNavigationString: 'profileScreen'});
              }),
        );

    return Scaffold(
        backgroundColor: AppColors.pageColor,
        appBar: appbarWidget(local),
        body: SafeArea(
          child: BlocBuilder<OrderBloc, OrderState>(
              buildWhen: (prev, curr) =>
                  prev.isShimmering != curr.isShimmering ||
                  prev.orderDetailsList != curr.orderDetailsList ||
                  prev.isBottomOfProducts != curr.isBottomOfProducts ||
                  prev.statusList != curr.statusList ||
                  prev.language != curr.language,
              builder: (context, state) {
                final bloc = context.read<OrderBloc>();
                final local = AppLocalizations.of(context)!;

                if (state.isShimmering) {
                  return const OrderSummaryScreenShimmerWidget(itemCount: 10);
                }
                if (state.orderDetailsList.isEmpty) {
                  return noDataWidget(local.no_data);
                }

                return SmartRefresher(
                  physics: const ClampingScrollPhysics(),
                  enablePullDown: true,
                  controller: state.refreshController,
                  header: const RefreshWidget(),
                  footer: CustomFooter(builder: (_, __) => const OrderSummaryScreenShimmerWidget(itemCount: 2)),
                  enablePullUp: !state.isBottomOfProducts,
                  onRefresh: () {
                    bloc.add(OrderEvent.refreshListEvent(context: context));
                  },
                  onLoading: () {
                    bloc.add(OrderEvent.getAllOrderEvent(context: context));
                  },
                  child: AnimationLimiter(
                    child: ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        itemCount: state.orderDetailsList.length,
                        itemBuilder: (context, index) {
                          return AnimationConfiguration.staggeredList(
                            duration: const Duration(seconds: 1),
                            position: index,
                            child: SlideAnimation(
                              verticalOffset: 44.0,
                              child: FadeInAnimation(
                                  child: orderListItem(
                                      state: state, index: index, context: context, orderDetailsList: state.orderDetailsList, local: local)),
                            ),
                          );
                        }),
                  ),
                );
              }),
        ));
  }

  Widget orderListItem(
      {required OrderState state,
      required int index,
      required BuildContext context,
      required List<Datum> orderDetailsList,
      required AppLocalizations local}) {
    final order = orderDetailsList[index];
    final orderId = order.id ?? '';
    final orderNumber = order.orderNumber ?? '';
    final supplierName = order.supplierName ?? '';
    final isMultiSupplier = (order.suppliers ?? 0) > 1;

    final amount = order.rivchitInvoicePrice != '0' ? formatSignedNumber(order.rivchitInvoicePrice) : formatSignedNumber(order.totalAmount);
    final orderDate = _formatDate(order.createdAt);
    final dueDate = order.paymentMethod == AppStrings.creditCard ? "-" : _formatDate(order.dueDate, fallback: '-');

    Widget orderNumberWidget() => Text(orderNumber,
        style: AppStyles.rkRegularTextStyle(size: AppConstants.normalFont, color: AppColors.blackColor, fontWeight: FontWeight.bold));

    Widget supplierNameWidget() => Expanded(
          child: Center(
            child: Text(supplierName,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.mainColor)),
          ),
        );

    Widget orderAmountWidget() => Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_100)), border: Border.all(color: AppColors.borderColor)),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_10, vertical: AppConstants.padding_5),
            decoration: BoxDecoration(
                color: AppColors.lightGreyColor,
                borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_100)),
                border: Border.all(color: AppColors.whiteColor)),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Text(amount,
                  style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: AppColors.whiteColor, fontWeight: FontWeight.bold)),
            ),
          ),
        );

    Widget commonOrderContentWidget() => Row(children: [
          CommonOrderContentWidget(
              backGroundColor: AppColors.iconBGColor,
              borderCoder: AppColors.lightBorderColor,
              flexValue: 2,
              title: local.products,
              value: order.products.toString(),
              titleColor: AppColors.blackColor,
              valueColor: AppColors.blackColor),
          5.width,
          CommonOrderContentWidget(
              backGroundColor: AppColors.iconBGColor,
              borderCoder: AppColors.lightBorderColor,
              flexValue: 4,
              title: local.order_date,
              value: orderDate,
              titleColor: AppColors.blackColor,
              valueColor: AppColors.blackColor,
              valueTextSize: getScreenWidth(context) < 380 ? AppConstants.font_14 : AppConstants.smallFont),
          5.width,
          order.status?.orderStatusNo == 2 && order.paymentMethod == AppStrings.creditCard
              ? Expanded(
                  flex: 4,
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_5, vertical: AppConstants.padding_10),
                      decoration: BoxDecoration(
                        color: AppColors.iconBGColor,
                        borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_5)),
                        border: Border.all(color: AppColors.lightBorderColor),
                      ),
                      child: Text(local.invoice_charge, style: TextStyle(color: AppColors.blackColor, fontSize: AppConstants.font_10))),
                )
              : CommonOrderContentWidget(
                  backGroundColor: AppColors.iconBGColor,
                  borderCoder: AppColors.lightBorderColor,
                  flexValue: 4,
                  title: local.due_date,
                  value: dueDate,
                  titleColor: AppColors.blackColor,
                  valueColor: AppColors.blackColor),
          5.width,
          CommonOrderContentWidget(
              backGroundColor: AppColors.iconBGColor,
              borderCoder: AppColors.lightBorderColor,
              flexValue: 4,
              title: local.order_status,
              value: getStatus(state.statusList, order.status?.statusName ?? '', state.language).toTitleCase(),
              titleColor: AppColors.blackColor,
              valueColor: getStatusColor(state.statusList, order.status?.statusName ?? '')),
        ]);

    Widget paymentTypeWidget() => RichText(
          text: TextSpan(text: '${local.payment_type} : ', style: TextStyle(color: AppColors.blackColor, fontSize: AppConstants.font_14), children: [
            TextSpan(
                text: _paymentTypeLabel(order.paymentMethod.toString(), local) ?? '',
                style: TextStyle(color: AppColors.mainColor, fontWeight: FontWeight.w700)),
          ]),
        );

    return GestureDetector(
      onTap: () async {
        final prefs = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
        prefs.setOrderId(productOrderId: orderId);

        if (!context.mounted) return;

        if (isMultiSupplier) {
          Navigator.pushNamed(context, RouteDefine.orderDetailsScreen.name,
              arguments: {AppStrings.orderIdString: orderId, AppStrings.orderNumberString: orderNumber});
        } else {
          Navigator.push(
              context,
              PageRouteBuilder(
                  pageBuilder: (_, __, ___) => ProductDetailsScreen(
                      statusList: state.statusList, orderNumber: orderNumber, orderId: orderId, isNavigateToProductDetailString: true),
                  transitionsBuilder: (_, animation, __, child) {
                    return SlideTransition(
                        position: animation.drive(Tween(begin: const Offset(0, 1), end: Offset.zero).chain(CurveTween(curve: Curves.bounceIn))),
                        child: child);
                  }));
        }
      },
      child: Container(
        margin: const EdgeInsets.all(AppConstants.padding_10),
        padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_15, horizontal: AppConstants.padding_10),
        decoration: BoxDecoration(
            color: AppColors.whiteColor,
            boxShadow: [BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.15), blurRadius: AppConstants.blur_10)],
            borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_5))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [orderNumberWidget(), 5.width, supplierNameWidget(), orderAmountWidget()]),
          7.height,
          commonOrderContentWidget(),
          7.height,
          paymentTypeWidget()
        ]),
      ),
    );
  }

  String _formatDate(String? value, {String fallback = ''}) {
    if (value == null || value.isEmpty) return fallback;
    if (value.length >= 16) {
      return value.replaceRange(11, 16, '').replaceRange(6, 8, '');
    }
    return value;
  }

  String? _paymentTypeLabel(String type, AppLocalizations local) {
    switch (type) {
      case AppStrings.wallet:
        return local.wallet;
      case AppStrings.creditCard:
        return local.credit_card;
      case AppStrings.bankTransfer:
        return local.bank_transfer;
      case AppStrings.bankCheck:
        return local.bank_check;
      default:
        return '';
    }
  }
}
