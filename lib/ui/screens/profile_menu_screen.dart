import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/bloc/profile_menu/profile_menu_bloc.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utils/themes/app_urls.dart';

class ProfileMenuRoute {
  static Widget get route => ProfileMenuScreen();
}

class ProfileMenuScreen extends StatelessWidget {
  const ProfileMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProfileMenuBloc()..add(ProfileMenuEvent.getPreferenceDataEvent()),
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
                    height: 80,
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
                          child: state.UserImageUrl.isNotEmpty ? ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              imageUrl: '${AppUrls.baseFileUrl}' +
                                  '${state.UserImageUrl}',
                              fit: BoxFit.fill,
                            ),
                          ) : SizedBox(),
                        ),
                        25.width,
                        Padding(
                          padding:
                              EdgeInsets.only(top: AppConstants.padding_20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 34,
                                width: getScreenHeight(context) * 0.18,
                                child: state.UserCompanyLogoUrl.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: '${AppUrls.baseFileUrl}' +
                                            '${state.UserCompanyLogoUrl}',
                                        fit: BoxFit.fill,
                                      )
                                    : SizedBox(),
                              ),
                              5.height,
                              Text(
                                state.userName,
                                style: AppStyles.rkRegularTextStyle(
                                  size: AppConstants.mediumFont,
                                  color: AppColors.greyColor,
                                ),
                              ),
                            ],
                          ),
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
