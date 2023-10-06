import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../../bloc/order_details/order_details_bloc.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_styles.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_order_content_widget.dart';

class OrderDetailsRoute {
  static Widget get route => OrderDetailsScreen();
}


class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderDetailsBloc(),
      child: OrderDetailsScreenWidget(),
    );
  }
}

class OrderDetailsScreenWidget extends StatelessWidget {
  const OrderDetailsScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderDetailsBloc, OrderDetailsState>(
      listener: (context, state) {

      },
      child: BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: AppColors.pageColor,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(AppConstants.appBarHeight),
                child: CommonAppBar(
                  title: '123456',
                  iconData: Icons.arrow_back_ios_sharp,
                    trailingWidget:  Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_10,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(AppConstants.radius_100)),
                          border: Border.all(
                            color: AppColors.borderColor,
                            width: 1,
                          ),
                        ),
                        child: Container(
                          alignment: Alignment.center,
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
                          child: RichText(
                            text: TextSpan(
                              text: AppLocalizations.of(context)!.total ,
                             style: TextStyle(
                          color: AppColors.whiteColor, fontSize: AppConstants.font_14,fontWeight: FontWeight.w400),
                               children: <TextSpan>[
                            TextSpan(text: ' : 12,450₪',
                                style: TextStyle(
                                    color: AppColors.whiteColor, fontSize: AppConstants.font_14,fontWeight: FontWeight.w700)
                            ),
                            ],
                          ),
                          ),
                        ),
                      ),
                    ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: ListView.builder(
                itemCount: 5,
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
              color: AppColors.shadowColor.withOpacity(0.15),
              blurRadius: AppConstants.blur_10),
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
                AppLocalizations.of(context)!.name_provider,
                style: AppStyles.rkRegularTextStyle(
                    size: AppConstants.font_14,
                    color: AppColors.blackColor,
                    fontWeight: FontWeight.w400),
              ),
              Text(
                index == 0 ? AppLocalizations.of(context)!.awaiting_shipment :  AppLocalizations.of(context)!.everything_was_received,
                style: AppStyles.rkRegularTextStyle(
                    size: AppConstants.smallFont,
                    color: index == 0 ? AppColors.orangeColor : AppColors.mainColor,
                    fontWeight: FontWeight.w700),

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
                columnPadding: AppConstants.padding_8,
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