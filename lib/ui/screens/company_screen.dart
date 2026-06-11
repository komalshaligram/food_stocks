import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/company/company_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../routes/app_routes.dart';
import '../utils/app_utils.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_img_path.dart';
import '../utils/constants/app_strings.dart';
import '../utils/constants/app_styles.dart';
import '../utils/constants/app_urls.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_shimmer_widget.dart';
import '../widget/company_screen_shimmer_widget.dart';
import '../widget/refresh_widget.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';

class CompanyRoute {
  static Widget get route => const CompanyScreen();
}

class CompanyScreen extends StatelessWidget {
  const CompanyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
        create: (context) => CompanyBloc()
          ..add(CompanyEvent.setSearchEvent(search: args?[AppStrings.searchString] ?? ''))
          ..add(CompanyEvent.getCompaniesListEvent(context: context)),
        child: const CompanyScreenWidget());
  }
}

class CompanyScreenWidget extends StatelessWidget {
  const CompanyScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompanyBloc, CompanyState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: AppColors.pageColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
          child: CommonAppBar(
            bgColor: AppColors.pageColor,
            title: AppLocalizations.of(context)?.brands ?? '',
            iconData: Icons.arrow_back_ios_sharp,
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
          child: SmartRefresher(
            physics: const ClampingScrollPhysics(),
            enablePullDown: true,
            controller: state.refreshController,
            header: const RefreshWidget(),
            footer: CustomFooter(builder: (context, mode) => const CompanyScreenShimmerWidget()),
            enablePullUp: !state.isBottomOfCompanies,
            onRefresh: () {
              context.read<CompanyBloc>().add(CompanyEvent.refreshListEvent(context: context));
            },
            onLoading: () {
              context.read<CompanyBloc>().add(CompanyEvent.getCompaniesListEvent(context: context));
            },
            child: SingleChildScrollView(
              physics: state.companiesList.isEmpty ? const NeverScrollableScrollPhysics() : null,
              child: Column(children: [
                state.isShimmering
                    ? const CompanyScreenShimmerWidget()
                    : state.companiesList.isEmpty
                        ? Container(
                            height: getScreenHeight(context) - 80,
                            width: getScreenWidth(context),
                            alignment: Alignment.center,
                            child: noDataWidget(AppLocalizations.of(context)?.companies_not_available ?? ''),
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.companiesList.length,
                            padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_10),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 0.9),
                            itemBuilder: (context, index) => buildCompanyListItem(
                                index: index,
                                context: context,
                                companyLogo: state.companiesList[index].brandLogo ?? '',
                                companyName: state.companiesList[index].brandName ?? '',
                                onTap: () {
                                  Navigator.pushNamed(context, RouteDefine.companyProductsScreen.name, arguments: {
                                    AppStrings.companyIdString: state.companiesList[index].id ?? '',
                                    AppStrings.companyName: state.companiesList[index].brandName ?? '',
                                    AppStrings.companyLogo: state.companiesList[index].brandLogo ?? '',
                                  });
                                })),
              ]),
            ),
          ),
        ),
      );
    });
  }

  Widget buildCompanyListItem({required int index, required String companyLogo, required String companyName, required BuildContext context, required void Function() onTap}) {
    return Container(
      height: getScreenHeight(context),
      width: getScreenWidth(context),
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.symmetric(vertical: AppConstants.padding_10, horizontal: AppConstants.padding_5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_10)),
        color: AppColors.whiteColor,
        boxShadow: [BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.15), blurRadius: AppConstants.blur_10)],
      ),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_10)),
        onTap: onTap,
        child: Column(children: [
          Expanded(
            child: companyLogo.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: "${AppUrlEndPoints.baseFileUrl}$companyLogo",
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                    placeholder: (context, url) => CommonShimmerWidget(
                          child: Container(
                            height: getScreenHeight(context),
                            width: getScreenWidth(context),
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(AppConstants.radius_10), topRight: Radius.circular(AppConstants.radius_10)),
                            ),
                          ),
                        ),
                    errorWidget: (context, url, error) {
                      return Container(
                        height: getScreenHeight(context),
                        width: getScreenWidth(context),
                        color: AppColors.whiteColor,
                        child: Image.asset(AppImagePath.imageNotAvailable5, fit: BoxFit.cover),
                      );
                    })
                : Container(
                    height: getScreenHeight(context),
                    width: getScreenWidth(context),
                    color: AppColors.whiteColor,
                    child: Image.asset(AppImagePath.imageNotAvailable5, fit: BoxFit.cover),
                  ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_5, horizontal: AppConstants.padding_5),
            decoration: BoxDecoration(
              gradient: AppColors.appMainGradientColor,
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(AppConstants.radius_10), bottomRight: Radius.circular(AppConstants.radius_10)),
            ),
            child: Text(
              companyName,
              style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: AppColors.whiteColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ]),
      ),
    );
  }
}
