import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/ui/screens/product_details_screen.dart';
import 'package:share_plus/share_plus.dart';
import '../../ui/utils/constants/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../ui/widget/sized_box_widget.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../bloc/invoice_pdf/invoice_pdf_bloc.dart';
import '../../data/model/res_model/invoices_res/invoices_res_model.dart';
import '../utils/app_utils.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_strings.dart';
import '../utils/constants/app_styles.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_divider_widget.dart';

class InvoicePdfRoute {
  static Widget get route => const InvoicePdfScreen();
}

class InvoicePdfScreen extends StatelessWidget {
  const InvoicePdfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
      create: (context) => InvoicePdfBloc()
        ..add(InvoicePdfEvent.getArgumentEvent(
          invoiceDetailsList: args?[AppStrings.invoiceListString],
          context: context,
        )),
      child: InvoicePdfScreenWidget(invoiceDetailsList: args?[AppStrings.invoiceListString]),
    );
  }
}

class InvoicePdfScreenWidget extends StatelessWidget {
  final Invoice invoiceDetailsList;
  InvoicePdfScreenWidget({super.key, required this.invoiceDetailsList});

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  final PdfViewerController _pdfViewerController = PdfViewerController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoicePdfBloc, InvoicePdfState>(
      builder: (context, state) {
        final bloc = context.read<InvoicePdfBloc>();
        final String? fullUrl = state.invoiceDetailsList.invoiceLink;

        Widget itemOne(InvoicePdfState state) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleText(context, AppLocalizations.of(context)!.invoice),
                    subTitleValueText(context, invoiceDetailsList.invoiceNumber.toString()),
                  ],
                ),
                invoiceDetailsList.paymentStatus != null ? getPaymentStatusWidget(invoiceDetailsList.paymentStatus!, context) : 0.width
              ],
            );

        Widget itemTwo(InvoicePdfState state) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      titleText(context, AppLocalizations.of(context)!.invoice_date),
                      subTitleValueText(
                        context,
                        (invoiceDetailsList.invoiceDate ?? '').isNotEmpty ? invoiceDetailsList.invoiceDate!.substring(0, 10) : '',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      titleText(context, AppLocalizations.of(context)!.due_date),
                      subTitleValueText(context, (invoiceDetailsList.dueDate ?? '').isNotEmpty ? invoiceDetailsList.dueDate!.substring(0, 10) : '--'),
                    ],
                  ),
                ),
              ],
            );

        Widget itemThree(InvoicePdfState state) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      titleText(context, AppLocalizations.of(context)!.for_order),
                      GestureDetector(
                        onTap: () async {
                          Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) => ProductDetailsScreen(
                                  statusList: state.statusList,
                                  orderNumber: invoiceDetailsList.orderNumber.toString() ?? '',
                                  orderId: invoiceDetailsList.orderId.toString() ?? '',
                                  isNavigateToProductDetailString: true,
                                ),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  const begin = Offset(0.0, 1.0);
                                  const end = Offset.zero;
                                  const curve = Curves.bounceIn;
                                  var tween = Tween(
                                    begin: begin,
                                    end: end,
                                  ).chain(CurveTween(curve: curve));
                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                              ));
                        },
                        child: invoiceDetailsList.orderNumber == null
                            ? const Text('---')
                            : Stack(
                                alignment: Alignment.bottomLeft,
                                children: [
                                  Text(
                                    invoiceDetailsList.orderNumber.toString(),
                                    style: AppStyles.rkRegularTextStyle(
                                      size: AppConstants.smallFont,
                                      color: AppColors.notificationColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      height: 1,
                                      color: AppColors.notificationColor,
                                      margin: const EdgeInsets.only(top: AppConstants.padding_3),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      titleText(context, AppLocalizations.of(context)!.total_invoice_amount),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: subTitleValueText(context, formatSignedNumber(invoiceDetailsList.invoiceAmount)),
                      ),
                    ],
                  ),
                ),
              ],
            );

        return Scaffold(
          backgroundColor: AppColors.pageColor,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
            child: CommonAppBar(
              bgColor: AppColors.pageColor,
              title: context.read<InvoicePdfBloc>().screenTitleName == AppLocalizations.of(context)!.my_invoices ? AppLocalizations.of(context)!.my_invoices : AppLocalizations.of(context)!.my_refunds,
              iconData: Icons.arrow_back_ios_sharp,
              onTap: () {
                Navigator.pop(context);
              },
              trailingWidget: GestureDetector(
                onTap: () async {
                  Share.share('${invoiceDetailsList.invoiceLink}');
                },
                child: Icon(
                  Icons.download_outlined,
                  color: AppColors.mainColor,
                ),
              ),
            ),
          ),
          body: Builder(builder: (_) {
            if (state.hasValidLink == null) {
              return const SizedBox.shrink();
            }
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SafeArea(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(AppConstants.padding_8),
                          padding: const EdgeInsets.all(AppConstants.padding_8),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            border: Border.all(color: AppColors.borderColor),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(
                                AppConstants.radius_10,
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              itemOne(state),
                              const DividerWidget(
                                height: 20.0,
                              ),
                              itemTwo(state),
                              const DividerWidget(
                                height: 20.0,
                              ),
                              itemThree(state),
                            ],
                          ),
                        ),
                        15.height,
                        state.hasValidLink == false || !bloc.isValidLink(fullUrl)
                            ? Center(
                                child: Text(AppLocalizations.of(context)!.no_invoice_file),
                              )
                            : Container(
                                color: Colors.white,
                                height: getScreenHeight(context) * 0.7,
                                child: SfPdfViewer.network(
                                  invoiceDetailsList.invoiceLink ?? '',
                                  key: _pdfViewerKey,
                                  controller: _pdfViewerController,
                                ),
                              ),
                      ],
                    ),
                    state.isDownloading
                        ? Container(
                            height: getScreenHeight(context),
                            width: getScreenWidth(context),
                            color: const Color.fromARGB(20, 0, 0, 0),
                            alignment: Alignment.center,
                            child: Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(color: AppColors.whiteColor, borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_10))),
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CupertinoActivityIndicator(
                                    color: AppColors.mainColor,
                                    radius: AppConstants.radius_10,
                                  ),
                                  10.height,
                                  Text(
                                    '${state.downloadProgress}%',
                                    style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: AppColors.blackColor),
                                  )
                                ],
                              ),
                            ),
                          )
                        : 0.width,
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
