import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/bloc/supplier/supplier_bloc.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_img_path.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/widget/common_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/widget/common_shimmer_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:food_stock/ui/widget/supplier_screen_shimmer_widget.dart';

import '../utils/themes/app_styles.dart';
import '../utils/themes/app_urls.dart';

class SupplierRoute {
  static Widget get route => SupplierScreen();
}

class SupplierScreen extends StatelessWidget {
  const SupplierScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SupplierBloc()
        ..add(SupplierEvent.getSuppliersListEvent(context: context)),
      child: SupplierScreenWidget(),
    );
  }
}

class SupplierScreenWidget extends StatelessWidget {
  const SupplierScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupplierBloc, SupplierState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.pageColor,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(AppConstants.appBarHeight),
            child: CommonAppBar(
              title: AppLocalizations.of(context)!.suppliers,
              iconData: Icons.arrow_back_ios_sharp,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SafeArea(
              child: NotificationListener<ScrollNotification>(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  state.isShimmering
                      ? SupplierScreenShimmerWidget()
                      : state.suppliersList.isEmpty
                          ? Container(
                              height: getScreenHeight(context) - 80,
                              width: getScreenWidth(context),
                              alignment: Alignment.center,
                              child: Text(
                                'No Suppliers Available',
                                style: AppStyles.rkRegularTextStyle(
                                    size: AppConstants.smallFont,
                                    color: AppColors.textColor),
                              ),
                            )
                          : GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.suppliersList.length,
                              padding: EdgeInsets.symmetric(
                                  horizontal: AppConstants.padding_10),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3),
                              itemBuilder: (context, index) =>
                                  buildSupplierListItem(
                                      context: context,
                                      supplierLogo:
                                          state.suppliersList[index].logo ?? '',
                                      supplierName: state.suppliersList[index]
                                              .supplierDetail?.companyName ??
                                          '',
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context,
                                            RouteDefine
                                                .supplierProductsScreen.name,
                                            arguments: {
                                              AppStrings.supplierIdString: state
                                                      .suppliersList[index]
                                                      .id ??
                                                  ''
                                            });
                                      }),
                            ),
                  state.isLoadMore ? SupplierScreenShimmerWidget() : 0.width,
                  // state.isBottomOfSuppliers
                  //     ? CommonPaginationEndWidget(
                  //         pageEndText: 'No more Suppliers')
                  //     : 0.width,
                ],
              ),
            ),
            onNotification: (notification) {
              if (notification.metrics.pixels ==
                  notification.metrics.maxScrollExtent) {
                context
                    .read<SupplierBloc>()
                    .add(SupplierEvent.getSuppliersListEvent(context: context));
              }
              return true;
            },
          )),
        );
      },
    );
  }

  Widget buildSupplierListItem(
      {required String supplierLogo,
      required String supplierName,
      required BuildContext context,
      required void Function() onTap}) {
    return Container(
      height: getScreenHeight(context),
      width: getScreenWidth(context),
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.symmetric(
          vertical: AppConstants.padding_10,
          horizontal: AppConstants.padding_5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(AppConstants.radius_10)),
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
              color: AppColors.shadowColor.withOpacity(0.15),
              blurRadius: AppConstants.blur_10)
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(AppConstants.radius_10)),
        onTap: onTap,
        child: Column(
          children: [
            Expanded(
              child: Image.network(
                "${AppUrls.baseFileUrl}$supplierLogo",
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress?.cumulativeBytesLoaded !=
                      loadingProgress?.expectedTotalBytes) {
                    return CommonShimmerWidget(
                      child: Container(
                        height: getScreenHeight(context),
                        width: getScreenWidth(context),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(AppConstants.radius_10),
                              topRight:
                                  Radius.circular(AppConstants.radius_10)),
                        ),
                      ),
                    );
                  }
                  return child;
                },
                errorBuilder: (context, error, stackTrace) {
                  // debugPrint('product category list image error : $error');
                  return Container(
                    height: getScreenHeight(context),
                    width: getScreenWidth(context),
                    color: AppColors.whiteColor,
                    child: Image.asset(
                      AppImagePath.imageNotAvailable5,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                  vertical: AppConstants.padding_5,
                  horizontal: AppConstants.padding_5),
              decoration: BoxDecoration(
                color: AppColors.mainColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(AppConstants.radius_10),
                    bottomRight: Radius.circular(AppConstants.radius_10)),
                // border: Border.all(color: AppColors.whiteColor, width: 1),
              ),
              child: Text(
                supplierName,
                style: AppStyles.rkRegularTextStyle(
                    size: AppConstants.font_12, color: AppColors.whiteColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
