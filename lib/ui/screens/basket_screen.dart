import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:food_stock/bloc/basket/basket_bloc.dart';
import 'package:food_stock/data/model/res_model/get_all_cart_res_model/get_all_cart_res_model.dart'
    hide Image;
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:food_stock/ui/widget/common_product_details_widget.dart';
import 'package:food_stock/ui/widget/common_product_item_widget.dart';
import 'package:food_stock/ui/widget/custom_button_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:html/parser.dart';
import 'package:photo_view/photo_view.dart';
import '../../bloc/bottom_nav/bottom_nav_bloc.dart';
import '../../routes/app_routes.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_img_path.dart';

import '../utils/themes/app_styles.dart';
import '../widget/basket_screen_shimmer_widget.dart';
import '../widget/common_product_details_button.dart';
import '../widget/common_shimmer_widget.dart';
import '../widget/product_details_shimmer_widget.dart';

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

  bool isRemoveProcess = false;

  @override
  Widget build(BuildContext context) {
    BasketBloc bloc = context.read<BasketBloc>();
    return BlocListener<BasketBloc, BasketState>(
      listener: (context, state) {
        BlocProvider.of<BottomNavBloc>(context)
            .add(BottomNavEvent.updateCartCountEvent());
      },
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
                              padding: EdgeInsets.all(AppConstants.padding_10),
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
                                 /* Container(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [

                                        Container(
                                          height: AppConstants.containerSize_50,
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.symmetric(
                                              vertical: AppConstants.padding_3,
                                              horizontal:
                                                  AppConstants.padding_10),
                                          decoration: BoxDecoration(
                                              color: AppColors.mainColor,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: context.rtl
                                                      ? Radius.circular(
                                                          AppConstants.radius_5)
                                                      : Radius.circular(AppConstants
                                                          .radius_25),
                                                  bottomLeft: context.rtl
                                                      ? Radius.circular(
                                                          AppConstants.radius_5)
                                                      : Radius.circular(
                                                          AppConstants
                                                              .radius_25),
                                                  bottomRight: context.rtl
                                                      ? Radius.circular(
                                                          AppConstants
                                                              .radius_25)
                                                      : Radius.circular(
                                                          AppConstants.radius_5),
                                                  topRight: context.rtl ? Radius.circular(AppConstants.radius_25) : Radius.circular(AppConstants.radius_5))),
                                          child: (state.CartItemList.data?.cart!
                                                          .length ??
                                                      0) ==
                                                  0
                                              ? CupertinoActivityIndicator()
                                              : Row(
                                            children: [
                                              Text(
                                                '${AppLocalizations.of(context)!.total}',
                                                style: AppStyles.rkRegularTextStyle(
                                                    size: AppConstants.font_14,
                                                    color: AppColors
                                                        .whiteColor,
                                                    fontWeight:
                                                    FontWeight
                                                        .w700),
                                              ),
                                              Text(
                                                ' : ${(formatNumber(value: (state.totalPayment.toStringAsFixed(2)), local: AppStrings.hebrewLocal))}',
                                                style: AppStyles.rkRegularTextStyle(
                                                    size: AppConstants.mediumFont,
                                                    color: AppColors
                                                        .whiteColor,
                                                    fontWeight:
                                                    FontWeight
                                                        .w700),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          )
                                         *//*
                                         Directionality(
                                            textDirection:
                                            TextDirection.ltr,
                                            child: Expanded(
                                              child: Text(
                                                '${AppLocalizations.of(context)!.total} : ${(formatNumber(value: (state.totalPayment.toStringAsFixed(2)), local: AppStrings.hebrewLocal))}',
                                                style: AppStyles.rkRegularTextStyle(
                                                    size: 18,
                                                    color: AppColors
                                                        .whiteColor,
                                                    fontWeight:
                                                    FontWeight
                                                        .w700),
                                              ),
                                            ),
                                          )*//*
                                        ),
                                        5.width,
                                        GestureDetector(
                                          onTap: () {
                                            if(!state.isRemoveProcess && !state.isLoading && !state.isShimmering){
                                              Navigator.pushNamed(
                                                  context,
                                                  RouteDefine
                                                      .orderSummaryScreen.name,
                                                  arguments: {
                                                    AppStrings.getCartListString:
                                                    state.CartItemList
                                                  });
                                            }
                                          },
                                          child: Container(
                                            // width: getScreenWidth(context) * 0.22,
                                            height:
                                                AppConstants.containerSize_50,
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.symmetric(
                                                vertical:
                                                    AppConstants.padding_5,
                                                horizontal:
                                                    AppConstants.padding_10),
                                            decoration: BoxDecoration(
                                                color:
                                                    AppColors.navSelectedColor,
                                                borderRadius: BorderRadius.only(
                                                    topLeft: context.rtl
                                                        ? Radius.circular(AppConstants
                                                            .radius_25)
                                                        : Radius.circular(
                                                            AppConstants
                                                                .radius_4),
                                                    bottomLeft: context.rtl
                                                        ? Radius.circular(
                                                            AppConstants
                                                                .radius_25)
                                                        : Radius.circular(
                                                            AppConstants
                                                                .radius_4),
                                                    bottomRight: context.rtl
                                                        ? Radius.circular(AppConstants.radius_4)
                                                        : Radius.circular(AppConstants.radius_25),
                                                    topRight: context.rtl ? Radius.circular(AppConstants.radius_4) : Radius.circular(AppConstants.radius_25))),
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .submit,
                                              style:
                                                  AppStyles.rkRegularTextStyle(
                                                size: getScreenWidth(context) <=
                                                        380
                                                    ? AppConstants.smallFont
                                                    : AppConstants.mediumFont,
                                                color: AppColors.whiteColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),*/

                                  InkWell(
                                    onTap: () {
                                      deleteDialog(
                                        context: context,
                                        updateClearString:
                                        AppStrings.clearString,
                                        listIndex: 0,
                                        cartProductId: '',
                                        totalAmount: 0.0,
                                      );
                                    },
                                    child: Container(
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            AppImagePath.delete,color: AppColors.redColor,),
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
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.my_basket,
                                    textAlign: TextAlign.center,
                                    style: AppStyles.rkRegularTextStyle(
                                        size: AppConstants.mediumFont,
                                        color: AppColors
                                            .greyColor,
                                        fontWeight:
                                        FontWeight
                                            .w500),
                                  ),
                                  InkWell(
                                    onTap: () {

                                    },
                                    child: Container(
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            AppImagePath.delete,color: AppColors.whiteColor,),
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
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(),

                      state.isShimmering && state.basketProductList.isEmpty
                          ? BasketScreenShimmerWidget()
                          : (state.basketProductList.length) != 0
                              ? Expanded(
                                  child: AnimationLimiter(
                                    child: ListView.builder(
                                      itemCount: state.basketProductList.length,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      padding: EdgeInsets.symmetric(
                                          vertical: AppConstants.padding_5),
                                      itemBuilder: (context, index) =>
                                          AnimationConfiguration.staggeredList(
                                        duration: const Duration(seconds: 1),
                                        position: index,
                                        child: SlideAnimation(
                                          verticalOffset: 44.0,
                                          child: FadeInAnimation(
                                            child: basketListItem(
                                              index: index,
                                              context: context,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              :   !state.isShimmering && state.basketProductList.isEmpty ? Expanded(
                                  child: Center(
                                      child: Text(
                                    AppLocalizations.of(context)!.cart_empty,
                                    style: AppStyles.pVRegularTextStyle(
                                        size: AppConstants.normalFont,
                                        color: AppColors.blackColor,
                                        fontWeight: FontWeight.w400),
                                  )),
                                ) : BasketScreenShimmerWidget(),
                      (state.basketProductList.length)  ==
                          0
                          ? CupertinoActivityIndicator()
                          : totalAmountCard(state,context)
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


  Widget totalAmountCard(BasketState state,BuildContext context){
    BasketBloc bloc = context.read<BasketBloc>();
    return Container(
        alignment: state.language == AppStrings.englishString
            ? Alignment.centerLeft
            : Alignment.centerRight,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(
            vertical: AppConstants.padding_5,
            horizontal: AppConstants.padding_10),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius:
          BorderRadius.all(Radius.circular(AppConstants.radius_5)),
        ),
        child: Column(
          children: [
            state.bottleQty! >0?basketRow(state.language == AppStrings.englishString ? '${AppLocalizations.of(context)!.bottle_deposit}${'X'}${state.bottleQty.toString()}' : '${AppLocalizations.of(context)!.bottle_deposit}${state.bottleQty.toString()}${'X'}', '${(formatNumber(value:bottleDepositCalculation(deposit:state.bottleTax,qty: state.bottleQty?.toDouble()??0).toStringAsFixed(2), local: AppStrings.hebrewLocal))}'):Container(),
            state.bottleQty! >0?Divider():Container(),
            basketRow('${AppLocalizations.of(context)!.sub_total}', '${(formatNumber(value: (state.totalPayment.toStringAsFixed(2)), local: AppStrings.hebrewLocal))}'),
            Divider(),
            basketRow('${AppLocalizations.of(context)!.vat}', '${(formatNumber(value: totalVatAmountCalculation(price: state.totalPayment, vat:state.vatPercentage,qty: state.bottleQty?.toDouble() ?? 0, deposit: state.bottleTax).toStringAsFixed(2), local: AppStrings.hebrewLocal))}'),
            Divider(),
            basketRow('${AppLocalizations.of(context)!.total}', '${(formatNumber(value: vatCalculation(price: state.totalPayment, vat:state.vatPercentage,qty: state.bottleQty?.toDouble() ?? 0, deposit: state.bottleTax).toStringAsFixed(2), local: AppStrings.hebrewLocal))}',isTitle: true),
            Divider(),
            CustomButtonWidget(
              buttonText: AppLocalizations.of(context)!.submit,
              bGColor: AppColors.mainColor,
              isLoading: state.isLoading,
              onPressed: () {
                if(!state.isRemoveProcess && !state.isLoading && !state.isShimmering){
                  if(state.supplierCount == 1){
                    bloc.add(BasketEvent.orderSendEvent(context: context));
                  }
                  else{
                    Navigator.pushNamed(
                        context,
                        RouteDefine
                            .orderSummaryScreen.name,
                        arguments: {
                          AppStrings.getCartListString: state.CartItemList,
                        });
                  }
                }
              },
              fontColors: AppColors.whiteColor,
            ),
            10.height
          ],
        ));
  }

  Widget basketRow(String title,String amount,{bool isTitle = false}){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
         title,
          style: AppStyles.rkRegularTextStyle(
              size: AppConstants.font_14,
              color: AppColors
                  .blackColor),
        ),
        Text(
         amount,
          style: AppStyles.rkRegularTextStyle(
              size: AppConstants.mediumFont,
              color: AppColors
                  .blackColor,
          fontWeight: isTitle ?FontWeight.w700:FontWeight.w300),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget basketListItem({required int index, required BuildContext context}) {
    return BlocBuilder<BasketBloc, BasketState>(
      builder: (context, state) {
        BasketBloc bloc = context.read<BasketBloc>();
        return Dismissible(
          key: Key(state.basketProductList.toString()),
          direction: DismissDirection.startToEnd,
          background: Container(
            alignment: state.language == AppStrings.englishString
                ? Alignment.centerLeft
                : Alignment.centerRight,
            margin: EdgeInsets.symmetric(
                vertical: AppConstants.padding_5,
                horizontal: AppConstants.padding_10),
            decoration: BoxDecoration(
              color: AppColors.redColor,
              borderRadius:
                  BorderRadius.all(Radius.circular(AppConstants.radius_5)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: GestureDetector(
                onTap: () {
                  isRemoveProcess = true;
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
                  color: AppColors.whiteColor,
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
                          child: AlertDialog(
                            backgroundColor: AppColors.pageColor,
                            contentPadding: EdgeInsets.all(20.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            title: Text(
                                '${AppLocalizations.of(context)!.you_want_delete_product}',
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
                                  bloc.add(BasketEvent.removeCartProductEvent(
                                      context: context,
                                      cartProductId: state
                                          .basketProductList[index]
                                          .cartProductId,
                                      listIndex: index,
                                      dialogContext: context,
                                      totalAmount: state
                                          .basketProductList[index]
                                          .totalPayment!));
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 14.0, vertical: 10.0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0)),
                                  width: 80,
                                  child: Text(
                                    '${AppLocalizations.of(context)!.yes}',
                                    style: AppStyles.rkRegularTextStyle(
                                        color: AppColors.mainColor
                                            .withOpacity(0.9),
                                        size: AppConstants.smallFont),
                                  ),
                                ),
                              ),
                              InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  bloc.add(BasketEvent.refreshListEvent(
                                      context: context1));
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 14.0, vertical: 10.0),
                                  alignment: Alignment.center,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      color:
                                          AppColors.mainColor.withOpacity(0.9),
                                      borderRadius: BorderRadius.circular(8.0)),
                                  child: Text(
                                    '${AppLocalizations.of(context)!.no}',
                                    style: AppStyles.rkRegularTextStyle(
                                        color: AppColors.whiteColor,
                                        size: AppConstants.smallFont),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
          child: Container(
            margin: EdgeInsets.symmetric(
                vertical: AppConstants.padding_5,
                horizontal: AppConstants.padding_10),
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
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
                  padding: EdgeInsets.symmetric(
                      vertical: AppConstants.padding_10,
                      horizontal: AppConstants.padding_10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      state.basketProductList[index].mainImage == ''
                          ? GestureDetector(
                              onTap: () {
                                showProductDetails(
                                    context: context,
                                    index: index,
                                    qty: state.CartItemList.data?.data?.elementAt(index).totalQuantity??0,
                                    CartItemList: state.CartItemList,
                                  cartProductId: state.CartItemList.data?.data?[index].id ?? ''

                                );
                              },
                              child: Image.asset(
                                AppImagePath.imageNotAvailable5,
                                width: 100,
                                height: 100,
                                fit: BoxFit.fitWidth,
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                showProductDetails(
                                    context: context,
                                    index: index,
                                    qty: state.CartItemList.data?.data?.elementAt(index).totalQuantity??0,
                                    CartItemList: state.CartItemList,
                                    cartProductId: state.CartItemList.data?.data?[index].id ?? ''
                                );
                              },
                              child: Image.network(
                                '${AppUrls.baseFileUrl}${state.basketProductList[index].mainImage ?? ''}',
                                width: 100,
                                height: 100,
                                fit: BoxFit.contain,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Center(
                                      child: Container(
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
                                  return Container(
                                    width: 100,
                                    height: 100,
                                    color: AppColors.whiteColor,
                                    alignment: Alignment.center,
                                    child: Image.asset(AppImagePath.imageNotAvailable5)
                                  );
                                },
                              ),
                            ),
                      20.width,
                      Expanded(
                        flex: 3,
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showProductDetails(
                                      context: context,
                                      index: index,
                                      qty: state.CartItemList.data?.data?.elementAt(index).totalQuantity??0,
                                      CartItemList: state.CartItemList,
                                      cartProductId: state.CartItemList.data?.data?[index].id ?? ''
                                  );
                                },
                                child: Container(
                                  child: Text(
                                    state.basketProductList[index].productName ?? '',
                                    style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontSize: AppConstants.smallFont,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              5.height,

                              Text(
                                  '${formatNumber(value: state.basketProductList[index].totalPayment?.toStringAsFixed(2) ?? "0", local: AppStrings.hebrewLocal)}',
                                style: TextStyle(
                                    color: AppColors.blackColor,
                                    fontSize: AppConstants.smallFont,
                                    fontWeight: FontWeight.w700),
                              ),
                              10.height,
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (!state.isLoading) {
                                        if ((state
                                                    .CartItemList
                                                    .data
                                                    ?.data?[index]
                                                    .productStock ??
                                                0) >=
                                            state.basketProductList[index]
                                                    .totalQuantity! +
                                                1) {
                                          bloc.add(
                                              BasketEvent.productUpdateEvent(
                                            listIndex: index,
                                            isFromCart: false,
                                            productWeight: state.basketProductList[index].totalQuantity! +
                                                1,
                                            context: context,
                                            productId: state
                                                    .CartItemList
                                                    .data
                                                    ?.data?[index]
                                                    .productDetails
                                                    ?.id ??
                                                '',
                                            supplierId: state
                                                    .CartItemList
                                                    .data
                                                    ?.data?[index]
                                                    .suppliers
                                                    ?.first
                                                    .id ??
                                                '',
                                            cartProductId: state
                                                    .CartItemList
                                                    .data
                                                    ?.data?[index]
                                                    .cartProductId ??
                                                '',
                                            totalPayment: state.totalPayment,
                                            saleId: ((state
                                                        .CartItemList
                                                        .data
                                                        ?.data?[index]
                                                        .sales
                                                        ?.length ==
                                                    0)
                                                ? ''
                                                : (state
                                                        .CartItemList
                                                        .data
                                                        ?.data?[index]
                                                        .sales
                                                        ?.first
                                                        .id ??
                                                    '')),
                                          ));
                                        } else {
                                          CustomSnackBar.showSnackBar(
                                              context: context,
                                              title:
                                                  '${AppLocalizations.of(context)!.out_of_stock}',
                                              type: SnackBarType.FAILURE);
                                        }
                                      }
                                    },
                                    child: Container(
                                      width: AppConstants.containerSize_35,
                                      height: AppConstants.containerSize_35,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              AppConstants.radius_4),
                                          border: Border.all(
                                              color:
                                                  AppColors.navSelectedColor),
                                          color: AppColors.pageColor),
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
                                        if (state.basketProductList[index]
                                                .totalQuantity! >
                                            1) {
                                          bloc.add(
                                              BasketEvent.productUpdateEvent(
                                            listIndex: index,
                                            isFromCart: false,
                                            productWeight: state
                                                    .basketProductList[index]
                                                    .totalQuantity! -
                                                1,
                                            context: context,
                                            productId: state
                                                    .CartItemList
                                                    .data
                                                    ?.data?[index]
                                                    .productDetails
                                                    ?.id ??
                                                '',
                                            supplierId: state
                                                    .CartItemList
                                                    .data
                                                    ?.data?[index]
                                                    .suppliers
                                                    ?.first
                                                    .id ??
                                                '',
                                            cartProductId: state
                                                    .CartItemList
                                                    .data
                                                    ?.data?[index]
                                                    .cartProductId ??
                                                '',
                                            totalPayment: state.totalPayment,
                                            saleId: ((state
                                                        .CartItemList
                                                        .data
                                                        ?.data?[index]
                                                        .sales
                                                        ?.length ==
                                                    0)
                                                ? ''
                                                : (state
                                                        .CartItemList
                                                        .data
                                                        ?.data?[index]
                                                        .sales
                                                        ?.first
                                                        .id ??
                                                    '')),
                                          ));
                                        }
                                        else{
                                          deleteDialog(
                                              context: context,
                                              updateClearString: '',
                                              cartProductId: state
                                                  .CartItemList
                                                  .data
                                                  ?.data?[index]
                                                  .cartProductId ?? '',
                                              listIndex: index,
                                            totalAmount: state.totalPayment
                                          );
                                        }
                                      }
                                    },
                                    child: Container(
                                      width: AppConstants.containerSize_35,
                                      height: AppConstants.containerSize_35,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              AppConstants.radius_4),
                                          border: Border.all(
                                              color:
                                                  AppColors.navSelectedColor),
                                          color: AppColors.pageColor),
                                      child: Icon(
                                        Icons.remove,
                                        size: 20,
                                        color: AppColors.blackColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
                    child: AlertDialog(
                      backgroundColor: AppColors.pageColor,
                      contentPadding: EdgeInsets.all(20.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      title: Text(
                          updateClearString == AppStrings.clearString
                              ? '${AppLocalizations.of(context)!.you_want_clear_cart}'
                              : '${AppLocalizations.of(context)!.you_want_delete_product}',
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
                                ? bloc.add(BasketEvent.clearCartEvent(
                                    context: context1))
                                : bloc.add(BasketEvent.removeCartProductEvent(
                                    context: context,
                                    cartProductId: cartProductId,
                                    listIndex: listIndex,
                                    dialogContext: context1,
                                    totalAmount: totalAmount!));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 14.0, vertical: 10.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0)),
                            width: 80,
                            child: Text(
                              '${AppLocalizations.of(context)!.yes}',
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
                            bloc.add(BasketEvent.refreshListEvent(
                                context: context1));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 14.0, vertical: 10.0),
                            alignment: Alignment.center,
                            width: 80,
                            decoration: BoxDecoration(
                                color: AppColors.mainColor.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(8.0)),
                            child: Text(
                              '${AppLocalizations.of(context)!.no}',
                              style: AppStyles.rkRegularTextStyle(
                                  color: AppColors.whiteColor,
                                  size: AppConstants.smallFont),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ));
  }

  void showProductDetails(
      {required BuildContext context,
      required int index,
        required int qty,
      required GetAllCartResModel CartItemList,
        required String cartProductId,
      }) async {
/*    context.read<BasketBloc>().add(BasketEvent.getAllCartEvent(
        context: context,
    ));*/
    context.read<BasketBloc>().add(BasketEvent.getProductDetailsEvent(
      productId: cartProductId,
       isBarcode: false,
      context: context,
    ));
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      clipBehavior: Clip.hardEdge,
      showDragHandle: true,
      useSafeArea: true,
      enableDrag: true,
      builder: (context1) {
        return BlocProvider.value(
          value: context.read<BasketBloc>(),
          child: DraggableScrollableSheet(
            expand: true,
            maxChildSize: 1 -
                (MediaQuery.of(context).viewPadding.top /
                    getScreenHeight(context)),
            minChildSize: 0.4,
            initialChildSize: AppConstants.bottomSheetInitHeight,
            //shouldCloseOnMinExtent: true,
            builder:
                (BuildContext context1, ScrollController scrollController) {
              return BlocBuilder<BasketBloc, BasketState>(
                builder: (context, state) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AppConstants.radius_30),
                        topRight: Radius.circular(AppConstants.radius_30),
                      ),
                      color: AppColors.whiteColor,
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Scaffold(
                      body: state.isProductLoading
                          ? ProductDetailsShimmerWidget()
                          : state.productDetails.isEmpty
                          ? Center(
                        child: Text(
                            AppLocalizations.of(context)!.no_data,
                            style: AppStyles.rkRegularTextStyle(
                              size: AppConstants.normalFont,
                              color: AppColors.greyColor,
                              fontWeight: FontWeight.w500,
                            )),
                      )
                          : CommonProductDetailsWidget(
                        addToOrderTap: () {
                          context.read<BasketBloc>().add(
                              BasketEvent.addToCartProductEvent(
                                  context: context1,
                                  productId: cartProductId
                              ));
                        },
                        isLoading: state.isLoading,
                        imageOnTap: (){
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Stack(
                                children: [
                                  Container(
                                    height: getScreenHeight(context) - MediaQuery.of(context).padding.top ,
                                    width: getScreenWidth(context),
                                    child: PhotoView(
                                      imageProvider: CachedNetworkImageProvider(
                                        '${AppUrls.baseFileUrl}${state.productDetails[state.productImageIndex].mainImage}',
                                      ),
                                    ),
                                  ),

                                  GestureDetector(
                                      onTap: (){
                                        Navigator.pop(context);
                                      },
                                      child: Icon(Icons.close,
                                        color: Colors.white,
                                      )),
                                ],
                              );
                            },);
                        },
                        context: context,
                        productImageIndex: state.productImageIndex,
                        onPageChanged: (index, p1) {
                          context.read<BasketBloc>().add(
                              BasketEvent.updateImageIndexEvent(
                                  index: index));
                        },
                        productImages: [
                          state.productDetails.first.mainImage ??
                              '',
                          ...state.productDetails.first.images
                              ?.map((image) =>
                          image.imageUrl ?? '') ??
                              []
                        ],
                        productPerUnit: state.productDetails.first
                            .numberOfUnit ??
                            0,
                        productUnitPrice: state
                            .productStockList[
                        state.productStockUpdateIndex]
                            .totalPrice,
                        productName: state.productDetails.first
                            .productName ??
                            '',
                        productCompanyName: state
                            .productDetails.first.brandName ??
                            '',
                        productDescription: parse(state
                            .productDetails
                            .first
                            .productDescription ??
                            '')
                            .body
                            ?.text ??
                            '',
                        productSaleDescription: parse(state
                            .productDetails
                            .first
                            .productDescription ??
                            '')
                            .body
                            ?.text ??
                            '',
                        productPrice: state
                            .productStockList[
                        state.productStockUpdateIndex]
                            .totalPrice *
                            state
                                .productStockList[
                            state.productStockUpdateIndex]
                                .quantity *
                            (state.productDetails.first
                                .numberOfUnit ??
                                0),
                        productScaleType: state.productDetails
                            .first.scales?.scaleType ??
                            '',
                        productWeight: state
                            .productDetails.first.itemsWeight
                            ?.toDouble() ??
                            0.0,
                        productStock:
                        int.parse(state.productStockList[state.productStockUpdateIndex].stock.toString())
                        ,
                        isRTL: context.rtl,
                        isSupplierAvailable:
                        state.productSupplierList.isEmpty
                            ? false
                            : true,
                        scrollController: scrollController,
                        productQuantity: state
                            .productStockList[
                        state.productStockUpdateIndex]
                            .quantity,
                        onQuantityChanged: (quantity) {
                          context.read<BasketBloc>().add(
                              BasketEvent.updateQuantityOfProduct(
                                  context: context1,
                                  quantity: quantity));
                        },
                        onQuantityIncreaseTap: () {
                          context.read<BasketBloc>().add(
                              BasketEvent.increaseQuantityOfProduct(
                                  context: context1));
                        },
                        onQuantityDecreaseTap: () {
                          context.read<BasketBloc>().add(
                              BasketEvent.decreaseQuantityOfProduct(
                                  context: context1));
                        },
                      ),
                      bottomNavigationBar: state.isProductLoading
                          ? 0.height
                          :Container(
                        height: 200,
                        padding: EdgeInsets.only(bottom:10,left: 10,right: 10),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (context,i){return   CommonProductItemWidget(
                            productStock: '1',
                            height: 10,
                            width: 140,
                            productImage:
                            '',
                            productName:
                            '',
                            totalSaleCount:
                            0,
                            price:
                            0.0,
                            onButtonTap: () {
                              print("tap 2");

                            },
                          );},itemCount: 3,),
                      )
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    ).then((value) {
     /* context.read<BasketBloc>().add(BasketEvent.getAllCartEvent(
        context: context,
      ));*/
    });


  }
}
