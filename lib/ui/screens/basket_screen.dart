import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:food_stock/ui/screens/product_details_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../bloc/basket/basket_bloc.dart';
import '../../bloc/bottom_nav/bottom_nav_bloc.dart';
import '../../data/model/res_model/get_order_by_id/get_order_by_id_model.dart';
import '../../data/model/res_model/status_info_res_model/status_info_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_colors.dart';
import '../../ui/utils/constants/app_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../ui/utils/constants/app_img_path.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/utils/constants/app_styles.dart';
import '../../ui/utils/constants/app_urls.dart';
import '../../ui/widget/basket_screen_shimmer_widget.dart';
import '../../ui/widget/common_product_details_widget.dart';
import '../../ui/widget/custom_button_widget.dart';
import '../../ui/widget/product_details_shimmer_widget.dart';
import '../../ui/widget/sized_box_widget.dart';
import 'package:html/parser.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:photo_view/photo_view.dart';
import '../widget/bottomsheet_related_product_shimmer_widget.dart';
import '../widget/common_dialog_with_one_button.dart';
import '../widget/common_product_sale_item_widget.dart';
import '../widget/custom_dialog.dart';
import '../widget/no_data_bottom_sheet_widget.dart';

class BasketRoute {
  static Widget get route => const BasketScreen();
}

class BasketScreen extends StatelessWidget {
  const BasketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BasketBloc(),
      child: BasketScreenWidget(),
    );
  }
}

class BasketScreenWidget extends StatelessWidget {
  BasketScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BasketBloc bloc = context.read<BasketBloc>();
    return BlocListener<BasketBloc, BasketState>(
      listener: (context, state) {
        if (state.isAnimation) {
          BlocProvider.of<BottomNavBloc>(context).add(BottomNavEvent.updateCartCountEvent(context: context));
        } else if (state.isAccountPermissionShimmering) {
          BlocProvider.of<BottomNavBloc>(context).add(BottomNavEvent.seeWalletPermissionUpdateEvent(context: context));
        } else if (state.isAppOnMaintenance && !state.isDialogOpen) {
          appUnderMaintenanceDialog(context: context, state: state);
          BlocProvider.of<BasketBloc>(context).add(BasketEvent.updateMaintenanceEvent(context: context));
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


                  },
                  positiveTitle: AppLocalizations.of(context)!.show_order,
                  width: 120,
                  paymentType: 'creditCard');
            },
          ).then((value) {
            context.read<BasketBloc>().add(const BasketEvent.refreshEvent());
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
            context.read<BasketBloc>().add(const BasketEvent.refreshEvent());
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
                    bloc.add(BasketEvent.orderSendEvent(context: context, failPayment: false, isFromDialog: true, paymentMethod: AppStrings.creditCard, isFromRemovePopUp: false));
                  } else {
                    Navigator.pushNamed(context1, RouteDefine.creditCardDetailsScreen.name, arguments: {AppStrings.isPaymentFail: state.isPaymentFail});
                  }
                },
                positiveOnTap1: () {
                  Navigator.pop(context);
                  bool c = state.paymentTypesList.any((e) => e == AppStrings.wallet);
                  if (c) {
                    bloc.add(BasketEvent.orderSendEvent(context: context, failPayment: false, isFromDialog: true, paymentMethod: AppStrings.wallet, isFromRemovePopUp: false));
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
                        bloc.add(BasketEvent.payWithBankTransferEvent(context: context, isFromRemovePopUp: false, id: state.supplierId));
                      });
                },
                positiveOnTap3: () {
                  Navigator.pop(context);
                  bloc.add(BasketEvent.orderSendEvent(context: context, failPayment: state.isPaymentFail, isFromDialog: true, paymentMethod: AppStrings.bankCheck, isFromRemovePopUp: false));
                },
                positiveTitle1: state.paymentTypesList.any((e) => e == AppStrings.wallet) ? AppLocalizations.of(context)!.pay_with_wallet : null,
                positiveTitle3: state.paymentTypesList.any((e) => e == AppStrings.bankCheck) ? AppLocalizations.of(context)!.pay_with_bank_check : null,
                positiveTitle2: state.paymentTypesList.any((e) => e == AppStrings.bankTransfer) ? AppLocalizations.of(context)!.pay_with_bank_transfer : null,
              );
            },
          ).then((value) {
            context.read<BasketBloc>().add(const BasketEvent.refreshEvent());
          });
        }
      },
      child: BlocBuilder<BasketBloc, BasketState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.pageColor,
            body: FocusDetector(
              onFocusGained: () {
                bloc.add(BasketEvent.getPermissionList(context: context));
                bloc.add(BasketEvent.getAllCartEvent(context: context, isFromUpdate: false));
                bloc.add(BasketEvent.userApproveEvent(context: context));
                if (!state.isAppOnMaintenance) {
                  bloc.add(BasketEvent.generalSettings(context: context, dialogContext: context, isRetryLoading: false));
                }
              },
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppConstants.padding_5,
                  ),
                  child: AbsorbPointer(
                    absorbing: state.isRemoveProcess || state.isLoading || state.isShimmering ? true : false,
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            state.basketProductList.isNotEmpty
                                ? Container(
                                    margin: const EdgeInsets.all(AppConstants.padding_10),
                                    padding: const EdgeInsets.all(AppConstants.padding_10),
                                    decoration: BoxDecoration(
                                      color: AppColors.whiteColor.withOpacity(0.95),
                                      boxShadow: [
                                        BoxShadow(color: AppColors.shadowColor.withOpacity(0.20), blurRadius: AppConstants.blur_10),
                                      ],
                                      borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_40)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            deleteDialog(
                                              context: context,
                                              updateClearString: AppStrings.clearString,
                                              listIndex: 0,
                                              cartProductId: '',
                                              totalAmount: 0.0,
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                AppImagePath.delete,
                                                colorFilter: ColorFilter.mode(AppColors.redColor, BlendMode.srcIn),
                                              ),
                                              5.width,
                                              Text(
                                                AppLocalizations.of(context)!.empty,
                                                style: AppStyles.rkRegularTextStyle(
                                                  size: AppConstants.font_14,
                                                  color: AppColors.redColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          AppLocalizations.of(context)!.my_basket,
                                          textAlign: TextAlign.center,
                                          style: AppStyles.rkRegularTextStyle(size: AppConstants.mediumFont, color: AppColors.greyColor, fontWeight: FontWeight.w500),
                                        ),

                                        // InkWell(
                                        //   onTap: () {},
                                        //   child: Icon(
                                        //     Icons.info,
                                        //     color: AppColors.greyColor,
                                        //   ),
                                        // ),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              AppImagePath.delete,
                                              colorFilter: ColorFilter.mode(AppColors.whiteColor, BlendMode.srcIn),
                                            ),
                                            5.width,
                                            Text(
                                              AppLocalizations.of(context)!.empty,
                                              style: AppStyles.rkRegularTextStyle(
                                                size: AppConstants.font_14,
                                                color: AppColors.whiteColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                            state.isShimmering
                                ? const BasketScreenShimmerWidget()
                                : state.basketProductList.isNotEmpty
                                    ? Expanded(
                                        child: AnimationLimiter(
                                          child: ListView.builder(
                                            itemCount: state.basketProductList.length,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_5),
                                            itemBuilder: (context, index) => AnimationConfiguration.staggeredList(
                                              duration: const Duration(seconds: 1),
                                              position: index,
                                              child: SlideAnimation(
                                                verticalOffset: 44.0,
                                                child: FadeInAnimation(
                                                  child: basketListItem(
                                                    isPesach: state.basketProductList[index].isPesach ?? false,
                                                    index: index,
                                                    context: context,
                                                    isSaleOn: true,
                                                    lowStock: state.basketProductList[index].lowStock.toString(),
                                                    productStock: state.basketProductList[index].productStock ?? 0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : !state.isShimmering && state.basketProductList.isEmpty
                                        ? Expanded(
                                            child: Center(
                                                child: Text(
                                              AppLocalizations.of(context)!.cart_empty,
                                              style: AppStyles.pVRegularTextStyle(size: AppConstants.normalFont, color: AppColors.blackColor, fontWeight: FontWeight.w400),
                                            )),
                                          )
                                        : const BasketScreenShimmerWidget(),
                            state.basketProductList.isEmpty
                                ? const SizedBox()
                                : totalAmountCard(
                                    state,
                                    context,
                                  )
                          ],
                        ),
                        if (state.isSubmitLoading)
                          Positioned.fill(
                            child: Container(
                              color: Colors.black.withOpacity(0.3),
                              child: Center(
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  twoOptionPaymentDialog(BuildContext context, BasketState state, BasketBloc bloc, BuildContext context1) {
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
          bloc.add(BasketEvent.orderSendEvent(context: context, failPayment: state.isPaymentFail, isFromDialog: true, paymentMethod: AppStrings.creditCard, isFromRemovePopUp: false));
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
              bloc.add(BasketEvent.payWithBankTransferEvent(context: context, isFromRemovePopUp: false, id: state.supplierId));
            });
      },
      positiveOnTap2: () {
        Navigator.pop(context);
        bloc.add(BasketEvent.orderSendEvent(context: context, failPayment: state.isPaymentFail, isFromDialog: true, paymentMethod: AppStrings.bankCheck, isFromRemovePopUp: false));
      },
      positiveTitle2: state.paymentTypesList.any((e) => e == AppStrings.bankCheck) ? AppLocalizations.of(context)!.pay_with_bank_check : null,
    );
  }

  threeOptionPaymentDialog(BuildContext context, BasketState state, BasketBloc bloc, BuildContext context1) {
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
          bloc.add(BasketEvent.orderSendEvent(context: context, failPayment: state.isPaymentFail, isFromDialog: true, paymentMethod: AppStrings.creditCard, isFromRemovePopUp: false));
        } else {
          Navigator.pushNamed(context1, RouteDefine.creditCardDetailsScreen.name, arguments: {AppStrings.isPaymentFail: state.isPaymentFail});
        }
      },
      positiveOnTap1: () {
        Navigator.pop(context);
        if (state.isPaymentFail && state.bankTransferInfo.isNotEmpty) {
          bloc.add(BasketEvent.orderSendEvent(context: context, failPayment: state.isPaymentFail, isFromDialog: true, paymentMethod: AppStrings.wallet, isFromRemovePopUp: false));
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
              bloc.add(BasketEvent.payWithBankTransferEvent(context: context, isFromRemovePopUp: false, id: state.supplierId));
            });
      },
      positiveOnTap3: () {
        Navigator.pop(context);
        bloc.add(BasketEvent.orderSendEvent(context: context, failPayment: state.isPaymentFail, isFromDialog: true, paymentMethod: AppStrings.bankCheck, isFromRemovePopUp: false));
      },
      positiveTitle1: state.paymentTypesList.any((e) => e == AppStrings.wallet) ? AppLocalizations.of(context)!.change_to_wallet_payment : null,
      positiveTitle2: state.paymentTypesList.any((e) => e == AppStrings.bankTransfer) ? AppLocalizations.of(context)!.pay_with_bank_transfer : null,
      positiveTitle3: state.paymentTypesList.any((e) => e == AppStrings.bankCheck) ? AppLocalizations.of(context)!.pay_with_bank_check : null,
    );
  }

  Widget totalAmountCard(
    BasketState state,
    BuildContext context,
  ) {
    BasketBloc bloc = context.read<BasketBloc>();
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
            // state.bottleQty! > 0 ? basketRow(state.language == AppStrings.englishString ?
            // '${AppLocalizations.of(context)!.bottle_deposit}${'X'}${state.bottleQty.toString()}' :
            // '${AppLocalizations.of(context)!.bottle_deposit}${state.bottleQty.toString()}${'X'}',
            //     state.isIncludedVat ? (formatNumber(value: bottleDepositCalculationWithVat(deposit: state.bottleTax, vatPercentage: state.vatPercentage,
            //         qty: state.bottleQty?.toDouble() ?? 0).toStringAsFixed(2), local: AppStrings.hebrewLocal)) :
            //     (formatNumber(value: bottleDepositCalculation(deposit: state.bottleTax, qty: state.bottleQty?.toDouble() ?? 0).toStringAsFixed(2),
            //         local: AppStrings.hebrewLocal))) : 0.height,
            // state.bottleQty! > 0
            //     ? const Divider(
            //         height: 8,
            //       )
            //     : 0.height,
            // state.isIncludedVat ? const SizedBox() : basketRow(AppLocalizations.of(context)!.sub_total,
            //     (formatNumber(value: (state.totalPayment.toStringAsFixed(2)), local: AppStrings.hebrewLocal,))),
            // state.isIncludedVat ? const SizedBox() : const Divider(height: 8),
            // state.isIncludedVat ? const SizedBox() : basketRow(AppLocalizations.of(context)!.vat, (formatNumber(value: totalVatAmountCalculation(price:
            // state.totalPayment, vat: state.vatPercentage, qty: state.bottleQty?.toDouble() ?? 0, deposit: state.bottleTax).toStringAsFixed(2), local: AppStrings.hebrewLocal,))),
            // state.isIncludedVat ? const SizedBox() : const Divider(height: 8),
            const Divider(height: 10),
            state.isIncludedVat
                ? basketRow(
                    AppLocalizations.of(context)!.total_price_with_vat,
                    (formatNumber(
                      value: (state.totalPayment +
                              (bottleDepositCalculationWithVat(
                                deposit: state.bottleTax,
                                qty: state.bottleQty?.toDouble() ?? 0,
                                vatPercentage: state.vatPercentage,
                              )))
                          .toString(),
                      local: AppStrings.hebrewLocal,
                    )),
                    isTitle: true,
                  )
                : basketRow(
                    AppLocalizations.of(context)!.total,
                    (formatNumber(
                      value: vatCalculation(
                        price: state.totalPayment,
                        vat: state.vatPercentage,
                        qty: state.bottleQty?.toDouble() ?? 0,
                        deposit: state.bottleTax,
                      ).toStringAsFixed(2), //refund: 0.0
                      local: AppStrings.hebrewLocal,
                    )),
                    isTitle: true),
            // const Divider(height: 10),
            // Text(
            //   '${AppLocalizations.of(context)!.note} : ${AppLocalizations.of(context)!.not_include_surfaces_price}',
            //   style: AppStyles.rkRegularTextStyle(size: AppConstants.font_12, color: AppColors.redColor),
            // ),
            const Divider(height: 10),
            5.height,
            state.isSubUserCanCreateOrder
                ? CustomButtonWidget(
                    buttonText: AppLocalizations.of(context)!.continues,
                    bGColor: AppColors.mainColor,
                    height: 45,
                    // isLoading: state.isLoading,
                    onPressed: () async {
                      List<double> basketProductStockList = [];
                      for (var element in state.basketProductList) {
                        basketProductStockList.add(element.productStock ?? 0);
                      }
                      basketProductStockList.sort();
                      if (basketProductStockList.first == 0.0 || basketProductStockList.first == 0) {
                        removeOutOfStockProductDialog(
                          context: context,
                        );
                      } else {
                        if (!state.isRemoveProcess && !state.isLoading && !state.isShimmering) {
                          if (state.supplierCount == 1) {
                            Navigator.pushNamed(context, RouteDefine.basketSummaryScreen.name, arguments: {AppStrings.getCartListString: state.cartItemList, AppStrings.isSupplierSingle: 'Yes'});
                          } else {
                            Navigator.pushNamed(context, RouteDefine.orderSummaryScreen.name, arguments: {
                              AppStrings.getCartListString: state.cartItemList,
                              AppStrings.isbackString: 'Basket',
                              AppStrings.totalAmountString: state.isIncludedVat
                                  ? formatNumber(
                                      value: (state.totalPayment +
                                              (bottleDepositCalculationWithVat(
                                                deposit: state.bottleTax,
                                                qty: state.bottleQty?.toDouble() ?? 0,
                                                vatPercentage: state.vatPercentage,
                                              )))
                                          .toString(),
                                      local: AppStrings.hebrewLocal,
                                    )
                                  : (formatNumber(
                                      value: vatCalculation(
                                        price: state.totalPayment,
                                        vat: state.vatPercentage,
                                        qty: state.bottleQty?.toDouble() ?? 0,
                                        deposit: state.bottleTax,
                                      ).toStringAsFixed(2), //refund: 0.0
                                      local: AppStrings.hebrewLocal,
                                    )),
                            });
                          }
                        }
                      }
                    },
                    fontColors: AppColors.whiteColor,
                  )
                : 0.width,
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
        Text(
          amount,
          style: AppStyles.rkRegularTextStyle(size: fontSize, color: AppColors.blackColor, fontWeight: isTitle ? FontWeight.w700 : FontWeight.w300),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget basketListItem({required int index, required BuildContext context, required String lowStock, required double productStock, required bool isPesach, required bool isSaleOn}) {
    return BlocBuilder<BasketBloc, BasketState>(
      builder: (context, state) {
        BasketBloc bloc = context.read<BasketBloc>();
        return Dismissible(
          key: Key(state.basketProductList.toString()),
          direction: DismissDirection.startToEnd,
          background: Container(
            alignment: state.language == AppStrings.englishString ? Alignment.centerLeft : Alignment.centerRight,
            margin: const EdgeInsets.symmetric(vertical: AppConstants.padding_5, horizontal: AppConstants.padding_10),
            decoration: BoxDecoration(
              color: AppColors.redColor,
              borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_5)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: GestureDetector(
                onTap: () {
                  deleteDialog(
                    context: context,
                    cartProductId: state.basketProductList[index].cartProductId,
                    listIndex: index,
                    updateClearString: '',
                    totalAmount: state.basketProductList[index].totalPayment!,
                  );
                },
                child: SvgPicture.asset(
                  AppImagePath.delete,
                  colorFilter: ColorFilter.mode(AppColors.whiteColor, BlendMode.srcIn),
                  height: 30,
                  width: 30,
                ),
              ),
            ),
          ),
          confirmDismiss: (DismissDirection direction) async {
            if (direction == DismissDirection.startToEnd) {
              return await showDialog(
                context: context,
                builder: (BuildContext context1) {
                  return BlocProvider.value(
                    value: context.read<BasketBloc>(),
                    child: BlocBuilder<BasketBloc, BasketState>(
                      builder: (context, state) {
                        return AbsorbPointer(
                            absorbing: state.isRemoveProcess ? true : false,
                            child: CustomDialog(
                              isProcessing: state.isRemoveProcess,
                              title: AppLocalizations.of(context)!.you_want_delete_product,
                              content: const [],
                              isMixedSale: false,
                              directionality: state.language,
                              positiveTitle: AppLocalizations.of(context)!.yes,
                              negativeTitle: AppLocalizations.of(context)!.no,
                              positiveOnTap: () {
                                bloc.add(BasketEvent.removeCartProductEvent(isFromDelete: false, context: context, cartProductId: state.basketProductList[index].cartProductId, listIndex: index, dialogContext: context, totalAmount: state.basketProductList[index].totalPayment!));
                              },
                              negativeOnTap: () {
                                Navigator.pop(context1);
                              },
                            ));
                      },
                    ),
                  );
                },
              );
            }
            return null;
          },
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: AppConstants.padding_5, horizontal: AppConstants.padding_10),
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  boxShadow: [
                    BoxShadow(color: AppColors.shadowColor.withOpacity(0.15), blurRadius: AppConstants.blur_10),
                  ],
                  borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_5)),
                ),
                child: GestureDetector(
                  onTap: () {
                    showProductDetails(
                      isSaleOn: state.isSaleOn,
                      context: /*Platform.isIOS ? (state.context??context): */
                          context,
                      cartProductId: state.cartItemList.data?.data?[index].id ?? '',
                      productListIndex: 0,
                      productStock: state.cartItemList.data?.data?[index].productStock.toString() ?? '0',
                    );
                  },
                  child: Column(
                    children: [
                      state.basketProductList[index].isProcess == true
                          ? LinearProgressIndicator(
                              color: AppColors.mainColor,
                              minHeight: 3,
                              backgroundColor: AppColors.mainColor.withOpacity(0.5),
                            )
                          : 3.height,
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_10, horizontal: AppConstants.padding_10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            state.basketProductList[index].mainImage == ''
                                ? Image.asset(
                                    AppImagePath.imageNotAvailable5,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.fitWidth,
                                  )
                                : Image.network(
                                    '${AppUrlEndPoints.baseFileUrl}${state.basketProductList[index].mainImage ?? ''}',
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.contain,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return Center(
                                          child: SizedBox(
                                            width: 100,
                                            height: 100,
                                            child: CupertinoActivityIndicator(
                                              color: AppColors.blackColor,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(width: 100, height: 100, color: AppColors.whiteColor, alignment: Alignment.center, child: Image.asset(AppImagePath.imageNotAvailable5));
                                    },
                                  ),
                            20.width,
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    state.basketProductList[index].productName ?? '',
                                    style: TextStyle(color: AppColors.blackColor, fontSize: AppConstants.smallFont, fontWeight: FontWeight.bold),
                                  ),
                                  5.height,
                                  Text(
                                    state.basketProductList[index].supplierName ?? '',
                                    style: TextStyle(color: AppColors.mainColor),
                                  ),
                                  productStock == 0 || productStock == 0.0
                                      ? Text(
                                          AppLocalizations.of(context)!.product_no_longer_in_stock,
                                          style: AppStyles.rkBoldTextStyle(size: AppConstants.font_12, color: AppColors.redColor, fontWeight: FontWeight.w400),
                                        )
                                      : (lowStock.isNotEmpty) && double.parse(productStock.toString()) > 0
                                          ? Text(lowStock, style: AppStyles.rkBoldTextStyle(size: AppConstants.font_12, color: AppColors.orangeColor, fontWeight: FontWeight.w400))
                                          : 0.width,
                                  lowStock.isNotEmpty ? 5.height : 0.height,
                                  state.basketProductList[index].isSale
                                      ? Container(
                                          width: MediaQuery.of(context).size.width,
                                          margin: const EdgeInsets.only(top: 3, bottom: 5),
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(color: AppColors.saleBGColor, borderRadius: const BorderRadius.all(Radius.circular(8))),
                                          child: Center(
                                              child: Text(
                                            state.basketProductList[index].saleDesc,
                                            style: const TextStyle(color: Colors.white, fontSize: AppConstants.font_12),
                                          )),
                                        )
                                      : 0.width,
                                  isPesachLabelShow(isPesach, context),
                                  isPesach ? 5.height : 0.height,
                                  Text(
                                    formatNumber(value: state.basketProductList[index].totalPayment?.toStringAsFixed(2) ?? "0", local: AppStrings.hebrewLocal),
                                    style: TextStyle(color: AppColors.blackColor, fontSize: AppConstants.smallFont, fontWeight: FontWeight.w700),
                                  ),
                                  10.height,
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (!state.isLoading) {
                                            if (state.cartItemList.data?.data?[index].sale?.saleMaxQuantity == 0) {
                                              if ((state.cartItemList.data?.data?[index].productStock ?? 0.0) >= state.basketProductList[index].totalQuantity! + 1) {
                                                bloc.add(BasketEvent.productUpdateEvent(listIndex: index, productWeight: state.basketProductList[index].totalQuantity! + 1, context: context, productId: state.cartItemList.data?.data?[index].productDetails?.id ?? '', supplierId: state.cartItemList.data?.data?[index].suppliers?.first.id ?? '', cartProductId: state.cartItemList.data?.data?[index].cartProductId ?? '', totalPayment: state.totalPayment, saleId: state.cartItemList.data?.data?[index].id ?? ''));
                                              } else {
                                                CustomSnackBar.showSnackBar(context: context, title: AppLocalizations.of(context)!.out_of_stock, type: SnackBarType.failure);
                                              }
                                            } else if (state.cartItemList.data?.data?[index].sale?.saleMaxQuantity == state.basketProductList[index].totalQuantity!) {
                                              CustomSnackBar.showSnackBar(context: context, title: AppLocalizations.of(context)!.not_add_more_than_max_qty, type: SnackBarType.failure);
                                            } else {
                                              bloc.add(BasketEvent.productUpdateEvent(listIndex: index, productWeight: state.basketProductList[index].totalQuantity! + 1, context: context, productId: state.cartItemList.data?.data?[index].productDetails?.id ?? '', supplierId: state.cartItemList.data?.data?[index].suppliers?.first.id ?? '', cartProductId: state.cartItemList.data?.data?[index].cartProductId ?? '', totalPayment: state.totalPayment, saleId: state.cartItemList.data?.data?[index].id ?? ''));
                                            }
                                          }
                                        },
                                        child: Container(
                                          width: AppConstants.containerSize_35,
                                          height: AppConstants.containerSize_35,
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppConstants.radius_4), border: Border.all(color: AppColors.navSelectedColor), color: AppColors.pageColor),
                                          child: Icon(
                                            Icons.add,
                                            size: 20,
                                            color: AppColors.blackColor,
                                          ),
                                        ),
                                      ),
                                      10.width,
                                      Text(
                                        '${state.basketProductList[index].totalQuantity}${' '}${state.basketProductList[index].scales}',
                                        style: TextStyle(
                                          color: AppColors.blackColor,
                                          fontSize: AppConstants.smallFont,
                                        ),
                                      ),
                                      10.width,
                                      GestureDetector(
                                        onTap: () {
                                          if (!state.isLoading) {
                                            if (state.basketProductList[index].totalQuantity! > 1) {
                                              bloc.add(BasketEvent.productUpdateEvent(listIndex: index, productWeight: state.basketProductList[index].totalQuantity! - 1, context: context, productId: state.cartItemList.data?.data?[index].productDetails?.id ?? '', supplierId: state.cartItemList.data?.data?[index].suppliers?.first.id ?? '', cartProductId: state.cartItemList.data?.data?[index].cartProductId ?? '', totalPayment: state.totalPayment, saleId: state.cartItemList.data?.data?[index].id ?? ''));
                                            } else {
                                              deleteDialog(context: context, updateClearString: '', cartProductId: state.cartItemList.data?.data?[index].cartProductId ?? '', listIndex: index, totalAmount: state.totalPayment);
                                            }
                                          }
                                        },
                                        child: Container(
                                          width: AppConstants.containerSize_35,
                                          height: AppConstants.containerSize_35,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppConstants.radius_4), border: Border.all(color: AppColors.navSelectedColor), color: AppColors.pageColor),
                                          child: Icon(
                                            Icons.remove,
                                            size: 20,
                                            color: AppColors.blackColor,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          deleteDialog(
                                            context: context,
                                            cartProductId: state.basketProductList[index].cartProductId,
                                            listIndex: index,
                                            updateClearString: '',
                                            totalAmount: state.basketProductList[index].totalPayment!,
                                          );
                                        },
                                        child: Container(
                                          width: AppConstants.containerSize_35,
                                          height: AppConstants.containerSize_35,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppConstants.radius_4), border: Border.all(color: AppColors.redColor), color: AppColors.pageColor),
                                          child: SvgPicture.asset(
                                            AppImagePath.delete,
                                            colorFilter: ColorFilter.mode(AppColors.redColor, BlendMode.srcIn),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if ((state.cartItemList.data?.data?[index].productStock ?? 0) == 0)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: AppConstants.padding_5, horizontal: AppConstants.padding_10),
                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                      decoration: BoxDecoration(
                        color: AppColors.redColor.withOpacity(0.2), // Semi-transparent red
                        borderRadius: const BorderRadius.all(
                          Radius.circular(AppConstants.radius_5),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void removeOutOfStockProductDialog({
    required BuildContext context,
  }) {
    BasketBloc bloc = context.read<BasketBloc>();
    showDialog(
        context: context,
        builder: (context1) => BlocProvider.value(
              value: context.read<BasketBloc>(),
              child: BlocBuilder<BasketBloc, BasketState>(
                builder: (context, state) {
                  return AbsorbPointer(
                      absorbing: state.isRemoveProcess ? true : false,
                      child: CustomDialog(
                        title: AppLocalizations.of(context)!.some_products_out_of_stock_Do_you_want_submit_order,
                        content: const [],
                        isMixedSale: false,
                        directionality: state.language,
                        positiveTitle: AppLocalizations.of(context)!.yes,
                        isProcessing: state.isRemoveProcess,
                        negativeTitle: AppLocalizations.of(context)!.no,
                        positiveOnTap: () async {
                          if (!state.isRemoveProcess && !state.isLoading && !state.isShimmering) {
                            if (state.supplierCount == 1) {
                              if (state.draftReturnExists) {
                                await showDialog(
                                  context: context,
                                  builder: (_) => CallAgentDialog(language: state.language, state: state, context1: context, bloc: bloc),
                                );
                              } else {
                                paymentOptionPopup(state, context, bloc, isFromRemovePopUp: true);
                              }
                              //   bloc.add(BasketEvent.orderSendEvent(context: context, failPayment: true, isFromDialog: false, paymentMethod: ''));
                            } else {
                              Navigator.pushNamed(context, RouteDefine.orderSummaryScreen.name, arguments: {
                                AppStrings.getCartListString: state.cartItemList,
                              });
                            }
                          }
                        },
                        negativeOnTap: () {
                          Navigator.pop(context1);
                        },
                      ));
                },
              ),
            ));
  }

  void paymentOptionPopup(BasketState state, BuildContext context, BasketBloc bloc, {bool isFromRemovePopUp = false}) {
    showDialog(
        context: context,
        builder: (context1) {
          // old code
          return CustomOneButtonDialog(
            width: MediaQuery.of(context).size.width,
            title: AppLocalizations.of(context)!.how_do_you_want_to_pay,
            directionality: state.language,
            positiveTitle: state.paymentTypesList.any((e) => e == AppStrings.creditCard) ? AppLocalizations.of(context)!.pay_with_credit_card : null,
            positiveOnTap: () {
              Navigator.pop(context);
              bloc.add(BasketEvent.orderSendEvent(context: context, failPayment: false, isFromDialog: true, paymentMethod: AppStrings.creditCard, isFromRemovePopUp: isFromRemovePopUp));
            },
            positiveOnTap1: () {
              Navigator.pop(context);
              bloc.add(BasketEvent.orderSendEvent(context: context, failPayment: false, isFromDialog: true, paymentMethod: AppStrings.wallet, isFromRemovePopUp: isFromRemovePopUp));
            },
            positiveOnTap2: () {
              Navigator.pop(context);
              bankTransferDialog(
                  context: context1,
                  language: state.language,
                  text: state.bankTransferInfo,
                  function: () {
                    bloc.add(BasketEvent.payWithBankTransferEvent(context: context, isFromRemovePopUp: isFromRemovePopUp, id: state.supplierId));
                  });
            },
            positiveOnTap3: () {
              Navigator.pop(context);
              bloc.add(BasketEvent.orderSendEvent(context: context, failPayment: state.isPaymentFail, isFromDialog: true, paymentMethod: AppStrings.bankCheck, isFromRemovePopUp: isFromRemovePopUp));
            },
            positiveTitle1: state.paymentTypesList.any((e) => e == AppStrings.wallet) ? AppLocalizations.of(context)!.change_to_wallet_payment : null,
            positiveTitle2: state.paymentTypesList.any((e) => e == AppStrings.bankTransfer) ? AppLocalizations.of(context)!.pay_with_bank_transfer : null,
            positiveTitle3: state.paymentTypesList.any((e) => e == AppStrings.bankCheck) ? AppLocalizations.of(context)!.pay_with_bank_check : null,
            paymentType: context.read<BasketBloc>().paymentType,
          );
          /*   bool c = state.paymentTypesList.any((e) => e == AppStrings.wallet);
          if (c) {
            return CustomOneButtonDialog(
              width: MediaQuery.of(context).size.width,
              title: AppLocalizations.of(context)!.how_do_you_want_to_pay,
              directionality: state.language,
              positiveTitle: state.paymentTypesList.any((e) => e == AppStrings.creditCard)?AppLocalizations.of(context)!.pay_with_credit_card:null,
              positiveOnTap: () {
                Navigator.pop(context);
                bloc.add(BasketEvent.orderSendEvent(context: context, failPayment: false, isFromDialog: true, paymentMethod: AppStrings.creditCard,isFromRemovePopUp:isFromRemovePopUp));
              },
              positiveOnTap1: () {
                Navigator.pop(context);
                bloc.add(BasketEvent.orderSendEvent(context: context, failPayment: false, isFromDialog: true, paymentMethod: AppStrings.wallet,isFromRemovePopUp: isFromRemovePopUp));
              },
              positiveOnTap2: () {
                Navigator.pop(context);
                bankTransferDialog(
                    context: context1,
                    language: state.language,
                    text: state.bankTransferInfo,
                    function: () {
                      bloc.add(BasketEvent.payWithBankTransferEvent(context: context,isFromRemovePopUp:isFromRemovePopUp,id:state.supplierId));
                    });
              },
              positiveOnTap3: () {
                Navigator.pop(context);
                bloc.add(BasketEvent.orderSendEvent(context: context, failPayment: state.isPaymentFail, isFromDialog: true, paymentMethod: AppStrings.bankCheck,isFromRemovePopUp: isFromRemovePopUp));
              },
              positiveTitle1:state.paymentTypesList.any((e) => e == AppStrings.wallet)? AppLocalizations.of(context)!.change_to_wallet_payment:null,
              positiveTitle2: state.paymentTypesList.any((e) => e == AppStrings.bankTransfer)?AppLocalizations.of(context)!.pay_with_bank_transfer:null,
              positiveTitle3: state.paymentTypesList.any((e) => e == AppStrings.bankCheck)?AppLocalizations.of(context)!.pay_with_bank_check:null,
            );
          } else {
            return CustomOneButtonDialog(
              width: MediaQuery.of(context).size.width,
              title: AppLocalizations.of(context)!.how_do_you_want_to_pay,
              directionality: state.language,
              positiveTitle::state.paymentTypesList.any((e) => e == AppStrings.bankTransfer)? AppLocalizations.of(context)!.pay_with_credit_card,
              positiveOnTap: () {
                Navigator.pop(context);
                bloc.add(BasketEvent.orderSendEvent(context: context, failPayment: false, isFromDialog: true, paymentMethod: AppStrings.creditCard,isFromRemovePopUp:isFromRemovePopUp));
                //  Navigator.pushNamed(context1, RouteDefine.creditCardDetailsScreen.name, arguments: {AppStrings.isPaymentFail: state.isPaymentFail});
              },
              positiveOnTap1: () {
                Navigator.pop(context);
                bankTransferDialog(
                    context: context1,
                    language: state.language,
                    text: state.bankTransferInfo,
                    function: () {
                      bloc.add(BasketEvent.payWithBankTransferEvent(context: context,isFromRemovePopUp:isFromRemovePopUp,id:state.supplierId));
                    });
               // bloc.add(BasketEvent.orderSendEvent(context: context, failPayment: false, isFromDialog: true, paymentMethod: AppStrings.bankTransfer,isFromRemovePopUp:isFromRemovePopUp));
              },
              positiveTitle1:state.paymentTypesList.any((e) => e == AppStrings.bankTransfer)? AppLocalizations.of(context)!.pay_with_bank_transfer:null,
            );
          }*/
        });
  }

  void deleteDialog({
    required BuildContext context,
    required String updateClearString,
    required String cartProductId,
    required int listIndex,
    double? totalAmount,
  }) {
    BasketBloc bloc = context.read<BasketBloc>();
    showDialog(
        context: context,
        builder: (context1) => BlocProvider.value(
              value: context.read<BasketBloc>(),
              child: BlocBuilder<BasketBloc, BasketState>(
                builder: (context, state) {
                  return AbsorbPointer(
                      absorbing: state.isRemoveProcess ? true : false,
                      child: CustomDialog(
                        title: updateClearString == AppStrings.clearString ? AppLocalizations.of(context)!.you_want_clear_cart : AppLocalizations.of(context)!.you_want_delete_product,
                        content: const [],
                        isMixedSale: false,
                        directionality: state.language,
                        positiveTitle: AppLocalizations.of(context)!.yes,
                        isProcessing: state.isRemoveProcess,
                        negativeTitle: AppLocalizations.of(context)!.no,
                        positiveOnTap: () {
                          updateClearString == AppStrings.clearString ? bloc.add(BasketEvent.clearCartEvent(context: context1)) : bloc.add(BasketEvent.removeCartProductEvent(isFromDelete: false, context: context, cartProductId: cartProductId, listIndex: listIndex, dialogContext: context1, totalAmount: totalAmount!));
                        },
                        negativeOnTap: () {
                          Navigator.pop(context1);
                        },
                      ));
                },
              ),
            ));
  }

  void showProductDetails({
    required BuildContext context,
    bool isBarcode = false,
    String productStock = '0',
    int productListIndex = 0,
    required bool isSaleOn,
    required String cartProductId,
  }) async {
    context.read<BasketBloc>().add(BasketEvent.getProductDetailsEvent(
          context: context,
          productId: cartProductId,
          isBarcode: isBarcode,
          productListIndex: productListIndex,
        ));
    showMaterialModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      expand: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
      ),
      isDismissible: false,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      enableDrag: false,
      builder: (c) {
        return SafeArea(
          bottom: false,
          child: DraggableScrollableSheet(
            shouldCloseOnMinExtent: false,
            expand: true,
            maxChildSize: 1 - (MediaQuery.of(context).viewPadding.top / getScreenHeight(context)),
            minChildSize: 1 - (MediaQuery.of(context).viewPadding.top / getScreenHeight(context)),
            initialChildSize: 1 - (MediaQuery.of(context).viewPadding.top / getScreenHeight(context)),
            builder: (BuildContext context1, ScrollController scrollController) {
              return BlocProvider.value(
                value: context.read<BasketBloc>(),
                child: BlocBuilder<BasketBloc, BasketState>(
                  builder: (blocContext, state) {
                    return AbsorbPointer(
                      absorbing: state.isLoading ? true : false,
                      child: Container(
                        height: getScreenHeight(context1),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(AppConstants.radius_30),
                            topRight: Radius.circular(AppConstants.radius_30),
                          ),
                          color: AppColors.whiteColor,
                        ),
                        child: state.isProductLoading
                            ? const ProductDetailsShimmerWidget()
                            : state.productDetails.isEmpty
                                ? NoDataBottomSheet(dialogContext: context)
                                : SingleChildScrollView(
                                    controller: ModalScrollController.of(context1),
                                    child: Column(
                                      children: [
                                        CommonProductDetailsWidget(
                                          isFromBasketScreen: true,
                                          isIncludedVat: state.isIncludedVat,
                                          productDetails: state.productDetails,
                                          isSubUserAddToBasket: state.isSubUserAddToBasket,
                                          bottleTax: state.bottleTax,
                                          totalBottleDeposit: (state.bottleTax * (state.productDetails.first.numberOfUnit ?? 1).toDouble() * state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity),
                                          isBottle: (state.productDetails.first.isBottle ?? false),
                                          addToOrderTap: () {
                                            FocusManager.instance.primaryFocus?.unfocus();
                                            context.read<BasketBloc>().add(BasketEvent.addToCartProductEvent(
                                                  context: context1,
                                                  productId: cartProductId,
                                                ));
                                          },
                                          isLoading: state.isLoading,
                                          imageOnTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (dialogContext) {
                                                return Stack(
                                                  children: [
                                                    SizedBox(
                                                      height: getScreenHeight(context) - MediaQuery.of(context).padding.top,
                                                      width: getScreenWidth(context),
                                                      child: GestureDetector(
                                                        onVerticalDragStart: (dragDetails) {},
                                                        onVerticalDragUpdate: (dragDetails) {},
                                                        onVerticalDragEnd: (endDetails) {
                                                          Navigator.pop(dialogContext);
                                                        },
                                                        child: PhotoView(
                                                          imageProvider: NetworkImage(
                                                            '${AppUrlEndPoints.baseFileUrl}${state.productDetails[state.productImageIndex].mainImage}',
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          Navigator.pop(dialogContext);
                                                        },
                                                        child: const Padding(
                                                          padding: EdgeInsets.only(top: 10.0),
                                                          child: Icon(
                                                            Icons.close,
                                                            color: Colors.white,
                                                          ),
                                                        )),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          context: context,
                                          productImages: [state.productDetails.first.mainImage ?? ''],
                                          productUnitPrice: double.parse(state.productDetails.first.supplierSales?.first.productPrice.toString() ?? '0'),
                                          productPrice: (state.productDetails.first.sale?.isSale ?? false) ? double.parse(state.productDetails.first.sale?.salePrice ?? '') * state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity * (state.productDetails.first.numberOfUnit ?? 1) : state.productStockList[state.productListIndex][state.productStockUpdateIndex].totalPrice * state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity * (state.productDetails.first.numberOfUnit ?? 1),
                                          productStock: (state.productStockList[state.productListIndex][state.productStockUpdateIndex].stock.toString()),
                                          scrollController: scrollController,
                                          productQuantity: state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity,
                                          isMixedSale: state.productDetails.first.sale!.isMixedSale,
                                          onQuantityChanged: (quantity) {
                                            context.read<BasketBloc>().add(BasketEvent.updateQuantityOfProduct(context: context1, quantity: quantity));
                                          },
                                          onQuantityIncreaseTap: () {
                                            context.read<BasketBloc>().add(BasketEvent.increaseQuantityOfProduct(context: context1));
                                          },
                                          onQuantityDecreaseTap: () {
                                            if (state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity > 1) {
                                              context.read<BasketBloc>().add(BasketEvent.decreaseQuantityOfProduct(context: context1));
                                            }
                                          },
                                          onCloseTap: () {
                                            context.read<BasketBloc>().add(BasketEvent.getAllCartEvent(context: context, isFromUpdate: false));
                                            Navigator.pop(context);
                                          },
                                        ),
                                        state.isRelatedShimmering
                                            ? const RelatedProductShimmerWidget()
                                            : state.relatedProductList.isEmpty
                                                ? 0.height
                                                : relatedProductWidget(context, state, context1, isSaleOn),
                                      ],
                                    ),
                                  ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget relatedProductWidget(BuildContext prevContext, BasketState state, BuildContext context, bool isSaleOn) {
    return AbsorbPointer(
      absorbing: state.isLoading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: context.rtl ? Alignment.centerRight : Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Text(
                AppLocalizations.of(context)!.related_products,
                style: AppStyles.rkRegularTextStyle(size: AppConstants.mediumFont, color: AppColors.blackColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            height: getItemHeight(context, isSaleOn),
            padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context2, i) {
                return CommonProductSaleItemWidget(
                  isSale: state.relatedProductList.elementAt(i).sale?.isSale,
                  isGuestUser: false,
                  height: AppConstants.salesProductItemHeight,
                  width: getItemWidth(context),
                  productName: state.relatedProductList.elementAt(i).productName ?? '',
                  saleImage: state.relatedProductList.elementAt(i).mainImage ?? '',
                  title: state.relatedProductList.elementAt(i).name,
                  description: parse(state.relatedProductList.elementAt(i).sale?.saleDescription).body?.text ?? '',
                  discountedPrice: double.parse(state.relatedProductList.elementAt(i).sale?.salePrice ?? '0'),
                  originalPrice: state.relatedProductList.elementAt(i).productPrice,
                  productStock: state.relatedProductList.elementAt(i).productStock.toString(),
                  lowStock: state.relatedProductList.elementAt(i).lowStock ?? '',
                  isPesach: state.relatedProductList.elementAt(i).isPesach,
                  quantity: state.productStockList[1].firstWhere((test) => test.productId == state.relatedProductList.elementAt(i).id).quantity, //[i].quantity,
                  isMixedSale: state.relatedProductList.elementAt(i).sale?.isMixedSale,
                  onQuantityChanged: () {
                    context2.read<BasketBloc>().add(
                          BasketEvent.updateListQuantityOfProduct(
                            context: context2,
                            quantity: state.productStockList[1].firstWhere((test) => test.productId == state.relatedProductList.elementAt(i).id).quantity.toString(),
                            productListIndex: 1,
                            productStockUpdateIndex: state.productStockList[1].indexWhere((test) => test.productId == state.relatedProductList.elementAt(i).id),
                            productSupplierIds: state.relatedProductList[i].supplierId.toString(),
                          ),
                        );
                  },
                  onQuantityIncreaseTap: () {
                    context2.read<BasketBloc>().add(
                          BasketEvent.increaseListQuantityOfProduct(
                            context: context2,
                            productListIndex: 1,
                            productStockUpdateIndex: state.productStockList[1].indexWhere((test) => test.productId == state.relatedProductList.elementAt(i).id),
                            productSupplierIds: state.relatedProductList[i].supplierId.toString(),
                          ),
                        );

                    context2.read<BasketBloc>().add(
                          BasketEvent.addToCartListProductEvent(
                            context: context2,
                            productId: state.relatedProductList[i].id.toString(),
                            productListIndex: 1,
                            productStockUpdateIndex: state.productStockList[1].indexWhere((test) => test.productId == state.relatedProductList.elementAt(i).id),
                            productSupplierIds: state.relatedProductList[i].supplierId.toString(),
                          ),
                        );
                  },
                  onQuantityDecreaseTap: () {
                    if (state.productStockList[1].firstWhere((test) => test.productId == state.relatedProductList.elementAt(i).id).quantity != 0) {
                      context2.read<BasketBloc>().add(
                            BasketEvent.decreaseListQuantityOfProduct(
                              context: context2,
                              productListIndex: 1,
                              productStockUpdateIndex: state.productStockList[1].indexWhere((test) => test.productId == state.relatedProductList.elementAt(i).id),
                              productSupplierIds: state.relatedProductList[i].supplierId.toString(),
                            ),
                          );

                      context2.read<BasketBloc>().add(
                            BasketEvent.addToCartListProductEvent(
                              context: context2,
                              productId: state.relatedProductList[i].id.toString(),
                              productListIndex: 1,
                              productStockUpdateIndex: state.productStockList[1].indexWhere((test) => test.productId == state.relatedProductList.elementAt(i).id),
                              productSupplierIds: state.relatedProductList[i].supplierId.toString(),
                            ),
                          );
                    }
                  },
                  onButtonTap: () {
                    Navigator.pop(prevContext);
                    showProductDetails(
                      isSaleOn: isSaleOn,
                      context: Platform.isIOS ? (state.context ?? context) : context,
                      cartProductId: state.relatedProductList[i].id ?? '',
                      isBarcode: false,
                      productStock: state.relatedProductList[i].productStock.toString(),
                      productListIndex: 1,
                    );
                  },
                );
              },
              itemCount: state.relatedProductList.length,
            ),
          )
        ],
      ),
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

  appUnderMaintenanceDialog({required BuildContext context, required BasketState state}) {
    if (!state.isDialogOpen) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context1) => BlocProvider.value(
          value: context.read<BasketBloc>(),
          child: BlocBuilder<BasketBloc, BasketState>(
            builder: (context, state) {
              BasketBloc bloc = context.read<BasketBloc>();
              return CustomOneButtonDialog(
                width: MediaQuery.of(context).size.width,
                isLoading: state.retryLoading,
                directionality: state.language,
                title: AppLocalizations.of(context)!.under_maintenance,
                positiveTitle: AppLocalizations.of(context)!.retry,
                positiveOnTap: () async {
                  bloc.add(BasketEvent.generalSettings(context: context, dialogContext: context1, isRetryLoading: true));
                },
              );
            },
          ),
        ),
      );
    } else {
      context.read<BasketBloc>().add(BasketEvent.updateMaintenanceEvent(context: context));
    }
  }

  Color getProductColor(int index, state) {
    final stock = state.cartItemList.data?.data?[index].productStock ?? 0.0;
    final totalQty = state.basketProductList[index].totalQuantity ?? 0;

    return stock >= totalQty + 1 ? AppColors.whiteColor : const Color(0XFFfadad7);
  }
}

class CallAgentDialog extends StatelessWidget {
  final String language;
  final BasketState state;
  final BuildContext context1;
  final BasketBloc bloc;

  const CallAgentDialog({Key? key, required this.language, required this.state, required this.context1, required this.bloc}) : super(key: key);

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
                  Navigator.pushNamed(context, RouteDefine.returnListScreen.name, arguments: {AppStrings.isbackString: 'Basket'}
                      //  arguments: false
                      );
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
                  paymentOptionPopup(state, context1, bloc);
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

  void paymentOptionPopup(BasketState state, BuildContext context, BasketBloc bloc, {bool isFromRemovePopUp = false}) {
    showDialog(
        context: context,
        builder: (context1) {
          // old code
          return CustomOneButtonDialog(
            width: MediaQuery.of(context).size.width,
            title: AppLocalizations.of(context)!.how_do_you_want_to_pay,
            directionality: state.language,
            positiveTitle: state.paymentTypesList.any((e) => e == AppStrings.creditCard) ? AppLocalizations.of(context)!.pay_with_credit_card : null,
            positiveOnTap: () {
              Navigator.pop(context);
              bloc.add(BasketEvent.orderSendEvent(context: context, failPayment: false, isFromDialog: true, paymentMethod: AppStrings.creditCard, isFromRemovePopUp: isFromRemovePopUp));
            },
            positiveOnTap1: () {
              Navigator.pop(context);
              bloc.add(BasketEvent.orderSendEvent(context: context, failPayment: false, isFromDialog: true, paymentMethod: AppStrings.wallet, isFromRemovePopUp: isFromRemovePopUp));
            },
            positiveOnTap2: () {
              Navigator.pop(context);
              bankTransferDialog(
                  context: context1,
                  language: state.language,
                  text: state.bankTransferInfo,
                  function: () {
                    bloc.add(BasketEvent.payWithBankTransferEvent(context: context, isFromRemovePopUp: isFromRemovePopUp, id: state.supplierId));
                  });
            },
            positiveOnTap3: () {
              Navigator.pop(context);
              bloc.add(BasketEvent.orderSendEvent(context: context, failPayment: state.isPaymentFail, isFromDialog: true, paymentMethod: AppStrings.bankCheck, isFromRemovePopUp: isFromRemovePopUp));
            },
            positiveTitle1: state.paymentTypesList.any((e) => e == AppStrings.wallet) ? AppLocalizations.of(context)!.change_to_wallet_payment : null,
            positiveTitle2: state.paymentTypesList.any((e) => e == AppStrings.bankTransfer) ? AppLocalizations.of(context)!.pay_with_bank_transfer : null,
            positiveTitle3: state.paymentTypesList.any((e) => e == AppStrings.bankCheck) ? AppLocalizations.of(context)!.pay_with_bank_check : null,
            paymentType: context.read<BasketBloc>().paymentType,
          );
        });
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
}
