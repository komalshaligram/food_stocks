import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/bloc/order/order_bloc.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/widget/common_order_content_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../../routes/app_routes.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utils/themes/app_strings.dart';
import '../utils/themes/app_styles.dart';
import '../widget/common_app_bar.dart';
import '../widget/order_summary_screen_shimmer_widget.dart';

class OrderRoute {
  static Widget get route => const OrderScreen();
}

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          OrderBloc()..add(OrderEvent.getAllOrderEvent(context: context)),
      child: OrderScreenWidget(),
    );
  }
}

class OrderScreenWidget extends StatelessWidget {
  const OrderScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderBloc, OrderState>(
      listener: (context, state) {},
      child: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.pageColor,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(AppConstants.appBarHeight),
              child: CommonAppBar(
                title: AppLocalizations.of(context)!.orders,
                iconData: Icons.arrow_back_ios_sharp,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: SafeArea(
              child: NotificationListener<ScrollNotification>(
                child: Column(
                  children: [
                    state.isShimmering
                        ? OrderSummaryScreenShimmerWidget()
                        : (state.orderDetailsList.length) != 0
                            ? Expanded(
                      /*height: getScreenHeight(context) * 0.85,*/
                                child: ListView.builder(
                                  //scrollDirection: Axis.vertical,
                                  itemCount: state.orderDetailsList.length,
                                  shrinkWrap: true,
                                  physics: (state.orderDetailsList.length) == 0
                                      ? const NeverScrollableScrollPhysics()
                                      : const AlwaysScrollableScrollPhysics(),
                                //  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) =>
                                      orderListItem(
                                          index: index, context: context),
                                ),
                              )
                            : SizedBox(
                      height: getScreenHeight(context) * 0.8,
                                child: Center(
                                    child: Text(
                                      AppLocalizations.of(context)!.no_data,
                                  style: AppStyles.rkRegularTextStyle(
                                      size: AppConstants.normalFont,
                                      color: AppColors.blackColor,
                                      fontWeight: FontWeight.w400),
                                )),
                              ),
                    state.isLoadMore
                        ? OrderSummaryScreenShimmerWidget()
                        : 0.width,
                  ],
                ),
                onNotification: (notification) {
                  if (notification.metrics.pixels ==
                      notification.metrics.maxScrollExtent) {
                    if ((state.orderList.metaData?.totalFilteredCount ?? 1 ) >
                        state.orderDetailsList.length) {
                      context
                          .read<OrderBloc>()
                          .add(OrderEvent.getAllOrderEvent(context: context));
                    } else {
                      return false;
                    }
                  }
                  return true;
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget orderListItem({required int index, required BuildContext context}) {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        OrderBloc bloc = context.read<OrderBloc>();
        return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                  context, RouteDefine.orderDetailsScreen.name,
                  arguments: {
                    AppStrings.orderIdString:
                    state.orderDetailsList[index].id,
                    AppStrings.orderNumberString:
                    state.orderDetailsList[index].orderNumber,
                  });
          },
          child: Container(
            margin: EdgeInsets.all(AppConstants.padding_10),
            padding: EdgeInsets.symmetric(
                vertical: AppConstants.padding_15,
                horizontal: AppConstants.padding_10),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              boxShadow: [
                BoxShadow(
                    color: AppColors.shadowColor.withOpacity(0.15),
                    blurRadius: AppConstants.blur_10),
              ],
              borderRadius:
                  BorderRadius.all(Radius.circular(AppConstants.radius_5)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      state.orderDetailsList[index].orderNumber.toString(),
                      style: AppStyles.rkRegularTextStyle(
                          size: AppConstants.normalFont,
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(AppConstants.radius_100)),
                        border: Border.all(
                          color: AppColors.borderColor,
                          width: 1,
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppConstants.padding_10,
                            vertical: AppConstants.padding_5),
                        decoration: BoxDecoration(
                          color: AppColors.lightGreyColor,
                          borderRadius: BorderRadius.all(
                              Radius.circular(AppConstants.radius_100)),
                          border: Border.all(
                            color: AppColors.whiteColor,
                            width: 1,
                          ),
                        ),
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(
                            '${formatter(double.parse(state.orderDetailsList[index].totalAmount.toString() ?? "0").toStringAsFixed(2))}${AppLocalizations.of(context)!.currency}',
                            style: AppStyles.rkRegularTextStyle(
                                size: AppConstants.font_14,
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                7.height,
                Row(
                  children: [
                    CommonOrderContentWidget(
                      flexValue: 2,
                      title: AppLocalizations.of(context)!.products,
                      value: state.orderDetailsList[index].products.toString(),
                      titleColor: AppColors.blackColor,
                      valueColor: AppColors.blackColor,
                      valueTextSize: AppConstants.smallFont,
                    ),
                    5.width,
                    CommonOrderContentWidget(
                      flexValue: 2,
                      title: AppLocalizations.of(context)!.suppliers,
                      value: state.orderDetailsList[index].suppliers.toString(),
                      titleColor: AppColors.blackColor,
                      valueColor: AppColors.blackColor,
                      valueTextSize: AppConstants.smallFont,
                    ),
                    5.width,
                    CommonOrderContentWidget(
                      flexValue: 4,
                      title: AppLocalizations.of(context)!.order_date,
                      value: state.orderDetailsList[index].createdAt
                              ?.replaceRange(11, 16, '') ??
                          '',
                      titleColor: AppColors.blackColor,
                      valueColor: AppColors.blackColor,
                      valueTextSize: getScreenWidth(context) < 380 ? AppConstants.font_14 : AppConstants.smallFont,
                    ),
                    5.width,
                    CommonOrderContentWidget(
                      flexValue: 4,
                      title: AppLocalizations.of(context)!.order_status,
                      value: state.orderDetailsList[index].status?.statusName
                              ?.toTitleCase() ??
                          '',
                      titleColor: AppColors.blackColor,
                      valueColor:
                          state.orderDetailsList[index].status?.statusName?.toTitleCase() ==
                                  AppLocalizations.of(context)!.pending_delivery.toTitleCase()
                              ? AppColors.orangeColor
                              : AppColors.mainColor,
                      valueTextSize: AppConstants.smallFont,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
