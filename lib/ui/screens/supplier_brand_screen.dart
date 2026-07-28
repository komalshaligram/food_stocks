import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/data/model/res_model/supplier_list_products_response_model/supplier_list_products_response_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../bloc/supplier_brand/supplier_brand_bloc.dart';
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

class SupplierBrandRoute {
  static Widget get route => const SupplierBrandScreen();
}

class SupplierBrandScreen extends StatelessWidget {
  const SupplierBrandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map? args = ModalRoute.of(context)?.settings.arguments as Map?;
    final String? supplierId = args?[AppStrings.supplierIdString];
    final String? supplierName = args?[AppStrings.supplierNameString];
    final List<BrandData> brandList = args?[AppStrings.brandListText] ?? [];

    return BlocProvider(
      create: (context) => SupplierBrandBloc()
        ..add(SupplierBrandEvent.initEvent(brandList: brandList)),
      child: SupplierBrandScreenWidget(
          supplierId: supplierId,
          supplierName: supplierName,
          brandList: brandList),
    );
  }
}

class SupplierBrandScreenWidget extends StatelessWidget {
  const SupplierBrandScreenWidget(
      {super.key,
      required this.supplierId,
      required this.supplierName,
      required this.brandList});
  final String? supplierId;
  final String? supplierName;
  final List<BrandData> brandList;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupplierBrandBloc, SupplierBrandState>(
        builder: (context, state) {
      return Scaffold(
        backgroundColor: AppColors.pageColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
          child: CommonAppBar(
              bgColor: AppColors.pageColor,
              title: AppLocalizations.of(context)?.brands ?? '',
              iconData: Icons.arrow_back_ios_sharp,
              onTap: () => Navigator.pop(context)),
        ),
        body: SafeArea(
          child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: false,
            controller: state.refreshController,
            header: const RefreshWidget(),
            onRefresh: () {
              context
                  .read<SupplierBrandBloc>()
                  .add(SupplierBrandEvent.refreshEvent(brandList: brandList));
            },
            child: state.isShimmering
                ? const CompanyScreenShimmerWidget()
                : state.brandsList.isEmpty
                    ? Center(
                        child: Text(AppLocalizations.of(context)
                                ?.companies_not_available ??
                            ''))
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.padding_10),
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: state.brandsList.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3, childAspectRatio: 0.9),
                        itemBuilder: (context, index) {
                          final item = state.brandsList[index];
                          return buildSupplierBrandListItem(
                              context: context,
                              brandLogo: item.brandLogo ?? '',
                              brandName: item.brandName ?? '',
                              onTap: () {
                                Navigator.pushNamed(
                                    context,
                                    RouteDefine
                                        .supplierBrandProductsScreen.name,
                                    arguments: {
                                      AppStrings.brandIdText: item.id ?? '',
                                      AppStrings.brandNameText:
                                          item.brandName ?? '',
                                      AppStrings.supplierIdString:
                                          supplierId ?? '',
                                      AppStrings.supplierNameString:
                                          supplierName ?? '',
                                    });
                              });
                        }),
          ),
        ),
      );
    });
  }

  Widget buildSupplierBrandListItem(
      {required BuildContext context,
      required String brandLogo,
      required String brandName,
      required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(
          vertical: AppConstants.padding_10,
          horizontal: AppConstants.padding_5),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(AppConstants.radius_10),
        boxShadow: [
          BoxShadow(
              color: AppColors.shadowColor.withValues(alpha: 0.15),
              blurRadius: AppConstants.blur_10)
        ],
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(children: [
          Expanded(
            child: brandLogo.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: "${AppUrlEndPoints.baseFileUrl}$brandLogo",
                    fit: BoxFit.scaleDown,
                    placeholder: (_, __) => CommonShimmerWidget(
                      child: Container(
                        height: getScreenHeight(context),
                        width: getScreenWidth(context),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(AppConstants.radius_10),
                              topRight:
                                  Radius.circular(AppConstants.radius_10)),
                        ),
                      ),
                    ),
                    errorWidget: (_, __, ___) => Image.asset(
                        AppImagePath.imageNotAvailable5,
                        fit: BoxFit.cover),
                  )
                : Image.asset(AppImagePath.imageNotAvailable5,
                    fit: BoxFit.cover),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppConstants.padding_6),
            decoration: BoxDecoration(
              gradient: AppColors.appMainGradientColor,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(AppConstants.radius_10),
                  bottomRight: Radius.circular(AppConstants.radius_10)),
            ),
            child: Text(
              brandName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppStyles.rkRegularTextStyle(
                  size: AppConstants.font_14, color: AppColors.whiteColor),
            ),
          ),
        ]),
      ),
    );
  }
}
