import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:food_stock/ui/screens/product_details_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../bloc/basket_summary/basket_summary_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../data/model/res_model/get_order_by_id/get_order_by_id_model.dart';
import '../../data/model/res_model/status_info_res_model/status_info_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../routes/app_routes.dart';
import '../../ui/widget/custom_button_widget.dart';
import '../../ui/widget/sized_box_widget.dart';
import '../utils/app_utils.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_strings.dart';
import '../utils/constants/app_styles.dart';
import '../utils/constants/app_urls.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_dialog_with_one_button.dart';
import '../widget/common_order_content_widget.dart';
import '../widget/order_summary_screen_shimmer_widget.dart';

class BasketSummaryRoute {
  static Widget get route => const BasketSummaryScreen();
}

class BasketSummaryScreen extends StatelessWidget {
  const BasketSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
      create: (context) => BasketSummaryBloc()..add(BasketSummaryEvent.getDataEvent(context: context, cartItemList: args?[AppStrings.getCartListString], orderBySupplierId: args?[AppStrings.orderBySupplierId] ?? '', isSupplierSingle: args?[AppStrings.isSupplierSingle], totalSupplier: args?[AppStrings.totalSupplier])),
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
      listener: (context, state) {
        if (state.showPopUp) {
          paymentOptionPopup(state, context, bloc);
        } else if (state.isOrderPending) {
          showDialog(
            context: context,
            builder: (context1) {
              return CustomOneButtonDialog(
                  title: AppLocalizations.of(context)!.order_sign_dialog,
                  directionality: state.language,
                  positiveOnTap: () async {
                    SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

                    try {
                      final res = await DioClient(context).get(path: '${AppUrlEndPoints.getLatestOnthewayOrderUrl}${preferencesHelper.getUserId()}');

                      GetOrderByIdModel response = GetOrderByIdModel.fromJson(res);

                      final String statusData = preferencesHelper.getOrderStatusInfo();
                      final List<StatusData> statusList = StatusData.decode(statusData);

                      Navigator.pop(context1);
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => ProductDetailsScreen(
                              statusList: statusList,
                              orderNumber: response.data?.orderData?[0].orderNumber.toString() ?? '',
                              orderId: response.data?.orderData?[0].id ?? '',
                              isNavigateToProductDetailString: false,
                              productData: response.data!.ordersBySupplier![0],
                              orderData: response.data!.orderData![0],
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
                      //
                    } catch (e) {
                      CustomSnackBar.showSnackBar(context: context, title: e.toString(), type: SnackBarType.failure);
                    }

                    // Navigator.pop(context1);
                    // Navigator.pushNamed(context, RouteDefine.orderScreen.name);
                  },
                  positiveTitle: AppLocalizations.of(context)!.show_order,
                  width: 120,
                  paymentType: 'creditCard');
            },
          ).then((value) {
            context.read<BasketSummaryBloc>().add(const BasketSummaryEvent.refreshEvent());
            // context.read<OrderSummaryBloc>().add(const OrderSummaryEvent.refreshEvent());
          });
        } else if (state.isPaymentFail) {
          showDialog(
            context: context,
            builder: (context1) {
              if (state.isAllPaymentAvailable) {
                if (state.isWalletRelatedError) {
                  return twoOptionPaymentDialog(context, state, bloc, context1);
                } else {
                  return threeOptionPaymentDialog(context, state, bloc, context1);
                }
              } else {
                return twoOptionPaymentDialog(context, state, bloc, context1);
              }
            },
          ).then((value) {
            context.read<BasketSummaryBloc>().add(const BasketSummaryEvent.refreshEvent());
          });
        } else if (state.updatePaymentMethod) {
          showDialog(
            context: context,
            builder: (context1) {
              return CustomOneButtonDialog(
                width: MediaQuery.of(context).size.width,
                title: AppLocalizations.of(context)!.how_do_you_want_to_pay,
                directionality: state.language,
                positiveTitle: state.paymentTypesList.any((e) => e == AppStrings.creditCard) ? AppLocalizations.of(context)!.pay_with_credit_card : null,
                positiveOnTap: () {
                  Navigator.pop(context);
                  bool c = state.paymentTypesList.any((e) => e == AppStrings.creditCard);
                  if (c) {
                    bloc.add(BasketSummaryEvent.orderSendEvent(
                      context: context,
                      failPayment: false,
                      paymentMethod: AppStrings.creditCard,
                    ));
                  } else {
                    Navigator.pushNamed(context1, RouteDefine.creditCardDetailsScreen.name, arguments: {AppStrings.isPaymentFail: state.isPaymentFail});
                  }
                },
                positiveOnTap1: () {
                  Navigator.pop(context);
                  bool c = state.paymentTypesList.any((e) => e == AppStrings.wallet);
                  if (c) {
                    bloc.add(BasketSummaryEvent.orderSendEvent(
                      context: context,
                      failPayment: false,
                      paymentMethod: AppStrings.wallet,
                    ));
                  } else {
                    Navigator.pushNamed(context1, RouteDefine.bankInfoScreen.name, arguments: {AppStrings.isPaymentFail: state.isPaymentFail, AppStrings.updateString: true});
                  }
                },
                positiveOnTap2: () {
                  Navigator.pop(context);
                  bankTransferDialog(
                      context: context1,
                      language: state.language,
                      text: state.bankTransferInfo ?? '',
                      function: () {
                        bloc.add(BasketSummaryEvent.payWithBankTransferEvent(context: context, isFromRemovePopUp: false));
                      });
                },
                positiveOnTap3: () {
                  Navigator.pop(context);
                  bloc.add(BasketSummaryEvent.orderSendEvent(context: context, failPayment: state.isPaymentFail, paymentMethod: AppStrings.bankCheck));
                },
                positiveTitle1: state.paymentTypesList.any((e) => e == AppStrings.wallet) ? AppLocalizations.of(context)!.pay_with_wallet : null,
                positiveTitle3: state.paymentTypesList.any((e) => e == AppStrings.bankCheck) ? AppLocalizations.of(context)!.pay_with_bank_check : null,
                positiveTitle2: state.paymentTypesList.any((e) => e == AppStrings.bankTransfer) ? AppLocalizations.of(context)!.pay_with_bank_transfer : null,
              );
            },
          ).then((value) {
            context.read<BasketSummaryBloc>().add(const BasketSummaryEvent.refreshEvent());
          });
        }
      },
      child: BlocBuilder<BasketSummaryBloc, BasketSummaryState>(
        builder: (context, state) {
          return Stack(
            children: [
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
                    },
                  ),
                ),
                body: FocusDetector(
                  onFocusGained: () {},
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        (state.tempList.length ?? 0) == 0
                            ? const Expanded(child: OrderSummaryScreenShimmerWidget())
                            : Expanded(
                                child: AnimationLimiter(
                                  child: ListView.builder(
                                    itemCount: state.tempList.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_5),
                                    itemBuilder: (context, index) => AnimationConfiguration.staggeredList(
                                      duration: const Duration(seconds: 1),
                                      position: index,
                                      child: SlideAnimation(
                                        child: FadeInAnimation(
                                          child: orderListItem(
                                            index: index,
                                            context: context,
                                            bloc: bloc,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
              if (state.isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                    child: Center(
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                  height: 80,
                                  width: 130,
                                  child: Lottie.asset(
                                    'assets/images/super_market.json',
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.fill,
                                  )),
                              const SizedBox(height: 10),
                              Text(
                                AppLocalizations.of(context)!.basket_loader_text,
                                style: TextStyle(color: AppColors.blackColor, fontSize: AppConstants.font_14, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(AppLocalizations.of(context)!.please_wait_text, style: TextStyle(fontSize: AppConstants.font_14, color: AppColors.greyColor)),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  twoOptionPaymentDialog(BuildContext context, BasketSummaryState state, BasketSummaryBloc bloc, BuildContext context1) {
    return CustomOneButtonDialog(
      width: MediaQuery.of(context).size.width,
      subTitle: AppLocalizations.of(context)!.payment_dialog_option_title,
      title: state.errorString,
      directionality: state.language,
      positiveTitle: state.paymentTypesList.any((e) => e == AppStrings.creditCard)
          ? state.isPaymentFail && state.errorString != AppStrings.getLocalizedStrings(AppLocalizations.of(context)!.credit_card_not_found, context)
              ? AppLocalizations.of(context)!.pay_with_credit_card
              : AppLocalizations.of(context)!.change_credit_card
          : null,
      positiveTitle1: state.paymentTypesList.any((e) => e == AppStrings.bankTransfer) ? AppLocalizations.of(context)!.pay_with_bank_transfer : null,
      positiveOnTap: () {
        Navigator.pop(context);
        if (state.isPaymentFail && state.errorString != AppStrings.getLocalizedStrings(AppLocalizations.of(context)!.credit_card_not_found, context)) {
          bloc.add(BasketSummaryEvent.orderSendEvent(context: context, failPayment: state.isPaymentFail, paymentMethod: AppStrings.creditCard));
        } else {
          Navigator.pushNamed(context1, RouteDefine.creditCardDetailsScreen.name, arguments: {AppStrings.isPaymentFail: state.isPaymentFail});
        }
      },
      positiveOnTap1: () {
        Navigator.pop(context);
        bankTransferDialog(
            context: context1,
            language: state.language,
            text: state.bankTransferInfo,
            function: () {
              bloc.add(BasketSummaryEvent.payWithBankTransferEvent(context: context, isFromRemovePopUp: false));
            });
      },
      positiveOnTap2: () {
        Navigator.pop(context);
        bloc.add(BasketSummaryEvent.orderSendEvent(context: context, failPayment: state.isPaymentFail, paymentMethod: AppStrings.bankCheck));
      },
      positiveTitle2: state.paymentTypesList.any((e) => e == AppStrings.bankCheck) ? AppLocalizations.of(context)!.pay_with_bank_check : null,
    );
  }

  threeOptionPaymentDialog(BuildContext context, BasketSummaryState state, BasketSummaryBloc bloc, BuildContext context1) {
    return CustomOneButtonDialog(
      width: MediaQuery.of(context).size.width,
      title: state.errorString,
      subTitle: AppLocalizations.of(context)!.payment_dialog_option_title,
      directionality: state.language,
      positiveTitle: state.paymentTypesList.any((e) => e == AppStrings.creditCard)
          ? state.isPaymentFail && !state.isWalletRelatedError
              ? AppLocalizations.of(context)!.change_credit_card
              : AppLocalizations.of(context)!.pay_with_credit_card
          : null,
      positiveOnTap: () {
        Navigator.pop(context);
        if (state.isPaymentFail && state.errorString != AppStrings.getLocalizedStrings(AppLocalizations.of(context)!.credit_card_not_found, context)) {
          bloc.add(BasketSummaryEvent.orderSendEvent(
            context: context,
            failPayment: state.isPaymentFail,
            paymentMethod: AppStrings.creditCard,
          ));
        } else {
          Navigator.pushNamed(context1, RouteDefine.creditCardDetailsScreen.name, arguments: {AppStrings.isPaymentFail: state.isPaymentFail});
        }
      },
      positiveOnTap1: () {
        Navigator.pop(context);
        if (state.isPaymentFail && state.bankTransferInfo.isNotEmpty) {
          bloc.add(BasketSummaryEvent.orderSendEvent(
            context: context,
            failPayment: state.isPaymentFail,
            paymentMethod: AppStrings.wallet,
          ));
        } else {
          Navigator.pushNamed(context1, RouteDefine.bankInfoScreen.name, arguments: {
            AppStrings.isPaymentFail: false,
            AppStrings.updateString: true,
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
              bloc.add(BasketSummaryEvent.payWithBankTransferEvent(context: context, isFromRemovePopUp: false));
            });
      },
      positiveOnTap3: () {
        Navigator.pop(context);
        bloc.add(BasketSummaryEvent.orderSendEvent(context: context, failPayment: state.isPaymentFail, paymentMethod: AppStrings.bankCheck));
      },
      positiveTitle1: state.paymentTypesList.any((e) => e == AppStrings.wallet) ? AppLocalizations.of(context)!.change_to_wallet_payment : null,
      positiveTitle2: state.paymentTypesList.any((e) => e == AppStrings.bankTransfer) ? AppLocalizations.of(context)!.pay_with_bank_transfer : null,
      positiveTitle3: state.paymentTypesList.any((e) => e == AppStrings.bankCheck) ? AppLocalizations.of(context)!.pay_with_bank_check : null,
    );
  }

  void bankTransferDialog({required BuildContext context, required String language, required String text, required Function function}) {
    showDialog(
      context: context,
      builder: (context1) {
        return Directionality(
          textDirection: language == AppStrings.englishString ? TextDirection.ltr : TextDirection.rtl,
          child: AlertDialog(
            contentPadding: const EdgeInsets.all(20.0),
            surfaceTintColor: AppColors.whiteColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            title: Text(
              text,
              style: AppStyles.rkRegularTextStyle(size: 16),
            ),
            actionsPadding: const EdgeInsets.only(right: AppConstants.padding_20, bottom: AppConstants.padding_10, left: AppConstants.padding_20),
            actions: [
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  Navigator.pop(context1);
                  function();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(gradient: AppColors.appMainGradientColor, borderRadius: BorderRadius.circular(8.0)),
                  child: Text(
                    AppLocalizations.of(context)!.understand_submit_order,
                    style: AppStyles.rkRegularTextStyle(color: AppColors.whiteColor, size: AppConstants.smallFont),
                  ),
                ),
              ),
              8.height,
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  Navigator.pop(context1);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(gradient: AppColors.connectGradientColor, border: Border.all(color: AppColors.mainColor), borderRadius: BorderRadius.circular(8.0)),
                  child: Text(
                    AppLocalizations.of(context)!.close,
                    style: AppStyles.rkRegularTextStyle(color: AppColors.mainColor, size: AppConstants.smallFont),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void paymentOptionPopup(BasketSummaryState state, BuildContext context, BasketSummaryBloc bloc, {bool isFromRemovePopUp = false}) {
    showDialog(
        context: context,
        builder: (context1) {
          bool c = state.paymentTypesList.any((e) => e == AppStrings.wallet);
          if (c) {
            return CustomOneButtonDialog(
              width: MediaQuery.of(context).size.width,
              title: AppLocalizations.of(context)!.how_do_you_want_to_pay,
              directionality: state.language,
              positiveTitle: AppLocalizations.of(context)!.pay_with_credit_card, //state.paymentTypesList.any((e) => e == AppStrings.creditCard) ? AppLocalizations.of(context)!.pay_with_credit_card : null,
              positiveOnTap: () {
                Navigator.pop(context);
                bloc.add(BasketSummaryEvent.orderSendEvent(context: context, failPayment: false, paymentMethod: AppStrings.creditCard));
              },
              positiveOnTap1: () {
                Navigator.pop(context);
                bloc.add(BasketSummaryEvent.orderSendEvent(context: context, failPayment: false, paymentMethod: AppStrings.wallet));
              },
              positiveOnTap2: () {
                Navigator.pop(context);
                bankTransferDialog(
                    context: context1,
                    language: state.language,
                    text: state.bankTransferInfo,
                    function: () {
                      bloc.add(BasketSummaryEvent.payWithBankTransferEvent(context: context, isFromRemovePopUp: isFromRemovePopUp));
                    });
              },
              positiveOnTap3: () {
                Navigator.pop(context1);
                bloc.add(BasketSummaryEvent.orderSendEvent(context: context, failPayment: state.isPaymentFail, paymentMethod: AppStrings.bankCheck));
              },
              positiveTitle1: AppLocalizations.of(context)!.change_to_wallet_payment, //state.paymentTypesList.any((e) => e == AppStrings.wallet) ? AppLocalizations.of(context)!.change_to_wallet_payment : null,
              positiveTitle2: AppLocalizations.of(context)!.pay_with_bank_transfer, //state.paymentTypesList.any((e) => e == AppStrings.bankTransfer) ? AppLocalizations.of(context)!.pay_with_bank_transfer : null,
              positiveTitle3: AppLocalizations.of(context)!.pay_with_bank_check, //state.paymentTypesList.any((e) => e == AppStrings.bankCheck) ? AppLocalizations.of(context)!.pay_with_bank_check : null,
            );
          } else {
            return CustomOneButtonDialog(
              width: MediaQuery.of(context).size.width,
              title: AppLocalizations.of(context)!.how_do_you_want_to_pay,
              directionality: state.language,
              positiveTitle: AppLocalizations.of(context)!.pay_with_credit_card,
              positiveOnTap: () {
                Navigator.pop(context);
                bloc.add(BasketSummaryEvent.orderSendEvent(
                  context: context,
                  failPayment: false,
                  paymentMethod: AppStrings.creditCard,
                ));
                //  Navigator.pushNamed(context1, RouteDefine.creditCardDetailsScreen.name, arguments: {AppStrings.isPaymentFail: state.isPaymentFail});
              },
              positiveOnTap1: () {
                Navigator.pop(context);
                bankTransferDialog(
                    context: context1,
                    language: state.language,
                    text: state.bankTransferInfo,
                    function: () {
                      bloc.add(BasketSummaryEvent.payWithBankTransferEvent(context: context, isFromRemovePopUp: isFromRemovePopUp));
                    });
                //   bloc.add(OrderSummaryEvent.orderSendEvent(context: context, failPayment: false,  paymentMethod: AppStrings.bankTransfer,));
              },
              positiveTitle1: AppLocalizations.of(context)!.pay_with_bank_transfer,
            );
          }
        });
  }

  Widget orderListItem({required int index, required BuildContext context, required BasketSummaryBloc bloc}) {
    /* OrderSummaryBloc bloc = context.read<OrderSummaryBloc>();*/
    return BlocBuilder<BasketSummaryBloc, BasketSummaryState>(
      builder: (context, state) {
        return Column(
          children: [
            Container(
              margin: const EdgeInsets.all(AppConstants.padding_10),
              padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_10, horizontal: AppConstants.padding_10),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                boxShadow: [
                  BoxShadow(color: AppColors.shadowColor.withOpacity(0.15), blurRadius: AppConstants.blur_10),
                ],
                borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_5)),
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
                          color: AppColors.blackColor,
                        ),
                      ),
                    ],
                  ),
                  10.height,
                  Row(
                    children: [
                      CommonOrderContentWidget(
                        backGroundColor: AppColors.iconBGColor,
                        borderCoder: AppColors.lightBorderColor,
                        flexValue: 3,
                        title: AppLocalizations.of(context)!.products,
                        value: state.tempList[index].totalQuantity?.toString() ?? '',
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
                        value: state.tempList[index].totalSavings != null ? state.tempList[index].totalSavings! ?? '' : '',
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

                        value: formatNumber(
                          value: vatCalculation(
                            price: double.parse(state.tempList[index].totalAmount ?? '0'),
                            vat: state.tempList[index].vatPercentage ?? 0,
                            qty: state.tempList[index].bottleQuantities!.toDouble() ?? 0,
                            deposit: state.tempList[index].bottleTax!.toDouble() ?? 0,
                          ).toStringAsFixed(2),
                          local: AppStrings.hebrewLocal,
                        ), //refund: 0.0
                        titleColor: AppColors.mainColor,
                        valueColor: AppColors.blackColor,
                        valueTextWeight: FontWeight.w500,
                        valueTextSize: AppConstants.smallFont,
                      ),
                    ],
                  ),

                  // CustomButtonWidget(
                  //   buttonText: AppLocalizations.of(context)!.send_order,
                  //   bGColor: AppColors.mainColor,
                  //   height: 40,
                  //   // isLoading: state.tempList[index].isProcess ?? false,
                  //   onPressed: () async {
                  //     if (state.tempList[index].draftReturnExists!) {
                  //       await showDialog(
                  //         context: context,
                  //         builder: (_) => CallAgentDialog(
                  //           language: state.language,
                  //           id: state.tempList[index].suppliers?.id ?? '',
                  //           index: index,
                  //           bloc: bloc,
                  //         ),
                  //       );
                  //     } else {
                  //       bloc.add(BasketSummaryEvent.getSupplierPaymentTypeEvent(context: context, id: state.tempList[index].suppliers?.id ?? '', index: index));
                  //     }
                  //   },
                  //   fontColors: AppColors.whiteColor,
                  // ),
                ],
              ),
            ),
            totalAmountCard(state, context, index)
          ],
        );
      },
    );
  }

  Widget totalAmountCard(BasketSummaryState state, BuildContext context, int index) {
    BasketSummaryBloc bloc = context.read<BasketSummaryBloc>();

    // --- Compute price parts ---
    double orderAmount = double.tryParse(state.tempList[index].totalAmount ?? '0') ?? 0;
    double vatPercentage = state.tempList[index].vatPercentage ?? 0;
    double deposit = state.tempList[index].bottleTax ?? 0;
    double qty = state.tempList[index].bottleQuantities?.toDouble() ?? 0;
    double refundAmount = state.orderSummaryList.data?.openRefundTotalAmount ?? 0; // negative value (e.g. -150)

// --- Compute each component ---
    double vatAmount = totalVatAmountCalculation(
      price: orderAmount,
      vat: vatPercentage,
      qty: qty,
      deposit: deposit,
    );

    double bottleDeposit = bottleDepositCalculation(
      deposit: deposit,
      qty: qty,
    );

    double bottleDepositVat = (qty * deposit * vatPercentage) / 100;

// --- Calculate total payable before refund ---
    double totalBeforeRefund;

    if (state.isIncludedVat) {
      // VAT already included in totalAmount
      // So total = orderAmount (already with VAT) + deposit + deposit VAT
      totalBeforeRefund = orderAmount + bottleDeposit ; // +bottleDepositVat
    } else {
      // VAT is not included yet
      totalBeforeRefund = orderAmount + vatAmount + bottleDeposit ; // +bottleDepositVat
    }

// --- Apply refund logic ---
    double remainingRefund = 0;
    double totalRefund =0.0;
    if (refundAmount < 0) {
      double refundAbs = -refundAmount; // make refund positive
      if (refundAbs > totalBeforeRefund) {
        // extra refund left
        totalRefund = totalBeforeRefund - 1;
        remainingRefund = refundAbs - totalRefund;

      }
      else{
        totalRefund =refundAbs;
        remainingRefund = 0;
      }

      printData("check totalRefund ${totalRefund}");
      printData("check remainingRefund ${remainingRefund}");
      printData("check totalBeforeRefund ${totalBeforeRefund}");
      printData("check total refund ${state.orderSummaryList.data?.openRefundTotalAmount}");
    }

    final isHebrew = Localizations.localeOf(context).languageCode == 'he';





    return Container(
        alignment: state.language == AppStrings.englishString ? Alignment.centerLeft : Alignment.centerRight,
        padding: const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 10),
        margin: const EdgeInsets.symmetric(vertical: AppConstants.padding_5, horizontal: AppConstants.padding_10),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_5)),
        ),
        child: Column(
          children: [
            state.tempList[index].bottleQuantities! > 0 ? basketRow(state.language == AppStrings.englishString ? '${AppLocalizations.of(context)!.bottle_deposit}${'X'}${state.tempList[index].bottleQuantities.toString()}' : '${AppLocalizations.of(context)!.bottle_deposit}${state.tempList[index].bottleQuantities.toString()}${'X'}', state.isIncludedVat ? (formatNumber(value: bottleDepositCalculationWithVat(deposit: state.tempList[index].bottleTax!, vatPercentage: state.tempList[index].vatPercentage!, qty: state.tempList[index].bottleQuantities?.toDouble() ?? 0).toStringAsFixed(2), local: AppStrings.hebrewLocal)) : (formatNumber(value: bottleDepositCalculation(deposit: state.tempList[index].bottleTax!, qty: state.tempList[index].bottleQuantities?.toDouble() ?? 0).toStringAsFixed(2), local: AppStrings.hebrewLocal))) : 0.height,
            state.tempList[index].bottleQuantities! > 0
                ? const Divider(
                    height: 8,
                  )
                : 0.height,
            state.isIncludedVat
                ? const SizedBox()
                : basketRow(
                    AppLocalizations.of(context)!.order_amount,
                    formatNumber(
                      value: double.parse(state.tempList[index].totalAmount!.toString()).toStringAsFixed(2),
                      local: AppStrings.hebrewLocal,
                    ),
                  ),

            state.isIncludedVat ? const SizedBox() : const Divider(height: 8),
            state.isIncludedVat
                ? const SizedBox()
                : basketRow(
                    AppLocalizations.of(context)!.vat,
                    (formatNumber(
                      value: totalVatAmountCalculation(price: double.parse(state.tempList[index].totalAmount!), vat: state.tempList[index].vatPercentage!, qty: state.tempList[index].bottleQuantities?.toDouble() ?? 0, deposit: state.tempList[index].bottleTax!).toStringAsFixed(2),
                      local: AppStrings.hebrewLocal,
                    ))),
            state.isIncludedVat ? const SizedBox() : const Divider(height: 8),
            state.isIncludedVat
                ? const SizedBox()
                : basketRow(
                    AppLocalizations.of(context)!.total_refunds,

                    '${totalRefund.toStringAsFixed(2)}₪', //state.orderSummaryList.data?.openRefundTotalAmount! ?? 0
                    // (formatNumber(
                    //   value: (state.orderSummaryList.data?.openRefundTotalAmount! ?? 0).toString(),
                    //   local: AppStrings.hebrewLocal,
                    // ))
                  ),
            state.isIncludedVat ? const SizedBox() : const Divider(height: 8),
            state.isIncludedVat
                ? basketRow(
                    AppLocalizations.of(context)!.total_price_with_vat,
                    (formatNumber(
                        value: (double.parse(state.tempList[index].totalAmount!) +
                                (bottleDepositCalculationWithVatRefund(
                                  deposit: state.tempList[index].bottleTax!,
                                  qty: state.tempList[index].bottleQuantities?.toDouble() ?? 0,
                                  vatPercentage: state.tempList[index].vatPercentage!,
                                  refund: state.orderSummaryList.data?.openRefundTotalAmount,
                                )))
                            .toString(),
                        local: AppStrings.hebrewLocal)),
                    isTitle: true)
                : basketRow(
                    AppLocalizations.of(context)!.total,
                    (formatNumber(
                      value: vatCalculationRefund(
                        price: double.parse(state.tempList[index].totalAmount!),
                        vat: state.tempList[index].vatPercentage!,
                        qty: state.tempList[index].bottleQuantities?.toDouble() ?? 0,
                        deposit: state.tempList[index].bottleTax!,
                        refund: state.orderSummaryList.data?.openRefundTotalAmount,
                      ).toStringAsFixed(2),
                      local: AppStrings.hebrewLocal,
                    )),
                    isTitle: true),
            state.isIncludedVat ? const SizedBox() : const Divider(height: 8),
            if (remainingRefund > 0)
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 4, // space between texts
                children: [
                  Text(
                  isHebrew ? AppLocalizations.of(context)!.refund_amount_1 :
                    '${AppLocalizations.of(context)!.refund_amount_1} ${remainingRefund.toStringAsFixed(2)}${'₪'}', // ₪ // ${formatNumber(
                    // value: remainingRefund.toStringAsFixed(2),
                    // local: AppStrings.hebrewLocal,
                    // )
                    style: AppStyles.rkBoldTextStyle(
                      size: AppConstants.font_15,
                      color: AppColors.notificationColor,
                    ),
                  ),
                  Text(
                    isHebrew ? '${AppLocalizations.of(context)!.refund_amount_2} ${remainingRefund.toStringAsFixed(2)}${'₪'}' :
                    AppLocalizations.of(context)!.refund_amount_2,
                    style: AppStyles.rkBoldTextStyle(
                      size: AppConstants.font_15,
                      color: AppColors.notificationColor,
                    ),
                  ),
                ],
              ),

            30.height,
            Text(
              '${AppLocalizations.of(context)!.note} : ${AppLocalizations.of(context)!.not_include_surfaces_price}',
              style: AppStyles.rkRegularTextStyle(size: AppConstants.font_12, color: AppColors.redColor),
            ),
            2.height,

            CustomButtonWidget(
              buttonText: AppLocalizations.of(context)!.submit,
              bGColor: AppColors.mainColor,
              height: 45,
              // isLoading: state.isLoading,
              onPressed: () async {
                if (state.tempList[index].draftReturnExists!) {
                  await showDialog(
                    context: context,
                    builder: (_) => CallAgentDialog(
                      language: state.language,
                      id: state.tempList[index].suppliers?.id ?? '',
                      index: index,
                      bloc: bloc,
                    ),
                  );
                } else {
                  bloc.add(BasketSummaryEvent.getSupplierPaymentTypeEvent(context: context, id: state.tempList[index].suppliers?.id ?? '', index: index));
                }
                // if (!state.isRemoveProcess && !state.isLoading && !state.isShimmering) {
                //   if (state.supplierCount == 1) {
                //     Navigator.pushNamed(context, RouteDefine.basketSummaryScreen.name, arguments: {
                //       AppStrings.getCartListString: state.cartItemList,
                //     });
                //     // if (state.draftReturnExists) {
                //     //   await showDialog(
                //     //     context: context,
                //     //     builder: (_) => CallAgentDialog(language: state.language, state: state, context1: context, bloc: bloc),
                //     //   );
                //     // } else {
                //     //   paymentOptionPopup(state, context, bloc);
                //     // }
                //
                //     //bloc.add(BasketEvent.orderSendEvent(context: context, failPayment: true, isFromDialog: false, paymentMethod: ''));
                //   } else {
                //     Navigator.pushNamed(context, RouteDefine.orderSummaryScreen.name, arguments: {
                //       AppStrings.getCartListString: state.cartItemList,
                //     });
                //   }
                // }
                // }
              },
              fontColors: AppColors.whiteColor,
            ),
            // : 0.width,
            10.height
          ],
        ));
  }

  Widget basketRow(String title, String amount, {bool isTitle = false, double fontSize = 16}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppStyles.rkRegularTextStyle(size: AppConstants.font_12, color: AppColors.blackColor),
        ),
        Directionality(
          textDirection: TextDirection.ltr,
          child: Text(
            amount,
            style: AppStyles.rkRegularTextStyle(size: fontSize, color: AppColors.blackColor, fontWeight: isTitle ? FontWeight.w700 : FontWeight.w300),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // void removeOutOfStockProductDialog({
  //   required BuildContext context,
  // }) {
  //   BasketSummaryBloc bloc = context.read<BasketSummaryBloc>();
  //   showDialog(
  //       context: context,
  //       builder: (context1) => BlocProvider.value(
  //         value: context.read<BasketSummaryBloc>(),
  //         child: BlocBuilder<BasketSummaryBloc, BasketSummaryState>(
  //           builder: (context, state) {
  //             return AbsorbPointer(
  //                 absorbing: state.isRemoveProcess ? true : false,
  //                 child: CustomDialog(
  //                   title: AppLocalizations.of(context)!.some_products_out_of_stock_Do_you_want_submit_order,
  //                   content: const [],
  //                   isMixedSale: false,
  //                   directionality: state.language,
  //                   positiveTitle: AppLocalizations.of(context)!.yes,
  //                   isProcessing: state.isRemoveProcess,
  //                   negativeTitle: AppLocalizations.of(context)!.no,
  //                   positiveOnTap: () async {
  //                     if (!state.isRemoveProcess && !state.isLoading && !state.isShimmering) {
  //                       if (state.supplierCount == 1) {
  //                         if (state.draftReturnExists) {
  //                           await showDialog(
  //                             context: context,
  //                             builder: (_) => CallAgentDialog(language: state.language, state: state, context1: context, bloc: bloc),
  //                           );
  //                         } else {
  //                           paymentOptionPopup(state, context, bloc, isFromRemovePopUp: true);
  //                         }
  //                         //   bloc.add(BasketEvent.orderSendEvent(context: context, failPayment: true, isFromDialog: false, paymentMethod: ''));
  //                       } else {
  //                         Navigator.pushNamed(context, RouteDefine.orderSummaryScreen.name, arguments: {
  //                           AppStrings.getCartListString: state.cartItemList,
  //                         });
  //                       }
  //                     }
  //                   },
  //                   negativeOnTap: () {
  //                     Navigator.pop(context1);
  //                   },
  //                 ));
  //           },
  //         ),
  //       ));
  // }
}

class CallAgentDialog extends StatelessWidget {
  final String language;
  final String id;
  final int index;
  final BasketSummaryBloc bloc;

  const CallAgentDialog({
    Key? key,
    required this.language,
    required this.id,
    required this.index,
    required this.bloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: language == 'en' ? TextDirection.ltr : TextDirection.rtl,
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(20.0),
        surfaceTintColor: AppColors.whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        content: Text(
          AppLocalizations.of(context)!.return_draft_not_sent,
          // AppStrings.getLocalizedStrings(, context),
          style: AppStyles.rkRegularTextStyle(color: AppColors.blackColor, size: AppConstants.smallFont),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, RouteDefine.returnListScreen.name, arguments: {AppStrings.isbackString: 'orderSummary'});
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 8),
                  decoration: BoxDecoration(gradient: AppColors.appMainGradientColor, borderRadius: BorderRadius.circular(5.0)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.view_return,
                        style: AppStyles.rkRegularTextStyle(
                          size: AppConstants.smallFont,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  Navigator.of(context).pop();
                  bloc.add(BasketSummaryEvent.getSupplierPaymentTypeEvent(context: context, id: id, index: index));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 8),
                  decoration: BoxDecoration(gradient: AppColors.appMainGradientColor, borderRadius: BorderRadius.circular(5.0)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.send_any_way,
                        style: AppStyles.rkRegularTextStyle(
                          size: AppConstants.smallFont,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
