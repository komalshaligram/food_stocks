import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/bloc/order_summary/order_summary_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
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
      create: (context) => OrderSummaryBloc(),
      child: OrderSummaryScreenWidget(),
    );
  }
}


class OrderSummaryScreenWidget extends StatelessWidget {
  const OrderSummaryScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderSummaryBloc, OrderSummaryState>(
      builder: (context, state) {
        return Scaffold(
          appBar:PreferredSize(
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
                ListView.builder(
                  itemCount: 4,
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(vertical: AppConstants.padding_5),
                  itemBuilder: (context, index) =>
                      orderListItem(index: index, context: context),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.all(AppConstants.padding_30),
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
                          horizontal: AppConstants.padding_5
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: AppColors.whiteColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 60,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  vertical: AppConstants.padding_5,
                                  horizontal: AppConstants.padding_5),
                              decoration: BoxDecoration(
                                  color: AppColors.mainColor,
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(6),bottomLeft: Radius.circular(6),
                                      bottomRight: Radius.circular(30),topRight: Radius.circular(30)
                                  )
                              ),
                              child: Text('${'11.90₪ : ' + AppLocalizations.of(context)!.total}',
                                style: AppStyles.rkRegularTextStyle(
                                    size: AppConstants.normalFont,
                                    color: AppColors.whiteColor,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          8.width,
                          Expanded(
                            flex:2 ,
                            child: Container(
                              height: 60,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  vertical: AppConstants.padding_5,
                                  horizontal: AppConstants.padding_5),
                              decoration: BoxDecoration(
                                  color: AppColors.navSelectedColor,
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30),bottomLeft: Radius.circular(30),
                                      bottomRight: Radius.circular(6),topRight: Radius.circular(6)
                                  )
                              ),
                              child: Text(AppLocalizations.of(context)!.send_order,
                                style: AppStyles.rkRegularTextStyle(
                                    size: AppConstants.normalFont,
                                    color: AppColors.whiteColor,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),

                        ],
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
    return Container(
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
        borderRadius: BorderRadius.all(Radius.circular(AppConstants.radius_5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppLocalizations.of(context)!.supplier_name,
            style: AppStyles.rkRegularTextStyle(
                size: AppConstants.font_14,
                color: AppColors.blackColor,
                fontWeight: FontWeight.w400),
          ),
          13.height,
          Row(
            children: [
              CommonOrderContentWidget(
                flexValue: 1,
                title: AppLocalizations.of(context)!.products,
                value: "23",
                titleColor: AppColors.mainColor,
                valueColor: AppColors.blackColor,
                valueTextWeight: FontWeight.w700,
                valueTextSize: AppConstants.mediumFont,
              ),
              5.width,
              CommonOrderContentWidget(
                flexValue: 2,
                title: AppLocalizations.of(context)!.delivery_date,
                value: "12.02.23 10:00-12:00",
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
                value: '18,360₪',
                titleColor: AppColors.mainColor,
                valueColor:AppColors.blackColor,
                valueTextWeight: FontWeight.w500,
                valueTextSize: AppConstants.smallFont,
              ),
            ],
          ),
        ],
      ),
    );

  }
}
