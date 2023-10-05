import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/bloc/profile_menu/profile_menu_bloc.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utils/themes/app_img_path.dart';

class ProfileMenuRoute {
  static Widget get route => ProfileMenuScreen();
}

class ProfileMenuScreen extends StatelessWidget {
  const ProfileMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileMenuBloc(),
      child: ProfileMenuScreenWidget(),
    );
  }
}

class ProfileMenuScreenWidget extends StatelessWidget {
  const ProfileMenuScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileMenuBloc, ProfileMenuState>(
      listener: (context, state) {},
      child: BlocBuilder<ProfileMenuBloc, ProfileMenuState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.pageColor,
            body: SafeArea(
              child: Column(
                children: [
                  10.height,
                  Container(
                    height: 70,
                    padding: EdgeInsets.symmetric(
                        horizontal: AppConstants.padding_10),
                    child: Row(
                      children: [
                        Container(
                          // height: 60,
                          // width: 60,
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            boxShadow: [
                              BoxShadow(
                                  color: AppColors.shadowColor.withOpacity(0.3),
                                  blurRadius: AppConstants.blur_10)
                            ],
                            shape: BoxShape.circle,
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: Image.asset(
                            AppImagePath.profileImage,
                          ),
                        ),
                        20.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Image.asset(
                                AppImagePath.companyLogo,
                              ),
                            ),
                            Text(
                              "Customer's Name",
                              style: AppStyles.rkRegularTextStyle(
                                size: 20,
                                color: AppColors.textColor,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  30.height,
                  profileMenuTiles(
                      title: AppLocalizations.of(context)!.business_details,
                      onTap: () {
                        Navigator.pushNamed(
                            context, RouteDefine.profileScreen.name,
                            arguments: {AppStrings.isUpdateParamString: true});
                      }),
                  profileMenuTiles(
                      title: AppLocalizations.of(context)!.more_details,
                      onTap: () {
                        Navigator.pushNamed(
                            context, RouteDefine.moreDetailsScreen.name,
                            arguments: {AppStrings.isUpdateParamString: true});
                      }),
                  profileMenuTiles(
                      title: AppLocalizations.of(context)!.operation_time,
                      onTap: () {
                        Navigator.pushNamed(
                            context, RouteDefine.operationTimeScreen.name,
                            arguments: {AppStrings.isUpdateParamString: true});
                      }),
                  profileMenuTiles(
                      title: AppLocalizations.of(context)!.forms_files,
                      onTap: () {
                        Navigator.pushNamed(
                            context, RouteDefine.fileUploadScreen.name,
                            arguments: {AppStrings.isUpdateParamString: true});
                      }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget profileMenuTiles({required title, required void Function() onTap}) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius:
              BorderRadius.all(Radius.circular(AppConstants.radius_5)),
          boxShadow: [
            BoxShadow(
                color: AppColors.shadowColor.withOpacity(0.15),
                blurRadius: AppConstants.blur_10)
          ]),
      margin: EdgeInsets.symmetric(
          vertical: AppConstants.padding_5,
          horizontal: AppConstants.padding_10),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.padding_15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppStyles.rkRegularTextStyle(
                    size: AppConstants.smallFont, color: AppColors.blackColor),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.blackColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}