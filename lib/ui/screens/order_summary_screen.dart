import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../bloc/order_summary/order_summary_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../data/model/req_model/order_send_req_model/order_send_req_model.dart';
import '../../routes/app_routes.dart';
import '../../ui/widget/custom_button_widget.dart';
import '../../ui/widget/sized_box_widget.dart';
import '../utils/app_utils.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_strings.dart';
import '../utils/themes/app_styles.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_dialog_with_one_button.dart';
import '../widget/common_order_content_widget.dart';
import '../widget/order_summary_screen_shimmer_widget.dart';

class OrderSummaryRoute {
  static Widget get route => const OrderSummaryScreen();
}

class OrderSummaryScreen extends StatelessWidget {
  const OrderSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args =
    ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
      create: (context) => OrderSummaryBloc()..add(OrderSummaryEvent.getDataEvent(context: context,cartItemList: args?[AppStrings.getCartListString])),
      child: const OrderSummaryScreenWidget(),
    );
  }
}

class OrderSummaryScreenWidget extends StatelessWidget {
  const OrderSummaryScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    OrderSummaryBloc bloc = context.read<OrderSummaryBloc>();
    return BlocListener<OrderSummaryBloc,OrderSummaryState>(
      listener: (context,state){
        if(state.showPopUp){
          paymentOptionPopup(state,context,bloc);
        }
        else if (state.isPaymentFail) {
          showDialog(
            context: context,
            builder: (context1) {
              printData('available all : ${state.isAllPaymentAvailable}');
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
            context.read<OrderSummaryBloc>().add(const OrderSummaryEvent.refreshEvent());
          });
        }
      else if (state.updatePaymentMethod) {
          showDialog(
            context: context,
            builder: (context1) {
              return CustomOneButtonDialog(
                width: MediaQuery.of(context).size.width,
                title: AppLocalizations.of(context)!.how_do_you_want_to_pay,
                directionality: state.language,
                positiveTitle: AppLocalizations.of(context)!.pay_with_credit_card,
                positiveOnTap: () {
                  Navigator.pop(context);
                  bool c = state.paymentTypesList.any((e) => e == AppStrings.creditCard);
                  if (c) {
                    bloc.add(OrderSummaryEvent.orderSendEvent(context: context, failPayment: false,  paymentMethod: AppStrings.creditCard,));
                  } else {
                    Navigator.pushNamed(context1, RouteDefine.creditCardDetailsScreen.name, arguments: {AppStrings.isPaymentFail: state.isPaymentFail});
                  }
                },
                positiveOnTap1: () {
                  Navigator.pop(context);
                  bool c = state.paymentTypesList.any((e) => e == AppStrings.wallet);
                  if (c) {
                    bloc.add(OrderSummaryEvent.orderSendEvent(context: context, failPayment: false,  paymentMethod: AppStrings.wallet));
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
                        bloc.add(OrderSummaryEvent.payWithBankTransferEvent(context: context,isFromRemovePopUp:false));
                      });
                },
                positiveOnTap3: () {
                  Navigator.pop(context);
                  bloc.add(OrderSummaryEvent.orderSendEvent(context: context, failPayment: state.isPaymentFail,  paymentMethod: AppStrings.bankCheck));
                },
                positiveTitle1: AppLocalizations.of(context)!.pay_with_wallet,
                positiveTitle3: AppLocalizations.of(context)!.pay_with_bank_check,
                positiveTitle2: AppLocalizations.of(context)!.pay_with_bank_transfer,
              );
            },
          ).then((value) {
            context.read<OrderSummaryBloc>().add(const OrderSummaryEvent.refreshEvent());
          });
        }
      },
      child: BlocBuilder<OrderSummaryBloc, OrderSummaryState>(
        builder: (context, state) {

          return Scaffold(
            backgroundColor: AppColors.pageColor,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
              child: CommonAppBar(
                trailingWidget: Container(
                  padding: const EdgeInsets.only(left: 2,right: 2,top: 2,bottom: 2),
                  decoration: BoxDecoration(
                    color: AppColors.greyColor,
                    border: Border.all(color: AppColors.whiteColor,width: 3),
                    borderRadius: const BorderRadius.all(Radius.circular(20))
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(left: 8,right: 8,top: 3,bottom: 3),
                      decoration: BoxDecoration(color: AppColors.greyColor,
                          borderRadius: const BorderRadius.all(Radius.circular(20))),
                      child: Text('${AppLocalizations.of(context)!.total} :${formatNumber(value:vatCalculation(price: state.orderSummaryList.data?.cart?.first.totalAmount?? 0,vat: state.orderSummaryList.data?.vatPercentage ?? 0).toStringAsFixed(2),local: AppStrings.hebrewLocal)}',
                        style:  TextStyle(
                  color:AppColors.whiteColor
                      ),)),
                ),
                bgColor: AppColors.pageColor,
                title: AppLocalizations.of(context)!.order_summary,
                iconData: Icons.arrow_back_ios_sharp,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: SafeArea(
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
                              padding: const EdgeInsets.symmetric(
                                  vertical: AppConstants.padding_5),
                              itemBuilder: (context, index) =>
                                  AnimationConfiguration.staggeredList(
                                      duration: const Duration(seconds: 1),
                                      position: index,
                                      child: SlideAnimation(
                                          child: FadeInAnimation(
                                              child: orderListItem(index: index, context: context,bloc:bloc)))),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  twoOptionPaymentDialog(BuildContext context, OrderSummaryState state, OrderSummaryBloc bloc, BuildContext context1) {
    return CustomOneButtonDialog(
      width: MediaQuery.of(context).size.width,
      subTitle: AppLocalizations.of(context)!.payment_dialog_option_title,
      title: state.errorString,
      directionality: state.language,
      positiveTitle: state.isPaymentFail && state.errorString != AppStrings.getLocalizedStrings(AppLocalizations.of(context)!.credit_card_not_found, context)?AppLocalizations.of(context)!.pay_with_credit_card:AppLocalizations.of(context)!.change_credit_card,
      positiveTitle1: AppLocalizations.of(context)!.pay_with_bank_transfer,
      positiveOnTap: () {
        Navigator.pop(context);
        if (state.isPaymentFail && state.errorString != AppStrings.getLocalizedStrings(AppLocalizations.of(context)!.credit_card_not_found, context)) {
          bloc.add(OrderSummaryEvent.orderSendEvent(context: context, failPayment: state.isPaymentFail, paymentMethod: AppStrings.creditCard));
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
              bloc.add(OrderSummaryEvent.payWithBankTransferEvent(context: context,isFromRemovePopUp:false));
            });
      },
      positiveOnTap2: () {
        Navigator.pop(context);
        bloc.add(OrderSummaryEvent.orderSendEvent(context: context, failPayment: state.isPaymentFail,  paymentMethod: AppStrings.bankCheck));
      },
      positiveTitle2: AppLocalizations.of(context)!.pay_with_bank_check,
    );
  }

  threeOptionPaymentDialog(BuildContext context, OrderSummaryState state, OrderSummaryBloc bloc, BuildContext context1) {
    return CustomOneButtonDialog(
      width: MediaQuery.of(context).size.width,
      title: state.errorString,
      subTitle: AppLocalizations.of(context)!.payment_dialog_option_title,
      directionality: state.language,
      positiveTitle: state.isPaymentFail && !state.isWalletRelatedError ? AppLocalizations.of(context)!.change_credit_card : AppLocalizations.of(context)!.pay_with_credit_card,
      positiveOnTap: () {
        Navigator.pop(context);
        if (state.isPaymentFail && state.errorString != AppStrings.getLocalizedStrings(AppLocalizations.of(context)!.credit_card_not_found, context)) {
          bloc.add(OrderSummaryEvent.orderSendEvent(context: context, failPayment: state.isPaymentFail, paymentMethod: AppStrings.creditCard,));
        } else {
          Navigator.pushNamed(context1, RouteDefine.creditCardDetailsScreen.name, arguments: {AppStrings.isPaymentFail: state.isPaymentFail});
        }
      },
      positiveOnTap1: () {
        Navigator.pop(context);
        printData(' state.bankTransferInfo:${state.bankTransferInfo}');
        if (state.isPaymentFail && state.bankTransferInfo.isNotEmpty) {
          bloc.add(OrderSummaryEvent.orderSendEvent(context: context, failPayment: state.isPaymentFail, paymentMethod: AppStrings.wallet,));
        } else {
          Navigator.pushNamed(context1, RouteDefine.bankInfoScreen.name, arguments: {AppStrings.isPaymentFail: false, AppStrings.updateString: true,});
        }
      },
      positiveOnTap2: () {
        Navigator.pop(context);
        bankTransferDialog(
            context: context1,
            language: state.language,
            text: state.bankTransferInfo,
            function: () {
              bloc.add(OrderSummaryEvent.payWithBankTransferEvent(context: context,isFromRemovePopUp:false));
            });
      },
      positiveOnTap3: () {
        Navigator.pop(context);
        bloc.add(OrderSummaryEvent.orderSendEvent(context: context, failPayment: state.isPaymentFail,  paymentMethod: AppStrings.bankCheck));
      },
      positiveTitle1: AppLocalizations.of(context)!.change_to_wallet_payment,
      positiveTitle2: AppLocalizations.of(context)!.pay_with_bank_transfer,
      positiveTitle3: AppLocalizations.of(context)!.pay_with_bank_check,
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

  void paymentOptionPopup(OrderSummaryState state, BuildContext context, OrderSummaryBloc bloc, {bool isFromRemovePopUp = false}) {
    showDialog(
        context: context,
        builder: (context1) {
          bool c = state.paymentTypesList.any((e) => e == AppStrings.wallet);
          if (c) {
            return CustomOneButtonDialog(
              width: MediaQuery.of(context).size.width,
              title: AppLocalizations.of(context)!.how_do_you_want_to_pay,
              directionality: state.language,
              positiveTitle: AppLocalizations.of(context)!.pay_with_credit_card,
              positiveOnTap: () {
                Navigator.pop(context);
                bloc.add(OrderSummaryEvent.orderSendEvent(context: context, failPayment: false, paymentMethod: AppStrings.creditCard));
              },
              positiveOnTap1: () {
                Navigator.pop(context);
                bloc.add(OrderSummaryEvent.orderSendEvent(context: context, failPayment: false,  paymentMethod: AppStrings.wallet));
              },
              positiveOnTap2: () {
                Navigator.pop(context);
                bankTransferDialog(
                    context: context1,
                    language: state.language,
                    text: state.bankTransferInfo,
                    function: () {
                      bloc.add(OrderSummaryEvent.payWithBankTransferEvent(context: context,isFromRemovePopUp:isFromRemovePopUp));
                    });
              },
              positiveOnTap3: () {
                Navigator.pop(context1);
                bloc.add(OrderSummaryEvent.orderSendEvent(context: context, failPayment: state.isPaymentFail, paymentMethod: AppStrings.bankCheck));
              },
              positiveTitle1: AppLocalizations.of(context)!.change_to_wallet_payment,
              positiveTitle2: AppLocalizations.of(context)!.pay_with_bank_transfer,
              positiveTitle3: AppLocalizations.of(context)!.pay_with_bank_check,
            );
          } else {
            return CustomOneButtonDialog(
              width: MediaQuery.of(context).size.width,
              title: AppLocalizations.of(context)!.how_do_you_want_to_pay,
              directionality: state.language,
              positiveTitle: AppLocalizations.of(context)!.pay_with_credit_card,
              positiveOnTap: () {
                Navigator.pop(context);
                bloc.add(OrderSummaryEvent.orderSendEvent(context: context, failPayment: false, paymentMethod: AppStrings.creditCard,));
                //  Navigator.pushNamed(context1, RouteDefine.creditCardDetailsScreen.name, arguments: {AppStrings.isPaymentFail: state.isPaymentFail});
              },
              positiveOnTap1: () {
                Navigator.pop(context);
                bankTransferDialog(
                    context: context1,
                    language: state.language,
                    text: state.bankTransferInfo,
                    function: () {
                      bloc.add(OrderSummaryEvent.payWithBankTransferEvent(context: context,isFromRemovePopUp:isFromRemovePopUp));
                    });
             //   bloc.add(OrderSummaryEvent.orderSendEvent(context: context, failPayment: false,  paymentMethod: AppStrings.bankTransfer,));
              },
              positiveTitle1: AppLocalizations.of(context)!.pay_with_bank_transfer,
            );
          }
        });
  }

  Widget orderListItem({required int index, required BuildContext context,required OrderSummaryBloc bloc}) {
   /* OrderSummaryBloc bloc = context.read<OrderSummaryBloc>();*/
    return BlocBuilder<OrderSummaryBloc, OrderSummaryState>(
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.all(AppConstants.padding_10),
          padding: const EdgeInsets.symmetric(
              vertical: AppConstants.padding_10,
              horizontal: AppConstants.padding_10),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            boxShadow: [
              BoxShadow(
                  color: AppColors.shadowColor.withOpacity(0.15),
                  blurRadius: AppConstants.blur_10),
            ],
            borderRadius:
                const BorderRadius.all(Radius.circular(AppConstants.radius_5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                state.tempList[index].suppliers
                        ?.contactName! ?? '',
                style: AppStyles.rkRegularTextStyle(
                  size: AppConstants.font_14,
                  color: AppColors.blackColor,
                ),
              ),
              10.height,
              Row(
                children: [
                  CommonOrderContentWidget(
                    backGroundColor: AppColors.iconBGColor,
                    borderCoder: AppColors.lightBorderColor,
                    flexValue: 3,
                    title: AppLocalizations.of(context)!.products,
                    value:   state.tempList[index].totalQuantity
                            ?.toString() ??
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
                    value:   state.tempList[index].totalSavings
                        ?.toString() ??
                        '',
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
                    value:
                    formatNumber(value: vatCalculation(price: double.parse(  state.tempList[index].totalAmount ?? '0'),vat: state.orderSummaryList.data?.vatPercentage ?? 0).toStringAsFixed(2),local: AppStrings.hebrewLocal),
                    titleColor: AppColors.mainColor,
                    valueColor: AppColors.blackColor,
                    valueTextWeight: FontWeight.w500,
                    valueTextSize: AppConstants.smallFont,
                  ),

                ],
              ),
             8.height,
              CustomButtonWidget(
                buttonText: AppLocalizations.of(context)!.send_order,
                bGColor: AppColors.mainColor,
                height: 40,
                isLoading: state.tempList[index].isProcess??false,
                onPressed: () {
                  bloc.add(OrderSummaryEvent.getSupplierPaymentTypeEvent(context: context,id:  state.tempList[index].suppliers?.id??'',index: index));
                },
                fontColors: AppColors.whiteColor,
              ),
            ],
          ),
        );
      },
    );
  }
}
