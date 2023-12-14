import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:food_stock/bloc/basket/basket_bloc.dart';
import 'package:food_stock/data/model/res_model/get_all_cart_res_model/get_all_cart_res_model.dart' hide Image;
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:html/parser.dart';
import '../../bloc/bottom_nav/bottom_nav_bloc.dart';
import '../../routes/app_routes.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_img_path.dart';
import '../utils/themes/app_strings.dart';
import '../utils/themes/app_styles.dart';
import '../widget/basket_screen_shimmer_widget.dart';
import '../widget/common_shimmer_widget.dart';

class BasketRoute {
  static Widget get route => const BasketScreen();
}

class BasketScreen extends StatelessWidget {
  const BasketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          BasketBloc(),
      child: const BasketScreenWidget(),
    );
  }
}

class BasketScreenWidget extends StatelessWidget {
  const  BasketScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BasketBloc bloc = context.read<BasketBloc>();
    return BlocListener<BasketBloc, BasketState>(
      listener: (context, state) {
        BlocProvider.of<BottomNavBloc>(context)
            .add(BottomNavEvent.updateCartCountEvent());
        BlocProvider.of<BottomNavBloc>(context).add(BottomNavEvent.cartAnimationEvent(cartCount: state.cartCount));
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          //width: getScreenWidth(context) * 0.36,
                                          height: AppConstants.containerSize_50,
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.symmetric(
                                              vertical: AppConstants.padding_5,
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
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                               '${AppLocalizations.of(context)!.total}',
                                                style: AppStyles
                                                    .rkRegularTextStyle(
                                                  size:  AppConstants
                                                      .font_14,
                                                  color: AppColors
                                                      .whiteColor,
                                                ),
                                              ),
                                              Directionality(
                                                textDirection: TextDirection.ltr,
                                                child: Expanded(
                                                  child: Text(
                                                    '${(formatNumber(value:(state.totalPayment.toStringAsFixed(2)),local:AppStrings.hebrewLocal))}',
                                                      style: AppStyles
                                                          .rkRegularTextStyle(
                                                          size: getScreenWidth(
                                                              context) <= 380
                                                              ? AppConstants
                                                              .font_14
                                                              : AppConstants
                                                              .smallFont,
                                                          color: AppColors
                                                              .whiteColor,
                                                          fontWeight:
                                                          FontWeight.w700),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          /*RichText(
                                            text: TextSpan(
                                              text: AppLocalizations.of(context)!
                                                  .total,
                                                style: AppStyles
                                                    .rkRegularTextStyle(
                                                    size: getScreenWidth(
                                                        context) <=
                                                        380
                                                        ? AppConstants
                                                        .font_14
                                                        : AppConstants
                                                        .mediumFont,
                                                    color: AppColors
                                                        .whiteColor,
                                                ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text:
                                                    '${' : '}${formatter(state.totalPayment.toString())}${AppLocalizations.of(context)!.currency}',
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
                                                        FontWeight.w700)),
                                              ],
                                            ),
                                          ),*/
                                        ),
                                        5.width,
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(context, RouteDefine.orderSummaryScreen.name,arguments: {
                                              AppStrings.getCartListString : state.CartItemList
                                                });
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
                                                size: getScreenWidth(context) <= 380
                                                    ? AppConstants.smallFont
                                                    : AppConstants.mediumFont,
                                                color: AppColors.whiteColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  10.width,
                                  InkWell(
                                    onTap: () {
                                      deleteDialog(
                                          context: context,
                                          updateClearString:
                                              AppStrings.clearString,
                                          listIndex: 0,
                                          cartProductId: '',
                                      totalAmount : 0.0,
                                      );
                                    },
                                    child: Container(
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            AppImagePath.delete,
                                          ),
                                         5.width,
                                          Text(
                                            AppLocalizations.of(context)!.empty,
                                            style: AppStyles.rkRegularTextStyle(
                                              size: AppConstants.font_14,
                                              color: AppColors.greyColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  2.width,
                                ],
                              ),
                            )
                          : SizedBox(),
                      state.isShimmering
                          ? BasketScreenShimmerWidget() :
                        /*  : state.basketProductList.isEmpty
                              ? Expanded(
                                  child: Center(
                                      child: Text(
                                        AppLocalizations.of(context)!.cart_empty,
                                    style: AppStyles.rkRegularTextStyle(
                                        size: AppConstants.normalFont,
                                        color: AppColors.blackColor,
                                        fontWeight: FontWeight.w400),
                                  )),
                                )
                              :*/ (state.basketProductList.length) != 0
                                  ? Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: getScreenHeight(context) * 0.1),
                                    child: ListView.builder(
                                      itemCount: state.basketProductList.length,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      padding: EdgeInsets.symmetric(
                                          vertical: AppConstants.padding_5),
                                      itemBuilder: (context, index) =>
                                          basketListItem(
                                              index: index, context: context,
                                          ),
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

        return Dismissible(
          key: Key(state.basketProductList.toString()),
          direction: DismissDirection.startToEnd,
          background: Container(
            alignment: state.language == AppStrings.englishString ? Alignment.centerLeft : Alignment.centerRight,
            margin: EdgeInsets.symmetric(
                vertical: AppConstants.padding_5,
                horizontal: AppConstants.padding_10),
          decoration: BoxDecoration(
            color: AppColors.redColor,
            borderRadius: BorderRadius.all(Radius.circular(AppConstants.radius_5)),
          ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: SvgPicture.asset(
                AppImagePath.delete,
                color: AppColors.whiteColor,
                height: 30,
                width: 30,
              ),
            ),
          ),
          onDismissed: (direction){
            bloc.add(BasketEvent.removeCartProductEvent(
                context: context,
                cartProductId: state.basketProductList[index].cartProductId,
                listIndex: index,
                dialogContext: context,
                totalAmount: state.basketProductList[index].totalPayment!
            ));
          },
          child: Container(
            margin: EdgeInsets.symmetric(
                vertical: AppConstants.padding_5,
                horizontal: AppConstants.padding_10
            ),
            padding: EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 0),
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
              state.basketProductList[index].isProcess == true ? LinearProgressIndicator(
                      color: AppColors.mainColor,
                      minHeight: 3,
                      borderRadius: BorderRadius.all(
                          Radius.circular(
                              AppConstants.radius_5)),
                      backgroundColor:
                      AppColors.mainColor.withOpacity(0.5),
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

                     state.basketProductList[index].mainImage == ''? GestureDetector(
                       onTap: (){
                         showProductDetails(
                             context: context,
                             index: index,
                             CartItemList : state.CartItemList
                           
                         );
                       },
                       child: Image.asset(AppImagePath.imageNotAvailable5,
                         width: 100,
                         height: 100,
                         fit: BoxFit.fitWidth,
                       ),
                     ) : GestureDetector(
                       onTap: (){
                         showProductDetails(
                             context: context,
                             index: index, CartItemList: state.CartItemList
                         );
                       },
                       child: Image.network(
                          '${AppUrls.baseFileUrl}${state.basketProductList[index].mainImage ?? ''}',
                          width: 100,
                          height: 100,
                         fit: BoxFit.fill,
                         loadingBuilder:
                             (context,
                             child,
                             loadingProgress) {
                           if (loadingProgress ==
                               null) {
                             return child;
                           } else {
                             return Center(
                               child: Container(
                                 width: 80,
                                 height: 80,
                                 child: CupertinoActivityIndicator(
                                   color: AppColors
                                       .blackColor,
                                 ),
                               ),
                             );
                           }
                         },
                         errorBuilder:
                             (context,
                             error,
                             stackTrace) {
                           return Container(
                             width: 80,
                             height: 80,
                             color: AppColors
                                 .whiteColor,
                             alignment:
                             Alignment
                                 .center,
                             child: Text(
                               AppStrings
                                   .failedToLoadString,
                               style: AppStyles.rkRegularTextStyle(
                                   size: AppConstants
                                       .font_14,
                                   color:
                                   AppColors.textColor),
                             ),
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
                                onTap: (){
                                  showProductDetails(
                                      context: context,
                                      index: index, CartItemList: state.CartItemList
                                  );
                                },
                                child: Container(
                                  child: Text(
                                    state.basketProductList[index].productName!,
                                    style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontSize: AppConstants.smallFont,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ),
                              5.height,
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: Text(
                                  /* '${splitNumber(state.basketProductList[index].totalPayment?.toStringAsFixed(2) ??"0")}${AppLocalizations.of(context)!.currency}',*/
                                  '${formatNumber(value: state.basketProductList[index].totalPayment?.toStringAsFixed(2) ??"0",local:AppStrings.hebrewLocal)}',
                                  style: TextStyle(
                                      color: AppColors.blackColor,
                                      fontSize: AppConstants.smallFont,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              10.height,
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if(!state.isLoading){
                                        if ((state.CartItemList.data?.data?[index].productStock ?? 0 )>=
                                            state.basketProductList[index].totalQuantity! + 1) {
                                          bloc.add(BasketEvent.productUpdateEvent(
                                            listIndex: index,
                                            productWeight:
                                            state.basketProductList[index].totalQuantity! + 1,
                                            context: context,
                                            productId: state.CartItemList.data?.data?[index].productDetails?.id ?? '',
                                            supplierId: state.CartItemList.data?.data?[index].suppliers?.first.id ?? '',
                                            cartProductId: state.CartItemList.data?.data?[index].cartProductId ?? '',
                                            totalPayment:state.totalPayment,
                                            saleId: ((state.CartItemList.data?.data?[index].sales?.length == 0) ? '':(state.CartItemList.data?.data?[index].sales?.first.id ?? '') ),
                                          ));
                                        } else {
                                          showSnackBar(
                                              context: context,
                                              title: '${AppLocalizations.of(context)!.out_of_stock}',
                                              bgColor: AppColors.redColor);
                                        }
                                      }

                                    },
                                    child: Container(
                                      width: AppConstants.containerSize_35,
                                      height: AppConstants.containerSize_35,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(AppConstants.radius_4),
                                          border: Border.all(color: AppColors.navSelectedColor),
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
                                      if(!state.isLoading) {
                                        if (state.basketProductList[index].totalQuantity! > 1) {
                                          bloc.add(BasketEvent.productUpdateEvent(
                                            listIndex: index,
                                            productWeight:
                                            state.basketProductList[index].totalQuantity! - 1,
                                            context: context,
                                            productId: state.CartItemList.data?.data?[index].productDetails?.id ?? '',
                                            supplierId: state.CartItemList.data?.data?[index].suppliers?.first.id ?? '',
                                            cartProductId: state.CartItemList.data?.data?[index].cartProductId ?? '',
                                            totalPayment: state
                                                .totalPayment,
                                            saleId: ((state.CartItemList.data?.data?[index].sales?.length ==
                                                0) ? '' : (state.CartItemList.data?.data?[index].sales?.first
                                                .id ?? '')),
                                          ));
                                        }
                                      }

                                    },
                                    child: Container(
                                      width: AppConstants.containerSize_35,
                                      height: AppConstants.containerSize_35,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(AppConstants.radius_4),
                                          border: Border.all(color: AppColors.navSelectedColor),
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
    required int listIndex,  double? totalAmount,
  }) {
    BasketBloc bloc = context.read<BasketBloc>();
    showDialog(
        context: context,
        builder: (context1) => AlertDialog(
              contentPadding: EdgeInsets.all(20.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              title: Text(
                   '${AppLocalizations.of(context)!.you_want_clear_cart}',

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
                        ? bloc.add(BasketEvent.clearCartEvent(context: context1))
                        : bloc.add(BasketEvent.removeCartProductEvent(
                            context: context,
                            cartProductId: cartProductId,
                            listIndex: listIndex,
                      dialogContext: context1,
                      totalAmount: totalAmount!
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
                    Navigator.pop(context1);
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
                        '${AppLocalizations.of(context)!.no}',
                      style: AppStyles.rkRegularTextStyle(
                          color: AppColors.whiteColor,
                          size: AppConstants.smallFont),
                    ),
                  ),
                )
              ],
            ));
  }

  void showProductDetails(
      {required BuildContext context, required int index, required GetAllCartResModel CartItemList}) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      clipBehavior: Clip.hardEdge,
      // showDragHandle: true,
      useSafeArea: true,
      enableDrag: true,
      builder: (context1) {

        return BlocProvider.value(
          value: context.read<BasketBloc>(),
          child: DraggableScrollableSheet(
            expand: false,
          //  maxChildSize: 1 - (MediaQuery.of(context).viewPadding.top / getScreenHeight(context)),
          //  minChildSize: 0.6,
         //   initialChildSize: 0.6,
          //  shouldCloseOnMinExtent: false,
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
                          backgroundColor: AppColors.whiteColor,
                          body: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_20),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(AppConstants.radius_30),
                                  topRight: Radius.circular(AppConstants.radius_30),
                                ),
                                color: AppColors.whiteColor,
                              ),
                              padding: EdgeInsets.only(
                                  top: AppConstants.padding_10,
                                  bottom: MediaQuery.of(context).viewInsets.bottom),
                              clipBehavior: Clip.hardEdge,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Expanded(child: 0.width),
                                      Expanded(
                                        flex: 4,
                                        child: Text(
                                          CartItemList.data?.data?[index].productDetails?.productName ??
                                              '',
                                          style: AppStyles.rkBoldTextStyle(
                                            size: AppConstants.normalFont,
                                            color: AppColors.blackColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Icon(
                                              Icons.close,
                                              size: 36,
                                              color: AppColors.blackColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  5.height,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${(double.parse(CartItemList.data?.data?[index].productDetails?.itemsWeight?.toStringAsFixed(2) ?? '')/(CartItemList.data?.data?[index].totalQuantity ?? 1)).toStringAsFixed(2)}${CartItemList.data?.data?[index].productDetails?.scales ?? ''}',
                                        style: AppStyles.rkRegularTextStyle(
                                            size: AppConstants.smallFont, color: AppColors.blackColor),
                                      ),
                                      Text(
                                        ' | ',
                                        style: AppStyles.rkRegularTextStyle(
                                            size: AppConstants.smallFont, color: AppColors.blackColor),
                                      ),
                                      Text(
                                        '${CartItemList.data?.data?[index].suppliers?.first.contactName ?? ''}',
                                        style: AppStyles.rkRegularTextStyle(
                                            size: AppConstants.smallFont, color: AppColors.blackColor),
                                      ),
                                    ],
                                  ),
                                  10.height,
                                  Expanded(
                                    child: SingleChildScrollView(
                                      controller: scrollController,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Stack(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      bottom: 20,
                                                      right: AppConstants.padding_10,
                                                      left: AppConstants.padding_10,
                                                      top: AppConstants.padding_10),
                                                  child: CarouselSlider(
                                                    // carouselController: carouselController,
                                                      items: [ CartItemList.data?.data?[index].productDetails?.mainImage ?? '',
                                                        ...?CartItemList.data?.data?[index].productDetails?.images?.map(
                                                                (image) => image.imageUrl ?? '')
                                                            ].map(
                                                              (productImage) =>
                                                          Image.network(
                                                            "${AppUrls.baseFileUrl}$productImage",
                                                            height: 150,
                                                            fit: BoxFit.fitHeight,
                                                            loadingBuilder: (context, child,
                                                                loadingProgress) {
                                                              if (loadingProgress
                                                                  ?.cumulativeBytesLoaded !=
                                                                  loadingProgress
                                                                      ?.expectedTotalBytes) {
                                                                return CommonShimmerWidget(
                                                                  child: Container(
                                                                    height: 150,
                                                                    width: 150,
                                                                    decoration: BoxDecoration(
                                                                      color:
                                                                      AppColors.whiteColor,
                                                                      borderRadius: BorderRadius
                                                                          .all(Radius.circular(
                                                                          AppConstants
                                                                              .radius_10)),
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                              return child;
                                                            },
                                                            errorBuilder:
                                                                (context, error, stackTrace) {
                                                              // debugPrint('product category list image error : $error');
                                                              return Image.asset(
                                                                AppImagePath.imageNotAvailable5,
                                                                fit: BoxFit.cover,
                                                                width: 80,
                                                                height: 150,
                                                              );
                                                            },
                                                          ))
                                                          .toList(),
                                                      options: CarouselOptions(
                                                          height: 150,
                                                          onPageChanged: (index, p1) {
                                                  context.read<BasketBloc>().add(
                                                  BasketEvent.updateImageIndexEvent(
                                                  index: index));
                                                  },
                                                          initialPage: 1,
                                                          aspectRatio: 16 / 9,
                                                          scrollDirection: Axis.horizontal,
                                                          enableInfiniteScroll: false,
                                                          autoPlayCurve: Curves.decelerate,
                                                          pageSnapping: true)),
                                                ),
                                                [ CartItemList.data?.data?[index].productDetails?.mainImage ?? '',
                                                  ...?CartItemList.data?.data?[index].productDetails?.images?.map(
                                                          (image) => image.imageUrl ?? '')
                                                      ].length < 2
                                                    ? 0.width
                                                    : Positioned(
                                                    bottom: 5,
                                                    child: Container(
                                                      width: getScreenWidth(context),
                                                      alignment: Alignment.center,
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.center,
                                                        children: [ CartItemList.data?.data?[index].productDetails?.mainImage ?? '',
                                                          ...?CartItemList.data?.data?[index].productDetails?.images?.map(
                                                                  (image) => image.imageUrl ?? '')
                                                              ]
                                                            .asMap()
                                                            .entries
                                                            .map((productImage) => Container(
                                                          height: 7,
                                                          width: 7,
                                                          margin: EdgeInsets.symmetric(
                                                              horizontal:
                                                              AppConstants.padding_2),
                                                          decoration: BoxDecoration(
                                                              color: state.productImageIndex ==
                                                                  productImage.key
                                                                  ? AppColors.mainColor
                                                                  : AppColors.borderColor,
                                                              shape: BoxShape.circle),
                                                        ))
                                                            .toList(),
                                                      ),
                                                    ))
                                              ],
                                            ),
                                          ),
                                          5.width,
                                          Text(
                                            CartItemList.data?.data?[index].productDetails?.productName ??
                                                '',
                                            style: AppStyles.rkBoldTextStyle(
                                              size: AppConstants.smallFont,
                                              color: AppColors.greyColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            '${(double.parse(CartItemList.data?.data?[index].totalAmount.toString() ?? '0')/(CartItemList.data?.data?[index].totalQuantity ?? 1)).toStringAsFixed(2)}${AppLocalizations.of(context)!.currency}',
                                            style: AppStyles.rkBoldTextStyle(
                                              size: AppConstants.smallFont,
                                              color: AppColors.blackColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          10.height,
                                          (CartItemList.data?.data?[index].sales?.length ?? 0) > 0 ? Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              "${parse(CartItemList.data?.data?[index].sales?.first.salesDescription).body?.text}",
                                              style: AppStyles.rkBoldTextStyle(
                                                size: AppConstants.font_14,
                                                color: AppColors.greyColor,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ) : SizedBox(),
                                          (CartItemList.data?.data?[index].note ?? '').isNotEmpty ? Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: AppConstants.padding_20,
                                                   ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      AppLocalizations.of(context)!.note,
                                                      style: AppStyles.rkRegularTextStyle(
                                                          size: AppConstants.font_14,
                                                          color: AppColors.greyColor,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    10.height,
                                                    Container(
                                                      width: getScreenWidth(context),
                                                      padding: EdgeInsets.only(
                                                          left: AppConstants.padding_10,
                                                          right: AppConstants.padding_10,
                                                          bottom: AppConstants.padding_5),
                                                      decoration: BoxDecoration(
                                                          color: AppColors.notesBGColor,
                                                          borderRadius: BorderRadius.all(
                                                              Radius.circular(
                                                                  AppConstants.radius_5))),
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_10),
                                                        child: Text(CartItemList.data?.data?[index].note ?? '',
                                                          style: AppStyles.rkRegularTextStyle(
                                                              size: AppConstants.font_14,
                                                              color: AppColors.blackColor),
                                                        ),
                                                      )
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ) : SizedBox(),
                                          // 160.height,
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
  },
);
                
            },
          ),
        );
      },
    );
  }
}
