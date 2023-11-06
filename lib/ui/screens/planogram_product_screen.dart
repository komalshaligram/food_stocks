import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/bloc/planogram_product/planogram_product_bloc.dart';
import 'package:food_stock/data/model/res_model/planogram_res_model/planogram_res_model.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';

import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_img_path.dart';
import '../utils/themes/app_styles.dart';
import '../utils/themes/app_urls.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_product_details_widget.dart';
import '../widget/common_shimmer_widget.dart';
import '../widget/product_details_shimmer_widget.dart';

class PlanogramProductRoute {
  static Widget get route => const PlanogramProductScreen();
}

class PlanogramProductScreen extends StatelessWidget {
  const PlanogramProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
      create: (context) => PlanogramProductBloc()
        ..add(PlanogramProductEvent.getPlanogramProductsEvent(
            planogram:
                args?[AppStrings.planogramProductsParamString] ?? Datum())),
      child: PlanogramProductScreenWidget(),
    );
  }
}

class PlanogramProductScreenWidget extends StatelessWidget {
  const PlanogramProductScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlanogramProductBloc, PlanogramProductState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.pageColor,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(AppConstants.appBarHeight),
            child: CommonAppBar(
              title: state.planogramName,
              iconData: Icons.arrow_back_ios_sharp,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SafeArea(
              child: GridView.builder(
            itemCount: state.planogramProductList.length,
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: AppConstants.padding_5),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, childAspectRatio: 9 / 11),
            itemBuilder: (context, index) => buildPlanoGramProductItem(
                context: context,
                index: index,
                isRTL: isRTLContent(context: context)),
          )),
        );
      },
    );
  }

  Widget buildPlanoGramProductItem(
      {required BuildContext context,
      required int index,
      required bool isRTL}) {
    return BlocProvider.value(
      value: context.read<PlanogramProductBloc>(),
      child: BlocBuilder<PlanogramProductBloc, PlanogramProductState>(
        builder: (context1, state) {
          return InkWell(
            onTap: () {
              showProductDetails(
                  context: context,
                  productId: state.planogramProductList[index].id ?? '',
                  planoGramIndex: index);
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Container(
              // height: 170,
              // width: 140,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius:
                    BorderRadius.all(Radius.circular(AppConstants.radius_10)),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.shadowColor.withOpacity(0.15),
                      blurRadius: AppConstants.blur_10),
                ],
              ),
              clipBehavior: Clip.hardEdge,
              margin: EdgeInsets.symmetric(
                  vertical: AppConstants.padding_10,
                  horizontal: AppConstants.padding_5),
              padding: EdgeInsets.symmetric(
                  vertical: AppConstants.padding_5,
                  horizontal: AppConstants.padding_10),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Image.network(
                      "${AppUrls.baseFileUrl}${state.planogramProductList[index].mainImage}",
                      height: 70,
                      fit: BoxFit.fitHeight,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress?.cumulativeBytesLoaded !=
                            loadingProgress?.expectedTotalBytes) {
                          return CommonShimmerWidget(
                            child: Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(AppConstants.radius_10)),
                              ),
                            ),
                          );
                        }
                        return child;
                      },
                      errorBuilder: (context, error, stackTrace) {
                        // debugPrint('sale list image error : $error');
                        return Container(
                          child: Image.asset(AppImagePath.imageNotAvailable5,
                              height: 70,
                              width: double.maxFinite,
                              fit: BoxFit.cover),
                        );
                      },
                    ),
                  ),
                  5.height,
                  Text(
                    "${state.planogramProductList[index].productName}",
                    style: AppStyles.rkBoldTextStyle(
                        size: AppConstants.font_12,
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  5.height,
                  Expanded(
                    child: state.planogramProductList[index].totalSale == 0
                        ? 0.width
                        : Text(
                            "${state.planogramProductList[index].totalSale} ${AppLocalizations.of(context)!.discount}",
                            style: AppStyles.rkRegularTextStyle(
                                size: AppConstants.font_10,
                                color: AppColors.saleRedColor,
                                fontWeight: FontWeight.w600),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                  ),
                  5.height,
                  Center(
                    child: Container(
                      height: AppConstants.buttonHeightSmall,
                      width: double.maxFinite,
                      margin: EdgeInsets.symmetric(
                          horizontal: AppConstants.padding_10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: AppColors.mainColor,
                          borderRadius: BorderRadius.all(
                              Radius.circular(AppConstants.radius_3))),
                      padding: EdgeInsets.symmetric(
                          vertical: AppConstants.padding_5,
                          horizontal: AppConstants.padding_10),
                      child: Text(
                        "${state.planogramProductList[index].productPrice?.toStringAsFixed(0)}${AppLocalizations.of(context)!.currency}",
                        style: AppStyles.rkRegularTextStyle(
                            size: AppConstants.font_12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.whiteColor),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void showProductDetails(
      {required BuildContext context,
      required String productId,
      required int planoGramIndex}) async {
    context.read<PlanogramProductBloc>().add(
        PlanogramProductEvent.getProductDetailsEvent(
            context: context, productId: productId));
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
          value: context.read<PlanogramProductBloc>(),
          child: DraggableScrollableSheet(
            expand: true,
            maxChildSize: 1 -
                (MediaQuery.of(context).viewPadding.top /
                    getScreenHeight(context)),
            minChildSize: 0.4,
            initialChildSize: 0.7,
            shouldCloseOnMinExtent: true,
            builder:
                (BuildContext context1, ScrollController scrollController) {
              return BlocProvider.value(
                  value: context.read<PlanogramProductBloc>(),
                  child:
                      BlocBuilder<PlanogramProductBloc, PlanogramProductState>(
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
                              : CommonProductDetailsWidget(
                                  context: context,
                                  productImage:
                                      state.productDetails.product?.first.mainImage ??
                                          '',
                                  productName:
                                      state.productDetails.product?.first.productName ??
                                          '',
                                  productCompanyName:
                                      state.productDetails.product?.first.brandName ??
                                          '',
                                  productDescription: state.productDetails
                                          .product?.first.productDescription ??
                                      '',
                                  productSaleDescription: state.productDetails
                                          .product?.first.productDescription ??
                                      '',
                                  productPrice: state.productDetails.product
                                          ?.first.numberOfUnit
                                          ?.toDouble() ??
                                      0.0,
                                  productWeight: state.productDetails.product
                                          ?.first.itemsWeight
                                          ?.toDouble() ??
                                      0.0,
                                  productsStock: state.productStockList[state.productStockUpdateIndex].stock,
                                  isRTL: isRTLContent(context: context),
                                  scrollController: scrollController,
                                  productQuantity: state.productStockList[state.productStockUpdateIndex].quantity,
                                  onQuantityIncreaseTap: () {
                                    context.read<PlanogramProductBloc>().add(
                                        PlanogramProductEvent
                                            .increaseQuantityOfProduct(
                                                context: context1));
                                  },
                                  onQuantityDecreaseTap: () {
                                    context.read<PlanogramProductBloc>().add(
                                        PlanogramProductEvent
                                            .decreaseQuantityOfProduct(
                                                context: context1));
                                  },
                                  noteController: TextEditingController(text: state.productStockList[state.productStockUpdateIndex].note),
                                  onNoteChanged: (newNote) {
                                    context.read<PlanogramProductBloc>().add(
                                        PlanogramProductEvent
                                            .changeNoteOfProduct(
                                                newNote: newNote));
                                  },
                                  isLoading: state.isLoading,
                                  onAddToOrderPressed: state.isLoading
                                      ? null
                                      : () {
                                          context
                                              .read<PlanogramProductBloc>()
                                              .add(PlanogramProductEvent
                                                  .addProductToBasketEvent(
                                                      context: context1));
                                        }),
                        ),
                      );
                    },
                  ));
            },
          ),
        );
      },
    );
  }
}