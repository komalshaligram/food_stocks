import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/bloc/order/order_bloc.dart';
import 'package:food_stock/ui/widget/common_order_content_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utils/themes/app_styles.dart';
import '../widget/common_app_bar.dart';

class OrderRoute {
  static Widget get route => const OrderScreen();
}

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderBloc(),
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
          return SafeArea(
            child: Scaffold(
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
              body: ListView.builder(
                itemCount: 4,
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(vertical: AppConstants.padding_5),
                itemBuilder: (context, index) =>
                    orderListItem(index: index, context: context),
              ),
            ),
          );
        },
      ),
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
              color: AppColors.shadowColor.withOpacity(0.15), blurRadius: 10),
        ],
        borderRadius: BorderRadius.all(Radius.circular(AppConstants.radius_5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '1250123',
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
                    color: AppColors.greyColor,
                    borderRadius: BorderRadius.all(
                        Radius.circular(AppConstants.radius_100)),
                    border: Border.all(
                      color: AppColors.whiteColor,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '12,450${AppLocalizations.of(context)!.currency}',
                    style: AppStyles.rkRegularTextStyle(
                        size: AppConstants.font_14,
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
          7.height,
          Row(
            children: [
              CommonOrderContentWidget(
                flexValue: 1,
                title: AppLocalizations.of(context)!.products,
                value: "23",
                titleColor: AppColors.blackColor,
                valueColor: AppColors.blackColor,
              ),
              5.width,
              CommonOrderContentWidget(
                flexValue: 1,
                title: AppLocalizations.of(context)!.providers,
                value: "3",
                titleColor: AppColors.blackColor,
                valueColor: AppColors.blackColor,
              ),
              5.width,
              CommonOrderContentWidget(
                flexValue: 2,
                title: AppLocalizations.of(context)!.order_date,
                value: "12.05.2023",
                titleColor: AppColors.blackColor,
                valueColor: AppColors.blackColor,
              ),
              5.width,
              CommonOrderContentWidget(
                flexValue: 2,
                title: AppLocalizations.of(context)!.order_status,
                value: index == 0
                    ? AppLocalizations.of(context)!.awaiting_shipment
                    : AppLocalizations.of(context)!.received,
                titleColor: AppColors.blackColor,
                valueColor:
                    index == 0 ? AppColors.orangeColor : AppColors.mainColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}