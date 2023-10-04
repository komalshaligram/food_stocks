import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../bloc/order_details/order_details_bloc.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_styles.dart';
import '../widget/common_app_bar.dart';

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
        // TODO: implement listener
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
                    trailingWidget:  Container(
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
                        height: 17,
                        width: 99,
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
                    ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),

            ),
          );
        },
      ),
    );
  }
}
