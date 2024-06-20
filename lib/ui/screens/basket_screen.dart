
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:food_stock/bloc/basket/basket_bloc.dart';
import 'package:food_stock/bloc/bottom_nav/bottom_nav_bloc.dart';
import 'package:food_stock/data/model/res_model/related_product_res_model/related_product_res_model.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/utils/themes/app_img_path.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:food_stock/ui/widget/basket_screen_shimmer_widget.dart';
import 'package:food_stock/ui/widget/common_product_details_widget.dart';
import 'package:food_stock/ui/widget/custom_button_widget.dart';
import 'package:food_stock/ui/widget/product_details_shimmer_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:html/parser.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:photo_view/photo_view.dart';
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
        if(state.isAnimation){
          BlocProvider.of<BottomNavBloc>(context)
              .add(BottomNavEvent.updateCartCountEvent(context: context));
        }
        if(state.isAccountPermissionShimmering){
          BlocProvider.of<BottomNavBloc>(context)
              .add(BottomNavEvent.seeWalletPermissionUpdateEvent(context: context));
        }
        if(state.isOrderPending){
          showDialog(
            context:context,
            builder: (context1) {
              return CustomOneButtonDialog(
                title: AppLocalizations.of(context)!.order_sign_dialog,
                  directionality: state.language,
                positiveOnTap: () {
                  Navigator.pop(context1);
                  Navigator.pushNamed(context, RouteDefine.orderScreen.name);
                },
                positiveTitle: AppLocalizations.of(context)!.show_order,
                width: 120,
              );
            },).then((value) {
            context.read<BasketBloc>().add(BasketEvent.refreshEvent());
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
                bloc.add(BasketEvent.getAllCartEvent(context: context));
                bloc.add(BasketEvent.userApproveEvent(context: context));
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
                                      AppImagePath.delete,colorFilter:ColorFilter.mode(
                                        AppColors.redColor, BlendMode.srcIn),),
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
                                      AppImagePath.delete,
                                      colorFilter: ColorFilter.mode(
                                          AppColors.whiteColor, BlendMode.srcIn),
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
                              ),
                            ),
                          ],
                        ),
                      )
                          : SizedBox(),

                      state.isShimmering
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
                                        isPesach: state.basketProductList[index].isPesach??false,
                                        index: index,
                                        context: context,
                                        isSaleOn: true,
                                        lowStock: state.basketProductList[index].lowStock.toString(),
                                        productStock: state.basketProductList[index].productStock ?? 0
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
                          ? SizedBox()
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
            Text('${AppLocalizations.of(context)!.note} : ${AppLocalizations.of(context)!.not_include_surfaces_price}',
              style: AppStyles.rkRegularTextStyle(
                  size: AppConstants.font_14,
                  color: AppColors
                      .redColor),
            ),

            5.height,
           state.isSubUserCanCreateOrder ?  CustomButtonWidget(
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
            ) : 0.width,
            10.height
          ],
        ));
  }

  Widget basketRow(String title,String amount,  {bool isTitle = false,double fontSize = 18} ){
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
              size: fontSize,
              color: AppColors
                  .blackColor,
              fontWeight: isTitle ?FontWeight.w700:FontWeight.w300),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget basketListItem({required int index, required BuildContext context,
    required String lowStock, required double productStock,required bool isPesach,required bool isSaleOn}) {
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
                  colorFilter: ColorFilter.mode(
                      AppColors.whiteColor, BlendMode.srcIn),
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
                            title: '${AppLocalizations.of(context)!.you_want_delete_product}',
                            directionality: state.language,
                            positiveTitle:AppLocalizations.of(context)!.yes,
                            negativeTitle: AppLocalizations.of(context)!.no,
                            positiveOnTap: (){
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
                            negativeOnTap: (){
                              Navigator.pop(context1);
                            },
                          )
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
            child: GestureDetector(
              onTap: (){
                showProductDetails(
                    context: context,
                    cartProductId: state.CartItemList.data?.data?[index].id ?? '',
                  productListIndex: 0,
                  productStock: state.CartItemList.data?.data?[index].productStock.toString() ?? '0'
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
                    padding: EdgeInsets.symmetric(
                        vertical: AppConstants.padding_10,
                        horizontal: AppConstants.padding_10),
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
                        20.width,
                        Expanded(
                          flex: 3,
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Text(
                                    state.basketProductList[index].productName ?? '',
                                    style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontSize: AppConstants.smallFont,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                5.height,
                                lowStock.isNotEmpty ? Text(
                                 lowStock,
                                  style: TextStyle(
                                      color: AppColors.orangeColor,
                                      fontSize: AppConstants.smallFont,
                                      ),
                                ) : 0.width,
                                lowStock.isNotEmpty?5.height:0.height,
                                state.basketProductList[index].isSale ?Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(top:3,bottom:5),
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: AppColors.saleBGColor,
                                    borderRadius: BorderRadius.all(Radius.circular(8))
                                  ),
                                  child: Center(child: Text(state.basketProductList[index].saleDesc,style: TextStyle(color: Colors.white,fontSize: AppConstants.font_12),)),
                                ):Container(),
                                isPesachLabelShow(isPesach, context),
                                isPesach?5.height:0.height,
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
                                              0.0) >=
                                              state.basketProductList[index]
                                                  .totalQuantity! +
                                                  1) {
                                            bloc.add(
                                                BasketEvent.productUpdateEvent(
                                                  listIndex: index,
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
                                                  saleId: state
                                                      .CartItemList
                                                      .data
                                                      ?.data?[index]
                                                      .id??''
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
                                                    saleId: state
                                                        .CartItemList
                                                        .data
                                                        ?.data?[index]
                                                        .id??''
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
                child:  CustomDialog(
                      title: updateClearString == AppStrings.clearString
                          ? '${AppLocalizations.of(context)!.you_want_clear_cart}'
                          : '${AppLocalizations.of(context)!.you_want_delete_product}',
                      directionality: state.language,
                      positiveTitle:AppLocalizations.of(context)!.yes,
                      isProcessing:  state.isRemoveProcess,
                      negativeTitle: AppLocalizations.of(context)!.no,
                      positiveOnTap: (){
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
                      negativeOnTap: (){
                        Navigator.pop(context1);
                      },
                    ));
            },
          ),
        ));
  }

  void showProductDetails({
    required BuildContext context,
    bool isBarcode= false,
    String productStock = '0',
    int productListIndex = 0,
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
      ),
      isDismissible: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      enableDrag: true,
      builder: (context1) {
        return SafeArea(
          bottom: false,
          child: DraggableScrollableSheet(
            expand: true,
            maxChildSize: 1 -
                (MediaQuery.of(context).viewPadding.top /
                    getScreenHeight(context)),
            minChildSize:    1 -
                (MediaQuery.of(context).viewPadding.top /
                    getScreenHeight(context)),
            initialChildSize:   1 -
                (MediaQuery.of(context).viewPadding.top /
                    getScreenHeight(context)),
            builder:
                (BuildContext context1, ScrollController scrollController) {
              return BlocProvider.value(
                value: context.read<BasketBloc>(),
                child: BlocBuilder<BasketBloc, BasketState>(
                  builder: (blocContext, state) {
                    return Container(
                      height: getScreenHeight(context),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(AppConstants.radius_30),
                          topRight: Radius.circular(AppConstants.radius_30),
                        ),
                        color: AppColors.whiteColor,
                      ),
                      child: state.isProductLoading
                          ? ProductDetailsShimmerWidget()
                          : state.productDetails.isEmpty
                          ? NoDataBottomSheet(dialogContext: context)
                          : SingleChildScrollView(
                        controller:  ModalScrollController.of(context),
                        child: Column(
                          children: [
                            CommonProductDetailsWidget(
                              productDetails: state.productDetails,
                            /*  salePrice: double.parse(state.productDetails.first.sale.salePrice),
                              maxQty: state.productDetails.first.sale.saleMaxQuantity,
                              endDate: state.productDetails.first.sale.saleUntilDate,
                              startDate: state.productDetails.first.sale.saleFromDate,
                              isSaleOn: state.productDetails.first.sale.isSale,*/
                              isSubUserAddToBasket: state.isSubUserAddToBasket,
                              bottleTax: state.bottleTax,
                              totalBottleDeposit: (state.bottleTax* state.productDetails.first.numberOfUnit.toDouble()* state
                                  .productStockList[state.productListIndex][
                              state.productStockUpdateIndex]
                                  .quantity),
                              isBottle:state.productDetails.first.isBottle,
                              // nmMashlim: state.productDetails.first.nmMashlim,
                              // isPesach: state.productDetails.first.isPesach,
                              // lowStock: state.productDetails.first.supplierSales.first.lowStock.toString() ,
                              // qrCode:state.productDetails.first.qrcode,
                              addToOrderTap: () {
                             FocusManager.instance.primaryFocus?.unfocus();
                                context.read<BasketBloc>().add(
                                    BasketEvent.addToCartProductEvent(
                                        context: context1,
                                        productId: cartProductId,
                                    ));
                              },
                              isLoading: state.isLoading,
                              imageOnTap: (){
                                showDialog(
                                  context: context,
                                  builder: (dialogContext) {
                                    return Stack(
                                      children: [
                                        Container(
                                          height: getScreenHeight(context) - MediaQuery.of(context).padding.top ,
                                          width: getScreenWidth(context),
                                          child: GestureDetector(
                                            onVerticalDragStart: (dragDetails) {
                                              debugPrint('onVerticalDragStart');
                                            },
                                            onVerticalDragUpdate: (dragDetails) {
                                              debugPrint('onVerticalDragUpdate');
                                            },
                                            onVerticalDragEnd: (endDetails) {
                                              debugPrint('onVerticalDragEnd');
                                              Navigator.pop(dialogContext);
                                            },
                                            child: PhotoView(
                                              imageProvider: NetworkImage(
                                                '${AppUrls.baseFileUrl}${state.productDetails[state.productImageIndex].mainImage}',
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                            onTap: (){
                                              Navigator.pop(dialogContext);
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(top:10.0),
                                              child: Icon(Icons.close,
                                                color: Colors.white,
                                              ),
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
                                state.productDetails.first.mainImage,
                                ...state.productDetails.first.images.map((image) =>
                                image.imageUrl ?? '')
                              ],
                            /*  productPerUnit: state.productDetails.first
                                  .numberOfUnit ,*/
                              productUnitPrice: double.parse(state.productDetails.first.supplierSales.first.productPrice.toString()??'0'),
                            /*  productName: state.productDetails.first
                                  .productName,
                              productSaleDescription: parse(state
                                  .productDetails
                                  .first
                                  .sale.saleDescription ??
                                  '')
                                  .body
                                  ?.text ??
                                  '',*/
                              productPrice: state.productDetails.first.sale.isSale?
                              double.parse(state.productDetails.first.sale.salePrice) *
                                  state.productStockList
                                  [state.productListIndex][
                                  state.productStockUpdateIndex]
                                      .quantity*
                                  (state.productDetails.first
                                      .numberOfUnit):state
                                  .productStockList[state.productListIndex][
                              state.productStockUpdateIndex]
                                  .totalPrice *
                                  state.productStockList
                                  [state.productListIndex][
                                  state.productStockUpdateIndex]
                                      .quantity*
                                  (state.productDetails.first
                                      .numberOfUnit) ,

                            /*  productWeight: state
                                  .productDetails.first.itemsWeight
                                  .toDouble(),*/
                              productStock: (state.productStockList[state.productListIndex][state.productStockUpdateIndex].stock.toString()),
                              isRTL: context.rtl,
                              // isSupplierAvailable:
                              // state.productSupplierList.isEmpty
                              //     ? false
                              //     : true,
                              scrollController: scrollController,
                              productQuantity:  state
                                  .productStockList[state.productListIndex][
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
                                if(state
                                    .productStockList[state.productListIndex][
                                state.productStockUpdateIndex]
                                    .quantity > 1){
                                  context.read<BasketBloc>().add(
                                      BasketEvent.decreaseQuantityOfProduct(
                                          context: context1));
                                }
                              },
                            ),
                            state.relatedProductList.isEmpty ? 0.height :
                            relatedProductWidget(context1,state.relatedProductList,context),
                          ],
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

  Widget relatedProductWidget(BuildContext prevContext, List<RelatedProductDatum> relatedProductList,BuildContext context,){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Align(
          alignment:
          context.rtl ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Text(
              AppLocalizations.of(context)!.related_products,
              style: AppStyles.rkRegularTextStyle(
                  size: AppConstants.mediumFont,
                  color: AppColors.blackColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Container(
          height: AppConstants.relatedProductItemHeight,
          padding: EdgeInsets.only(bottom:10,left: 10,right: 10),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context2,i){
              return CommonProductSaleItemWidget(
                isSale:  relatedProductList.elementAt(i).sale.isSale,
                isGuestUser: false,
                height: AppConstants.salesProductItemHeight,
                width: 140,
                productName: relatedProductList.elementAt(i).productName??'',
                saleImage: relatedProductList.elementAt(i)
                    .mainImage ??
                    '',
                title:  relatedProductList.elementAt(i)
                    .name ??
                    '',
                description: parse( relatedProductList.elementAt(i).sale
                    .saleDescription ??
                    '')
                    .body
                    ?.text ??
                    '',
                discountedPrice:
                double.parse( relatedProductList.elementAt(i).sale.salePrice),

                originalPrice: relatedProductList.elementAt(i)
                    .productPrice ??
                    0 ,
                productStock: relatedProductList.elementAt(i)
                    .productStock.toString()??'0',
                lowStock: relatedProductList.elementAt(i)
                    .lowStock??'',
                isPesach: relatedProductList.elementAt(i)
                    .isPesach,

                onButtonTap: () {
                  Navigator.pop(prevContext);
                  showProductDetails(
                      context: context,
                      cartProductId: relatedProductList[i].id,
                      isBarcode: false,
                      productStock: relatedProductList[i].productStock.toString(),
                      productListIndex: 1
                  );
                },);},itemCount: relatedProductList.length,),
        )
      ],
    );
  }
}