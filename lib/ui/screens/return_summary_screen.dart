import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '/ui/widget/custom_button_widget.dart';
import '/ui/widget/sized_box_widget.dart';
import '../../bloc/return_summary/return_summary_bloc.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_styles.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_order_content_widget.dart';
import '../widget/order_summary_screen_shimmer_widget.dart';

class ReturnSummaryRoute {
  static Widget get route => const ReturnSummaryScreen();
}

class ReturnSummaryScreen extends StatelessWidget {
  const ReturnSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
      create: (context) => ReturnSummaryBloc()..add(ReturnSummaryEvent.getSummaryListEvent(context: context, list: args ?? {})),
      child: const ReturnSummaryScreenWidget(),
    );
  }
}

class ReturnSummaryScreenWidget extends StatelessWidget {
  const ReturnSummaryScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ReturnSummaryBloc bloc = context.read<ReturnSummaryBloc>();
    return BlocBuilder<ReturnSummaryBloc, ReturnSummaryState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.pageColor,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
            child: CommonAppBar(
              bgColor: AppColors.pageColor,
              title: AppLocalizations.of(context)!.return_summary,
              iconData: Icons.arrow_back_ios_sharp,
              onTap: () {
                Navigator.pop(context, state.returnProductList);
              },
            ),
          ),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                state.isShimmer
                    ? const Expanded(child: OrderSummaryScreenShimmerWidget())
                    : Expanded(
                        child: AnimationLimiter(
                          child: SizedBox(
                            height: 200,
                            child: ListView(
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_5),
                              children: state.supplierWiseMap.keys.map((supplierId) {
                                return orderListItem(context: context, bloc: bloc, supplierId: supplierId ?? '');
                              }).toList(),
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

  Widget orderListItem({required BuildContext context, required ReturnSummaryBloc bloc, required String supplierId}) {
    return BlocBuilder<ReturnSummaryBloc, ReturnSummaryState>(
      builder: (context1, state) {
        return Container(
            height: 160,
            margin: const EdgeInsets.all(AppConstants.padding_10),
            padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_10, horizontal: AppConstants.padding_10),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              boxShadow: [
                BoxShadow(color: AppColors.shadowColor.withValues(alpha:0.15), blurRadius: AppConstants.blur_10),
              ],
              borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  state.supplierWiseMap[supplierId]!.first.supplierName.toString(),
                  style: AppStyles.rkRegularTextStyle(
                    size: AppConstants.font_14,
                    color: AppColors.blackColor,
                  ),
                ),
                10.height,
                CommonOrderContentWidget(
                  backGroundColor: AppColors.iconBGColor,
                  borderCoder: AppColors.lightBorderColor,
                  flexValue: 1,
                  title: AppLocalizations.of(context)!.products,
                  value: state.supplierWiseMap[supplierId]?.length.toString() ?? '',
                  titleColor: AppColors.mainColor,
                  valueColor: AppColors.blackColor,
                  valueTextWeight: FontWeight.w700,
                  valueTextSize: AppConstants.smallFont,
                ),
                8.height,
                CustomButtonWidget(
                  buttonText: AppLocalizations.of(context)!.send_the_request,
                  bGColor: AppColors.mainColor,
                  height: 40,
                  isLoading: false,
                  onPressed: () {
                    bloc.add(ReturnSummaryEvent.updateReturnEvent(context: context, supplierId: supplierId));
                  },
                  fontColors: AppColors.whiteColor,
                ),
              ],
            ));
      },
    );
  }
}
