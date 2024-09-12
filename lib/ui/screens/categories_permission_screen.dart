import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/bloc/categories_permission/categories_permission_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/widget/order_summary_screen_shimmer_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_strings.dart';
import '../utils/themes/app_styles.dart';
import '../widget/common_app_bar.dart';
import '../widget/custom_button_widget.dart';

class CategoriesPermissionRoute {
  static Widget get route => const CategoriesPermissionScreen();
}

class CategoriesPermissionScreen extends StatelessWidget {
  const CategoriesPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args =
    ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
      create: (context) => CategoriesPermissionBloc()..add(CategoriesPermissionEvent.getPermissionList(
          context: context,
          subUserId: args?[AppStrings.subUserIdString] ?? ''
      )),
      child: const CategoriesPermissionScreenWidget(),
    );
  }
}


class CategoriesPermissionScreenWidget extends StatelessWidget {
  const CategoriesPermissionScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    CategoriesPermissionBloc bloc = context.read<CategoriesPermissionBloc>();
    return BlocBuilder<CategoriesPermissionBloc, CategoriesPermissionState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.pageColor,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
            child: CommonAppBar(
              bgColor: AppColors.pageColor,
              title: AppLocalizations.of(context)!.categories_permissions,
              iconData: Icons.arrow_back_ios_sharp,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SafeArea(
            child:  Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_15),
              child: SingleChildScrollView(
                  child:state.isShimmering ?  const OrderSummaryScreenShimmerWidget(itemCount: 10,containerHeight: 40) :
                  !state.isShimmering && state.categoriesPermissionList.isEmpty ?
                  SizedBox(
                    height: getScreenHeight(context) * 0.8,
                    child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.no_data,
                          style: AppStyles.pVRegularTextStyle(
                              size: AppConstants.normalFont,
                              color: AppColors.blackColor,
                              fontWeight: FontWeight.w400),
                        )),
                  ): Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_20,vertical: AppConstants.padding_20 ),
                        child: Align(
                          alignment: Alignment.center,
                          child: CustomButtonWidget(
                           width: 150,
                            height: 40,
                            fontSize: AppConstants.font_14,
                            buttonText: !state.isSelectAll ? AppLocalizations.of(context)!.select_all.toUpperCase() : AppLocalizations.of(context)!.select_none.toUpperCase(),
                            bGColor: AppColors.mainColor,
                            onPressed:  () {
                              bloc.add(CategoriesPermissionEvent.switchButtonEvent(
                                  context: context,
                                  subCategoriesIndex: -2,
                                  categoriesIndex: -2
                              ));
                            },
                            fontColors: AppColors.whiteColor,
                          ),
                        ),
                      ),

                      5.height,
                      ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.categoriesPermissionList.length,
                        itemBuilder: (context, index) {
                          return  Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                          menuSwitchTile(
                          title: state.categoriesPermissionList[index].category?.categoryName ?? '',
                              context: context,
                              isEnable:state.categoriesPermissionList[index].isAllowed ?? false,
                              isSelectAll: state.isSelectAll,
                              onChanged: (bool value) {
                                bloc.add(CategoriesPermissionEvent.switchButtonEvent(
                                    context: context,
                                    categoriesIndex: index,
                                  subCategoriesIndex: -1
                                ));
                              }),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: SizedBox(
                                 width : getScreenWidth(context) * 0.8,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: state.categoriesPermissionList[index].subCategories?.length,
                                      itemBuilder: (context, index1) {
                                        return menuSwitchTile(
                                            title: state.categoriesPermissionList[index].subCategories?[index1].subCategoryData?.subCategoryName ?? '',
                                            context: context,
                                            isEnable:state.categoriesPermissionList[index].subCategories?[index1].isAllowed ?? false,
                                            isSelectAll: state.isSelectAll,
                                            isSubCategories: true,
                                            onChanged: (bool value) {
                                              bloc.add(CategoriesPermissionEvent.switchButtonEvent(
                                                  context: context,
                                                  categoriesIndex: index,
                                                subCategoriesIndex: index1
                                              ));
                                            });
                                      },
                                  ),
                                ),
                              )
                            ],
                          );

                        },
                      ),

                    ],
                  ),
                ),
            ),
          ),
          bottomNavigationBar: state.isShimmering || state.categoriesPermissionList.isEmpty ? const SizedBox() : Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_20,vertical: AppConstants.padding_20 ),
            child: CustomButtonWidget(
              buttonText: AppLocalizations.of(context)!.save.toUpperCase(),
              bGColor: AppColors.mainColor,
              isLoading: state.isUpdateProcess,
              onPressed:  () {
                bloc.add(CategoriesPermissionEvent.updateCategoriesPermissionEvent(context: context));
              },
              fontColors: AppColors.whiteColor,
            ),
          ),

        );
      },
    );
  }

  Widget menuSwitchTile(
      {required String title,required BuildContext context, required bool isEnable,
        required void Function(bool)? onChanged,
         bool isSubCategories = false,
      bool isSelectAll = false,
      }) {
    return Container(

      decoration: BoxDecoration(
          color: AppColors.whiteColor,
        border: Border(
          bottom: BorderSide(
              color: AppColors.greyColor.withOpacity(0.4)),
        ),

      ),
      margin: const EdgeInsets.symmetric(
          vertical: AppConstants.padding_10,
          horizontal: AppConstants.padding_10),
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          onChanged?.call(true);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.padding_15,
              vertical: AppConstants.padding_8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.font_17, color: AppColors.greyColor),
                ),
              ),
              SizedBox(
                width: 45,
                child: Transform.scale(
                  scaleX: 1,
                  scaleY: 1,
                  child: CupertinoSwitch(
                    onChanged: onChanged,
                    activeColor: AppColors.mainColor,
                    thumbColor: AppColors.whiteColor,
                    trackColor: AppColors.lightBorderColor,
                    value: /*isSelectAll ? true :*/ isEnable,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
