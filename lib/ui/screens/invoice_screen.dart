import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../../bloc/invoice/invoice_bloc.dart';
import '../../data/model/invoice_model/invoice_model.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_strings.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_order_content_widget.dart';

class InvoiceRoute {
  static Widget get route => InvoiceScreen();
}

class InvoiceScreen extends StatelessWidget {
  const InvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InvoiceBloc(),
      child: InvoiceScreenWidget(),
    );
  }
}

class InvoiceScreenWidget extends StatelessWidget {
  const InvoiceScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoiceBloc, InvoiceState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.pageColor,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(AppConstants.appBarHeight),
            child: CommonAppBar(
              bgColor: AppColors.pageColor,
              title: AppLocalizations.of(context)!.my_invoices,
              iconData: Icons.arrow_back_ios_sharp,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SafeArea(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: AnimationLimiter(
              child: ListView.builder(
                itemCount: state.invoiceDetailsList.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) =>
                    AnimationConfiguration.staggeredList(
                  duration: const Duration(seconds: 1),
                  position: index,
                  child: SlideAnimation(
                    verticalOffset: 44.0,
                    child: FadeInAnimation(
                      child: invoiceList(
                        index: index,
                        invoicesList: state.invoiceDetailsList,
                          context: context,
                          invoiceType:
                              state.invoiceDetailsList[index].invoiceType,
                          invoiceDate:
                              state.invoiceDetailsList[index].date.toString(),
                          invoicePrice: state
                              .invoiceDetailsList[index].invoicePrice
                              .toString(),
                          invoiceNumber: state
                              .invoiceDetailsList[index].invoiceNumber
                              .toString(),
                          invoiceStatue: state
                              .invoiceDetailsList[index].invoiceState
                              .toString(),

                      ),
                    ),
                  ),
                ),
              ),
            ),
          )),
        );
      },
    );
  }

  Widget invoiceList({
    required BuildContext context,
    required String invoiceDate,
    required String invoiceType,
    required String invoicePrice,
    required String invoiceStatue,
    required String invoiceNumber,
    required List<InvoiceModel>invoicesList,
    required int index,
  }) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, RouteDefine.invoicePdfScreen.name,arguments:
        {AppStrings.invoiceListString : invoicesList[index] });
      },
      child: Container(
        margin: EdgeInsets.all(AppConstants.padding_8),
        padding: EdgeInsets.symmetric(
            vertical: AppConstants.padding_8, horizontal: AppConstants.padding_8),
        decoration: BoxDecoration(
            color: AppColors.whiteColor,
            boxShadow: [
              BoxShadow(
                  color: AppColors.shadowColor.withOpacity(0.15),
                  blurRadius: AppConstants.blur_10),
            ],
            borderRadius:
                BorderRadius.all(Radius.circular(AppConstants.radius_5))),
        child: Row(
          children: [
            CommonOrderContentWidget(
                backGroundColor: AppColors.iconBGColor,
                borderCoder: AppColors.lightBorderColor,
                flexValue: 2,
                title: AppLocalizations.of(context)!.invoice_number,
                value: invoiceNumber,
                titleColor: AppColors.mainColor,
                valueColor: AppColors.blackColor,
                valueTextSize: AppConstants.font_12,
                columnPadding: 2,
                valueTextWeight: FontWeight.w400),
            4.width,
            CommonOrderContentWidget(
                backGroundColor: AppColors.iconBGColor,
                borderCoder: AppColors.lightBorderColor,
                flexValue: 2,
                title: AppLocalizations.of(context)!.invoice_date,
                value: invoiceDate,
                titleColor: AppColors.mainColor,
                valueColor: AppColors.blackColor,
                valueTextSize: AppConstants.font_12,
                columnPadding: 2,
                valueTextWeight: FontWeight.w400),
            4.width,
            CommonOrderContentWidget(
                backGroundColor: AppColors.iconBGColor,
                borderCoder: AppColors.lightBorderColor,
                flexValue: 2,
                title: AppLocalizations.of(context)!.invoice_type,
                value: invoiceType,
                titleColor: AppColors.mainColor,
                valueColor: AppColors.blackColor,
                valueTextSize: AppConstants.font_12,
                columnPadding: 2,
                valueTextWeight: FontWeight.w400),
            4.width,
            CommonOrderContentWidget(
                backGroundColor: AppColors.iconBGColor,
                borderCoder: AppColors.lightBorderColor,
                flexValue: 2,
                title: AppLocalizations.of(context)!.invoice_statue,
                value: invoiceStatue,
                titleColor: AppColors.mainColor,
                valueColor: AppColors.blackColor,
                valueTextSize: AppConstants.font_12,
                columnPadding: 2,
                valueTextWeight: FontWeight.w400),
            4.width,
            CommonOrderContentWidget(
                backGroundColor: AppColors.iconBGColor,
                borderCoder: AppColors.lightBorderColor,
                flexValue: 2,
                title: AppLocalizations.of(context)!.invoice_amount,
                value: formatNumber(
                    value: invoicePrice, local: AppStrings.hebrewLocal),
                titleColor: AppColors.mainColor,
                valueColor: AppColors.blackColor,
                valueTextSize: AppConstants.font_12,
                columnPadding: 2,
                valueTextWeight: FontWeight.w400),
          ],
        ),
      ),
    );
  }
}
