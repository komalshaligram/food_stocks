import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:food_stock/ui/widget/related_product_title.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:photo_view/photo_view.dart';
import '../../bloc/supplier_List_products/supplier_list_products_bloc.dart';
import '../../data/model/product_stock_model/product_stock_model.dart';
import '../../data/model/res_model/related_product_res_model/related_product_res_model.dart';
import '../../data/model/search_model/search_model.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_colors.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/utils/constants/app_urls.dart';
import '../../ui/widget/common_product_sale_item_widget.dart';
import '../../ui/widget/common_shimmer_widget.dart';
import '../../ui/widget/sized_box_widget.dart';
import '../../data/model/res_model/supplier_list_products_response_model/supplier_list_products_response_model.dart';
import '../../ui/widget/supplier_products_screen_shimmer_widget.dart';
import 'package:html/parser.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../routes/app_routes.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_img_path.dart';
import '../utils/constants/app_styles.dart';
import '../widget/bottomsheet_related_product_shimmer_widget.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_product_button_widget.dart';
import '../widget/common_product_details_widget.dart';
import '../widget/common_sale_listview.dart';
import '../widget/common_search_widget.dart';
import '../widget/confetti.dart';
import '../widget/no_data_bottom_sheet_widget.dart';
import '../widget/product_details_shimmer_widget.dart';
import '../widget/refresh_widget.dart';
import '../widget/sale_promotion_sheet.dart';
import '../widget/search_item_widget.dart';
import '../widget/store_category_screen_subcategory_shimmer_widget.dart';
import '../widget/build_list_title.dart';
import '../widget/supplier_products_info_bar.dart';

class SupplierListProductsRoute {
  static Widget get route => const SupplierListProductsScreen();
}

class SupplierListProductsScreen extends StatelessWidget {
  const SupplierListProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args =
    ModalRoute.of(context)?.settings.arguments as Map?;
    final String? supplierName = args?[AppStrings.supplierNameString];
    final int? minimumOrder = args?[AppStrings.minimumOrderText];
    final String? supplierId = args?[AppStrings.supplierIdString];
    return BlocProvider(
      create: (context) => SupplierListProductsBloc()
        ..add(const SupplierListProductsEvent.getPreferencesDataEvent())
        ..add(SupplierListProductsEvent.getSupplierProductsIdEvent(
            supplierId: args?[AppStrings.supplierIdString] ?? '',
            search: args?[AppStrings.searchString] ?? ''))
        ..add(SupplierListProductsEvent.getSupplierDeliveryScheduleEvent(
            context: context))
        ..add(SupplierListProductsEvent.getSupplierProductsListEvent(
          context: context,
          searchType: args?[AppStrings.searchType] ?? '',
        ))
        ..add(SupplierListProductsEvent.userApproveEvent(context: context)),
      child: SupplierListProductsScreenWidget(
          supplierName: supplierName,
          minimumOrder: minimumOrder,
          supplierId: supplierId),
    );
  }
}

class SupplierListProductsScreenWidget extends StatelessWidget {
  const SupplierListProductsScreenWidget(
      {super.key,
        required this.supplierName,
        required this.minimumOrder,
        required this.supplierId});
  final String? supplierName;
  final int? minimumOrder;
  final String? supplierId;

  @override
  Widget build(BuildContext context) {
    SupplierListProductsBloc bloc = context.read<SupplierListProductsBloc>();
    return BlocListener<SupplierListProductsBloc, SupplierListProductsState>(
      listener: (context, state) {},
      child: BlocBuilder<SupplierListProductsBloc, SupplierListProductsState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: AppColors.pageColor,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
                child: CommonAppBar(
                  bgColor: AppColors.pageColor,
                  title: supplierName!,
                  iconData: Icons.arrow_back_ios_sharp,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  trailingWidget: Row(mainAxisSize: MainAxisSize.min, children: [
                    GestureDetector(
                        onTap: () => showSortOptionsBottomSheet(context, state),
                        child: Icon(Icons.tune,
                            color: state.sortOption == ProductSortOption.none
                                ? null
                                : AppColors.mainColor)),
                    AppConstants.padding_20.width,
                    GestureDetector(
                        onTap: () {
                          context.read<SupplierListProductsBloc>().add(
                              const SupplierListProductsEvent.getGridListView());
                        },
                        child:
                        Icon(state.isGridView ? Icons.list : Icons.grid_view)),
                  ]),
                ),
              ),
              body: FocusDetector(
                onFocusGained: () {
                  bloc.add(
                      const SupplierListProductsEvent.getPreferencesDataEvent());
                  bloc.add(SupplierListProductsEvent.getPermissionList(
                      context: context));
                },
                child: SafeArea(
                  child: NotificationListener<ScrollNotification>(
                      child: Stack(children: [
                        Column(children: [
                          76.height,
                          Expanded(
                            child: SmartRefresher(
                              physics:
                              (!state.isShimmering && state.productList.isEmpty)
                                  ? const NeverScrollableScrollPhysics()
                                  : const ClampingScrollPhysics(),
                              enablePullDown: true,
                              controller: state.refreshController,
                              header: const RefreshWidget(),
                              footer: CustomFooter(
                                builder: (context, mode) => state.isGridView
                                    ? const SupplierProductsScreenShimmerWidget()
                                    : const StoreCategoryScreenSubcategoryShimmerWidget(),
                              ),
                              enablePullUp: !state.isBottomOfProducts &&
                                  state.productList.isNotEmpty,
                              onRefresh: () {
                                context.read<SupplierListProductsBloc>().add(
                                    SupplierListProductsEvent.refreshListEvent(
                                        context: context));
                                context.read<SupplierListProductsBloc>().add(
                                    const SupplierListProductsEvent
                                        .getPreferencesDataEvent());
                                context.read<SupplierListProductsBloc>().add(
                                    SupplierListProductsEvent
                                        .getSupplierDeliveryScheduleEvent(
                                        context: context));
                              },
                              child: !state.isShimmering &&
                                  state.productList.isEmpty
                                  ? Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SupplierProductsInfoBar(
                                    minimumOrder: minimumOrder,
                                    deliveryCityName:
                                    state.deliveryScheduleCityName,
                                    deliveryDays: state.deliveryScheduleDays,
                                    isDeliveryScheduleLoading:
                                    state.isDeliveryScheduleLoading,
                                  ),
                                  brandDataWidget(context, state),
                                  categoryDataWidget(context, state),
                                  Expanded(
                                      child: Center(
                                          child: noDataWidget(
                                              AppLocalizations.of(context)!
                                                  .no_data))),
                                ],
                              )
                                  : SingleChildScrollView(
                                child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      SupplierProductsInfoBar(
                                        minimumOrder: minimumOrder,
                                        deliveryCityName:
                                        state.deliveryScheduleCityName,
                                        deliveryDays:
                                        state.deliveryScheduleDays,
                                        isDeliveryScheduleLoading:
                                        state.isDeliveryScheduleLoading,
                                      ),
                                      brandDataWidget(context, state),
                                      categoryDataWidget(context, state),
                                      state.isShimmering
                                          ? state.isGridView
                                          ? const SupplierProductsScreenShimmerWidget()
                                          : const StoreCategoryScreenSubcategoryShimmerWidget()
                                          : state.isGridView
                                          ? gridViewWidget(context, state)
                                          : listViewWidget(context, state)
                                    ]),
                              ),
                            ),
                          ),
                        ]),
                        searchWidget(context, bloc, state),
                      ]),
                      onNotification: (notification) {
                        if (notification.metrics.axis != Axis.vertical) {
                          return false;
                        }
                        if (state.productList.isEmpty ||
                            state.isShimmering ||
                            state.isProgress) {
                          return false;
                        }
                        if (notification.metrics.pixels >
                            (notification.metrics.maxScrollExtent - 400)) {
                          if (!state.isBottomOfProducts) {
                            context.read<SupplierListProductsBloc>().add(
                                SupplierListProductsEvent
                                    .getSupplierProductsListEvent(
                                    context: context,
                                    searchType: state.searchType));
                          } else {
                            return false;
                          }
                        }
                        return true;
                      }),
                ),
              ),
              floatingActionButton: !state.isGuestUser
                  ? floatingButtonWidget(context, state)
                  : 0.width,
            );
          }),
    );
  }

  Widget brandDataWidget(
      BuildContext context, SupplierListProductsState state) =>
      AnimatedCrossFade(
          firstChild: getScreenWidth(context).width,
          secondChild: Column(children: [
            buildListTitles(
                context: context,
                title: AppLocalizations.of(context)!.brands,
                subTitle: AppLocalizations.of(context)!.all_brands,
                onTap: () {
                  Navigator.pushNamed(
                      context, RouteDefine.supplierBrandScreen.name,
                      arguments: {
                        AppStrings.supplierIdString: supplierId ?? '',
                        AppStrings.brandListText: state.brandList,
                        AppStrings.supplierNameString: supplierName,
                      });
                }),
            SizedBox(
              width: getScreenWidth(context),
              height: 78,
              child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  // +1 for the leading "All" tile.
                  itemCount: state.brandList.length + 1,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.padding_5),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return buildSupplierListDataItem(
                          label: AppLocalizations.of(context)!.all,
                          isSelected: (state.selectedBrandId ?? '').isEmpty,
                          onTap: () => _onBrandTap(context, ''));
                    }
                    final brand = state.brandList[index - 1];
                    return buildSupplierListDataItem(
                        supplierLogo: brand.brandLogo ?? '',
                        isSelected: state.selectedBrandId == brand.id,
                        onTap: () => _onBrandTap(context, brand.id ?? ''));
                  }),
            ),
          ]),
          crossFadeState: state.brandList.isEmpty
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 300));

  Widget categoryDataWidget(
      BuildContext context, SupplierListProductsState state) =>
      AnimatedCrossFade(
          firstChild: getScreenWidth(context).width,
          secondChild: Column(children: [
            buildListTitles(
                context: context,
                title: AppLocalizations.of(context)!.categories,
                subTitle: AppLocalizations.of(context)!.all_categories,
                onTap: () {
                  Navigator.pushNamed(
                      context, RouteDefine.supplierCategoryScreen.name,
                      arguments: {
                        AppStrings.supplierIdString: supplierId ?? '',
                        AppStrings.categoryListText: state.supplierCategoryList,
                        AppStrings.supplierNameString: supplierName,
                      });
                }),
            SizedBox(
              width: getScreenWidth(context),
              height: 44,
              child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  // +1 for the leading "All" chip.
                  itemCount: state.supplierCategoryList.length + 1,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.padding_5),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return buildFilterChip(
                        context: context,
                        name: AppLocalizations.of(context)!.all,
                        isSelected: state.selectedCategoryId.isEmpty,
                        onTap: () => _onCategoryTap(context, ''),
                      );
                    }
                    final category = state.supplierCategoryList[index - 1];
                    return buildFilterChip(
                      context: context,
                      name: category.categoryName ?? '',
                      isSelected:
                      state.selectedCategoryId == (category.id ?? ''),
                      onTap: () => _onCategoryTap(context, category.id ?? ''),
                    );
                  }),
            ),
            // Sub-categories of the selected category (only those with products),
            // with a leading "All". Hidden until a category is chosen.
            if (state.selectedCategoryId.isNotEmpty &&
                state.subCategoryList.isNotEmpty)
              subCategoryRowWidget(context, state),
          ]),
          crossFadeState: state.supplierCategoryList.isEmpty
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 300));

  void _onCategoryTap(BuildContext context, String categoryId) {
    context.read<SupplierListProductsBloc>().add(
        SupplierListProductsEvent.selectCategoryEvent(
            context: context, categoryId: categoryId));
  }

  Widget subCategoryRowWidget(
      BuildContext context, SupplierListProductsState state) {
    return SizedBox(
      width: getScreenWidth(context),
      height: 44,
      child: ListView.builder(
        physics: const ClampingScrollPhysics(),
        itemCount: state.subCategoryList.length + 1,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_5),
        itemBuilder: (context, index) {
          if (index == 0) {
            return buildFilterChip(
              context: context,
              name: AppLocalizations.of(context)!.all,
              isSelected: state.selectedSubCategoryId.isEmpty,
              onTap: () => _onSubCategoryTap(context, ''),
            );
          }
          final subCategory = state.subCategoryList[index - 1];
          return buildFilterChip(
            context: context,
            name: subCategory.subCategoryName ?? '',
            isSelected: state.selectedSubCategoryId == (subCategory.id ?? ''),
            onTap: () => _onSubCategoryTap(context, subCategory.id ?? ''),
          );
        },
      ),
    );
  }

  void _onSubCategoryTap(BuildContext context, String subCategoryId) {
    context.read<SupplierListProductsBloc>().add(
        SupplierListProductsEvent.selectSubCategoryEvent(
            context: context, subCategoryId: subCategoryId));
  }

  // Shared pill used by both the category and sub-category rows: gradient fill
  // when selected, white with a mainColor border otherwise.
  Widget buildFilterChip({
    required BuildContext context,
    required String name,
    required bool isSelected,
    required void Function() onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(
          vertical: AppConstants.padding_5, horizontal: AppConstants.padding_5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.radius_10),
        gradient: isSelected ? AppColors.appMainGradientColor : null,
        color: isSelected ? null : AppColors.whiteColor,
        border: Border.all(
            color: isSelected
                ? Colors.transparent
                : AppColors.mainColor.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
              color: AppColors.shadowColor.withValues(alpha: 0.12),
              blurRadius: AppConstants.blur_10)
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppConstants.radius_10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.padding_15,
                vertical: AppConstants.padding_5),
            child: Center(
              child: Text(
                name,
                style: AppStyles.rkRegularTextStyle(
                    size: AppConstants.font_12,
                    color:
                    isSelected ? AppColors.whiteColor : AppColors.mainColor,
                    fontWeight: FontWeight.w500),
                maxLines: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onBrandTap(BuildContext context, String brandId) {
    context.read<SupplierListProductsBloc>().add(
        SupplierListProductsEvent.selectBrandEvent(
            context: context, brandId: brandId));
  }

  Widget buildSupplierListDataItem(
      {String supplierLogo = '',
        String? label,
        required void Function() onTap,
        required bool isSelected}) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 250),
      tween: Tween<double>(begin: 1.0, end: isSelected ? 1.05 : 1.0),
      curve: Curves.easeInOut,
      builder: (context, scale, child) {
        return Transform.scale(
            scale: scale, alignment: Alignment.center, child: child);
      },
      child: ClipRRect(
        borderRadius:
        const BorderRadius.all(Radius.circular(AppConstants.radius_10)),
        child: Container(
          height: 68,
          width: isSelected ? 68 : 60,
          margin: const EdgeInsets.symmetric(
              vertical: AppConstants.padding_5,
              horizontal: AppConstants.padding_5),
          decoration: BoxDecoration(
            borderRadius:
            const BorderRadius.all(Radius.circular(AppConstants.radius_10)),
            gradient: (label != null && isSelected)
                ? AppColors.appMainGradientColor
                : null,
            color: (label != null && isSelected) ? null : AppColors.whiteColor,
            border: isSelected
                ? Border.all(color: AppColors.mainColor, width: 1.5)
                : null,
            boxShadow: [
              BoxShadow(
                  color: AppColors.shadowColor.withValues(alpha: 0.15),
                  blurRadius: AppConstants.blur_10)
            ],
          ),
          child: InkWell(
            borderRadius:
            const BorderRadius.all(Radius.circular(AppConstants.radius_10)),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.padding_6),
              child: label != null
                  ? Center(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.font_12,
                      color: isSelected
                          ? AppColors.whiteColor
                          : AppColors.mainColor,
                      fontWeight: FontWeight.w500),
                ),
              )
                  : supplierLogo.isNotEmpty
                  ? CachedNetworkImage(
                  imageUrl:
                  "${AppUrlEndPoints.baseFileUrl}$supplierLogo",
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity)
                  : Image.asset(
                AppImagePath.imageNotAvailable5,
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String getProductId(SupplierListProductsState state, int index) {
    return state.searchType == SearchTypes.product.toString()
        ? state.productList[index].id ?? ''
        : state.productList[index].id ?? '';
  }

  int getMinQty(SupplierListProductsState state, int index) {
    return int.parse(state.productList[index].sale?.saleMinQuantity ?? '0');
  }

  void handleIncrease(
      BuildContext context, SupplierListProductsState state, int index) {
    if (state.isGuestUser) {
      Navigator.pushNamed(context, RouteDefine.connectScreen.name);
      return;
    }
    if (index >= state.productStockList[1].length) return;
    final quantity = state.productStockList[1][index].quantity;
    final minQty = getMinQty(state, index);
    final isMixedSale = state.productList[index].sale?.isMixedSale ?? false;

    if (!isMixedSale && minQty <= quantity + 1) {
      context
          .read<SupplierListProductsBloc>()
          .add(SupplierListProductsEvent.increaseListQuantityOfProduct(
        context: context,
        productListIndex: 1,
        productStockUpdateIndex: index,
        productSupplierIds: state.productList[index].supplierId.toString(),
      ));

      context
          .read<SupplierListProductsBloc>()
          .add(SupplierListProductsEvent.addToCartListProductEvent(
        context: context,
        productId: getProductId(state, index),
        productListIndex: 1,
        productStockUpdateIndex: index,
        productSupplierIds: state.productList[index].supplierId.toString(),
      ));
    } else {
      showMinMaxQtyConfirmDialog(
        context: context,
        productId: state.productList[index].id.toString(),
        minBox: minQty.toString(),
        index: index,
        supplierId: state.productList[index].supplierId.toString(),
        productListIndex: 1,
        isIncrease: true,
        isMixedSale: state.productList[index].sale?.isMixedSale,
        sameSaleProducts: state.productList[index].sale?.sameSaleProducts,
      );
    }
  }

  void handleDecrease(
      BuildContext context, SupplierListProductsState state, int index) {
    if (state.isGuestUser) {
      Navigator.pushNamed(context, RouteDefine.connectScreen.name);
      return;
    }
    if (index >= state.productStockList[1].length) return;

    final quantity = state.productStockList[1][index].quantity;
    final minQty = getMinQty(state, index);
    final isMixedSale = state.productList[index].sale?.isMixedSale ?? false;

    if (quantity == 0) return;

    if (!isMixedSale && minQty <= quantity - 1) {
      context
          .read<SupplierListProductsBloc>()
          .add(SupplierListProductsEvent.decreaseListQuantityOfProduct(
        context: context,
        productListIndex: 1,
        productStockUpdateIndex: index,
        productSupplierIds: state.productList[index].supplierId.toString(),
      ));

      context
          .read<SupplierListProductsBloc>()
          .add(SupplierListProductsEvent.addToCartListProductEvent(
        context: context,
        productId: getProductId(state, index),
        productListIndex: 1,
        productStockUpdateIndex: index,
        productSupplierIds: state.productList[index].supplierId.toString(),
      ));
    } else {
      showMinMaxQtyConfirmDialog(
        context: context,
        productId: state.productList[index].id.toString(),
        minBox: minQty.toString(),
        index: index,
        supplierId: state.productList[index].supplierId.toString(),
        productListIndex: 1,
        isIncrease: false,
        isMixedSale: state.productList[index].sale?.isMixedSale,
        sameSaleProducts: state.productList[index].sale?.sameSaleProducts,
      );
    }
  }

  Widget gridViewWidget(BuildContext context, SupplierListProductsState state) {
    final indices = sortedProductIndices(state);
    return GridView.builder(
        itemCount: indices.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_5),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: getChildAspectRatio(context, state.isSaleOn)),
        itemBuilder: (context, position) {
          final index = indices[position];
          final product = state.productList[index];
          final stock = state.productStockList[1][index];

          return CommonProductSaleItemWidget(
              isGuestUser: state.isGuestUser,
              onGuestLoginRequired: () =>
                  Navigator.pushNamed(context, RouteDefine.connectScreen.name),
              height: AppConstants.salesProductItemHeight,
              width: 140,
              isSale: product.sale!.isSale,
              productName: product.productName ?? '',
              saleImage: product.mainImage ?? '',
              title: product.name,
              description:
              parse(product.sale!.saleDescription).body?.text ?? '',
              discountedPrice: double.parse(product.sale!.salePrice!),
              originalPrice: double.parse(product.productPrice.toString()),
              productStock: product.productStock.toString(),
              lowStock: product.lowStock ?? '',
              isPesach: product.isPesach,
              quantity: stock.quantity,
              minQuantity: product.sale?.saleMinQuantity,
              maxQuantity: product.sale?.saleMaxQuantity,
              isMixedSale: product.sale?.isMixedSale,
              numberOfUnits: product.numberOfUnit.toString(),
              scaleType: product.scaleType,
              onQuantityChanged: () {
                context.read<SupplierListProductsBloc>().add(
                  SupplierListProductsEvent.updateListQuantityOfProduct(
                    context: context,
                    quantity: stock.quantity.toString(),
                    productListIndex: 1,
                    productStockUpdateIndex: index,
                    productSupplierIds: product.supplierId.toString(),
                  ),
                );
              },
              onQuantityIncreaseTap: () =>
                  handleIncrease(context, state, index),
              onQuantityDecreaseTap: () =>
                  handleDecrease(context, state, index),
              onButtonTap: () {
                if (!state.isGuestUser) {
                  showProductDetails(
                      context: context,
                      productListIndex: 1,
                      productId: getProductId(state, index),
                      productStock: product.productStock.toString(),
                      isSaleOn: state.isSaleOn);
                } else {
                  Navigator.pushNamed(context, RouteDefine.connectScreen.name);
                }
              });
        });
  }

  Widget listViewWidget(BuildContext context, SupplierListProductsState state) {
    final indices = sortedProductIndices(state);
    return ListView.builder(
        itemCount: indices.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_5),
        itemBuilder: (context, position) {
          final index = indices[position];
          final product = state.productList[index];
          final stock = state.productStockList[1][index];

          return CommonSaleListView(
            context: context,
            discountedPrice: double.parse(product.sale!.salePrice!),
            isFromSale: product.sale?.isSale,
            salesDesc: product.sale?.saleDescription,
            isPesach: product.isPesach,
            numberOfUnits: product.numberOfUnit.toString(),
            scaleType: product.scaleType,
            lowStock: product.lowStock.toString(),
            productStock: product.productStock.toString(),
            productImage: product.mainImage ?? '',
            productName: product.productName ?? '',
            price: double.parse(product.productPrice.toString()),
            quantity: stock.quantity,
            minQuantity: product.sale?.saleMinQuantity,
            maxQuantity: product.sale?.saleMaxQuantity,
            isMixedSale: product.sale?.isMixedSale,
            onQuantityChanged: () {
              context.read<SupplierListProductsBloc>().add(
                SupplierListProductsEvent.updateListQuantityOfProduct(
                  context: context,
                  quantity: stock.quantity.toString(),
                  productListIndex: 1,
                  productStockUpdateIndex: index,
                  productSupplierIds: product.supplierId.toString(),
                ),
              );
            },
            onQuantityIncreaseTap: () => handleIncrease(context, state, index),
            onQuantityDecreaseTap: () => handleDecrease(context, state, index),
            onButtonTap: () {
              if (!state.isGuestUser) {
                showProductDetails(
                    context: context,
                    productListIndex: 1,
                    productId: getProductId(state, index),
                    productStock: product.productStock.toString(),
                    isSaleOn: state.isSaleOn);
              } else {
                Navigator.pushNamed(context, RouteDefine.connectScreen.name);
              }
            },
            isGuestUser: state.isGuestUser,
          );
        });
  }

  /// Display order of indices into [state.productList] for the current
  /// [state.sortOption]. `onlySales` is already filtered server-side, so it
  /// keeps natural order; the a-z / price options are sorted here client-side.
  /// Clamped to the loaded stock length so the parallel productStockList[1]
  /// stays index-aligned.
  List<int> sortedProductIndices(SupplierListProductsState state) {
    final int count =
    state.productList.length < state.productStockList[1].length
        ? state.productList.length
        : state.productStockList[1].length;
    final List<int> indices = List<int>.generate(count, (i) => i);
    switch (state.sortOption) {
      case ProductSortOption.aToZ:
        indices.sort((a, b) => (state.productList[a].productName ?? '')
            .toLowerCase()
            .compareTo((state.productList[b].productName ?? '').toLowerCase()));
        break;
      case ProductSortOption.priceLowToHigh:
        indices.sort((a, b) => _productPrice(state.productList[a])
            .compareTo(_productPrice(state.productList[b])));
        break;
      case ProductSortOption.priceHighToLow:
        indices.sort((a, b) => _productPrice(state.productList[b])
            .compareTo(_productPrice(state.productList[a])));
        break;
      case ProductSortOption.none:
      case ProductSortOption.onlySales:
        break;
    }
    return indices;
  }

  double _productPrice(ProductData product) =>
      double.tryParse(product.productPrice?.toString() ?? '') ?? 0;

  void showSortOptionsBottomSheet(
      BuildContext context, SupplierListProductsState state) {
    final bloc = context.read<SupplierListProductsBloc>();
    final l10n = AppLocalizations.of(context)!;
    final options = <MapEntry<ProductSortOption, String>>[
      MapEntry(ProductSortOption.none, l10n.sort_none),
      MapEntry(ProductSortOption.aToZ, l10n.sort_a_to_z),
      MapEntry(ProductSortOption.priceLowToHigh, l10n.sort_price_low_high),
      MapEntry(ProductSortOption.priceHighToLow, l10n.sort_price_high_low),
      MapEntry(ProductSortOption.onlySales, l10n.show_only_sales),
    ];
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.whiteColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppConstants.radius_20))),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Padding(
              padding: const EdgeInsets.all(AppConstants.padding_20),
              child: Text(l10n.sort_products,
                  style: AppStyles.rkBoldTextStyle(
                      size: AppConstants.font_20, color: AppColors.blackColor)),
            ),
            const Divider(height: 1),
            ...options.map((opt) {
              final bool selected = opt.key == state.sortOption;
              return ListTile(
                title: Text(opt.value,
                    style: AppStyles.rkRegularTextStyle(
                        size: AppConstants.font_14,
                        color: selected
                            ? AppColors.mainColor
                            : AppColors.blackColor)),
                trailing: selected
                    ? Icon(Icons.check, color: AppColors.mainColor)
                    : null,
                onTap: () {
                  Navigator.pop(sheetContext);
                  bloc.add(SupplierListProductsEvent.applySortOptionEvent(
                      context: context, option: opt.key));
                },
              );
            }),
            AppConstants.padding_10.height,
          ]),
        );
      },
    );
  }

  Widget buildSupplierProducts({
    required BuildContext context,
    required int index,
    required String productImage,
    required String productName,
    required double productPrice,
    required void Function() onPressed,
    required bool isRTL,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius:
        const BorderRadius.all(Radius.circular(AppConstants.radius_10)),
        boxShadow: [
          BoxShadow(
              color: AppColors.shadowColor.withValues(alpha: 0.15),
              blurRadius: AppConstants.blur_10)
        ],
      ),
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.symmetric(
          vertical: AppConstants.padding_10,
          horizontal: AppConstants.padding_5),
      padding: const EdgeInsets.symmetric(
          vertical: AppConstants.padding_5,
          horizontal: AppConstants.padding_10),
      child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: productImage.isNotEmpty
                  ? Image.network("${AppUrlEndPoints.baseFileUrl}$productImage",
                  height: 70, fit: BoxFit.fitHeight,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress?.cumulativeBytesLoaded !=
                        loadingProgress?.expectedTotalBytes) {
                      return CommonShimmerWidget(
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(AppConstants.radius_10))),
                        ),
                      );
                    }
                    return child;
                  }, errorBuilder: (context, error, stackTrace) {
                    return Image.asset(AppImagePath.imageNotAvailable5,
                        height: 70,
                        width: double.maxFinite,
                        fit: BoxFit.cover);
                  })
                  : Image.asset(AppImagePath.imageNotAvailable5,
                  height: 70, width: double.maxFinite, fit: BoxFit.cover),
            ),
            5.height,
            Text(
              productName,
              style: AppStyles.rkBoldTextStyle(
                  size: AppConstants.font_12,
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            5.height,
            Expanded(child: 0.width),
            5.height,
            Center(
              child: CommonProductButtonWidget(
                title:
                "${AppLocalizations.of(context)!.currency}${productPrice.toStringAsFixed(AppConstants.amountFrLength) == "0.00" ? '0' : productPrice.toStringAsFixed(
                  AppConstants.amountFrLength,
                )}",
                onPressed: onPressed,
                textColor: AppColors.whiteColor,
                bgColor: AppColors.mainColor,
                borderRadius: AppConstants.radius_3,
                textSize: AppConstants.font_12,
              ),
            )
          ]),
    );
  }

  Widget searchWidget(BuildContext context, SupplierListProductsBloc bloc,
      SupplierListProductsState state) =>
      CommonSearchWidget(
          onCloseTap: () {
            bloc.add(const SupplierListProductsEvent.changeCategoryExpansion(
                isOpened: false));
            context.read<SupplierListProductsBloc>().add(
                SupplierListProductsEvent.getSupplierProductsListEvent(
                    context: context, searchType: state.searchType));
          },
          isFilterTap: true,
          isCategoryExpand: state.isCategoryExpand,
          isSearching: state.isSearching,
          onFilterTap: () {
            bloc.add(const SupplierListProductsEvent.changeCategoryExpansion());
          },
          onSearchTap: () {
            if (state.searchController.text != '') {
              bloc.add(const SupplierListProductsEvent.changeCategoryExpansion(
                  isOpened: true));
            }
          },
          onSearch: (String search) {
            if (search.length > 1) {
              bloc.add(const SupplierListProductsEvent.changeCategoryExpansion(
                  isOpened: true));
              bloc.add(SupplierListProductsEvent.globalSearchEvent(
                  context: context));
            }
          },
          onSearchSubmit: (String search) {
            Navigator.pushNamed(
                context, RouteDefine.supplierProductsScreen.name,
                arguments: {
                  AppStrings.searchString: state.search,
                  AppStrings.searchType: SearchTypes.product.toString(),
                });
          },
          onOutSideTap: () {
            state.searchController.clear();
            bloc.add(const SupplierListProductsEvent.changeCategoryExpansion(
                isOpened: false));
          },
          onSearchItemTap: () {
            bloc.add(const SupplierListProductsEvent.changeCategoryExpansion());
          },
          controller: state.searchController,
          searchList: state.searchList,
          searchResultWidget: state.isSearching
              ? const SizedBox()
              : state.searchList.isEmpty
              ? noDataWidget(
              AppLocalizations.of(context)!.search_result_not_found)
              : ListView.builder(
              itemCount: state.searchList.length,
              shrinkWrap: true,
              itemBuilder: (listViewContext, index) {
                if (index >= state.productStockList[0].length) {
                  return const SizedBox.shrink();
                }
                return SearchItemWidget(
                    isShowSeeAll: index == state.searchList.length - 1
                        ? true
                        : false,
                    saleDesc: state.searchList[index].salesDesc,
                    salePrice: state.searchList[index].salePrice,
                    isPesach: state.searchList[index].isPesach,
                    lowStock:
                    state.searchList[index].lowStock.toString(),
                    isGuestUser: state.isGuestUser,
                    numberOfUnits:
                    state.searchList[index].numberOfUnits,
                    scaleType: state.searchList[index].scaleType,
                    priceOfBox: state.searchList[index].priceOfBox,
                    productStock:
                    state.searchList[index].productStock.toString(),
                    context: context,
                    searchName: state.searchList[index].name,
                    searchImage: state.searchList[index].image,
                    searchType: state.searchList[index].searchType,
                    isMoreResults: state.searchList
                        .where((search) =>
                    search.searchType ==
                        state.searchList[index].searchType)
                        .toList()
                        .isNotEmpty,
                    isLastItem: state.searchList.length - 1 == index,
                    quantity: state.productStockList[0][index].quantity,
                    isSale: state.searchList[index].isSale,
                    minQuantity:
                    state.searchList[index].saleMinQuantity,
                    maxQuantity:
                    state.searchList[index].saleMaxQuantity,
                    isMixedSale: state.searchList[index].isMixedSale,
                    onQuantityChanged: () {
                      context.read<SupplierListProductsBloc>().add(
                          SupplierListProductsEvent
                              .updateListQuantityOfProduct(
                            context: context,
                            quantity: state
                                .productStockList[0][index].quantity
                                .toString(),
                            productListIndex: 0,
                            productStockUpdateIndex: index,
                            productSupplierIds: state
                                .searchList[index].supplierId
                                .toString(),
                          ));
                    },
                    onQuantityIncreaseTap: () {
                      if (!(state.searchList[index].isMixedSale ?? false) &&
                          int.parse(
                          state.searchList[index].saleMinQuantity ??
                              '0') <=
                          state.productStockList[0][index].quantity +
                              1) {
                        context.read<SupplierListProductsBloc>().add(
                            SupplierListProductsEvent
                                .increaseListQuantityOfProduct(
                              context: context,
                              productListIndex: 0,
                              productStockUpdateIndex: index,
                              productSupplierIds: state
                                  .searchList[index].supplierId
                                  .toString(),
                            ));

                        context.read<SupplierListProductsBloc>().add(
                            SupplierListProductsEvent
                                .addToCartListProductEvent(
                              context: context,
                              productId:
                              state.searchList[index].searchId,
                              productListIndex: 0,
                              productStockUpdateIndex: index,
                              productSupplierIds: state
                                  .searchList[index].supplierId
                                  .toString(),
                            ));
                      } else {
                        showMinMaxQtyConfirmDialog(
                          context: context,
                          productId: state.searchList[index].searchId,
                          minBox: state
                              .searchList[index].saleMinQuantity
                              .toString(),
                          index: index,
                          supplierId: state.searchList[index].supplierId
                              .toString(),
                          productListIndex: 0,
                          isIncrease: true,
                          isMixedSale:
                          state.searchList[index].isMixedSale,
                          sameSaleProducts:
                          state.searchList[index].sameSaleProducts,
                        );
                      }
                    },
                    onQuantityDecreaseTap: () {
                      if (state.productStockList[0][index].quantity !=
                          0) {
                        if (!(state.searchList[index].isMixedSale ?? false) &&
                            int.parse(state.searchList[index]
                            .saleMinQuantity ??
                            '0') <=
                            state.productStockList[0][index].quantity -
                                1) {
                          context.read<SupplierListProductsBloc>().add(
                              SupplierListProductsEvent
                                  .decreaseListQuantityOfProduct(
                                context: context,
                                productListIndex: 0,
                                productStockUpdateIndex: index,
                                productSupplierIds: state
                                    .searchList[index].supplierId
                                    .toString(),
                              ));

                          context.read<SupplierListProductsBloc>().add(
                              SupplierListProductsEvent
                                  .addToCartListProductEvent(
                                context: context,
                                productId:
                                state.searchList[index].searchId,
                                productListIndex: 0,
                                productStockUpdateIndex: index,
                                productSupplierIds: state
                                    .searchList[index].supplierId
                                    .toString(),
                              ));
                        } else {
                          showMinMaxQtyConfirmDialog(
                            context: context,
                            productId: state.searchList[index].searchId,
                            minBox: state
                                .searchList[index].saleMinQuantity
                                .toString(),
                            index: index,
                            supplierId: state
                                .searchList[index].supplierId
                                .toString(),
                            productListIndex: 0,
                            isIncrease: false,
                            isMixedSale:
                            state.searchList[index].isMixedSale,
                            sameSaleProducts: state
                                .searchList[index].sameSaleProducts,
                          );
                        }
                      }
                    },
                    isShowSearchLabel: index == 0
                        ? true
                        : state.searchList[index].searchType !=
                        state.searchList[index - 1].searchType
                        ? true
                        : false,
                    onSeeAllTap: () async {
                      if (state.searchList[index].searchType ==
                          SearchTypes.category) {
                        dynamic searchResult =
                        await Navigator.pushNamed(context,
                            RouteDefine.productCategoryScreen.name,
                            arguments: {
                              AppStrings.searchString: state.search,
                              AppStrings.reqSearchString: state.search,
                              AppStrings.searchResultString:
                              state.searchList,
                            });
                        if (searchResult != null) {
                          bloc.add(SupplierListProductsEvent
                              .updateGlobalSearchEvent(
                            search:
                            searchResult[AppStrings.searchString],
                            searchList: searchResult[
                            AppStrings.searchResultString],
                          ));
                        }
                      } else if (state.searchList[index].searchType ==
                          SearchTypes.subCategory) {
                        dynamic searchResult =
                        await Navigator.pushNamed(context,
                            RouteDefine.storeCategoryScreen.name,
                            arguments: {
                              AppStrings.categoryIdString:
                              state.searchList[index].categoryId,
                              AppStrings.categoryNameString:
                              state.searchList[index].categoryName,
                              AppStrings.searchString: state.search,
                              AppStrings.searchResultString:
                              state.searchList,
                            });
                        if (searchResult != null) {
                          bloc.add(SupplierListProductsEvent
                              .updateGlobalSearchEvent(
                            search:
                            searchResult[AppStrings.searchString],
                            searchList: searchResult[
                            AppStrings.searchResultString],
                          ));
                        }
                      } else {
                        state.searchList[index].searchType ==
                            SearchTypes.company
                            ? Navigator.pushNamed(
                            context, RouteDefine.companyScreen.name,
                            arguments: {
                              AppStrings.searchString:
                              state.search,
                            })
                            : state.searchList[index].searchType ==
                            SearchTypes.supplier
                            ? Navigator.pushNamed(context,
                            RouteDefine.supplierScreen.name,
                            arguments: {
                              AppStrings.searchString:
                              state.search,
                            })
                            : state.searchList[index].searchType ==
                            SearchTypes.sale
                            ? Navigator.pushNamed(
                            context,
                            RouteDefine
                                .productSaleScreen.name,
                            arguments: {
                              AppStrings.searchString:
                              state.search,
                            })
                            : Navigator.pushNamed(
                            context,
                            RouteDefine
                                .supplierProductsScreen
                                .name,
                            arguments: {
                              AppStrings.searchString:
                              state.search,
                              AppStrings.searchType:
                              SearchTypes.product
                                  .toString(),
                            });
                      }
                    },
                    onTap: () async {
                      if (state.searchList[index].searchType ==
                          SearchTypes.subCategory) {
                        inProgressSnackBarWidget(context);
                        return;
                      }
                      if (state.searchList[index].searchType ==
                          SearchTypes.sale ||
                          state.searchList[index].searchType ==
                              SearchTypes.product) {
                        if (!state.isGuestUser) {
                          showProductDetails(
                            productListIndex: 0,
                            context: context,
                            productStock: state
                                .searchList[index].productStock
                                .toString(),
                            productId: state.searchList[index].searchId,
                            isBarcode: true,
                            isSaleOn: state.isSaleOn,
                          );
                        } else {
                          Navigator.pushNamed(
                              context, RouteDefine.connectScreen.name);
                        }
                      } else if (state.searchList[index].searchType ==
                          SearchTypes.category) {
                        dynamic searchResult =
                        await Navigator.pushNamed(context,
                            RouteDefine.storeCategoryScreen.name,
                            arguments: {
                              AppStrings.categoryIdString:
                              state.searchList[index].searchId,
                              AppStrings.categoryNameString:
                              state.searchList[index].name,
                              AppStrings.searchString:
                              state.searchController.text,
                              AppStrings.searchResultString:
                              state.searchList,
                            });
                        if (searchResult != null) {
                          bloc.add(SupplierListProductsEvent
                              .updateGlobalSearchEvent(
                            search:
                            searchResult[AppStrings.searchString],
                            searchList: searchResult[
                            AppStrings.searchResultString],
                          ));
                        }
                      } else {
                        state.searchList[index].searchType ==
                            SearchTypes.company
                            ? Navigator.pushNamed(context,
                            RouteDefine.companyProductsScreen.name,
                            arguments: {
                              AppStrings.companyIdString: state
                                  .searchList[index].searchId,
                            })
                            : Navigator.pushNamed(context,
                            RouteDefine.supplierProductsScreen.name,
                            arguments: {
                              AppStrings.supplierIdString: state
                                  .searchList[index].searchId,
                            });
                      }
                      bloc.add(const SupplierListProductsEvent
                          .changeCategoryExpansion());
                    });
              }),
          onScanTap: () async {
            String scanResult = await scanBarcodeOrQRCode(
                context: context,
                cancelText: AppLocalizations.of(context)!.cancel,
                scanMode: ScanMode.BARCODE);
            if (scanResult != '-1') {
              if (!state.isGuestUser) {
                showProductDetails(
                  productListIndex: 0,
                  context: context,
                  productId: scanResult,
                  isBarcode: true,
                  productStock: '1',
                  isSaleOn: state.isSaleOn,
                );
              } else {
                Navigator.pushNamed(context, RouteDefine.connectScreen.name);
              }
            }
          });

  void showProductDetails({
    required BuildContext context,
    required String productId,
    required int productListIndex,
    required bool isSaleOn,
    bool? isBarcode,
    String productStock = '0',
  }) async {
    context
        .read<SupplierListProductsBloc>()
        .add(SupplierListProductsEvent.getProductDetailsEvent(
      context: context,
      productId: productId,
      productListIndex: productListIndex,
      isBarcode: isBarcode ?? false,
    ));
    showMaterialModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isDismissible: false,
        clipBehavior: Clip.hardEdge,
        enableDrag: false,
        builder: (context1) {
          return SafeArea(
            bottom: false,
            child: DraggableScrollableSheet(
                expand: true,
                maxChildSize: 1 -
                    (MediaQuery.of(context).viewPadding.top /
                        getScreenHeight(context) *
                        0.2),
                minChildSize: productStock == '0'
                    ? 0.9
                    : 1 -
                    (MediaQuery.of(context).viewPadding.top /
                        getScreenHeight(context) *
                        0.2),
                initialChildSize: productStock == '0'
                    ? 0.9
                    : 1 -
                    (MediaQuery.of(context).viewPadding.top /
                        getScreenHeight(context) *
                        0.2),
                builder:
                    (BuildContext context1, ScrollController scrollController) {
                  return BlocProvider.value(
                    value: context.read<SupplierListProductsBloc>(),
                    child: BlocBuilder<SupplierListProductsBloc,
                        SupplierListProductsState>(
                        builder: (blocContext, state) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(AppConstants.radius_30),
                                  topRight:
                                  Radius.circular(AppConstants.radius_30)),
                              color: AppColors.whiteColor,
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: state.isProductLoading
                                ? const ProductDetailsShimmerWidget()
                                : state.productDetails.isEmpty
                                ? NoDataBottomSheet(dialogContext: context)
                                : SingleChildScrollView(
                              physics: const ClampingScrollPhysics(),
                              controller:
                              ModalScrollController.of(context),
                              child: Column(children: [
                                CommonProductDetailsWidget(
                                    isIncludedVat: state.isIncludedVat,
                                    productDetails: state.productDetails,
                                    isSubUserAddToBasket:
                                    state.isSubUserAddToBasket,
                                    bottleTax: state.bottleDeposit,
                                    totalBottleDeposit: (state.bottleDeposit *
                                        (state.productDetails.first.numberOfUnit ?? 1)
                                            .toDouble() *
                                        state
                                            .productStockList[state.productListIndex][state
                                            .productStockUpdateIndex]
                                            .quantity),
                                    isBottle:
                                    (state.productDetails.first.isBottle ??
                                        false),
                                    addToOrderTap: () {
                                      final isMixedSale = state.productDetails.first.sale?.isMixedSale ?? false;
                                      if (!isMixedSale && int.parse(state
                                          .productDetails
                                          .first
                                          .sale!
                                          .saleMinQuantity!) <=
                                          state
                                              .productStockList[
                                          state.productListIndex][
                                          state
                                              .productStockUpdateIndex]
                                              .quantity) {
                                        context
                                            .read<
                                            SupplierListProductsBloc>()
                                            .add(SupplierListProductsEvent
                                            .addToCartProductEvent(
                                            context: context1,
                                            productId:
                                            productId));
                                      } else {
                                        showMinQtyConfirmDialog(
                                          context,
                                          productId,
                                          state.productDetails.first.sale!
                                              .saleMinQuantity
                                              .toString(),
                                          state.productDetails.first.sale!
                                              .isMixedSale,
                                          state.productDetails.first.sale!
                                              .sameSaleProducts,
                                        );
                                      }
                                    },
                                    isLoading: state.isLoading,
                                    imageOnTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (dialogContext) {
                                            return SafeArea(
                                              bottom: false,
                                              child: Stack(children: [
                                                SizedBox(
                                                  height: getScreenHeight(
                                                      context) -
                                                      MediaQuery.of(
                                                          context)
                                                          .padding
                                                          .top,
                                                  width: getScreenWidth(
                                                      context),
                                                  child: GestureDetector(
                                                    onVerticalDragStart:
                                                        (dragDetails) {},
                                                    onVerticalDragUpdate:
                                                        (dragDetails) {},
                                                    onVerticalDragEnd:
                                                        (endDetails) {
                                                      Navigator.pop(
                                                          dialogContext);
                                                    },
                                                    child: state
                                                        .productDetails[
                                                    state
                                                        .imageIndex]
                                                        .mainImage !=
                                                        ''
                                                        ? PhotoView(
                                                      imageProvider:
                                                      NetworkImage(
                                                          '${AppUrlEndPoints.baseFileUrl}${state.productDetails[state.imageIndex].mainImage}'),
                                                    )
                                                        : const SizedBox(),
                                                  ),
                                                ),
                                                GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(
                                                          dialogContext);
                                                    },
                                                    child: const Padding(
                                                      padding: EdgeInsets.only(
                                                          top: AppConstants
                                                              .padding_10),
                                                      child: Icon(
                                                          Icons.close,
                                                          color: Colors
                                                              .white),
                                                    )),
                                              ]),
                                            );
                                          });
                                    },
                                    context: context,
                                    productImages: [
                                      state.productDetails.first
                                          .mainImage ??
                                          '',
                                    ],
                                    productUnitPrice: double.parse(state
                                        .productDetails
                                        .first
                                        .supplierSales
                                        ?.first
                                        .productPrice
                                        .toString() ??
                                        ''),
                                    scaleType: state
                                        .productDetails.first.scaleType,
                                    productPrice: (state.productDetails.first.sale?.isSale ?? false)
                                        ? double.parse(state.productDetails.first.sale?.salePrice ?? '') *
                                        state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity *
                                        (state.productDetails.first.numberOfUnit ?? 1)
                                        : state.productStockList[state.productListIndex][state.productStockUpdateIndex].totalPrice * state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity * (state.productDetails.first.numberOfUnit ?? 1),
                                    productStock: (state.productStockList[state.productListIndex][state.productStockUpdateIndex].stock.toString()),
                                    scrollController: scrollController,
                                    productQuantity: state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity,
                                    isMixedSale: state.productDetails.first.sale!.isMixedSale,
                                    recommendedRetailConsumerPricerOffer: state.clubAgentId == AppStrings.clubAgentIdText
                                        ? state.productDetails.first.sale?.isSale == true
                                        ? state.productDetails.first.recommendedConsumerOffer
                                        : state.productDetails.first.recommendedRetailPrice
                                        : '',
                                    onQuantityChanged: (quantity) {
                                      context
                                          .read<
                                          SupplierListProductsBloc>()
                                          .add(SupplierListProductsEvent
                                          .updateQuantityOfProduct(
                                          context: context1,
                                          quantity: quantity));
                                    },
                                    onQuantityIncreaseTap: () {
                                      context
                                          .read<
                                          SupplierListProductsBloc>()
                                          .add(SupplierListProductsEvent
                                          .increaseQuantityOfProduct(
                                          context: context1));
                                    },
                                    onQuantityDecreaseTap: () {
                                      if (state
                                          .productStockList[
                                      state.productListIndex][
                                      state
                                          .productStockUpdateIndex]
                                          .quantity >
                                          1) {
                                        context
                                            .read<
                                            SupplierListProductsBloc>()
                                            .add(SupplierListProductsEvent
                                            .decreaseQuantityOfProduct(
                                            context: context1));
                                      }
                                    },
                                    onCloseTap: () async {
                                      final bloc = context.read<
                                          SupplierListProductsBloc>();
                                      final cartMap =
                                      await fetchCartQuantities(
                                          context);
                                      if (!context.mounted) return;
                                      bloc.add(SupplierListProductsEvent
                                          .applyListCartQuantitiesEvent(
                                          cartQuantities: cartMap));
                                      Navigator.pop(context);
                                    }),
                                state.isRelatedShimmering
                                    ? const RelatedProductShimmerWidget()
                                    : state.relatedProductList.isEmpty
                                    ? 0.width
                                    : relatedProductWidget(
                                  context1,
                                  state.relatedProductList,
                                  context,
                                  isSaleOn,
                                  productStockList:
                                  state.productStockList,
                                  state.clubAgentId!,
                                ),
                                10.height
                              ]),
                            ),
                          );
                        }),
                  );
                }),
          );
        });
  }

  Widget relatedProductWidget(
      BuildContext prevContext,
      List<RelatedProductDatum> relatedProductList,
      BuildContext context,
      bool isSaleOn,
      String clubAgentId, {
        required List<List<ProductStockModel>> productStockList,
      }) {
    final hasRelatedStock = productStockList.length > 2;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          relatedProductTitle(context),
          Container(
            height: getItemHeight(context, isSaleOn),
            padding:
            const EdgeInsets.symmetric(horizontal: AppConstants.padding_10),
            child: ListView.builder(
              physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context2, i) {
                final relatedProduct = relatedProductList.elementAt(i);
                int relatedQty = 0;
                int relatedStockIdx = -1;
                if (hasRelatedStock) {
                  relatedStockIdx = productStockList[2]
                      .indexWhere((s) => s.productId == relatedProduct.id);
                  if (relatedStockIdx != -1) {
                    relatedQty = productStockList[2][relatedStockIdx].quantity;
                  }
                }
                return CommonProductSaleItemWidget(
                    isSale: relatedProduct.sale?.isSale,
                    isGuestUser: context
                        .read<SupplierListProductsBloc>()
                        .state
                        .isGuestUser,
                    onGuestLoginRequired: () => Navigator.pushNamed(
                        context, RouteDefine.connectScreen.name),
                    height: AppConstants.salesProductItemHeight,
                    width: getItemWidth(context),
                    productName: relatedProduct.productName ?? '',
                    saleImage: relatedProduct.mainImage ?? '',
                    title: relatedProduct.name,
                    description: parse(relatedProduct.sale?.saleDescription)
                        .body
                        ?.text ??
                        '',
                    discountedPrice:
                    double.parse(relatedProduct.sale?.salePrice ?? '0'),
                    originalPrice: relatedProduct.productPrice,
                    productStock: relatedProduct.productStock.toString(),
                    lowStock: relatedProduct.lowStock ?? '',
                    isPesach: relatedProduct.isPesach,
                    quantity: relatedQty,
                    minQuantity: relatedProduct.sale?.saleMinQuantity,
                    maxQuantity: relatedProduct.sale?.saleMaxQuantity,
                    isMixedSale: relatedProduct.sale?.isMixedSale,
                    numberOfUnits:
                    relatedProductList.elementAt(i).numberOfUnit.toString(),
                    scaleType: relatedProductList.elementAt(i).scaleType,
                    onQuantityChanged: () {
                      if (!hasRelatedStock || relatedStockIdx == -1) return;
                      context.read<SupplierListProductsBloc>().add(
                          SupplierListProductsEvent
                              .updateListQuantityOfProduct(
                            context: context,
                            quantity: productStockList[2][relatedStockIdx]
                                .quantity
                                .toString(),
                            productListIndex: 2,
                            productStockUpdateIndex: relatedStockIdx,
                            productSupplierIds:
                            relatedProduct.supplierId.toString(),
                          ));
                    },
                    onQuantityIncreaseTap: () {
                      if (!hasRelatedStock || relatedStockIdx == -1) return;
                      if (!(relatedProduct.sale?.isMixedSale ?? false) &&
                          int.parse(
                          relatedProduct.sale?.saleMinQuantity ?? '0') <=
                          productStockList[2][relatedStockIdx].quantity + 1) {
                        context.read<SupplierListProductsBloc>().add(
                            SupplierListProductsEvent
                                .increaseListQuantityOfProduct(
                              context: context,
                              productListIndex: 2,
                              productStockUpdateIndex: relatedStockIdx,
                              productSupplierIds:
                              relatedProduct.supplierId.toString(),
                            ));

                        context.read<SupplierListProductsBloc>().add(
                            SupplierListProductsEvent
                                .addToCartListProductEvent(
                              context: context,
                              productId: relatedProduct.id.toString(),
                              productListIndex: 2,
                              productStockUpdateIndex: relatedStockIdx,
                              productSupplierIds:
                              relatedProduct.supplierId.toString(),
                            ));
                      } else {
                        showMinMaxQtyConfirmDialog(
                          context: context,
                          productId: relatedProduct.id.toString(),
                          minBox:
                          relatedProduct.sale?.saleMinQuantity.toString() ??
                              '0',
                          index: relatedStockIdx,
                          supplierId: relatedProduct.supplierId.toString(),
                          productListIndex: 2,
                          isIncrease: true,
                          isMixedSale: relatedProduct.sale?.isMixedSale,
                          sameSaleProducts:
                          relatedProduct.sale?.sameSaleProducts,
                        );
                      }
                    },
                    onQuantityDecreaseTap: () {
                      if (!hasRelatedStock || relatedStockIdx == -1) return;
                      if (productStockList[2][relatedStockIdx].quantity != 0) {
                        if (!(relatedProduct.sale?.isMixedSale ?? false) &&
                            int.parse(
                            relatedProduct.sale?.saleMinQuantity ?? '0') <=
                            productStockList[2][relatedStockIdx].quantity - 1) {
                          context.read<SupplierListProductsBloc>().add(
                              SupplierListProductsEvent
                                  .decreaseListQuantityOfProduct(
                                context: context,
                                productListIndex: 2,
                                productStockUpdateIndex: relatedStockIdx,
                                productSupplierIds:
                                relatedProduct.supplierId.toString(),
                              ));

                          context.read<SupplierListProductsBloc>().add(
                              SupplierListProductsEvent
                                  .addToCartListProductEvent(
                                context: context,
                                productId: relatedProduct.id.toString(),
                                productListIndex: 2,
                                productStockUpdateIndex: relatedStockIdx,
                                productSupplierIds:
                                relatedProduct.supplierId.toString(),
                              ));
                        } else {
                          showMinMaxQtyConfirmDialog(
                            context: context,
                            productId: relatedProduct.id.toString(),
                            minBox: relatedProduct.sale?.saleMinQuantity
                                .toString() ??
                                '0',
                            index: relatedStockIdx,
                            supplierId: relatedProduct.supplierId.toString(),
                            productListIndex: 2,
                            isIncrease: false,
                            isMixedSale: relatedProduct.sale?.isMixedSale,
                            sameSaleProducts:
                            relatedProduct.sale?.sameSaleProducts,
                          );
                        }
                      }
                    },
                    onButtonTap: () {
                      Navigator.pop(prevContext);
                      showProductDetails(
                        isSaleOn: isSaleOn,
                        context: context,
                        productListIndex: 2,
                        productId: relatedProduct.id ?? '',
                        isBarcode: false,
                        productStock: (relatedProduct.productStock.toString()),
                      );
                    });
              },
              itemCount: relatedProductList.length,
            ),
          )
        ]);
  }

  showMinQtyConfirmDialog(BuildContext context, String productId, String minBox,
      bool? isMixedSale, List? sameSaleProducts) {
    _openSalePromotionSheet(context, productId);
  }

  void showMinMaxQtyConfirmDialog({
    required BuildContext context,
    required String productId,
    required String minBox,
    required int index,
    required dynamic supplierId,
    required int productListIndex,
    required bool isIncrease,
    bool? isMixedSale,
    List? sameSaleProducts,
  }) {
    _openSalePromotionSheet(context, productId);
  }

  Future<void> _openSalePromotionSheet(
      BuildContext context, String productId) async {
    final SupplierListProductsBloc bloc =
    context.read<SupplierListProductsBloc>();
    if (bloc.state.isGuestUser) {
      Navigator.pushNamed(context, RouteDefine.connectScreen.name);
      return;
    }
    final l10n = AppLocalizations.of(context)!;
    final bool changed = await showSalePromotionSheet(
        context: context, productId: productId, l10n: l10n);
    if (!changed || !context.mounted) return;
    final cartMap = await fetchCartQuantities(context);
    if (!context.mounted) return;
    bloc.add(SupplierListProductsEvent.applyListCartQuantitiesEvent(
        cartQuantities: cartMap));
    bloc.add(SupplierListProductsEvent.getCartCountNoEvent(context: context));
  }

  Widget floatingButtonWidget(
      BuildContext context, SupplierListProductsState state) =>
      FloatingActionButton(
        elevation: 0,
        backgroundColor: Colors.transparent,
        onPressed: () {
          Navigator.pushNamed(context, RouteDefine.bottomNavScreen.name,
              arguments: {AppStrings.isBasketScreenString: 'true'});
        },
        child: Stack(children: [
          cartImageWidget(),
          state.cartCount != 0
              ? Positioned(
            top: 5,
            right: context.rtl ? null : 0,
            left: context.rtl ? 0 : null,
            child: Stack(children: [
              Container(
                height: 18,
                width: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.mainColor,
                  borderRadius: const BorderRadius.all(
                      Radius.circular(AppConstants.radius_100)),
                  border:
                  Border.all(color: AppColors.whiteColor, width: 1),
                ),
                child: Text('${state.cartCount}',
                    style: AppStyles.rkRegularTextStyle(
                        size: AppConstants.font_10,
                        color: AppColors.whiteColor)),
              ),
            ]),
          )
              : 0.width,
          SizedBox(
            height: 50,
            width: 25,
            child: Visibility(
              visible: state.duringCelebration,
              child: IgnorePointer(
                  child: Confetti(
                      isStopped: !state.duringCelebration,
                      snippingCount: 10,
                      snipSize: 3.0,
                      colors: [AppColors.mainColor])),
            ),
          ),
        ]),
      );
}