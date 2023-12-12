import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/bloc/company/company_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/widget/delayed_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../routes/app_routes.dart';
import '../utils/app_utils.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_img_path.dart';
import '../utils/themes/app_strings.dart';
import '../utils/themes/app_styles.dart';
import '../utils/themes/app_urls.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_shimmer_widget.dart';
import '../widget/company_screen_shimmer_widget.dart';
import '../widget/refresh_widget.dart';

class CompanyRoute {
  static Widget get route => CompanyScreen();
}

class CompanyScreen extends StatelessWidget {
  const CompanyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map?;
    debugPrint('company args = $args');
    return BlocProvider(
      create: (context) => CompanyBloc()
        ..add(CompanyEvent.setSearchEvent(
            search: args?[AppStrings.searchString] ?? ''))
        ..add(CompanyEvent.getCompaniesListEvent(context: context)),
      child: CompanyScreenWidget(),
    );
  }
}

class CompanyScreenWidget extends StatelessWidget {
  const CompanyScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompanyBloc, CompanyState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.pageColor,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(AppConstants.appBarHeight),
            child: CommonAppBar(
              title: AppLocalizations.of(context)!.companies,
              iconData: Icons.arrow_back_ios_sharp,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SafeArea(
            child:
                // NotificationListener<ScrollNotification>(
                // child:
                SmartRefresher(
              enablePullDown: true,
              controller: state.refreshController,
              header: RefreshWidget(),
              footer: CustomFooter(
                builder: (context, mode) => CompanyScreenShimmerWidget(),
              ),
              enablePullUp: !state.isBottomOfCompanies,
              onRefresh: () {
                context
                    .read<CompanyBloc>()
                    .add(CompanyEvent.refreshListEvent(context: context));
              },
              onLoading: () {
                context
                    .read<CompanyBloc>()
                    .add(CompanyEvent.getCompaniesListEvent(context: context));
              },
              child: SingleChildScrollView(
                physics: state.companiesList.isEmpty
                    ? const NeverScrollableScrollPhysics()
                    : null,
                child: Column(
                  children: [
                    state.isShimmering
                        ? CompanyScreenShimmerWidget()
                        : state.companiesList.isEmpty
                            ? Container(
                                height: getScreenHeight(context) - 80,
                                width: getScreenWidth(context),
                                alignment: Alignment.center,
                                child: Text(
                                  '${AppLocalizations.of(context)!.companies_not_available}',
                                  style: AppStyles.rkRegularTextStyle(
                                      size: AppConstants.smallFont,
                                      color: AppColors.textColor),
                                ),
                              )
                            : GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: state.companiesList.length,
                                padding: EdgeInsets.symmetric(
                                    horizontal: AppConstants.padding_10),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3),
                                itemBuilder: (context, index) =>
                                    buildCompanyListItem(
                                        index: index,
                                        context: context,
                                        companyLogo: state.companiesList[index]
                                                .brandLogo ??
                                            '',
                                        companyName: state.companiesList[index]
                                                .brandName ??
                                            '',
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context,
                                              RouteDefine
                                                  .companyProductsScreen.name,
                                              arguments: {
                                                AppStrings.companyIdString:
                                                    state.companiesList[index]
                                                            .id ??
                                                        ''
                                              });
                                        }),
                              ),
                    // state.isLoadMore ? CompanyScreenShimmerWidget() : 0.width,
                  ],
                ),
              ),
            ),
            // onNotification: (notification) {
            //   if (notification.metrics.pixels ==
            //       notification.metrics.maxScrollExtent) {
            //     context
            //         .read<CompanyBloc>()
            //         .add(CompanyEvent.getCompaniesListEvent(context: context));
            //   }
            //   return true;
            // },
            // ),
          ),
        );
      },
    );
  }

  Widget buildCompanyListItem(
      {required int index,
      required String companyLogo,
      required String companyName,
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
                child: Image.network(
                  "${AppUrls.baseFileUrl}$companyLogo",
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
                                topLeft:
                                    Radius.circular(AppConstants.radius_10),
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
                  companyName,
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
      ),
    );
  }
}
