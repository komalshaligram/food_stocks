import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_stock/bloc/store_category/store_category_bloc.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_img_path.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:food_stock/ui/widget/common_marquee_widget.dart';
import 'package:food_stock/ui/widget/common_product_category_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:food_stock/ui/widget/store_category_screen_planogram_shimmer_widget.dart';

import '../widget/common_pagination_end_widget.dart';
import '../widget/common_shimmer_widget.dart';

class StoreCategoryRoute {
  static Widget get route => const StoreCategoryScreen();
}

class StoreCategoryScreen extends StatelessWidget {
  const StoreCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StoreCategoryBloc(),
      child: StoreCategoryScreenWidget(),
    );
  }
}

class StoreCategoryScreenWidget extends StatelessWidget {
  const StoreCategoryScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    StoreCategoryBloc bloc = context.read<StoreCategoryBloc>();
    return BlocBuilder<StoreCategoryBloc, StoreCategoryState>(
      builder: (context, state) => WillPopScope(
        onWillPop: () {
          if (state.isCategory) {
            return Future.value(true);
          } else {
            bloc.add(StoreCategoryEvent.changeCategoryOrSubCategoryEvent(
                isCategory: true, context: context));
            return Future.value(false);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.pageColor,
          body: SafeArea(
            child: Stack(
              children: [
                SizedBox(
                    height: getScreenHeight(context),
                    width: getScreenWidth(context),
                    child: Stack(
                      children: [
                        state.isCategory
                            ? SingleChildScrollView(
                                child: GestureDetector(
                                  onTap: () {
                                    bloc.add(StoreCategoryEvent
                                        .changeCategoryOrSubCategoryEvent(
                                            isCategory: false,
                                            context: context));
                                  },
                                  child: Column(
                                    children: [
                                      80.height,
                                      buildTopNavigation(
                                          context: context,
                                          categoryName: 'Category'),
                                    ],
                                  ),
                                ),
                              )
                            : NotificationListener<ScrollNotification>(
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      80.height,
                                      buildTopNavigation(
                                          context: context,
                                          categoryName: 'Category',
                                          subCategoryName: 'Sub Category'),
                                      16.height,
                                      state.isShimmering
                                          ? StoreCategoryScreenPlanogramShimmerWidget()
                                          : ListView.builder(
                                              itemCount:
                                                  state.planogramsList.length,
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                return buildPlanogramItem(
                                                    context: context,
                                                    index: index);
                                              },
                                            ),
                                      state.isLoadMore
                                          ? StoreCategoryScreenPlanogramShimmerWidget()
                                          : 0.width,
                                      state.isBottomOfPlanograms
                                          ? CommonPaginationEndWidget(
                                              pageEndText: 'No more Planograms')
                                          : 0.width,
                                      85.height,
                                      // Container(
                                      //   color: AppColors.whiteColor,
                                      //   child: Column(
                                      //     mainAxisSize: MainAxisSize.min,
                                      //     children: [
                                      //       // Row(
                                      //       //   mainAxisAlignment:
                                      //       //   MainAxisAlignment.start,
                                      //       //   children: [
                                      //       //     Padding(
                                      //       //       padding: const EdgeInsets.symmetric(
                                      //       //           horizontal:
                                      //       //           AppConstants.padding_10,
                                      //       //           vertical: AppConstants.padding_3),
                                      //       //       child: Text(
                                      //       //         AppLocalizations.of(context)!
                                      //       //             .planogram,
                                      //       //         style: AppStyles.rkBoldTextStyle(
                                      //       //             size: AppConstants.mediumFont,
                                      //       //             color: AppColors.blackColor,
                                      //       //             fontWeight: FontWeight.w600),
                                      //       //       ),
                                      //       //     ),
                                      //       //   ],
                                      //       // ),
                                      //       buildPlanogramTitles(
                                      //           context: context,
                                      //           title: 'planogram',
                                      //           onTap: () {},
                                      //           subTitle: 'all planogram'),
                                      //       5.height,
                                      //       SizedBox(
                                      //         height: 200,
                                      //         child: ListView.builder(
                                      //           itemCount: 10,
                                      //           padding: EdgeInsets.symmetric(
                                      //               horizontal:
                                      //               AppConstants.padding_5),
                                      //           scrollDirection: Axis.horizontal,
                                      //           shrinkWrap: true,
                                      //           itemBuilder: (context, index) {
                                      //             return buildPlanoGramListItem(
                                      //                 context: context,
                                      //                 isRTL: isRTLContent(
                                      //                     context: context),
                                      //                 width: getScreenWidth(
                                      //                     context) /
                                      //                     3.2);
                                      //           },
                                      //         ),
                                      //       ),
                                      //       10.height,
                                      //     ],
                                      //   ),
                                      // ),
                                      // Row(
                                      //   children: [
                                      //     Padding(
                                      //       padding: const EdgeInsets.all(8.0),
                                      //       child: Text(
                                      //         AppLocalizations.of(context)!.planogram,
                                      //         style: AppStyles.rkBoldTextStyle(
                                      //             size: AppConstants.mediumFont,
                                      //             color: AppColors.blackColor,
                                      //             fontWeight: FontWeight.w600),
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
                                      // GridView.builder(
                                      //   physics: const NeverScrollableScrollPhysics(),
                                      //   padding: EdgeInsets.symmetric(
                                      //       vertical: AppConstants.padding_5),
                                      //   gridDelegate:
                                      //   SliverGridDelegateWithFixedCrossAxisCount(
                                      //       crossAxisCount: 3,
                                      //       childAspectRatio:
                                      //       (getScreenWidth(context) + 70) /
                                      //           getScreenHeight(context)),
                                      //   shrinkWrap: true,
                                      //   itemCount: 20,
                                      //   itemBuilder: (context, index) {
                                      //     return buildPlanoGramListItem(
                                      //         context: context,
                                      //         isRTL: isRTLContent(context: context),
                                      //         width: getScreenWidth(context) / 3.2);
                                      //   },
                                      // )
                                    ],
                                  ),
                                ),
                                onNotification: (notification) {
                                  if (notification.metrics.pixels ==
                                      notification.metrics.maxScrollExtent) {
                                    if (!state.isLoadMore) {
                                      context.read<StoreCategoryBloc>().add(
                                          StoreCategoryEvent
                                              .getPlanogramProductsEvent(
                                                  context: context));
                                    }
                                  }
                                  return true;
                                },
                              ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 60,
                            margin: EdgeInsets.only(bottom: 20),
                            padding: EdgeInsets.symmetric(
                              horizontal: AppConstants.padding_5,
                              vertical: AppConstants.padding_5,
                            ),
                            decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(AppConstants.radius_100)),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        AppColors.shadowColor.withOpacity(0.3),
                                    blurRadius: AppConstants.blur_10,
                                  )
                                ]),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    alignment: Alignment.center,
                                    child: SvgPicture.asset(
                                      AppImagePath.store,
                                      height: 26,
                                      width: 26,
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(
                                          AppColors.navSelectedColor,
                                          BlendMode.srcIn),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: AppColors.mainColor,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(
                                          isRTLContent(context: context)
                                              ? AppConstants.radius_5
                                              : AppConstants.radius_100),
                                      bottomLeft: Radius.circular(
                                          isRTLContent(context: context)
                                              ? AppConstants.radius_5
                                              : AppConstants.radius_100),
                                      topRight: Radius.circular(
                                          isRTLContent(context: context)
                                              ? AppConstants.radius_100
                                              : AppConstants.radius_5),
                                      bottomRight: Radius.circular(
                                          isRTLContent(context: context)
                                              ? AppConstants.radius_100
                                              : AppConstants.radius_5),
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: AppConstants.padding_10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "${AppLocalizations.of(context)!.total}: ",
                                        style: AppStyles.rkRegularTextStyle(
                                          size: AppConstants.normalFont,
                                          color: AppColors.whiteColor,
                                        ),
                                      ),
                                      Text(
                                        "11.90${AppLocalizations.of(context)!.currency}",
                                        style: AppStyles.rkBoldTextStyle(
                                            size: AppConstants.normalFont,
                                            color: AppColors.whiteColor,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                ),
                                5.width,
                                GestureDetector(
                                  onTap: () {
                                    debugPrint('finish');
                                  },
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: AppColors.navSelectedColor,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(
                                            isRTLContent(context: context)
                                                ? AppConstants.radius_100
                                                : AppConstants.radius_5),
                                        bottomLeft: Radius.circular(
                                            isRTLContent(context: context)
                                                ? AppConstants.radius_100
                                                : AppConstants.radius_5),
                                        topRight: Radius.circular(
                                            isRTLContent(context: context)
                                                ? AppConstants.radius_5
                                                : AppConstants.radius_100),
                                        bottomRight: Radius.circular(
                                            isRTLContent(context: context)
                                                ? AppConstants.radius_5
                                                : AppConstants.radius_100),
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: AppConstants.padding_10),
                                    alignment: Alignment.center,
                                    child: Text(
                                      AppLocalizations.of(context)!.finish,
                                      style: AppStyles.rkRegularTextStyle(
                                        size: AppConstants.normalFont,
                                        color: AppColors.whiteColor,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
                CommonProductCategoryWidget(
                  isCategoryExpand: state.isCategoryExpand,
                  isRTL: isRTLContent(context: context),
                  onFilterTap: () {
                    bloc.add(StoreCategoryEvent.changeCategoryExpansionEvent());
                  },
                  onScanTap: () async {
                    // Navigator.pushNamed(context, RouteDefine.qrScanScreen.name);
                    String result = await scanBarcodeOrQRCode(
                        context: context,
                        cancelText: AppLocalizations.of(context)!.cancel,
                        scanMode: ScanMode.QR);
                    if (result != '-1') {
                      // -1 result for cancel scanning
                      debugPrint('result = $result');
                      showSnackBar(
                          context: context,
                          title: result,
                          bgColor: AppColors.mainColor);
                    }
                  },
                  controller: TextEditingController(),
                  onOutSideTap: () {
                    bloc.add(StoreCategoryEvent.changeCategoryExpansionEvent(
                        isOpened: true));
                  },
                  onCatListItemTap: () {},
                  categoryList: ['Category', 'Category'],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPlanogramTitles(
      {required BuildContext context,
      required String title,
      required void Function() onTap,
      required subTitle}) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppConstants.padding_10,
        right: AppConstants.padding_10,
        top: AppConstants.padding_10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppStyles.rkBoldTextStyle(
                size: AppConstants.mediumFont,
                color: AppColors.blackColor,
                fontWeight: FontWeight.w600),
          ),
          GestureDetector(
            onTap: onTap,
            child: Text(
              subTitle,
              style: AppStyles.rkBoldTextStyle(
                  size: AppConstants.mediumFont,
                  color: AppColors.mainColor,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPlanoGramProductListItem(
      {required BuildContext context,
      required int index,
      required int subIndex,
      required double height,
      required double width,
      required bool isRTL}) {
    return BlocProvider.value(
      value: context.read<StoreCategoryBloc>(),
      child: BlocBuilder<StoreCategoryBloc, StoreCategoryState>(
        builder: (context, state) {
          return Container(
            height: height,
            width: width,
            clipBehavior: Clip.hardEdge,
            margin: EdgeInsets.symmetric(
              horizontal: AppConstants.padding_10,
              vertical: AppConstants.padding_10,
            ),
            padding: EdgeInsets.symmetric(vertical: AppConstants.padding_10),
            decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(AppConstants.radius_10),
                ),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.shadowColor.withOpacity(0.15),
                      blurRadius: AppConstants.blur_10),
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: AppConstants.padding_5,
                        left: AppConstants.padding_10,
                        right: AppConstants.padding_10),
                    child: Image.network(
                      '${AppUrls.baseFileUrl}${state.planogramsList[index].planogramproducts?[subIndex].mainImage}',
                      // height: 120,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress?.cumulativeBytesLoaded !=
                            loadingProgress?.expectedTotalBytes) {
                          return CommonShimmerWidget(
                            child: Container(
                              // height: 120,
                              margin: EdgeInsets.only(
                                  bottom: AppConstants.padding_5),
                              decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(AppConstants.radius_10))),
                            ),
                          );
                        }
                        return child;
                      },
                      errorBuilder: (context, error, stackTrace) {
                        // debugPrint('product category list image error : $error');
                        return Container(
                          child: Image.asset(
                            AppImagePath.imageNotAvailable5,
                            fit: BoxFit.cover,
                            // width: 80,
                            // height: 120,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                4.height,
                Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: AppColors.mainColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(AppConstants.radius_10),
                    ),
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                      horizontal: AppConstants.padding_5,
                      vertical: AppConstants.padding_10),
                  margin:
                      EdgeInsets.symmetric(horizontal: AppConstants.padding_10),
                  child: CommonMarqueeWidget(
                    child: Text(
                      '${state.planogramsList[index].planogramproducts?[subIndex].productName}',
                      style: AppStyles.rkBoldTextStyle(
                          size: AppConstants.smallFont,
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                // 4.height,
                // Text(
                //   "23.00${AppLocalizations.of(context)!.currency}",
                //   style: AppStyles.rkBoldTextStyle(
                //       size: AppConstants.font_12, color: AppColors.blackColor),
                //   textAlign: TextAlign.center,
                // ),
                // 4.height,
                // Expanded(
                //   child: Text(
                //     "Sale 2 at a discount",
                //     style: AppStyles.rkBoldTextStyle(
                //         size: AppConstants.font_12,
                //         color: AppColors.saleRedColor),
                //     maxLines: 1,
                //     overflow: TextOverflow.ellipsis,
                //     textAlign: TextAlign.center,
                //   ),
                // ),
                // Container(
                //   height: 35,
                //   decoration: BoxDecoration(
                //     border: Border(
                //         top: BorderSide(
                //             color: AppColors.borderColor.withOpacity(0.7),
                //             width: 1)),
                //   ),
                //   child: Row(
                //     children: [
                //       Expanded(
                //         flex: 2,
                //         child: GestureDetector(
                //           onTap: () {
                //             debugPrint('+');
                //           },
                //           child: Container(
                //             decoration: BoxDecoration(
                //               color: AppColors.iconBGColor,
                //               border: Border(
                //                 left: isRTL
                //                     ? BorderSide(
                //                         color: AppColors.borderColor
                //                             .withOpacity(0.7),
                //                         width: 1)
                //                     : BorderSide.none,
                //                 right: isRTL
                //                     ? BorderSide.none
                //                     : BorderSide(
                //                         color: AppColors.borderColor
                //                             .withOpacity(0.7),
                //                         width: 1),
                //               ),
                //             ),
                //             padding: EdgeInsets.symmetric(
                //                 horizontal: AppConstants.padding_3),
                //             alignment: Alignment.center,
                //             child: Icon(Icons.add, color: AppColors.mainColor),
                //           ),
                //         ),
                //       ),
                //       Expanded(
                //         flex: 3,
                //         child: Container(
                //           color: AppColors.whiteColor,
                //           padding: EdgeInsets.symmetric(
                //               horizontal: AppConstants.padding_5),
                //           alignment: Alignment.center,
                //           child: Text(
                //             '0',
                //             style: AppStyles.rkBoldTextStyle(
                //                 size: 24,
                //                 color: AppColors.blackColor,
                //                 fontWeight: FontWeight.w600),
                //           ),
                //         ),
                //       ),
                //       Expanded(
                //         flex: 2,
                //         child: GestureDetector(
                //           onTap: () {
                //             debugPrint('-');
                //           },
                //           child: Container(
                //             decoration: BoxDecoration(
                //               color: AppColors.iconBGColor,
                //               border: Border(
                //                 left: isRTL
                //                     ? BorderSide.none
                //                     : BorderSide(
                //                         color: AppColors.borderColor
                //                             .withOpacity(0.7),
                //                         width: 1),
                //                 right: isRTL
                //                     ? BorderSide(
                //                         color: AppColors.borderColor
                //                             .withOpacity(0.7),
                //                         width: 1)
                //                     : BorderSide.none,
                //               ),
                //             ),
                //             padding: EdgeInsets.symmetric(
                //                 horizontal: AppConstants.padding_3),
                //             alignment: Alignment.center,
                //             child:
                //                 Icon(Icons.remove, color: AppColors.mainColor),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // )
              ],
            ),
          );
        },
      ),
    );
  }

  Container buildPlanoGramListItem(
      {required BuildContext context, double? width, required bool isRTL}) {
    return Container(
      // height: 190,
      width: width,
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.symmetric(
        horizontal: AppConstants.padding_10,
        vertical: AppConstants.padding_10,
      ),
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.all(
            Radius.circular(AppConstants.radius_10),
          ),
          boxShadow: [
            BoxShadow(
                color: AppColors.shadowColor.withOpacity(0.15),
                blurRadius: AppConstants.blur_10),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            AppImagePath.product3,
            height: 80,
            fit: BoxFit.fitHeight,
          ),
          4.height,
          Text(
            'ProductName',
            style: AppStyles.rkBoldTextStyle(
                size: AppConstants.font_14, color: AppColors.blackColor),
            textAlign: TextAlign.center,
          ),
          4.height,
          Text(
            "23.00${AppLocalizations.of(context)!.currency}",
            style: AppStyles.rkBoldTextStyle(
                size: AppConstants.font_12, color: AppColors.blackColor),
            textAlign: TextAlign.center,
          ),
          4.height,
          Expanded(
            child: Text(
              "Sale 2 at a discount",
              style: AppStyles.rkBoldTextStyle(
                  size: AppConstants.font_12, color: AppColors.saleRedColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            height: 35,
            decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(
                      color: AppColors.borderColor.withOpacity(0.7), width: 1)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () {
                      debugPrint('+');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.iconBGColor,
                        border: Border(
                          left: isRTL
                              ? BorderSide(
                                  color: AppColors.borderColor.withOpacity(0.7),
                                  width: 1)
                              : BorderSide.none,
                          right: isRTL
                              ? BorderSide.none
                              : BorderSide(
                                  color: AppColors.borderColor.withOpacity(0.7),
                                  width: 1),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: AppConstants.padding_3),
                      alignment: Alignment.center,
                      child: Icon(Icons.add, color: AppColors.mainColor),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    color: AppColors.whiteColor,
                    padding: EdgeInsets.symmetric(
                        horizontal: AppConstants.padding_5),
                    alignment: Alignment.center,
                    child: Text(
                      '0',
                      style: AppStyles.rkBoldTextStyle(
                          size: 24,
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () {
                      debugPrint('-');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.iconBGColor,
                        border: Border(
                          left: isRTL
                              ? BorderSide.none
                              : BorderSide(
                                  color: AppColors.borderColor.withOpacity(0.7),
                                  width: 1),
                          right: isRTL
                              ? BorderSide(
                                  color: AppColors.borderColor.withOpacity(0.7),
                                  width: 1)
                              : BorderSide.none,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: AppConstants.padding_3),
                      alignment: Alignment.center,
                      child: Icon(Icons.remove, color: AppColors.mainColor),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Container buildTopNavigation(
      {required BuildContext context,
      required String categoryName,
      String? subCategoryName}) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: AppConstants.padding_10,
          vertical: AppConstants.padding_10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context)!.home,
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.smallFont, color: AppColors.mainColor),
                  textAlign: TextAlign.center,
                ),
                1.width,
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.mainColor,
                  size: 16,
                ),
                1.width,
              ],
            ),
          ),
          GestureDetector(
            onTap: subCategoryName?.isEmpty ?? true
                ? null
                : () {
              debugPrint('cate');
                    BlocProvider.of<StoreCategoryBloc>(context).add(
                        StoreCategoryEvent.changeCategoryOrSubCategoryEvent(
                            isCategory: true, context: context));
                  },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  categoryName,
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.smallFont,
                      color: subCategoryName?.isEmpty ?? true
                          ? AppColors.blackColor
                          : AppColors.mainColor),
                  textAlign: TextAlign.center,
                ),
                1.width,
                subCategoryName?.isEmpty ?? true
                    ? 0.height
                    : Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: subCategoryName?.isEmpty ?? true
                            ? AppColors.blackColor
                            : AppColors.mainColor,
                        size: 16,
                      ),
                1.width,
              ],
            ),
          ),
          Text(
            subCategoryName ?? '',
            style: AppStyles.rkRegularTextStyle(
                size: AppConstants.smallFont, color: AppColors.blackColor),
            textAlign: TextAlign.end,
          ),
        ],
      ),
    );
  }

  Widget buildPlanogramItem(
      {required BuildContext context, required int index}) {
    return BlocProvider.value(
      value: context.read<StoreCategoryBloc>(),
      child: BlocBuilder<StoreCategoryBloc, StoreCategoryState>(
        builder: (context, state) {
          return Container(
            color: AppColors.whiteColor,
            margin: EdgeInsets.symmetric(vertical: AppConstants.padding_5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                buildPlanogramTitles(
                    context: context,
                    title: state.planogramsList[index].planogramName ?? '',
                    onTap: () {},
                    subTitle: AppLocalizations.of(context)!.see_all),
                5.height,
                SizedBox(
                  height: 200,
                  child:
                      state.planogramsList[index].planogramproducts?.isEmpty ??
                              false
                          ? Center(
                              child: Text(
                                AppStrings.outOfStockString,
                                style: AppStyles.rkRegularTextStyle(
                                    size: AppConstants.smallFont,
                                    color: AppColors.textColor),
                              ),
                            )
                          : ListView.builder(
                              itemCount: (state.planogramsList[index]
                                              .planogramproducts?.length ??
                                          0) <
                                      6
                                  ? state.planogramsList[index]
                                      .planogramproducts?.length
                                  : 6,
                              padding: EdgeInsets.symmetric(
                                  horizontal: AppConstants.padding_5),
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (context, subIndex) {
                                return buildPlanoGramProductListItem(
                                    context: context,
                                    index: index,
                                    subIndex: subIndex,
                                    isRTL: isRTLContent(context: context),
                                    height: 150,
                                    width: getScreenWidth(context) / 3.2);
                              },
                            ),
                ),
                10.height,
              ],
            ),
          );
        },
      ),
    );
  }
}
