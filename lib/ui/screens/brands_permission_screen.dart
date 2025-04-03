import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/brands_permission/brands_permission_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../ui/widget/sized_box_widget.dart';
import '../utils/app_utils.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_strings.dart';
import '../utils/constants/app_styles.dart';
import '../widget/common_app_bar.dart';
import '../widget/custom_button_widget.dart';
import '../widget/order_summary_screen_shimmer_widget.dart';

class BrandsPermissionRoute {
  static Widget get route => const BrandsPermissionScreen();
}

class BrandsPermissionScreen extends StatelessWidget {
  const BrandsPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args =
    ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
      create: (context) => BrandsPermissionBloc()..add(BrandsPermissionEvent.getPermissionList(
          context: context,
          subUserId: args?[AppStrings.subUserIdString] ?? ''
      )),
      child: const BrandsPermissionScreenWidget(),
    );
  }
}


class BrandsPermissionScreenWidget extends StatelessWidget {
  const BrandsPermissionScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    BrandsPermissionBloc bloc = context.read<BrandsPermissionBloc>();
    return BlocBuilder<BrandsPermissionBloc, BrandsPermissionState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.pageColor,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
            child: CommonAppBar(
              bgColor: AppColors.pageColor,
              title: AppLocalizations.of(context)!.brand_permissions,
              iconData: Icons.arrow_back_ios_sharp,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_15),
              child: SingleChildScrollView(
                child: state.isShimmering ?  const OrderSummaryScreenShimmerWidget(itemCount: 20,containerHeight: 40) :
                !state.isShimmering && state.brandPermissionList.isEmpty ?
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
                ):Column(
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
                            bloc.add(BrandsPermissionEvent.switchButtonEvent(
                              context: context, index: -1,
                            ));
                          },
                          fontColors: AppColors.whiteColor,
                        ),
                      ),
                    ),
                    10.height,
                    ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.brandPermissionList.length,
                      itemBuilder: (context, index) {
                        return  Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: menuSwitchTile(
                              title: state.brandPermissionList[index].title,
                              context: context,
                              isEnable:state.brandPermissionList[index].isEnable,
                              onChanged: (bool value) {
                                bloc.add(BrandsPermissionEvent.switchButtonEvent(
                                    context: context,
                                    index: index
                                ));
                              }),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: state.isShimmering || state.brandPermissionList.isEmpty ? const SizedBox() :  Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_20,vertical: AppConstants.padding_20 ),
            child: CustomButtonWidget(
              buttonText: AppLocalizations.of(context)!.save.toUpperCase(),
              bGColor: AppColors.mainColor,
              isLoading: state.isUpdateProcess,
              onPressed:  () {
                bloc.add(BrandsPermissionEvent.updateBrandPermissionEvent(context: context));

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
        required void Function(bool)? onChanged}) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
        border: Border(
          bottom: BorderSide(
              color: AppColors.greyColor.withOpacity(0.4)),
        ),),
      margin: const EdgeInsets.symmetric(
          vertical: AppConstants.padding_5,
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
                    value: isEnable,
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
