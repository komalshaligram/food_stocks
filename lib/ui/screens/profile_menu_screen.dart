import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:food_stock/bloc/bottom_nav/bottom_nav_bloc.dart';
import 'package:food_stock/bloc/profile_menu/profile_menu_bloc.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import 'package:food_stock/ui/widget/delayed_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utils/app_utils.dart';
import '../utils/themes/app_img_path.dart';
import '../utils/themes/app_urls.dart';

class ProfileMenuRoute {
  static Widget get route => ProfileMenuScreen();
}

class ProfileMenuScreen extends StatelessWidget {
  const ProfileMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileMenuBloc()
        ..add(ProfileMenuEvent.getAppLanguage())
        ..add(ProfileMenuEvent.getPreferenceDataEvent()),
      child: ProfileMenuScreenWidget(),
    );
  }
}

class ProfileMenuScreenWidget extends StatelessWidget {
  const ProfileMenuScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ProfileMenuBloc bloc = context.read<ProfileMenuBloc>();
    return BlocListener<ProfileMenuBloc, ProfileMenuState>(
      listenWhen: (previous, current) {
        if (previous.isHebrewLanguage != current.isHebrewLanguage) {
          return true;
        } else {
          return false;
        }
      },
      listener: (context, state) {
        context.read<BottomNavBloc>().add(BottomNavEvent.changePage(index: 0));
      },
      child: BlocBuilder<ProfileMenuBloc, ProfileMenuState>(
        builder: (context, state) {
          return FocusDetector(
            onFocusGained: () {
              bloc.add(ProfileMenuEvent.getPreferenceDataEvent());
              bloc.add(ProfileMenuEvent.getAppLanguage());
            },
            child: Scaffold(
              backgroundColor: AppColors.pageColor,
              body: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    15.height,
                    Container(
                      height: 90,
                      padding: EdgeInsets.symmetric(
                          horizontal: AppConstants.padding_10),
                      child: Row(
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color: /* state.UserImageUrl.isNotEmpty
                                  ? */
                                  AppColors
                                      .whiteColor /*: AppColors.mainColor.withOpacity(0.1)*/,
                              border: Border.all(
                                  color: AppColors.whiteColor, width: 0.5),
                              boxShadow: [
                                BoxShadow(
                                    color: /* state.UserImageUrl.isNotEmpty
                                        ? */
                                        AppColors.shadowColor.withOpacity(
                                            0.1) /*: AppColors.whiteColor*/,
                                    blurRadius: AppConstants.blur_10)
                              ],
                              shape: BoxShape.circle,
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: state.UserImageUrl.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          '${AppUrls.baseFileUrl}${state.UserImageUrl}',
                                      fit: BoxFit.fill,
                                      placeholder: (context, url) =>
                                          CupertinoActivityIndicator(),
                                      errorWidget: (context, url, error) {
                                        return Container(
                                          color: AppColors.whiteColor,
                                        );
                                      },
                                    ),
                                  )
                                : Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColors.whiteColor,
                                          width: 5),
                                      borderRadius:
                                          BorderRadius.circular(40)),
                                  child: SvgPicture.asset(
                                    AppImagePath.placeholderProfile,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.scaleDown,
                                    // colorFilter: ColorFilter.mode(
                                    //     AppColors.mainColor,
                                    //     BlendMode.dstIn),
                                  ),
                                ), /*Image.asset(
                                    AppImagePath.defaultProfileImage,
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.scaleDown,
                                  ) */ /*Icon(
                                    Icons.person,
                                    size: 60,
                                    color: AppColors.textColor,
                                  )*/
                          ),
                          20.width,
                          SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  state.UserCompanyLogoUrl.isEmpty
                                      ? 0.width
                                      : Expanded(
                                          child: CachedNetworkImage(
                                            placeholder: (context, url) => Container(
                                                decoration: BoxDecoration(
                                                    color: AppColors.whiteColor,
                                                    border: Border.all(
                                                        color: AppColors
                                                            .borderColor
                                                            .withOpacity(0.5),
                                                        width: 1)),
                                                alignment: Alignment.center,
                                                child: Container(
                                                    height: 50,
                                                    width: getScreenWidth(
                                                            context) *
                                                        0.35,
                                                    alignment: Alignment.center,
                                                    child:
                                                        const CupertinoActivityIndicator())),
                                            imageUrl:
                                                "${AppUrls.baseFileUrl}${state.UserCompanyLogoUrl}",
                                            height: 34,
                                            width:
                                                getScreenWidth(context) * 0.35,
                                            fit: BoxFit.fitHeight,
                                            alignment: context.rtl
                                                ? Alignment.centerRight
                                                : Alignment.centerLeft,
                                            errorWidget: (context, url, error) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  color: AppColors
                                                      .whiteColor /*AppColors.mainColor
                                                  .withOpacity(0.1)*/
                                                  ,
                                                  /*  border: Border.all(
                                                    color: AppColors.borderColor
                                                        .withOpacity(0.5),
                                                    width: 0)*/
                                                ),
                                                /*child: Icon(
                                              Icons
                                                  .image_not_supported_outlined,
                                              size: 25,
                                              color: AppColors.textColor,
                                            )*/
                                              );
                                            },
                                          ),
                                        ),
                                  10.height,
                                  Text(
                                    state.userName,
                                    style: AppStyles.rkRegularTextStyle(
                                      size: 20,
                                      color: AppColors.blackColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    15.height,
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            15.height,
                            profileMenuTiles(
                                title: AppLocalizations.of(context)!
                                    .business_details,
                                onTap: () {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  Navigator.pushNamed(
                                      context, RouteDefine.profileScreen.name,
                                      arguments: {
                                        AppStrings.isUpdateParamString: true
                                      });
                                }),
                            profileMenuTiles(
                                title:
                                    AppLocalizations.of(context)!.more_details,
                                onTap: () {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  Navigator.pushNamed(context,
                                      RouteDefine.moreDetailsScreen.name,
                                      arguments: {
                                        AppStrings.isUpdateParamString: true
                                      });
                                }),
                            profileMenuTiles(
                                title:
                                    AppLocalizations.of(context)!.activity_time,
                                onTap: () {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  Navigator.pushNamed(context,
                                      RouteDefine.activityTimeScreen.name,
                                      arguments: {
                                        AppStrings.isUpdateParamString: true
                                      });
                                }),
                            profileMenuTiles(
                                title:
                                    AppLocalizations.of(context)!.forms_files,
                                onTap: () {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  Navigator.pushNamed(context,
                                      RouteDefine.fileUploadScreen.name,
                                      arguments: {
                                        AppStrings.isUpdateParamString: true
                                      });
                                }),
                            profileMenuTiles(
                                title: AppLocalizations.of(context)!.log_out,
                                onTap: () {
                                  bloc.add(ProfileMenuEvent.logOutEvent(
                                      context: context));
                                  /*   context.read<ProfileMenuBloc>().add(
                                      ProfileMenuEvent.logOutEvent(
                                          context: context));*/
                                }),
                            menuSwitchTile(
                                title:
                                    AppLocalizations.of(context)!.app_language,
                                isHebrewLang: state.isHebrewLanguage,
                                onChanged: (bool value) {
                                  context.read<ProfileMenuBloc>().add(
                                      ProfileMenuEvent.changeAppLanguageEvent(
                                          context: context));
                                }),
                            AppConstants.bottomNavSpace.height,
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget profileMenuTiles({required title, required void Function() onTap}) {
    return DelayedWidget(
      child: Container(
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
                      size: AppConstants.smallFont,
                      color: AppColors.blackColor),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.blackColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget menuSwitchTile(
      {required String title,
      required bool isHebrewLang,
      required void Function(bool)? onChanged}) {
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
              Text(
                title,
                style: AppStyles.rkRegularTextStyle(
                    size: AppConstants.smallFont, color: AppColors.blackColor),
              ),
              SizedBox(
                width: 45,
                child: Transform.scale(
                  scaleX: 0.84,
                  scaleY: 0.8,
                  child: CupertinoSwitch(
                    value: isHebrewLang,
                    onChanged: onChanged,
                    activeColor: AppColors.mainColor,
                    thumbColor: AppColors.whiteColor,
                    trackColor: AppColors.lightBorderColor,
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
