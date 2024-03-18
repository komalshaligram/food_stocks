import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../bloc/invoice_pdf/invoice_pdf_bloc.dart';
import '../utils/app_utils.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_strings.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_order_content_widget.dart';

class InvoicePdfRoute {
  static Widget get route => InvoicePdfScreen();
}

class InvoicePdfScreen extends StatelessWidget {
  InvoicePdfScreen({super.key});


  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args =
    ModalRoute
        .of(context)
        ?.settings
        .arguments as Map?;
    return BlocProvider(
      create: (context) => InvoicePdfBloc()..add(InvoicePdfEvent.getArgumentEvent(invoiceDetailsList: args?[AppStrings.invoiceListString])),
      child: InvoicePdfScreenWidget(),
    );
  }
}


class InvoicePdfScreenWidget extends StatelessWidget {
   InvoicePdfScreenWidget({super.key});

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  final PdfViewerController _pdfViewerController = PdfViewerController();

  List<PdfFormField>? _formFields;

  ui.Image? image;


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoicePdfBloc, InvoicePdfState>(
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
          trailingWidget: Icon(Icons.download_outlined,
            color: AppColors.mainColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Container(
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
                        value: state.invoiceDetailsList.invoiceNumber.toString(),
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
                        value: state.invoiceDetailsList.date.toString(),
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
                        value: state.invoiceDetailsList.invoiceType.toString(),
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
                        value: state.invoiceDetailsList.invoiceState.toString(),
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
                        value: formatNumber(value: state.invoiceDetailsList.invoicePrice,local: AppStrings.hebrewLocal),
                        titleColor: AppColors.mainColor,
                        valueColor: AppColors.blackColor,
                        valueTextSize: AppConstants.font_12,
                        columnPadding: 2,
                        valueTextWeight: FontWeight.w400),
                  ],
                ),
              ),
              20.height,
              Container(
                color: Colors.white,
                height: getScreenHeight(context) - 200,
                child: SfPdfViewer.network(
                  'https://5.imimg.com/data5/SELLER/Doc/2021/4/QI/LK/YD/7115850/pdf-conversion-services.pdf',
                  key: _pdfViewerKey,
                  controller: _pdfViewerController,
                ),
              ),
        
            ],
          ),
        ),
      ),
    );
  },
);
  }
}
