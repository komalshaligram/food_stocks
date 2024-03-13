import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:food_stock/ui/widget/delayed_widget.dart';
import 'package:food_stock/ui/widget/supplier_screen_shimmer_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../utils/themes/app_styles.dart';
import '../utils/themes/app_urls.dart';
import '../widget/refresh_widget.dart';

class SupplierRoute {
  static Widget get route => SupplierScreen();
}

class SupplierScreen extends StatelessWidget {
  const SupplierScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map?;
    debugPrint('supplier args = $args');
    return BlocProvider(
      create: (context) => SupplierBloc()
        ..add(SupplierEvent.setSearchEvent(
            search: args?[AppStrings.searchString] ?? ''))
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
              bgColor: AppColors.pageColor,
              title: AppLocalizations.of(context)!.suppliers,
              iconData: Icons.arrow_back_ios_sharp,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SafeArea(
            child:
                //   NotificationListener<ScrollNotification>(
                // child:
                SmartRefresher(
              enablePullDown: true,
              controller: state.refreshController,
              header: RefreshWidget(),
              footer: CustomFooter(
                builder: (context, mode) => SupplierScreenShimmerWidget(),
              ),
              enablePullUp: !state.isBottomOfSuppliers,
              onRefresh: () {
                context
                    .read<SupplierBloc>()
                    .add(SupplierEvent.refreshListEvent(context: context));
              },
              onLoading: () {
                context
                    .read<SupplierBloc>()
                    .add(SupplierEvent.getSuppliersListEvent(context: context));
              },
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
                                  '${AppLocalizations.of(context)!.suppliers_not_available}',
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
                                        crossAxisCount: 3,
                                        childAspectRatio: 0.9
                                    ),
                                itemBuilder: (context, index) =>
                                    buildSupplierListItem(
                                        index: index,
                                        context: context,
                                        supplierLogo:
                                            state.suppliersList[index].logo ??
                                                '',
                                        supplierName: state.suppliersList[index]
                                                .supplierDetail?.companyName ??
                                            '',
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context,
                                              RouteDefine
                                                  .supplierProductsScreen.name,
                                              arguments: {
                                                AppStrings.supplierIdString:
                                                    state.suppliersList[index]
                                                            .id ??
                                                        ''
                                              });
                                        }),
                              ),

                  ],
                ),
              ),
            ),

          ),
        );
      },
    );
  }

  Widget buildSupplierListItem(
      {required int index,
      required String supplierLogo,
      required String supplierName,
      required BuildContext context,
      required void Function() onTap}) {
    return DelayedWidget(
      child: Container(
        height: getScreenHeight(context),
        width: getScreenWidth(context),
        clipBehavior: Clip.hardEdge,
        margin: EdgeInsets.symmetric(
            vertical: AppConstants.padding_10,
            horizontal: AppConstants.padding_5),
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.all(Radius.circular(AppConstants.radius_10)),
          color: AppColors.whiteColor,
          boxShadow: [
            BoxShadow(
                color: AppColors.shadowColor.withOpacity(0.15),
                blurRadius: AppConstants.blur_10)
          ],
        ),
        child: InkWell(
          borderRadius:
              BorderRadius.all(Radius.circular(AppConstants.radius_10)),
          onTap: onTap,
          child: Column(
            children: [
              Expanded(
                child: supplierLogo.isNotEmpty ? CachedNetworkImage(
                  imageUrl: "${AppUrls.baseFileUrl}$supplierLogo",
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                  placeholder: (context, url) => CommonShimmerWidget(
                    child: Container(
                      height: getScreenHeight(context),
                      width: getScreenWidth(context),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(AppConstants.radius_10),
                            topRight: Radius.circular(AppConstants.radius_10)),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: getScreenHeight(context),
                    width: getScreenWidth(context),
                    color: AppColors.whiteColor,
                    child: Image.asset(
                      AppImagePath.imageNotAvailable5,
                      fit: BoxFit.cover,
                    ),
                  ),
                ) :Container(
                  height: getScreenHeight(context),
                  width: getScreenWidth(context),
                  color: AppColors.whiteColor,
                  child: Image.asset(
                    AppImagePath.imageNotAvailable5,
                    fit: BoxFit.cover,
                  ),
                ) ,
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(
                    vertical: AppConstants.padding_5,
                    horizontal: AppConstants.padding_5),
                decoration: BoxDecoration(
                  gradient: AppColors.appMainGradientColor,
                //  color: AppColors.mainColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(AppConstants.radius_10),
                      bottomRight: Radius.circular(AppConstants.radius_10)),
                  // border: Border.all(color: AppColors.whiteColor, width: 1),
                ),
                child: Text(
                  supplierName,
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.font_14, color: AppColors.whiteColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
