import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:food_stock/ui/screens/product_details_screen.dart';
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
import '../widget/common_divider_widget.dart';
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
                    SharedPreferencesHelper preferences = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

                    try {
                      final res = await DioClient(context).get(path: '${AppUrlEndPoints.getLatestOnthewayOrderUrl}${preferences.getUserId()}');

                      GetOrderByIdModel response = GetOrderByIdModel.fromJson(res);

                      final String statusData = preferences.getOrderStatusInfo();
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
                              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                              return SlideTransition(position: animation.drive(tween), child: child);
                            },
                          ));
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
                  padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_5),
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
                                      color: AppColors.whiteColor.withValues(alpha: 0.95),
                                      boxShadow: [BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.20), blurRadius: AppConstants.blur_10)],
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
                                              SvgPicture.asset(AppImagePath.delete, colorFilter: ColorFilter.mode(AppColors.redColor, BlendMode.srcIn)),
                                              5.width,
                                              Text(
                                                AppLocalizations.of(context)!.empty,
                                                style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: AppColors.redColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          AppLocalizations.of(context)!.my_basket,
                                          textAlign: TextAlign.center,
                                          style: AppStyles.rkRegularTextStyle(
                                            size: AppConstants.mediumFont,
                                            color: AppColors.greyColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            SvgPicture.asset(AppImagePath.delete, colorFilter: ColorFilter.mode(AppColors.whiteColor, BlendMode.srcIn)),
                                            5.width,
                                            Text(AppLocalizations.of(context)!.empty, style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: AppColors.whiteColor)),
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
                                              style: AppStyles.pVRegularTextStyle(
                                                size: AppConstants.normalFont,
                                                color: AppColors.blackColor,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            )),
                                          )
                                        : const BasketScreenShimmerWidget(),
                            state.basketProductList.isEmpty ? const SizedBox() : totalAmountCard(state, context, bloc)
                          ],
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

  Widget totalAmountCard(
    BasketState state,
    BuildContext context,
    BasketBloc bloc,
  ) {
    return Container(
        alignment: state.language == AppStrings.englishString ? Alignment.centerLeft : Alignment.centerRight,
        padding: const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 10),
        margin: const EdgeInsets.symmetric(vertical: AppConstants.padding_5, horizontal: AppConstants.padding_10),
        decoration: BoxDecoration(color: AppColors.whiteColor, borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_5))),
        child: Column(
          children: [
            const DividerWidget(height: 10.0),
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
                      ).toStringAsFixed(2),
                      local: AppStrings.hebrewLocal,
                    )),
                    isTitle: true),
            const DividerWidget(height: 10.0),
            5.height,
            state.isSubUserCanCreateOrder
                ? CustomButtonWidget(
                    buttonText: AppLocalizations.of(context)!.continues,
                    bGColor: AppColors.mainColor,
                    height: 45,
                    onPressed: () async {
                      List<double> basketProductStockList = [];
                      for (var element in state.basketProductList) {
                        basketProductStockList.add(element.productStock ?? 0);
                      }
                      basketProductStockList.sort();
                      if (basketProductStockList.first == 0.0 || basketProductStockList.first == 0) {
                        removeOutOfStockProductDialog(context: context);
                      } else {
                        if (!state.isRemoveProcess && !state.isLoading && !state.isShimmering) {
                          if (state.draftReturnExists) {
                            await showDialog(context: context, builder: (_) => CallAgentDialog(language: state.language, state: state, context1: context, bloc: bloc));
                          } else {
                            if (state.supplierCount == 1) {
                              Navigator.pushNamed(context, RouteDefine.basketSummaryScreen.name, arguments: {
                                AppStrings.getCartListString: state.cartItemList,
                                AppStrings.isSupplierSingle: 'Yes',
                              });
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
                                        ).toStringAsFixed(2),
                                        local: AppStrings.hebrewLocal,
                                      )),
                              });
                            }
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

  Widget basketRow(String title, String amount, {bool isTitle = false, double fontSize = 20}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppStyles.rkRegularTextStyle(size: AppConstants.font_20, color: AppColors.blackColor, fontWeight: FontWeight.w700),
        ),
        Text(
          amount,
          style: AppStyles.rkRegularTextStyle(size: fontSize, color: AppColors.blackColor, fontWeight: isTitle ? FontWeight.w700 : FontWeight.w300),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget basketListItem({
    required int index,
    required BuildContext context,
    required String lowStock,
    required double productStock,
    required bool isPesach,
    required bool isSaleOn,
  }) {
    return BlocBuilder<BasketBloc, BasketState>(
      builder: (context, state) {
        BasketBloc bloc = context.read<BasketBloc>();
        return Dismissible(
          key: Key(state.basketProductList.toString()),
          direction: DismissDirection.startToEnd,
          background: Container(
            alignment: state.language == AppStrings.englishString ? Alignment.centerLeft : Alignment.centerRight,
            margin: const EdgeInsets.symmetric(vertical: AppConstants.padding_5, horizontal: AppConstants.padding_10),
            decoration: BoxDecoration(color: AppColors.redColor, borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_5))),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.padding_11),
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
                                bloc.add(BasketEvent.removeCartProductEvent(
                                  isFromDelete: false,
                                  context: context,
                                  cartProductId: state.basketProductList[index].cartProductId,
                                  listIndex: index,
                                  dialogContext: context,
                                  totalAmount: state.basketProductList[index].totalPayment!,
                                ));
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
                  boxShadow: [BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.15), blurRadius: AppConstants.blur_10)],
                  borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_5)),
                ),
                child: GestureDetector(
                  onTap: () {
                    showProductDetails(
                      isSaleOn: state.isSaleOn,
                      context: context,
                      cartProductId: state.cartItemList.data?.data?[index].id ?? '',
                      productListIndex: 0,
                      productStock: state.cartItemList.data?.data?[index].productStock.toString() ?? '0',
                      clubAgentId: state.clubAgentId!,
                    );
                  },
                  child: Column(
                    children: [
                      state.basketProductList[index].isProcess == true
                          ? LinearProgressIndicator(
                              color: AppColors.mainColor,
                              minHeight: 3,
                              backgroundColor: AppColors.mainColor.withValues(alpha: 0.5),
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
                                            child: CupertinoActivityIndicator(color: AppColors.blackColor),
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
                                        child: Image.asset(AppImagePath.imageNotAvailable5),
                                      );
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
                                  Text(state.basketProductList[index].supplierName ?? '', style: TextStyle(color: AppColors.mainColor)),
                                  productStock == 0 || productStock == 0.0
                                      ? Text(
                                          AppLocalizations.of(context)!.product_no_longer_in_stock,
                                          style: AppStyles.rkBoldTextStyle(
                                            size: AppConstants.font_12,
                                            color: AppColors.redColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        )
                                      : (lowStock.isNotEmpty) && double.parse(productStock.toString()) > 0
                                          ? Text(lowStock,
                                              style: AppStyles.rkBoldTextStyle(
                                                size: AppConstants.font_12,
                                                color: AppColors.orangeColor,
                                                fontWeight: FontWeight.w400,
                                              ))
                                          : 0.width,
                                  lowStock.isNotEmpty ? 5.height : 0.height,
                                  state.basketProductList[index].isSale
                                      ? Container(
                                          width: MediaQuery.of(context).size.width,
                                          margin: const EdgeInsets.only(top: AppConstants.padding_3, bottom: AppConstants.padding_5),
                                          padding: const EdgeInsets.all(AppConstants.padding_5),
                                          decoration: BoxDecoration(
                                            color: AppColors.saleBGColor,
                                            borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_7)),
                                          ),
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
                                    formatNumber(
                                      value: state.basketProductList[index].totalPayment?.toStringAsFixed(2) ?? "0",
                                      local: AppStrings.hebrewLocal,
                                    ),
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
                                                bloc.add(BasketEvent.productUpdateEvent(
                                                  listIndex: index,
                                                  productWeight: state.basketProductList[index].totalQuantity! + 1,
                                                  context: context,
                                                  productId: state.cartItemList.data?.data?[index].productDetails?.id ?? '',
                                                  supplierId: state.cartItemList.data?.data?[index].suppliers?.first.id ?? '',
                                                  cartProductId: state.cartItemList.data?.data?[index].cartProductId ?? '',
                                                  totalPayment: state.totalPayment,
                                                  saleId: state.cartItemList.data?.data?[index].id ?? '',
                                                ));
                                              } else {
                                                CustomSnackBar.showSnackBar(
                                                  context: context,
                                                  title: AppLocalizations.of(context)!.out_of_stock,
                                                  type: SnackBarType.failure,
                                                );
                                              }
                                            } else if (state.cartItemList.data?.data?[index].sale?.saleMaxQuantity == state.basketProductList[index].totalQuantity!) {
                                              CustomSnackBar.showSnackBar(
                                                context: context,
                                                title: AppLocalizations.of(context)!.not_add_more_than_max_qty,
                                                type: SnackBarType.failure,
                                              );
                                            } else {
                                              bloc.add(BasketEvent.productUpdateEvent(
                                                listIndex: index,
                                                productWeight: state.basketProductList[index].totalQuantity! + 1,
                                                context: context,
                                                productId: state.cartItemList.data?.data?[index].productDetails?.id ?? '',
                                                supplierId: state.cartItemList.data?.data?[index].suppliers?.first.id ?? '',
                                                cartProductId: state.cartItemList.data?.data?[index].cartProductId ?? '',
                                                totalPayment: state.totalPayment,
                                                saleId: state.cartItemList.data?.data?[index].id ?? '',
                                              ));
                                            }
                                          }
                                        },
                                        child: Container(
                                          width: AppConstants.containerSize_35,
                                          height: AppConstants.containerSize_35,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(AppConstants.radius_4),
                                            border: Border.all(color: AppColors.navSelectedColor),
                                            color: AppColors.pageColor,
                                          ),
                                          child: Icon(
                                            Icons.add,
                                            size: AppConstants.font_20,
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
                                              bloc.add(BasketEvent.productUpdateEvent(
                                                listIndex: index,
                                                productWeight: state.basketProductList[index].totalQuantity! - 1,
                                                context: context,
                                                productId: state.cartItemList.data?.data?[index].productDetails?.id ?? '',
                                                supplierId: state.cartItemList.data?.data?[index].suppliers?.first.id ?? '',
                                                cartProductId: state.cartItemList.data?.data?[index].cartProductId ?? '',
                                                totalPayment: state.totalPayment,
                                                saleId: state.cartItemList.data?.data?[index].id ?? '',
                                              ));
                                            } else {
                                              deleteDialog(
                                                context: context,
                                                updateClearString: '',
                                                cartProductId: state.cartItemList.data?.data?[index].cartProductId ?? '',
                                                listIndex: index,
                                                totalAmount: state.totalPayment,
                                              );
                                            }
                                          }
                                        },
                                        child: Container(
                                          width: AppConstants.containerSize_35,
                                          height: AppConstants.containerSize_35,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(AppConstants.radius_4),
                                            border: Border.all(color: AppColors.navSelectedColor),
                                            color: AppColors.pageColor,
                                          ),
                                          child: Icon(
                                            Icons.remove,
                                            size: AppConstants.font_20,
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
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(AppConstants.radius_4),
                                            border: Border.all(color: AppColors.redColor),
                                            color: AppColors.pageColor,
                                          ),
                                          child: SvgPicture.asset(AppImagePath.delete, colorFilter: ColorFilter.mode(AppColors.redColor, BlendMode.srcIn)),
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
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(color: AppColors.redColor.withValues(alpha: 0.2), borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_5))),
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
                            Navigator.pop(context1);
                            if (state.draftReturnExists) {
                              await showDialog(context: context, builder: (_) => CallAgentDialog(language: state.language, state: state, context1: context, bloc: bloc));
                            } else {
                              if (state.supplierCount == 1) {
                                Navigator.pushNamed(context, RouteDefine.basketSummaryScreen.name, arguments: {
                                  AppStrings.getCartListString: state.cartItemList,
                                  AppStrings.isSupplierSingle: 'Yes',
                                });
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
                                          ).toStringAsFixed(2),
                                          local: AppStrings.hebrewLocal,
                                        )),
                                });
                              }
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
                          updateClearString == AppStrings.clearString
                              ? bloc.add(BasketEvent.clearCartEvent(context: context1))
                              : bloc.add(BasketEvent.removeCartProductEvent(
                                  isFromDelete: false,
                                  context: context,
                                  cartProductId: cartProductId,
                                  listIndex: listIndex,
                                  dialogContext: context1,
                                  totalAmount: totalAmount!,
                                ));
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
    String? clubAgentId,
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
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppConstants.radius_10))),
      isDismissible: false,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      enableDrag: false,
      builder: (modalContext) {
        return BlocProvider.value(
          value: context.read<BasketBloc>(),
          child: SafeArea(
            bottom: false,
            child: DraggableScrollableSheet(
              shouldCloseOnMinExtent: false,
              expand: true,
              maxChildSize: 1 - (MediaQuery.of(context).viewPadding.top / getScreenHeight(context)),
              minChildSize: 1 - (MediaQuery.of(context).viewPadding.top / getScreenHeight(context)),
              initialChildSize: 1 - (MediaQuery.of(context).viewPadding.top / getScreenHeight(context)),
              builder: (BuildContext sheetContext, ScrollController scrollController) {
                return BlocBuilder<BasketBloc, BasketState>(
                  builder: (blocContext, state) {
                    return AbsorbPointer(
                      absorbing: state.isLoading ? true : false,
                      child: Container(
                        height: getScreenHeight(sheetContext),
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
                                    controller: ModalScrollController.of(sheetContext),
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
                                            context.read<BasketBloc>().add(BasketEvent.addToCartProductEvent(context: sheetContext, productId: cartProductId));
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
                                                          imageProvider: NetworkImage('${AppUrlEndPoints.baseFileUrl}${state.productDetails[state.productImageIndex].mainImage}'),
                                                        ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          Navigator.pop(dialogContext);
                                                        },
                                                        child: const Padding(
                                                          padding: EdgeInsets.only(top: AppConstants.padding_10),
                                                          child: Icon(Icons.close, color: Colors.white),
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
                                          recommendedRetailConsumerPricerOffer: clubAgentId == AppStrings.clubAgentIdText
                                              ? state.productDetails.first.sale?.isSale == true
                                                  ? state.productDetails.first.recommendedConsumerOffer
                                                  : state.productDetails.first.recommendedRetailPrice
                                              : '',
                                          onQuantityChanged: (quantity) {
                                            context.read<BasketBloc>().add(BasketEvent.updateQuantityOfProduct(context: sheetContext, quantity: quantity));
                                          },
                                          onQuantityIncreaseTap: () {
                                            context.read<BasketBloc>().add(BasketEvent.increaseQuantityOfProduct(context: sheetContext));
                                          },
                                          onQuantityDecreaseTap: () {
                                            if (state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity > 1) {
                                              context.read<BasketBloc>().add(BasketEvent.decreaseQuantityOfProduct(context: sheetContext));
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
                                                : relatedProductWidget(context, state, sheetContext, isSaleOn),
                                      ],
                                    ),
                                  ),
                      ),
                    );
                  },
                );
              },
            ),
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
              padding: const EdgeInsets.only(left: AppConstants.padding_8, right: AppConstants.padding_8),
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
            padding: const EdgeInsets.only(bottom: AppConstants.padding_10, left: AppConstants.padding_10, right: AppConstants.padding_10),
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
                  quantity: state.productStockList[1].firstWhere((test) => test.productId == state.relatedProductList.elementAt(i).id).quantity,
                  isMixedSale: state.relatedProductList.elementAt(i).sale?.isMixedSale,
                  // recommendedRetailConsumerPricerOffer: state.clubAgentId ==
                  //     AppStrings.clubAgentIdText  ? state.relatedProductList.elementAt(i).sale?.isSale == true
                  //     ?
                  // state.relatedProductList.elementAt(i).recommendedConsumerOffer :
                  // state.relatedProductList.elementAt(i).recommendedRetailPrice : '',
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
                      clubAgentId: state.clubAgentId!,
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
        contentPadding: const EdgeInsets.all(AppConstants.padding_20),
        surfaceTintColor: AppColors.whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radius_20)),
        content: Text(
          AppLocalizations.of(context)!.return_draft_not_sent,
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
                  Navigator.pushNamed(context, RouteDefine.returnListScreen.name, arguments: {AppStrings.isbackString: 'Basket'});
                },
                child: Container(
                  padding: const EdgeInsets.all(AppConstants.padding_8),
                  decoration: BoxDecoration(gradient: AppColors.appMainGradientColor, borderRadius: BorderRadius.circular(AppConstants.radius_5)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.view_return,
                        style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.whiteColor),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  Navigator.of(context).pop();
                  if (state.supplierCount == 1) {
                    Navigator.pushNamed(context, RouteDefine.basketSummaryScreen.name, arguments: {
                      AppStrings.getCartListString: state.cartItemList,
                      AppStrings.isSupplierSingle: 'Yes',
                    });
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
                              ).toStringAsFixed(2),
                              local: AppStrings.hebrewLocal,
                            )),
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(AppConstants.padding_8),
                  decoration: BoxDecoration(gradient: AppColors.appMainGradientColor, borderRadius: BorderRadius.circular(AppConstants.radius_5)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.send_any_way,
                        style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.whiteColor),
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
