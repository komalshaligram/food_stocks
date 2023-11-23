import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:food_stock/bloc/basket/basket_bloc.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../../routes/app_routes.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_img_path.dart';
import '../utils/themes/app_strings.dart';
import '../utils/themes/app_styles.dart';
import '../widget/basket_screen_shimmer_widget.dart';

class BasketRoute {
  static Widget get route => const BasketScreen();
}

class BasketScreen extends StatelessWidget {
  const BasketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          BasketBloc()/*..add(BasketEvent.getAllCartEvent(context: context))*/,
      child: const BasketScreenWidget(),
    );
  }
}

class BasketScreenWidget extends StatelessWidget {
  const BasketScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BasketBloc bloc = context.read<BasketBloc>();
    return BlocListener<BasketBloc, BasketState>(
      listener: (context, state) {},
      child: BlocBuilder<BasketBloc, BasketState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.pageColor,
            body: FocusDetector(
              onFocusGained: () {
                bloc.add(BasketEvent.getAllCartEvent(context: context));
              },
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: AppConstants.padding_5,
                  ),
                  child: Column(
                    children: [
                      (state.basketProductList.length) != 0
                          ? Container(
                              margin: EdgeInsets.all(AppConstants.padding_10),
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor.withOpacity(0.95),
                                boxShadow: [
                                  BoxShadow(
                                      color: AppColors.shadowColor
                                          .withOpacity(0.20),
                                      blurRadius: AppConstants.blur_10),
                                ],
                                borderRadius: BorderRadius.all(
                                    Radius.circular(AppConstants.radius_40)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: AppConstants.padding_5,
                                        horizontal: AppConstants.padding_5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            AppConstants.radius_30),
                                        color: AppColors.whiteColor,
                                        border: Border.all(
                                            color: AppColors.borderColor)),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: getScreenWidth(context) * 0.36,
                                          height: AppConstants.containerSize_50,
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.symmetric(
                                              vertical: AppConstants.padding_5,
                                              horizontal:
                                                  AppConstants.padding_5),
                                          decoration: BoxDecoration(
                                              color: AppColors.mainColor,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: isRTLContent(context: context)
                                                      ? Radius.circular(
                                                          AppConstants.radius_5)
                                                      : Radius.circular(
                                                          AppConstants
                                                              .radius_25),
                                                  bottomLeft: isRTLContent(context: context)
                                                      ? Radius.circular(
                                                          AppConstants.radius_5)
                                                      : Radius.circular(
                                                          AppConstants
                                                              .radius_25),
                                                  bottomRight: isRTLContent(
                                                          context: context)
                                                      ? Radius.circular(
                                                          AppConstants.radius_25)
                                                      : Radius.circular(AppConstants.radius_5),
                                                  topRight: isRTLContent(context: context) ? Radius.circular(AppConstants.radius_25) : Radius.circular(AppConstants.radius_5))),
                                          child: (state.CartItemList.data?.cart!
                                                          .length ??
                                                      0) ==
                                                  0
                                              ? CupertinoActivityIndicator()
                                              : /*Text(
                                                  '${AppLocalizations.of(context)!.total}${' : '}${state.CartItemList.data!.cart!.first.totalAmount.toString()}${AppLocalizations.of(context)!.currency}',
                                                  style: AppStyles
                                                      .rkRegularTextStyle(
                                                          size: getScreenWidth(
                                                                      context) <=
                                                                  380
                                                              ? AppConstants
                                                                  .smallFont
                                                              : AppConstants
                                                                  .mediumFont,
                                                          color: AppColors
                                                              .whiteColor,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                ),*/
                                          RichText(
                                            text: TextSpan(
                                              text: AppLocalizations.of(context)!
                                                  .total,
                                                style: AppStyles
                                                    .rkRegularTextStyle(
                                                    size: getScreenWidth(
                                                        context) <=
                                                        380
                                                        ? AppConstants
                                                        .smallFont
                                                        : AppConstants
                                                        .mediumFont,
                                                    color: AppColors
                                                        .whiteColor,
                                                ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text:
                                                    '${' : '}${state.CartItemList.data!.cart!.first.totalAmount.toString()}${AppLocalizations.of(context)!.currency}',
                                                    style: AppStyles
                                                        .rkRegularTextStyle(
                                                        size: getScreenWidth(
                                                            context) <=
                                                            380
                                                            ? AppConstants
                                                            .smallFont
                                                            : AppConstants
                                                            .normalFont,
                                                        color: AppColors
                                                            .whiteColor,
                                                        fontWeight:
                                                        FontWeight.w700)),
                                              ],
                                            ),
                                          ),
                                        ),
                                        5.width,
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context,
                                                RouteDefine
                                                    .orderSummaryScreen.name);
                                          },
                                          child: Container(
                                            width:
                                                getScreenWidth(context) * 0.22,
                                            height:
                                                AppConstants.containerSize_50,
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.symmetric(
                                                vertical:
                                                    AppConstants.padding_5,
                                                horizontal:
                                                    AppConstants.padding_5),
                                            decoration: BoxDecoration(
                                                color:
                                                    AppColors.navSelectedColor,
                                                borderRadius: BorderRadius.only(
                                                    topLeft: isRTLContent(context: context)
                                                        ? Radius.circular(AppConstants
                                                            .radius_25)
                                                        : Radius.circular(AppConstants
                                                            .radius_4),
                                                    bottomLeft: isRTLContent(context: context)
                                                        ? Radius.circular(AppConstants
                                                            .radius_25)
                                                        : Radius.circular(
                                                            AppConstants
                                                                .radius_4),
                                                    bottomRight: isRTLContent(context: context)
                                                        ? Radius.circular(AppConstants.radius_4)
                                                        : Radius.circular(AppConstants.radius_25),
                                                    topRight: isRTLContent(context: context) ? Radius.circular(AppConstants.radius_4) : Radius.circular(AppConstants.radius_25))),
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .submit,
                                              style:
                                                  AppStyles.rkRegularTextStyle(
                                                size: AppConstants.normalFont,
                                                color: AppColors.whiteColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      deleteDialog(
                                          context: context,
                                          updateClearString:
                                              AppStrings.clearString,
                                          listIndex: 0,
                                          cartProductId: '');
                                    },
                                    child: Container(
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            AppImagePath.delete,
                                          ),
                                          15.width,
                                          Text(
                                            AppLocalizations.of(context)!.empty,
                                            style: AppStyles.rkRegularTextStyle(
                                              size: AppConstants.smallFont,
                                              color: AppColors.greyColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  5.width,
                                ],
                              ),
                            )
                          : SizedBox(),
                      state.isShimmering
                          ? BasketScreenShimmerWidget()
                          : (state.basketProductList.length) != 0
                              ? Expanded(
                                  child: Padding(
                                    padding:  EdgeInsets.only(bottom: getScreenHeight(context) * 0.1),
                                    child: ListView.builder(
                                      itemCount: state.basketProductList.length,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      padding: EdgeInsets.symmetric(
                                          vertical: AppConstants.padding_5),
                                      itemBuilder: (context, index) =>
                                          basketListItem(
                                              index: index, context: context),
                                    ),
                                  ),
                                )
                              : Expanded(
                                  child: Center(
                                      child: Text(
                                        AppLocalizations.of(context)!.cart_empty,
                                    style: AppStyles.rkRegularTextStyle(
                                        size: AppConstants.normalFont,
                                        color: AppColors.blackColor,
                                        fontWeight: FontWeight.w400),
                                  )),
                                ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget basketListItem({required int index, required BuildContext context}) {
    return BlocBuilder<BasketBloc, BasketState>(
      builder: (context, state) {
        BasketBloc bloc = context.read<BasketBloc>();

        return Container(
          margin: EdgeInsets.symmetric(
              vertical: AppConstants.padding_5,
              horizontal: AppConstants.padding_10),
          padding: EdgeInsets.symmetric(
              vertical: AppConstants.padding_3,
              horizontal: AppConstants.padding_10),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            boxShadow: [
              BoxShadow(
                  color: AppColors.shadowColor.withOpacity(0.15),
                  blurRadius: AppConstants.blur_10),
            ],
            borderRadius:
                BorderRadius.all(Radius.circular(AppConstants.radius_5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.network(
                '${AppUrls.baseFileUrl}${state.basketProductList[index].mainImage ?? ''}',
                width: AppConstants.containerSize_50,
                height: AppConstants.containerSize_50,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: AppConstants.containerSize_50,
                    height: AppConstants.containerSize_50,
                  );
                },
              ),
              Container(
                width: 60,
                child: Text(
                  state.basketProductList[index].productName!,
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: AppConstants.font_14,
                  ),
                ),
              ),
              3.width,
              GestureDetector(
                onTap: () {
                  if (state.CartItemList.data!.data![index].productStock! >=
                      state.basketProductList[index].totalQuantity! + 1) {
                    bloc.add(BasketEvent.productUpdateEvent(
                      listIndex: index,
                      productWeight:
                          state.basketProductList[index].totalQuantity! + 1,
                      context: context,
                      productId: state
                          .CartItemList.data!.data![index].productDetails!.id!,
                      supplierId: state
                          .CartItemList.data!.data![index].suppliers!.first.id!,
                      cartProductId:
                          state.CartItemList.data!.data![index].cartProductId!,
                    ));
                  } else {
                    showSnackBar(
                        context: context,
                        title: AppStrings.stockNotAvailableString,
                        bgColor: AppColors.redColor);
                  }
                },
                child: Container(
                  width: AppConstants.containerSize_25,
                  height: AppConstants.containerSize_25,
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(AppConstants.radius_4),
                      border: Border.all(color: AppColors.navSelectedColor),
                      color: AppColors.pageColor),
                  child: Icon(
                    Icons.add,
                    size: 15,
                    color: AppColors.blackColor,
                  ),
                ),
              ),
              Text(
                '${state.basketProductList[index].totalQuantity}${' '}${state.basketProductList[index].scales}',
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: AppConstants.font_12,
                ),
              ),
              GestureDetector(
                onTap: () {
                  bloc.add(BasketEvent.productUpdateEvent(
                    listIndex: index,
                    productWeight:
                        state.basketProductList[index].totalQuantity! - 1,
                    context: context,
                    productId: state
                        .CartItemList.data!.data![index].productDetails!.id!,
                    supplierId: state
                        .CartItemList.data!.data![index].suppliers!.first.id!,
                    cartProductId:
                        state.CartItemList.data!.data![index].cartProductId!,
                  ));
                },
                child: Container(
                  width: AppConstants.containerSize_25,
                  height: AppConstants.containerSize_25,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(AppConstants.radius_4),
                      border: Border.all(color: AppColors.navSelectedColor),
                      color: AppColors.pageColor),
                  child: Text('-',
                      style: AppStyles.rkRegularTextStyle(
                          size: AppConstants.mediumFont,
                          color: AppColors.blackColor)),
                ),
              ),
              1.width,
              Container(
                width: 70,
                child: Text(
                  '${state.basketProductList[index].totalPayment.toString() + AppLocalizations.of(context)!.currency}',
                  style: TextStyle(
                      color: AppColors.blackColor,
                      fontSize: AppConstants.font_14,
                      fontWeight: FontWeight.w700),
                ),
              ),
              GestureDetector(
                onTap: () {
                  deleteDialog(
                    context: context,
                    updateClearString: AppStrings.deleteString,
                    cartProductId: state.basketProductList[index].cartProductId,
                    listIndex: index,
                  );
                },
                child: SvgPicture.asset(
                  AppImagePath.delete,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void deleteDialog({
    required BuildContext context,
    required String updateClearString,
    required String cartProductId,
    required int listIndex,
  }) {
    BasketBloc bloc = context.read<BasketBloc>();
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              contentPadding: EdgeInsets.all(20.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              title: Text(
                  updateClearString == AppStrings.clearString
                      ? AppStrings.clearCartPopUpString
                      : AppStrings.deleteProductPopUpString,
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.mediumFont,
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w400)),
              actionsPadding: EdgeInsets.only(
                  right: AppConstants.padding_20,
                  bottom: AppConstants.padding_20,
                  left: AppConstants.padding_20),
              actions: [
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    updateClearString == AppStrings.clearString
                        ? bloc.add(BasketEvent.clearCartEvent(context: context))
                        : bloc.add(BasketEvent.removeCartProductEvent(
                            context: context,
                            cartProductId: cartProductId,
                            listIndex: listIndex,
                          ));
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                    alignment: Alignment.center,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
                    width: 80,
                    child: Text(
                      'Yes',
                      style: AppStyles.rkRegularTextStyle(
                          color: AppColors.mainColor.withOpacity(0.9),
                          size: AppConstants.smallFont),
                    ),
                  ),
                ),
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                    alignment: Alignment.center,
                    width: 80,
                    decoration: BoxDecoration(
                        color: AppColors.mainColor.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Text(
                      'No',
                      style: AppStyles.rkRegularTextStyle(
                          color: AppColors.whiteColor,
                          size: AppConstants.smallFont),
                    ),
                  ),
                )
              ],
            ));
  }
}
