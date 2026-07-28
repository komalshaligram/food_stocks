import 'dart:ui' as widgets;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import 'package:food_stock/ui/screens/product_details_screen.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../bloc/invoice_payment/invoice_payment_bloc.dart';
import '../../data/model/res_model/invoices_res/invoices_res_model.dart';
import '../../data/model/res_model/my_account_card_invoices_res_model/my_account_card_invoices_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../routes/app_routes.dart';
import '../utils/app_utils.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_strings.dart';
import '../utils/constants/app_styles.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_divider_widget.dart';
import '../widget/custom_button_widget.dart';
import '../widget/custom_text_icon_button_widget.dart';

class InvoicePaymentRoute {
  static Widget get route => const InvoicePaymentScreen();
}

class InvoicePaymentScreen extends StatelessWidget {
  const InvoicePaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map?;
    final MyCardInvoice invoiceData = args?[AppStrings.invoiceData];
    final String? creditCardNumber = args?[AppStrings.creditCardNumberString];
    return BlocProvider(
      create: (context) => InvoicePaymentBloc()
        ..add(InvoicePaymentEvent.getStatusDataEvent(context: context)),
      child: InvoicePaymentScreenWidget(
          invoiceData: invoiceData, creditCardNumber: creditCardNumber),
    );
  }
}

class InvoicePaymentScreenWidget extends StatefulWidget {
  const InvoicePaymentScreenWidget(
      {super.key, required this.invoiceData, required this.creditCardNumber});
  final MyCardInvoice invoiceData;
  final String? creditCardNumber;

  @override
  State<InvoicePaymentScreenWidget> createState() =>
      _InvoicePaymentScreenWidgetState();
}

class _InvoicePaymentScreenWidgetState
    extends State<InvoicePaymentScreenWidget> {
  String? updatedCreditCardNumber;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoicePaymentBloc, InvoicePaymentState>(
        builder: (context, state) {
      Widget itemOne(InvoicePaymentState state, MyCardInvoice invoiceDataList) {
        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                titleText(context, AppLocalizations.of(context)!.invoice),
                GestureDetector(
                  onTap: () {
                    final refundInvoiceData = MyCardInvoice(
                      invoiceLink: invoiceDataList.invoiceLink,
                      invoiceNumber: invoiceDataList.invoiceNumber,
                      invoiceAmount: invoiceDataList.invoiceAmount,
                      paymentStatus: invoiceDataList.paymentStatus,
                      invoiceDate: invoiceDataList.invoiceDate,
                      dueDate: invoiceDataList.dueDate,
                      orderNumber: invoiceDataList.orderNumber,
                      orderId: invoiceDataList.orderId,
                      rivchitApiKey: invoiceDataList.rivchitApiKey,
                    );

                    final invoiceData = Invoice(
                      invoiceLink: refundInvoiceData.invoiceLink,
                      invoiceNumber: refundInvoiceData.invoiceNumber.toString(),
                      invoiceAmount: refundInvoiceData.invoiceAmount,
                      paymentStatus: refundInvoiceData.paymentStatus,
                      invoiceDate: refundInvoiceData.invoiceDate,
                      dueDate: refundInvoiceData.dueDate,
                      orderNumber: refundInvoiceData.orderNumber,
                      orderId: invoiceDataList.orderId,
                      rivchitApiKey: invoiceDataList.rivchitApiKey,
                    );

                    Navigator.pushNamed(
                        context, RouteDefine.invoicePdfScreen.name,
                        arguments: {
                          AppStrings.invoiceListString: invoiceData,
                          AppStrings.invoiceTitleNameString:
                              AppLocalizations.of(context)!.my_invoices,
                        });
                  },
                  child: invoiceOrderNumberWidget(
                      invoiceDataList.invoiceNumber.toString()),
                ),
              ]),
              invoiceDataList.paymentMethod != null
                  ? Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          vertical: AppConstants.padding_2,
                          horizontal: AppConstants.padding_10),
                      decoration: BoxDecoration(
                          color: AppColors.mainColor,
                          borderRadius:
                              BorderRadius.circular(AppConstants.radius_50)),
                      child: Text(
                        invoiceDataList.paymentMethod.toString() ==
                                AppStrings.wallet
                            ? AppLocalizations.of(context)!.payment_wallet
                            : invoiceDataList.paymentMethod.toString() ==
                                    AppStrings.creditCard
                                ? AppLocalizations.of(context)!
                                    .payment_credit_card
                                : invoiceDataList.paymentMethod.toString() ==
                                        AppStrings.bankTransfer
                                    ? AppLocalizations.of(context)!
                                        .payment_bank_transfer
                                    : AppLocalizations.of(context)!
                                        .payment_bank_check,
                        style: AppStyles.rkRegularTextStyle(
                            size: AppConstants.font_14,
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.normal),
                      ),
                    )
                  : 0.width,
              invoiceDataList.paymentStatus != null
                  ? getPaymentStatusWidget(
                      invoiceDataList.paymentStatus!, context)
                  : 0.width
            ]);
      }

      Widget itemTwo(InvoicePaymentState state, MyCardInvoice invoiceDataList) {
        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      titleText(
                          context, AppLocalizations.of(context)!.invoice_date),
                      subTitleValueText(
                          context,
                          (invoiceDataList.invoiceDate ?? '').isNotEmpty
                              ? invoiceDataList.invoiceDate!.substring(0, 10)
                              : '---'),
                    ]),
              ),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      titleText(
                          context, AppLocalizations.of(context)!.due_date),
                      subTitleValueText(
                          context,
                          (invoiceDataList.dueDate ?? '').isNotEmpty
                              ? invoiceDataList.dueDate!.substring(0, 10)
                              : '---'),
                    ]),
              ),
            ]);
      }

      Widget itemThree(
          InvoicePaymentState state, MyCardInvoice invoiceDataList) {
        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      titleText(
                          context, AppLocalizations.of(context)!.for_order),
                      GestureDetector(
                        onTap: () async {
                          SharedPreferencesHelper preferences =
                              SharedPreferencesHelper(
                                  prefs: await SharedPreferences.getInstance());
                          preferences.setOrderId(
                              productOrderId:
                                  invoiceDataList.orderId.toString());
                          Navigator.push(
                              context,
                              PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      ProductDetailsScreen(
                                        statusList: state.statusList,
                                        orderNumber: invoiceDataList.orderNumber
                                            .toString(),
                                        orderId:
                                            invoiceDataList.orderId.toString(),
                                        isNavigateToProductDetailString: true,
                                        isFromBasket: false,
                                      ),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    const begin = Offset(0.0, 1.0);
                                    const end = Offset.zero;
                                    const curve = Curves.bounceIn;
                                    var tween = Tween(begin: begin, end: end)
                                        .chain(CurveTween(curve: curve));
                                    return SlideTransition(
                                        position: animation.drive(tween),
                                        child: child);
                                  }));
                        },
                        child: invoiceDataList.orderNumber == null
                            ? const Text('---')
                            : invoiceOrderNumberWidget(
                                invoiceDataList.orderNumber.toString()),
                      ),
                    ]),
              ),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      titleText(context,
                          AppLocalizations.of(context)!.total_invoice_amount),
                      Directionality(
                          textDirection: widgets.TextDirection.ltr,
                          child: subTitleValueText(
                              context,
                              formatSignedNumber(
                                  invoiceDataList.payableAmount))),
                    ]),
              ),
            ]);
      }

      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            Navigator.pop(context, true);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.pageColor,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
            child: CommonAppBar(
                bgColor: AppColors.pageColor,
                title: AppLocalizations.of(context)!.invoice_payment,
                iconData: Icons.arrow_back_ios_sharp,
                onTap: () {
                  Navigator.pop(context, true);
                }),
          ),
          body: SafeArea(
            child: Container(
              padding: const EdgeInsets.all(AppConstants.padding_5),
              margin: const EdgeInsets.all(AppConstants.padding_5),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppConstants.padding_8),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        border: Border.all(color: AppColors.borderColor),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(AppConstants.radius_10)),
                      ),
                      child: Column(children: [
                        itemOne(state, widget.invoiceData),
                        const DividerWidget(height: 20.0),
                        itemTwo(state, widget.invoiceData),
                        const DividerWidget(height: 20.0),
                        itemThree(state, widget.invoiceData),
                      ]),
                    ),
                    15.height,
                    titleText(context,
                        AppLocalizations.of(context)!.credit_card_details),
                    15.height,
                    Container(
                      padding: const EdgeInsets.all(AppConstants.padding_8),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        border: Border.all(color: AppColors.borderColor),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(AppConstants.radius_10)),
                      ),
                      child: Column(children: [
                        10.height,
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              subTitleValueText(
                                  context,
                                  AppLocalizations.of(context)!
                                      .credit_card_number),
                              subTitleValueText(context, ' : '),
                              subTitleValueText(context, '********'),
                              subTitleValueText(
                                context,
                                widget.invoiceData.cardNumber == null
                                    ? (updatedCreditCardNumber ??
                                        widget.creditCardNumber ??
                                        '')
                                    : widget.invoiceData.cardNumber.toString(),
                              )
                            ]),
                        10.height,
                        CustomTextIconButtonWidget(
                            title: AppLocalizations.of(context)!
                                .change_credit_card,
                            onPressed: () async {
                              final result = await Navigator.pushNamed(context,
                                  RouteDefine.creditCardDetailsScreen.name,
                                  arguments: {
                                    AppStrings.isFromRegFlow: false,
                                    AppStrings.isPaymentToNext: true,
                                    AppStrings.invoiceData: widget.invoiceData,
                                    AppStrings.isFromInvoicePayment: true,
                                  });
                              if (!mounted) return;
                              if (result is Map &&
                                  result[AppStrings.creditCardNumberString] !=
                                      null) {
                                setState(() {
                                  updatedCreditCardNumber =
                                      result[AppStrings.creditCardNumberString]
                                          .toString();
                                });
                              }
                            })
                      ]),
                    )
                  ]),
            ),
          ),
          bottomSheet: Container(
            color: AppColors.pageColor,
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.padding_30),
              child: CustomButtonWidget(
                buttonText: AppLocalizations.of(context)!
                    .making_pay_with_credit_card
                    .toUpperCase(),
                bGColor: AppColors.mainColor,
                isLoading: state.isLoading,
                onPressed: () {
                  context.read<InvoicePaymentBloc>().add(
                      InvoicePaymentEvent.addCreditCardEvent(
                          context: context,
                          invoiceNumber: int.parse(
                              widget.invoiceData.invoiceNumber.toString()),
                          orderId: widget.invoiceData.orderId.toString(),
                          supplierId: widget.invoiceData.supplierId.toString(),
                          documentType: widget.invoiceData.documentType!));
                },
                fontColors: AppColors.whiteColor,
              ),
            ),
          ),
        ),
      );
    });
  }
}
