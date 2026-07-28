import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:food_stock/ui/screens/product_details_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../bloc/basket/basket_bloc.dart';
import '../../../bloc/bottom_nav/bottom_nav_bloc.dart';
import '../../../data/model/res_model/get_order_by_id/get_order_by_id_model.dart';
import '../../../data/model/res_model/status_info_res_model/status_info_res_model.dart';
import '../../../data/storage/shared_preferences_helper.dart';
import '../../../repository/dio_client.dart';
import '../../utils/app_utils.dart';
import '../../utils/constants/app_colors.dart';
import '../../utils/constants/app_constants.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../../utils/constants/app_img_path.dart';
import '../../utils/constants/app_strings.dart';
import '../../utils/constants/app_styles.dart';
import '../../utils/constants/app_urls.dart';
import '../../widget/basket_screen_shimmer_widget.dart';
import '../../widget/sized_box_widget.dart';
import '../../widget/common_dialog_with_one_button.dart';
import '../../widget/custom_dialog.dart';
import 'basket_app_bar_widget.dart';
import 'basket_product_detail.dart';
import 'basket_total_widget.dart';

class BasketRoute {
  static Widget get route => const BasketScreen();
}

class BasketScreen extends StatelessWidget {
  const BasketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => BasketBloc(), child: const BasketScreenWidget());
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
                                }));
                      } catch (e) {
                        CustomSnackBar.showSnackBar(context: context, title: e.toString(), type: SnackBarType.failure);
                      }
                    },
                    positiveTitle: AppLocalizations.of(context)!.show_order,
                    width: 120,
                    paymentType: 'creditCard');
              }).then((value) {
            context.read<BasketBloc>().add(const BasketEvent.refreshEvent());
          });
        }
      },
      child: BlocBuilder<BasketBloc, BasketState>(builder: (context, state) {
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
                  child: Column(children: [
                    appBarWidget(context, state),
                    state.isShimmering
                        ? const BasketScreenShimmerWidget()
                        : state.basketProductList.isNotEmpty
                            ? Expanded(
                                child: AnimationLimiter(
                                  child: ListView.builder(
                                    physics: const ClampingScrollPhysics(),
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
                                        )),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : !state.isShimmering && state.basketProductList.isEmpty
                                ? Expanded(child: noDataWidget(AppLocalizations.of(context)!.cart_empty))
                                : const BasketScreenShimmerWidget(),
                    state.basketProductList.isEmpty ? const SizedBox() : totalAmountCard(state, context, bloc)
                  ]),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _productImageWidget(BasketState state, int index) {
    if (state.basketProductList[index].mainImage == '') {
      return Image.asset(AppImagePath.imageNotAvailable5, width: 100, height: 100, fit: BoxFit.fitWidth);
    } else {
      return Image.network('${AppUrlEndPoints.baseFileUrl}${state.basketProductList[index].mainImage ?? ''}',
          width: 100, height: 100, fit: BoxFit.contain, loadingBuilder: (
        context,
        child,
        loadingProgress,
      ) {
        if (loadingProgress == null) {
          return child;
        } else {
          return loaderWidget(AppConstants.containerHeight_100);
        }
      }, errorBuilder: (context, error, stackTrace) {
        return imageNotAvailableWidget(AppConstants.containerHeight_100);
      });
    }
  }

  Widget _productNameWidget(BasketState state, int index) => Text(
        state.basketProductList[index].productName ?? '',
        style: TextStyle(color: AppColors.blackColor, fontSize: AppConstants.smallFont, fontWeight: FontWeight.bold),
      );

  Widget _numberOfUnitWidget(BasketState state, int index, BuildContext context) {
    if (state.basketProductList[index].numberOfUnits != '0') {
      if (state.basketProductList[index].scaleType == 'מארזים') {
        return Text(
          '${state.basketProductList[index].numberOfUnits.toString()} ${AppLocalizations.of(context)!.unit_in_box}',
          style: AppStyles.rkBoldTextStyle(size: AppConstants.font_12, color: AppColors.blackColor, fontWeight: FontWeight.w400),
        );
      } else {
        return Text(
          '${AppLocalizations.of(context)!.approx}${' '}${state.basketProductList[index].numberOfUnits.toString()}${' '}${AppLocalizations.of(context)!.kgBox}',
          style: AppStyles.rkBoldTextStyle(size: AppConstants.font_12, color: AppColors.blackColor, fontWeight: FontWeight.w400),
        );
      }
    } else {
      return 0.width;
    }
  }

  Widget _supplierNameWidget(BasketState state, int index) =>
      Text(state.basketProductList[index].supplierName ?? '', style: TextStyle(color: AppColors.mainColor));

  Widget _outOfStockProductWidget(BasketState state, int index, double productStock, String lowStock, BuildContext context) {
    if (productStock == 0 || productStock == 0.0) {
      return Text(
        AppLocalizations.of(context)!.product_no_longer_in_stock,
        style: AppStyles.rkBoldTextStyle(size: AppConstants.font_12, color: AppColors.redColor, fontWeight: FontWeight.w400),
      );
    } else if ((lowStock.isNotEmpty) && double.parse(productStock.toString()) > 0) {
      return Text(lowStock, style: AppStyles.rkBoldTextStyle(size: AppConstants.font_12, color: AppColors.orangeColor, fontWeight: FontWeight.w400));
    } else {
      return 0.width;
    }
  }

  Widget _isSaleWidget(BasketState state, int index, BuildContext context) {
    if (state.basketProductList[index].isSale) {
      return Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(top: AppConstants.padding_3, bottom: AppConstants.padding_5),
        padding: const EdgeInsets.all(AppConstants.padding_5),
        decoration: BoxDecoration(color: AppColors.saleBGColor, borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_7))),
        child: Center(
          child: Text(state.basketProductList[index].saleDesc, style: TextStyle(color: AppColors.whiteColor, fontSize: AppConstants.font_12)),
        ),
      );
    } else {
      return 0.width;
    }
  }

  Widget _totalAmountWidget(BasketState state, int index) => Text(
        formatNumber(value: state.basketProductList[index].totalPayment?.toStringAsFixed(2) ?? "0", local: AppStrings.hebrewLocal),
        style: TextStyle(color: AppColors.blackColor, fontSize: AppConstants.smallFont, fontWeight: FontWeight.w700),
      );

  Widget _increaseTapWidget(BasketState state, int index, BuildContext context, BasketBloc bloc) => GestureDetector(
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
              CustomSnackBar.showSnackBar(context: context, title: AppLocalizations.of(context)!.out_of_stock, type: SnackBarType.failure);
            }
          } else if (state.cartItemList.data?.data?[index].sale?.saleMaxQuantity == state.basketProductList[index].totalQuantity!) {
            CustomSnackBar.showSnackBar(context: context, title: AppLocalizations.of(context)!.not_add_more_than_max_qty, type: SnackBarType.failure);
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
        child: Icon(Icons.add, size: AppConstants.font_20, color: AppColors.blackColor),
      ));

  Widget _quantityWidget(BasketState state, int index) => Text(
        '${state.basketProductList[index].totalQuantity}${' '}${state.basketProductList[index].scales}',
        style: TextStyle(color: AppColors.blackColor, fontSize: AppConstants.smallFont),
      );

  Widget _decreaseTapWidget(BasketState state, int index, BuildContext context, BasketBloc bloc) => GestureDetector(
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
        child: Icon(Icons.remove, size: AppConstants.font_20, color: AppColors.blackColor),
      ));

  Widget _deleteTapWidget(BasketState state, int index, BuildContext context) => GestureDetector(
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
      );

  Widget basketListItem(
      {required int index,
      required BuildContext context,
      required String lowStock,
      required double productStock,
      required bool isPesach,
      required bool isSaleOn}) {
    return BlocBuilder<BasketBloc, BasketState>(builder: (context, state) {
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
              child:
                  SvgPicture.asset(AppImagePath.delete, colorFilter: ColorFilter.mode(AppColors.whiteColor, BlendMode.srcIn), height: 30, width: 30),
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
                    child: BlocBuilder<BasketBloc, BasketState>(builder: (context, state) {
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
                            }),
                      );
                    }),
                  );
                });
          }
          return null;
        },
        child: Stack(children: [
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
              child: Column(children: [
                state.basketProductList[index].isProcess == true
                    ? LinearProgressIndicator(
                        color: AppColors.mainColor,
                        minHeight: 3,
                        backgroundColor: AppColors.mainColor.withValues(alpha: 0.5),
                      )
                    : 3.height,
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_10, horizontal: AppConstants.padding_10),
                  child: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    _productImageWidget(state, index),
                    20.width,
                    Expanded(
                      flex: 3,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        _productNameWidget(state, index),
                        _numberOfUnitWidget(state, index, context),
                        _supplierNameWidget(state, index),
                        _outOfStockProductWidget(state, index, productStock, lowStock, context),
                        lowStock.isNotEmpty ? 5.height : 0.height,
                        _isSaleWidget(state, index, context),
                        isPesachLabelShow(isPesach, context),
                        isPesach ? 5.height : 0.height,
                        _totalAmountWidget(state, index),
                        10.height,
                        Row(children: [
                          _increaseTapWidget(state, index, context, bloc),
                          10.width,
                          _quantityWidget(state, index),
                          10.width,
                          _decreaseTapWidget(state, index, context, bloc),
                          const Spacer(),
                          _deleteTapWidget(state, index, context),
                        ]),
                      ]),
                    ),
                  ]),
                ),
              ]),
            ),
          ),
          if ((state.cartItemList.data?.data?[index].productStock ?? 0) == 0)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: AppConstants.padding_5, horizontal: AppConstants.padding_10),
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                      color: AppColors.redColor.withValues(alpha: 0.2), borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_5))),
                ),
              ),
            ),
        ]),
      );
    });
  }

  appUnderMaintenanceDialog({required BuildContext context, required BasketState state}) {
    if (!state.isDialogOpen) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context1) => BlocProvider.value(
                value: context.read<BasketBloc>(),
                child: BlocBuilder<BasketBloc, BasketState>(builder: (context, state) {
                  BasketBloc bloc = context.read<BasketBloc>();
                  return CustomOneButtonDialog(
                      width: MediaQuery.of(context).size.width,
                      isLoading: state.retryLoading,
                      directionality: state.language,
                      title: AppLocalizations.of(context)!.under_maintenance,
                      positiveTitle: AppLocalizations.of(context)!.retry,
                      positiveOnTap: () async {
                        bloc.add(BasketEvent.generalSettings(context: context, dialogContext: context1, isRetryLoading: true));
                      });
                }),
              ));
    } else {
      context.read<BasketBloc>().add(BasketEvent.updateMaintenanceEvent(context: context));
    }
  }
}
