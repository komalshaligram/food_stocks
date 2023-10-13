import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/bloc/store_category/store_category_bloc.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import 'package:food_stock/ui/widget/common_product_category_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';

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
      builder: (context, state) => Scaffold(
        backgroundColor: AppColors.pageColor,
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    90.height,
                    buildTopNavigation(navList: <String>[
                      AppLocalizations.of(context)!.home,
                      'category',
                      'subcategory'
                    ])
                  ],
                ),
              ),
              CommonProductCategoryWidget(
                isCategoryExpand: state.isCategoryExpand,
                onFilterTap: () {
                  bloc.add(StoreCategoryEvent.changeCategoryExpansionEvent());
                },
                onScanTap: () {},
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
    );
  }

  Widget buildTopNavigation({required List<String> navList}) {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(
          horizontal: AppConstants.padding_10,
          vertical: AppConstants.padding_10),
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: navList.length,
        itemBuilder: (context, index) => index == navList.length - 1
            ? Text(
                navList[index],
                style: AppStyles.rkRegularTextStyle(
                    size: AppConstants.smallFont, color: AppColors.blackColor),
              )
            : GestureDetector(
                onTap: () {
                  // BlocProvider.of<StoreCategoryBloc>(context).add();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      navList[index],
                      style: AppStyles.rkRegularTextStyle(
                          size: AppConstants.smallFont,
                          color: AppColors.mainColor),
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
      ),
    );
  }
}
