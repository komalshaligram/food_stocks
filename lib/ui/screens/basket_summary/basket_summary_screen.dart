import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:food_stock/ui/screens/basket_summary/total_amount_card_widget.dart';
import 'package:food_stock/ui/screens/product_details_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../bloc/basket_summary/basket_summary_bloc.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../../../data/model/res_model/get_order_by_id/get_order_by_id_model.dart';
import '../../../data/model/res_model/my_account_card_invoices_res_model/my_account_card_invoices_res_model.dart';
import '../../../data/model/res_model/status_info_res_model/status_info_res_model.dart';
import '../../../data/storage/shared_preferences_helper.dart';
import '../../../repository/dio_client.dart';
import '../../../routes/app_routes.dart';
import '../../widget/dialogs/bank_transfer_dialog.dart';
import '../../widget/dialogs/three_option_payment_dialog.dart';
import '../../widget/dialogs/two_option_payment_dialog.dart';
import '../../widget/sized_box_widget.dart';
import '../../utils/app_utils.dart';
import '../../utils/constants/app_colors.dart';
import '../../utils/constants/app_constants.dart';
import '../../utils/constants/app_strings.dart';
import '../../utils/constants/app_styles.dart';
import '../../utils/constants/app_urls.dart';
import '../../widget/common_app_bar.dart';
import '../../widget/common_dialog_with_one_button.dart';
import '../../widget/common_order_content_widget.dart';
import '../../widget/order_summary_screen_shimmer_widget.dart';

class BasketSummaryRoute {
  static Widget get route => const BasketSummaryScreen();
}

class BasketSummaryScreen extends StatelessWidget {
  const BasketSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
      create: (context) => BasketSummaryBloc()
        ..add(BasketSummaryEvent.getDataEvent(
          context: context,
          cartItemList: args?[AppStrings.getCartListString],
          orderBySupplierId: args?[AppStrings.orderBySupplierId] ?? '',
          isSupplierSingle: args?[AppStrings.isSupplierSingle],
          totalSupplier: args?[AppStrings.totalSupplier],
        )),
      child: const BasketSummaryScreenWidget(),
    );
  }
}

class BasketSummaryScreenWidget extends StatelessWidget {
  const BasketSummaryScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    BasketSummaryBloc bloc = context.read<BasketSummaryBloc>();
    return BlocListener<BasketSummaryBloc, BasketSummaryState>(
      listenWhen: (previous, current) =>
          previous.showPopUp != current.showPopUp && current.showPopUp == true,
      listener: (context, state) {
        if (state.showPopUp) {
          if (state.clubAgentId == AppStrings.clubAgentIdText &&
              state.isAvailableAllPayments == false) {
            paymentOptionPopupOne(state, context, bloc);
          } else if (state.clubAgentId == AppStrings.clubAgentIdText &&
              state.isAvailableAllPayments == true) {
            paymentOptionPopupTwo(state, context, bloc);
          } else {
            paymentOptionPopupThree(state, context, bloc);
          }
        } else if (state.isOrderPending) {
          showDialog(
              context: context,
              builder: (context1) {
                return CustomOneButtonDialog(
                    title: AppLocalizations.of(context)!.order_sign_dialog,
                    directionality: state.language,
                    positiveOnTap: () async {
                      SharedPreferencesHelper preferences =
                          SharedPreferencesHelper(
                              prefs: await SharedPreferences.getInstance());
                      try {
                        final res = await DioClient(context).get(
                            path:
                                '${AppUrlEndPoints.getLatestOnthewayOrderUrl}${preferences.getUserId()}');
                        GetOrderByIdModel response =
                            GetOrderByIdModel.fromJson(res);
                        final String statusData =
                            preferences.getOrderStatusInfo();
                        final List<StatusData> statusList =
                            StatusData.decode(statusData);
                        Navigator.pop(context1);
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                                pageBuilder: (context, animation,
                                        secondaryAnimation) =>
                                    ProductDetailsScreen(
                                      statusList: statusList,
                                      orderNumber: response
                                              .data?.orderData?[0].orderNumber
                                              .toString() ??
                                          '',
                                      orderId:
                                          response.data?.orderData?[0].id ?? '',
                                      isNavigateToProductDetailString: false,
                                      productData:
                                          response.data!.ordersBySupplier![0],
                                      orderData: response.data!.orderData![0],
                                      isFromBasket: true,
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
                      } catch (e) {
                        CustomSnackBar.showSnackBar(
                            context: context,
                            title: e.toString(),
                            type: SnackBarType.failure);
                      }
                    },
                    positiveTitle: AppLocalizations.of(context)!.show_order,
                    width: 150,
                    paymentType: 'creditCard');
              }).then((value) {
            context
                .read<BasketSummaryBloc>()
                .add(const BasketSummaryEvent.refreshEvent());
          });
        } else if (state.isPaymentFail) {
          showDialog(
              context: context,
              builder: (context1) {
                if (state.isAllPaymentAvailable) {
                  if (state.isWalletRelatedError) {
                    return twoOptionPaymentDialog(
                        context, state, bloc, context1);
                  } else {
                    return threeOptionPaymentDialog(
                        context, state, bloc, context1);
                  }
                } else {
                  return twoOptionPaymentDialog(context, state, bloc, context1);
                }
              }).then((value) {
            context
                .read<BasketSummaryBloc>()
                .add(const BasketSummaryEvent.refreshEvent());
          });
        } else if (state.updatePaymentMethod) {
          showDialog(
              context: context,
              builder: (context1) {
                return CustomOneButtonDialog(
                  width: MediaQuery.of(context).size.width,
                  title: AppLocalizations.of(context)!.how_do_you_want_to_pay,
                  directionality: state.language,
                  positiveTitle: state.paymentTypesList
                          .any((e) => e == AppStrings.creditCard)
                      ? AppLocalizations.of(context)!.pay_with_credit_card
                      : null,
                  positiveOnTap: () {
                    Navigator.pop(context);
                    bool c = state.paymentTypesList
                        .any((e) => e == AppStrings.creditCard);
                    if (c) {
                      bloc.add(BasketSummaryEvent.orderSendEvent(
                          context: context,
                          failPayment: false,
                          paymentMethod: AppStrings.creditCard));
                    } else {
                      Navigator.pushNamed(
                          context1, RouteDefine.creditCardDetailsScreen.name,
                          arguments: {
                            AppStrings.isPaymentFail: state.isPaymentFail,
                            AppStrings.isPaymentToNext: false,
                            AppStrings.invoiceData: const MyCardInvoice(),
                          });
                    }
                  },
                  positiveOnTap1: () {
                    Navigator.pop(context);
                    bool c = state.paymentTypesList
                        .any((e) => e == AppStrings.wallet);
                    if (c) {
                      bloc.add(BasketSummaryEvent.orderSendEvent(
                          context: context,
                          failPayment: false,
                          paymentMethod: AppStrings.wallet));
                    } else {
                      Navigator.pushNamed(
                          context1, RouteDefine.bankInfoScreen.name,
                          arguments: {
                            AppStrings.isPaymentFail: state.isPaymentFail,
                            AppStrings.updateString: true
                          });
                    }
                  },
                  positiveOnTap2: () {
                    Navigator.pop(context);
                    bankTransferDialog(
                        context: context1,
                        language: state.language,
                        text: state.bankTransferInfo,
                        function: () {
                          bloc.add(BasketSummaryEvent.payWithBankTransferEvent(
                              context: context, isFromRemovePopUp: false));
                        });
                  },
                  positiveOnTap3: () {
                    Navigator.pop(context);
                    bloc.add(BasketSummaryEvent.orderSendEvent(
                        context: context,
                        failPayment: state.isPaymentFail,
                        paymentMethod: AppStrings.bankCheck));
                  },
                  positiveTitle1:
                      state.paymentTypesList.any((e) => e == AppStrings.wallet)
                          ? AppLocalizations.of(context)!.pay_with_wallet
                          : null,
                  positiveTitle3: state.paymentTypesList
                          .any((e) => e == AppStrings.bankCheck)
                      ? AppLocalizations.of(context)!.pay_with_bank_check
                      : null,
                  positiveTitle2: state.paymentTypesList
                          .any((e) => e == AppStrings.bankTransfer)
                      ? AppLocalizations.of(context)!.pay_with_bank_transfer
                      : null,
                );
              }).then((value) {
            context
                .read<BasketSummaryBloc>()
                .add(const BasketSummaryEvent.refreshEvent());
          });
        }
      },
      child: BlocBuilder<BasketSummaryBloc, BasketSummaryState>(
          builder: (context, state) {
        return Stack(children: [
          Scaffold(
            backgroundColor: AppColors.pageColor,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
              child: CommonAppBar(
                  bgColor: AppColors.pageColor,
                  title: AppLocalizations.of(context)!.order_summary,
                  iconData: Icons.arrow_back_ios_sharp,
                  onTap: () {
                    Navigator.pop(context);
                  }),
            ),
            body: SafeArea(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    state.tempList.isEmpty
                        ? const Expanded(
                            child: OrderSummaryScreenShimmerWidget())
                        : Expanded(
                            child: AnimationLimiter(
                              child: ListView.builder(
                                physics: const ClampingScrollPhysics(),
                                itemCount: state.tempList.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                padding: const EdgeInsets.symmetric(
                                    vertical: AppConstants.padding_5),
                                itemBuilder: (context, index) =>
                                    AnimationConfiguration.staggeredList(
                                  duration: const Duration(seconds: 1),
                                  position: index,
                                  child: SlideAnimation(
                                      child: FadeInAnimation(
                                          child: orderListItem(
                                              index: index,
                                              context: context,
                                              bloc: bloc))),
                                ),
                              ),
                            ),
                          ),
                  ]),
            ),
          ),
          state.isLoading
              ? Positioned.fill(
                  child: Container(
                    color: AppColors.blackColor.withValues(alpha: 0.3),
                    child: Center(
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          padding: const EdgeInsets.all(AppConstants.padding_5),
                          width: 200,
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius:
                                BorderRadius.circular(AppConstants.radius_7),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: AppConstants.radius_10,
                                  offset: Offset(0, 4))
                            ],
                          ),
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            SizedBox(
                                height: 80,
                                width: 130,
                                child: Lottie.asset(
                                    'assets/images/super_market.json',
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.fill)),
                            10.height,
                            Text(
                              AppLocalizations.of(context)!.basket_loader_text,
                              style: TextStyle(
                                  color: AppColors.blackColor,
                                  fontSize: AppConstants.font_14,
                                  fontWeight: FontWeight.bold),
                            ),
                            4.height,
                            Text(AppLocalizations.of(context)!.please_wait_text,
                                style: TextStyle(
                                    fontSize: AppConstants.font_14,
                                    color: AppColors.greyColor)),
                            8.height,
                          ]),
                        ),
                      ),
                    ),
                  ),
                )
              : 0.width
        ]);
      }),
    );
  }

  void paymentOptionPopupOne(
      BasketSummaryState state, BuildContext context, BasketSummaryBloc bloc,
      {bool isFromRemovePopUp = false}) {
    showDialog(
        context: context,
        builder: (context1) {
          bool c = state.paymentTypesList.any((e) => e == AppStrings.wallet);
          if (c) {
            return CustomOneButtonDialog(
                width: MediaQuery.of(context).size.width,
                title: AppLocalizations.of(context)!.how_do_you_want_to_pay,
                directionality: state.language,
                positiveTitle: state.paymentTypesList
                        .any((e) => e == AppStrings.creditCard)
                    ? AppLocalizations.of(context)!.pay_with_credit_card
                    : null,
                positiveOnTap: () {
                  Navigator.of(context1, rootNavigator: true).pop();
                  Future.delayed(const Duration(milliseconds: 200), () {
                    bloc.add(BasketSummaryEvent.orderSendEvent(
                        context: context,
                        failPayment: false,
                        paymentMethod: AppStrings.creditCard));
                  });
                });
          } else {
            return CustomOneButtonDialog(
              width: MediaQuery.of(context).size.width,
              title: AppLocalizations.of(context)!.how_do_you_want_to_pay,
              directionality: state.language,
              positiveTitle:
                  state.paymentTypesList.any((e) => e == AppStrings.creditCard)
                      ? AppLocalizations.of(context)!.pay_with_credit_card
                      : null,
              positiveOnTap: () {
                Navigator.of(context1, rootNavigator: true).pop();
                Future.delayed(const Duration(milliseconds: 200), () {
                  bloc.add(BasketSummaryEvent.orderSendEvent(
                      context: context,
                      failPayment: false,
                      paymentMethod: AppStrings.creditCard));
                });
              },
              positiveOnTap1: () {
                Navigator.of(context1, rootNavigator: true).pop();
                Future.delayed(const Duration(milliseconds: 200), () {
                  bankTransferDialog(
                      context: context,
                      language: state.language,
                      text: state.bankTransferInfo,
                      function: () {
                        bloc.add(BasketSummaryEvent.payWithBankTransferEvent(
                            context: context,
                            isFromRemovePopUp: isFromRemovePopUp));
                      });
                });
              },
              positiveTitle1: state.paymentTypesList
                      .any((e) => e == AppStrings.bankTransfer)
                  ? AppLocalizations.of(context)!.pay_with_bank_transfer
                  : null,
            );
          }
        });
  }

  void paymentOptionPopupTwo(
      BasketSummaryState state, BuildContext context, BasketSummaryBloc bloc,
      {bool isFromRemovePopUp = false}) {
    showDialog(
        context: context,
        builder: (context1) {
          bool c = state.paymentTypesList.any((e) => e == AppStrings.wallet);
          if (c) {
            return CustomOneButtonDialog(
              width: MediaQuery.of(context).size.width,
              title: AppLocalizations.of(context)!.how_do_you_want_to_pay,
              directionality: state.language,
              positiveTitle:
                  state.paymentTypesList.any((e) => e == AppStrings.creditCard)
                      ? AppLocalizations.of(context)!.pay_with_credit_card
                      : null,
              positiveOnTap: () {
                Navigator.of(context1, rootNavigator: true).pop();
                Future.delayed(const Duration(milliseconds: 200), () {
                  bloc.add(BasketSummaryEvent.orderSendEvent(
                      context: context,
                      failPayment: false,
                      paymentMethod: AppStrings.creditCard));
                });
              },
              positiveOnTap1: () {
                Navigator.of(context1, rootNavigator: true).pop();
                Future.delayed(const Duration(milliseconds: 200), () {
                  bloc.add(BasketSummaryEvent.orderSendEvent(
                      context: context,
                      failPayment: false,
                      paymentMethod: AppStrings.wallet));
                });
              },
              positiveOnTap2: () {
                Navigator.of(context1, rootNavigator: true).pop();
                Future.delayed(const Duration(milliseconds: 200), () {
                  bankTransferDialog(
                      context: context,
                      language: state.language,
                      text: state.bankTransferInfo,
                      function: () {
                        bloc.add(BasketSummaryEvent.payWithBankTransferEvent(
                            context: context,
                            isFromRemovePopUp: isFromRemovePopUp));
                      });
                });
              },
              positiveTitle1:
                  state.paymentTypesList.any((e) => e == AppStrings.wallet)
                      ? AppLocalizations.of(context)!.pay_with_wallet
                      : null,
              positiveTitle2: state.paymentTypesList
                      .any((e) => e == AppStrings.bankTransfer)
                  ? AppLocalizations.of(context)!.pay_with_bank_transfer
                  : null,
            );
          } else {
            return CustomOneButtonDialog(
              width: MediaQuery.of(context).size.width,
              title: AppLocalizations.of(context)!.how_do_you_want_to_pay,
              directionality: state.language,
              positiveTitle:
                  state.paymentTypesList.any((e) => e == AppStrings.creditCard)
                      ? AppLocalizations.of(context)!.pay_with_credit_card
                      : null,
              positiveOnTap: () {
                Navigator.of(context1, rootNavigator: true).pop();
                Future.delayed(const Duration(milliseconds: 200), () {
                  bloc.add(BasketSummaryEvent.orderSendEvent(
                      context: context,
                      failPayment: false,
                      paymentMethod: AppStrings.creditCard));
                });
              },
              positiveOnTap1: () {
                Navigator.of(context1, rootNavigator: true).pop();
                Future.delayed(const Duration(milliseconds: 200), () {
                  bankTransferDialog(
                      context: context1,
                      language: state.language,
                      text: state.bankTransferInfo,
                      function: () {
                        bloc.add(BasketSummaryEvent.payWithBankTransferEvent(
                            context: context,
                            isFromRemovePopUp: isFromRemovePopUp));
                      });
                });
              },
              positiveTitle1: state.paymentTypesList
                      .any((e) => e == AppStrings.bankTransfer)
                  ? AppLocalizations.of(context)!.pay_with_bank_transfer
                  : null,
            );
          }
        });
  }

  void paymentOptionPopupThree(
      BasketSummaryState state, BuildContext context, BasketSummaryBloc bloc,
      {bool isFromRemovePopUp = false}) {
    showDialog(
        context: context,
        builder: (context1) {
          return CustomOneButtonDialog(
            width: MediaQuery.of(context).size.width,
            title: AppLocalizations.of(context)!.how_do_you_want_to_pay,
            directionality: state.language,
            positiveTitle:
                state.paymentTypesList.any((e) => e == AppStrings.creditCard)
                    ? AppLocalizations.of(context)!.pay_with_credit_card
                    : null,
            positiveOnTap: () {
              Navigator.of(context1, rootNavigator: true).pop();
              Future.delayed(const Duration(milliseconds: 200), () {
                bloc.add(BasketSummaryEvent.orderSendEvent(
                    context: context,
                    failPayment: false,
                    paymentMethod: AppStrings.creditCard));
              });
            },
            positiveOnTap1: () {
              Navigator.of(context1, rootNavigator: true).pop();
              Future.delayed(const Duration(milliseconds: 200), () {
                bloc.add(BasketSummaryEvent.orderSendEvent(
                    context: context,
                    failPayment: false,
                    paymentMethod: AppStrings.wallet));
              });
            },
            positiveOnTap2: () {
              Navigator.of(context1, rootNavigator: true).pop();
              Future.delayed(const Duration(milliseconds: 200), () {
                bankTransferDialog(
                    context: context,
                    language: state.language,
                    text: state.bankTransferInfo,
                    function: () {
                      bloc.add(BasketSummaryEvent.payWithBankTransferEvent(
                          context: context,
                          isFromRemovePopUp: isFromRemovePopUp));
                    });
              });
            },
            positiveOnTap3: () {
              Navigator.of(context1, rootNavigator: true).pop();
              Future.delayed(const Duration(milliseconds: 200), () {
                bloc.add(BasketSummaryEvent.orderSendEvent(
                    context: context,
                    failPayment: state.isPaymentFail,
                    paymentMethod: AppStrings.bankCheck));
              });
            },
            positiveTitle1:
                state.paymentTypesList.any((e) => e == AppStrings.wallet)
                    ? AppLocalizations.of(context)!.pay_with_wallet
                    : null,
            positiveTitle2:
                state.paymentTypesList.any((e) => e == AppStrings.bankTransfer)
                    ? AppLocalizations.of(context)!.pay_with_bank_transfer
                    : null,
            positiveTitle3:
                state.paymentTypesList.any((e) => e == AppStrings.bankCheck)
                    ? AppLocalizations.of(context)!.pay_with_bank_check
                    : null,
          );
        });
  }

  Widget orderListItem(
      {required int index,
      required BuildContext context,
      required BasketSummaryBloc bloc}) {
    return BlocBuilder<BasketSummaryBloc, BasketSummaryState>(
        builder: (context, state) {
      final totalSavingsValue =
          double.tryParse(state.tempList[index].totalSavings.toString()) ?? 0.0;
      final savingsSalesValue = totalSavingsValue < 0
          ? '\u200E-${totalSavingsValue.abs().toStringAsFixed(2)}₪'
          : '\u200E${totalSavingsValue.toStringAsFixed(2)}₪';
      return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(AppConstants.padding_10),
              padding: const EdgeInsets.symmetric(
                  vertical: AppConstants.padding_10,
                  horizontal: AppConstants.padding_10),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                boxShadow: [
                  BoxShadow(
                      color: AppColors.shadowColor.withValues(alpha: 0.15),
                      blurRadius: AppConstants.blur_10)
                ],
                borderRadius: const BorderRadius.all(
                    Radius.circular(AppConstants.radius_5)),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            state.tempList[index].suppliers?.contactName! ?? '',
                            style: AppStyles.rkRegularTextStyle(
                                size: AppConstants.font_14,
                                color: AppColors.blackColor),
                          ),
                        ]),
                    10.height,
                    Row(children: [
                      CommonOrderContentWidget(
                        backGroundColor: AppColors.iconBGColor,
                        borderCoder: AppColors.lightBorderColor,
                        flexValue: 3,
                        title: AppLocalizations.of(context)!.products,
                        value:
                            state.tempList[index].totalQuantity?.toString() ??
                                '',
                        titleColor: AppColors.mainColor,
                        valueColor: AppColors.blackColor,
                        valueTextWeight: FontWeight.w700,
                        valueTextSize: AppConstants.smallFont,
                      ),
                      5.width,
                      CommonOrderContentWidget(
                        backGroundColor: AppColors.iconBGColor,
                        borderCoder: AppColors.lightBorderColor,
                        flexValue: 5,
                        title: AppLocalizations.of(context)!.savings_for_sales,
                        value: savingsSalesValue,
                        titleColor: AppColors.orangeColor,
                        valueColor: AppColors.blackColor,
                        valueTextWeight: FontWeight.w700,
                        valueTextSize: AppConstants.smallFont,
                      ),
                      5.width,
                      CommonOrderContentWidget(
                        backGroundColor: AppColors.iconBGColor,
                        borderCoder: AppColors.lightBorderColor,
                        flexValue: 7,
                        title: AppLocalizations.of(context)!.total_order,
                        value: double.parse(
                                state.tempList[index].totalAmount!.toString())
                            .toStringAsFixed(2),
                        titleColor: AppColors.mainColor,
                        valueColor: AppColors.blackColor,
                        valueTextWeight: FontWeight.w500,
                        valueTextSize: AppConstants.smallFont,
                      ),
                    ]),
                  ]),
            ),
            5.height,
            Container(
              margin: const EdgeInsets.only(left: AppConstants.padding_10),
              padding: const EdgeInsets.symmetric(
                  vertical: AppConstants.padding_5,
                  horizontal: AppConstants.padding_10),
              decoration: BoxDecoration(
                  color: AppColors.pesachBGColor,
                  borderRadius: const BorderRadius.all(
                      Radius.circular(AppConstants.radius_50))),
              child: Text(
                '${AppLocalizations.of(context)!.minimum_order} ${state.tempList[index].minOrderAmount} ₪',
                style: AppStyles.rkRegularTextStyle(
                    size: AppConstants.font_14, color: AppColors.blackColor),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: AppConstants.padding_15),
              child: state.tempList[index].notMinimumOrder == false
                  ? Text(
                      AppLocalizations.of(context)!.you_can_send_the_order,
                      style: TextStyle(color: AppColors.notificationColor),
                    )
                  : Text(AppLocalizations.of(context)!.you_cant_send_the_order,
                      style: TextStyle(color: AppColors.redColor)),
            ),
            5.height,
            totalAmountCard(state, context, index)
          ]);
    });
  }

  _loaderWidget(BasketSummaryState state, BuildContext context) {
    if (state.isLoading) {
      return Positioned.fill(
        child: Container(
          color: AppColors.blackColor.withValues(alpha: 0.3),
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(AppConstants.padding_5),
                width: 200,
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(AppConstants.radius_7),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: AppConstants.radius_10,
                        offset: Offset(0, 4))
                  ],
                ),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  SizedBox(
                      height: 80,
                      width: 130,
                      child: Lottie.asset('assets/images/super_market.json',
                          width: 50, height: 50, fit: BoxFit.fill)),
                  10.height,
                  Text(
                    AppLocalizations.of(context)!.basket_loader_text,
                    style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: AppConstants.font_14,
                        fontWeight: FontWeight.bold),
                  ),
                  4.height,
                  Text(AppLocalizations.of(context)!.please_wait_text,
                      style: TextStyle(
                          fontSize: AppConstants.font_14,
                          color: AppColors.greyColor)),
                  8.height,
                ]),
              ),
            ),
          ),
        ),
      );
    }
  }
}
