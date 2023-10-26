import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/bloc/order_summary/order_summary_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../../routes/app_routes.dart';
import '../utils/app_utils.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_styles.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_order_content_widget.dart';

class OrderSummaryRoute {
  static Widget get route => const OrderSummaryScreen();
}

class OrderSummaryScreen extends StatelessWidget {
  const OrderSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderSummaryBloc()..add(OrderSummaryEvent.getDataEvent()),
      child: OrderSummaryScreenWidget(),
    );
  }
}

class OrderSummaryScreenWidget extends StatelessWidget {
  const OrderSummaryScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    OrderSummaryBloc bloc = context.read<OrderSummaryBloc>();
    return BlocBuilder<OrderSummaryBloc, OrderSummaryState>(
      builder: (context, state) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(AppConstants.appBarHeight),
            child: CommonAppBar(
              title: AppLocalizations.of(context)!.order_summary,
              iconData: Icons.arrow_back_ios_sharp,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              /*  state.isShimmering ? OrderSummaryScreenShimmerWidget():*/Expanded(
                  child: ListView.builder(
                    itemCount: state.orderSummaryList.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    padding:
                    EdgeInsets.symmetric(vertical: AppConstants.padding_5),
                    itemBuilder: (context, index) =>
                        orderListItem(index: index, context: context),
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(left:AppConstants.padding_40,right:AppConstants.padding_40,top:AppConstants.padding_10,
                      bottom: AppConstants.padding_30),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor.withOpacity(0.95),
                        boxShadow: [
                          BoxShadow(
                              color: AppColors.shadowColor.withOpacity(0.20),
                              blurRadius: AppConstants.blur_10),
                        ],
                        borderRadius: BorderRadius.all(
                            Radius.circular(AppConstants.radius_40)),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: AppConstants.padding_5,
                            horizontal: AppConstants.padding_5),
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(AppConstants.radius_40),
                          color: AppColors.whiteColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                                height: AppConstants.containerHeight_60,
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                    vertical: AppConstants.padding_5,
                                    horizontal: AppConstants.padding_5),
                                decoration: BoxDecoration(
                                    color: AppColors.mainColor,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(
                                            AppConstants.radius_6),
                                        bottomLeft: Radius.circular(
                                            AppConstants.radius_6),
                                        bottomRight: Radius.circular(
                                            AppConstants.radius_30),
                                        topRight: Radius.circular(
                                            AppConstants.radius_30))),
                                child: Text(
                                  '${'11.90₪ : ' +
                                      AppLocalizations.of(context)!.total}',
                                  style: AppStyles.rkRegularTextStyle(
                                      size: AppConstants.normalFont,
                                      color: AppColors.whiteColor,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                            6.width,
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () {
                                  bloc.add(OrderSummaryEvent.orderSendEvent(context: context));

                                },
                                child: Container(
                                  height: AppConstants.containerHeight_60,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      vertical: AppConstants.padding_5,
                                      horizontal: AppConstants.padding_5),
                                  decoration: BoxDecoration(
                                      color: AppColors.navSelectedColor,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(
                                              AppConstants.radius_30),
                                          bottomLeft: Radius.circular(
                                              AppConstants.radius_30),
                                          bottomRight: Radius.circular(
                                              AppConstants.radius_6),
                                          topRight: Radius.circular(
                                              AppConstants.radius_6))),
                                  child: Text(
                                    AppLocalizations.of(context)!.send_order,
                                    style: AppStyles.rkRegularTextStyle(
                                        size: getScreenWidth(context) <= 380 ?AppConstants.mediumFont :AppConstants.normalFont,
                                        color: AppColors.whiteColor,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget orderListItem({required int index, required BuildContext context}) {
    return BlocBuilder<OrderSummaryBloc, OrderSummaryState>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.all(AppConstants.padding_10),
          padding: EdgeInsets.symmetric(
              vertical: AppConstants.padding_10,
              horizontal: AppConstants.padding_10),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            boxShadow: [
              BoxShadow(
                  color: AppColors.shadowColor.withOpacity(0.15),
                  blurRadius: AppConstants.blur_10),
            ],
            borderRadius: BorderRadius.all(
                Radius.circular(AppConstants.radius_5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                state.orderSummaryList[index].supplierName.toString(),
                style: AppStyles.rkRegularTextStyle(
                    size: AppConstants.font_14,
                    color: AppColors.blackColor,
                    fontWeight: FontWeight.w400),
              ),
              10.height,
              Row(
                children: [
                  CommonOrderContentWidget(
                    flexValue: 1,
                    title: AppLocalizations.of(context)!.products,
                    value: state.orderSummaryList[index].productQuantity.toString(),
                    titleColor: AppColors.mainColor,
                    valueColor: AppColors.blackColor,
                    valueTextWeight: FontWeight.w700,
                    valueTextSize: AppConstants.smallFont,
                  ),
                  5.width,
                  CommonOrderContentWidget(
                    flexValue: 2,
                    title: AppLocalizations.of(context)!.delivery_date,
                    value: state.orderSummaryList[index].deliveryDate.toString(),
                    titleColor: AppColors.mainColor,
                    valueColor: AppColors.blackColor,
                    valueTextSize: AppConstants.font_10,
                    valueTextWeight: FontWeight.w500,
                    columnPadding: AppConstants.padding_10,
                  ),
                  5.width,
                  CommonOrderContentWidget(
                    flexValue: 2,
                    title: AppLocalizations.of(context)!.total_order,
                    value: state.orderSummaryList[index].totalPrice.toString(),
                    titleColor: AppColors.mainColor,
                    valueColor: AppColors.blackColor,
                    valueTextWeight: FontWeight.w500,
                    valueTextSize: AppConstants.smallFont,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
