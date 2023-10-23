import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/bloc/supplier_products/supplier_products_bloc.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';

import '../utils/themes/app_constants.dart';
import '../utils/themes/app_styles.dart';
import '../widget/common_app_bar.dart';

class SupplierProductsRoute {
  static Widget get route => SupplierProductsScreen();
}

class SupplierProductsScreen extends StatelessWidget {
  const SupplierProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SupplierProductsBloc(),
      child: SupplierProductsScreenWidget(),
    );
  }
}

class SupplierProductsScreenWidget extends StatelessWidget {
  const SupplierProductsScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupplierProductsBloc, SupplierProductsState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.pageColor,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(AppConstants.appBarHeight),
            child: CommonAppBar(
              title: AppLocalizations.of(context)!.products,
              iconData: Icons.arrow_back_ios_sharp,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: getScreenWidth(context) / 3,
                        width: getScreenWidth(context) / 3,
                        clipBehavior: Clip.hardEdge,
                        margin: EdgeInsets.symmetric(
                            vertical: AppConstants.padding_10,
                            horizontal: AppConstants.padding_5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(AppConstants.radius_10)),
                          color: AppColors.whiteColor,
                          boxShadow: [
                            BoxShadow(
                                color: AppColors.shadowColor.withOpacity(0.15),
                                blurRadius: AppConstants.blur_10)
                          ],
                        ),
                        child: Image.network(
                          "${AppUrls.baseFileUrl}",
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress?.cumulativeBytesLoaded !=
                                loadingProgress?.expectedTotalBytes) {
                              return Container(
                                height: getScreenWidth(context) / 3,
                                width: getScreenWidth(context) / 3,
                                alignment: Alignment.center,
                                color: AppColors.whiteColor,
                                child: CupertinoActivityIndicator(
                                  color: AppColors.blackColor,
                                ),
                              );
                            }
                            return child;
                          },
                          errorBuilder: (context, error, stackTrace) {
                            // debugPrint('product category list image error : $error');
                            return Container(
                              color: AppColors.whiteColor,
                            );
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: AppConstants.padding_5,
                        right: AppConstants.padding_5,
                        child: Container(
                          // height: 20,
                          // width: 80,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                              vertical: AppConstants.padding_5,
                              horizontal: AppConstants.padding_5),
                          decoration: BoxDecoration(
                            color: AppColors.mainColor,
                            borderRadius: BorderRadius.only(
                                bottomLeft:
                                    Radius.circular(AppConstants.radius_10),
                                bottomRight:
                                    Radius.circular(AppConstants.radius_10)),
                            // border: Border.all(color: AppColors.whiteColor, width: 1),
                          ),
                          child: Text(
                            'supplierName',
                            style: AppStyles.rkRegularTextStyle(
                                size: AppConstants.font_12,
                                color: AppColors.whiteColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                  10.height,
                  GridView.builder(
                    itemCount: 8,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                        horizontal: AppConstants.padding_10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, childAspectRatio: 9 / 14),
                    itemBuilder: (context, index) => buildSupplierProducts(
                        context: context, productImage: '', isMirror: true),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Container buildSupplierProducts(
      {required BuildContext context,
      required String productImage,
      required bool isMirror}) {
    return Container(
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.network(
            "${AppUrls.baseFileUrl}$productImage",
            height: 80,
            fit: BoxFit.fitHeight,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress?.cumulativeBytesLoaded !=
                  loadingProgress?.expectedTotalBytes) {
                return Container(
                  height: getScreenHeight(context),
                  width: getScreenWidth(context),
                  alignment: Alignment.center,
                  color: AppColors.whiteColor,
                  child: CupertinoActivityIndicator(
                    color: AppColors.blackColor,
                  ),
                );
              }
              return child;
            },
            errorBuilder: (context, error, stackTrace) {
              // debugPrint('product category list image error : $error');
              return Container(
                height: 80,
                color: AppColors.whiteColor,
              );
            },
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
                          left: isMirror
                              ? BorderSide.none
                              : BorderSide(
                                  color: AppColors.borderColor.withOpacity(0.7),
                                  width: 1),
                          right: isMirror
                              ? BorderSide(
                                  color: AppColors.borderColor.withOpacity(0.7),
                                  width: 1)
                              : BorderSide.none,
                        ),
                      ),
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
                          left: isMirror
                              ? BorderSide(
                                  color: AppColors.borderColor.withOpacity(0.7),
                                  width: 1)
                              : BorderSide.none,
                          right: isMirror
                              ? BorderSide.none
                              : BorderSide(
                                  color: AppColors.borderColor.withOpacity(0.7),
                                  width: 1),
                        ),
                      ),
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
}
