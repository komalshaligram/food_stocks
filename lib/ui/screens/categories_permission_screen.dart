import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/categories_permission/categories_permission_bloc.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../../ui/widget/permission_screen_widgets.dart';
import '../../ui/widget/sized_box_widget.dart';
import '../utils/app_utils.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_strings.dart';
import '../widget/common_app_bar.dart';

class CategoriesPermissionRoute {
  static Widget get route => const CategoriesPermissionScreen();
}

class CategoriesPermissionScreen extends StatelessWidget {
  const CategoriesPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
      create: (context) => CategoriesPermissionBloc()
        ..add(CategoriesPermissionEvent.getPermissionList(context: context, subUserId: args?[AppStrings.subUserIdString] ?? '')),
      child: const CategoriesPermissionScreenWidget(),
    );
  }
}

class CategoriesPermissionScreenWidget extends StatelessWidget {
  const CategoriesPermissionScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    CategoriesPermissionBloc bloc = context.read<CategoriesPermissionBloc>();
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<CategoriesPermissionBloc, CategoriesPermissionState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: AppColors.pageColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
          child: CommonAppBar(
            bgColor: AppColors.pageColor,
            title: l10n.categories_permissions,
            iconData: Icons.arrow_back_ios_new_rounded,
            trailingWidget: PermissionScreenWidgets.appBarIcon(Icons.category_outlined),
            onTap: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: state.isShimmering
              ? const PermissionScreenShimmerWidget(itemCount: 6)
              : state.categoriesPermissionList.isEmpty
                  ? Center(child: noDataWidget(l10n.no_data))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(
                        PermissionScreenWidgets.horizontalPadding,
                        8,
                        PermissionScreenWidgets.horizontalPadding,
                        100,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          PermissionScreenWidgets.selectAllButton(
                            text: !state.isSelectAll ? l10n.select_all.toUpperCase() : l10n.select_none.toUpperCase(),
                            onPressed: () {
                              bloc.add(CategoriesPermissionEvent.switchButtonEvent(context: context, subCategoriesIndex: -2, categoriesIndex: -2));
                            },
                          ),
                          16.height,
                          ...List.generate(state.categoriesPermissionList.length, (index) {
                            final category = state.categoriesPermissionList[index];
                            final subCategories = category.subCategories ?? [];
                            final tiles = <Widget>[
                              PermissionScreenWidgets.switchTile(
                                title: category.category?.categoryName ?? '',
                                value: category.isAllowed ?? false,
                                onChanged: (_) {
                                  bloc.add(CategoriesPermissionEvent.switchButtonEvent(context: context, categoriesIndex: index, subCategoriesIndex: -1));
                                },
                              ),
                              ...List.generate(subCategories.length, (subIndex) {
                                return PermissionScreenWidgets.switchTile(
                                  title: subCategories[subIndex].subCategoryData?.subCategoryName ?? '',
                                  value: subCategories[subIndex].isAllowed ?? false,
                                  isSubItem: true,
                                  onChanged: (_) {
                                    bloc.add(CategoriesPermissionEvent.switchButtonEvent(context: context, categoriesIndex: index, subCategoriesIndex: subIndex));
                                  },
                                );
                              }),
                            ];

                            return Padding(
                              padding: EdgeInsets.only(bottom: index < state.categoriesPermissionList.length - 1 ? 12 : 0),
                              child: PermissionScreenWidgets.formCard(
                                child: Column(
                                  children: PermissionScreenWidgets.intersperseDividers(tiles, indent: 28),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
        ),
        bottomNavigationBar: state.isShimmering || state.categoriesPermissionList.isEmpty
            ? null
            : PermissionScreenWidgets.bottomSaveBar(
                text: l10n.save.toUpperCase(),
                isLoading: state.isUpdateProcess,
                onPressed: () => bloc.add(CategoriesPermissionEvent.updateCategoriesPermissionEvent(context: context)),
              ),
      );
    });
  }
}
