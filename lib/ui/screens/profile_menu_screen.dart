import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_detector/focus_detector.dart';
import '../../bloc/bottom_nav/bottom_nav_bloc.dart';
import '../../bloc/profile_menu/profile_menu_bloc.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/themes/app_colors.dart';
import '../../ui/utils/themes/app_constants.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../../ui/utils/themes/app_styles.dart';
import '../../ui/widget/sized_box_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utils/themes/app_img_path.dart';
import '../utils/themes/app_urls.dart';
import '../widget/common_alert_dialog.dart';
import '../widget/common_dialog_with_one_button.dart';

class ProfileMenuRoute {
  static Widget get route => const ProfileMenuScreen();
}

class ProfileMenuScreen extends StatelessWidget {
  const ProfileMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileMenuBloc()
        ..add(const ProfileMenuEvent.getAppLanguage())
        ..add(const ProfileMenuEvent.getPreferenceDataEvent())
      ..add( ProfileMenuEvent.getStatusInfoEvent(context: context)),
      child: const ProfileMenuScreenWidget(),
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
        if (current.isAccountPermissionShimmering){

        }
        if(current.isAppOnMaintenance && !current.isDialogOpen){
          appUnderMaintenanceDialog(context: context, state: current);
          BlocProvider.of<ProfileMenuBloc>(context)
              .add(ProfileMenuEvent.updateMaintenanceEvent(context: context));
        }
        if (previous.isHebrewLanguage != current.isHebrewLanguage) {
          return true;
        } else {
          return false;
        }
      },
      listener: (context, state) async {

       context.read<BottomNavBloc>().add(BottomNavEvent.changePage(index: 0,context: context));

      },
      child: BlocBuilder<ProfileMenuBloc, ProfileMenuState>(
        builder: (context, state) {
          return FocusDetector(
            onFocusGained: () {
              bloc.add(ProfileMenuEvent.userApproveEvent(context: context));
              bloc.add(ProfileMenuEvent.getPermissionList(context: context));
              bloc.add(const ProfileMenuEvent.getPreferenceDataEvent());
              bloc.add(const ProfileMenuEvent.getAppLanguage());
              bloc.add(ProfileMenuEvent.generalSettings(context: context,dialogContext: context,isRetryLoading: false));
              bloc.add(ProfileMenuEvent.getProfileDetailsEvent(context: context));
            },
            child: Scaffold(
              backgroundColor: AppColors.pageColor,
              body: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    10.height,
                    Container(
                      height: 110,
                      width: double.maxFinite,
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.padding_10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color:
                                  AppColors
                                      .whiteColor,
                              border: Border.all(
                                  color: AppColors.whiteColor, width: 0.5),
                              boxShadow: [
                                BoxShadow(
                                    color: AppColors.shadowColor.withOpacity(
                                            0.1) ,
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
                                          '${AppUrlEndPoints.baseFileUrl}${state.UserImageUrl}',
                                      fit: BoxFit.fill,
                                      placeholder: (context, url) =>
                                          const CupertinoActivityIndicator(),
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
                                    ),
                                  ),
                          ),
                          Text(
                            state.userName,
                            style: AppStyles.rkRegularTextStyle(
                              size: 20,
                              color: AppColors.blackColor,
                            ),
                          ),
                    SvgPicture.asset(
                                  AppImagePath.splashLogo,
                                  fit: BoxFit.cover,
                                  height: 90,
                                  width: 90,
                                )
                        ],
                      ),
                    ),
                   Expanded(
                      child: SingleChildScrollView(
                        child:  AnimationLimiter(
                          child: Column(
                            children: AnimationConfiguration.toStaggeredList(
                              duration: const Duration(seconds: 1),
                              childAnimationBuilder: (widget) => SlideAnimation(
                                  duration: const Duration(seconds: 1),
                                  verticalOffset:
                                      MediaQuery.of(context).size.height / 5,
                                  child: FadeInAnimation(child: widget)),
                              children: [
                                15.height,
                                state.isSubUserSeeOrder ? profileMenuTiles(
                                    title:
                                        AppLocalizations.of(context)!.my_orders,
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        RouteDefine.orderScreen.name,
                                      );
                                    }) : 0.width,
                                state.isCanSeeInvoices ?  profileMenuTiles(
                                    title:
                                    AppLocalizations.of(context)!.my_invoices,
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        RouteDefine.invoiceScreen.name,
                                      );
                                    })
                                  : 0.width,


                                state.isCanSeeInvoices ?  profileMenuTiles(
                                    title:
                                    AppLocalizations.of(context)!.returns,
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        RouteDefine.returnListScreen.name,
                                      );
                                    }) : 0.width,
                               state.isSubUserUpdateBusinessInfo ?  profileMenuTiles(
                                    title: AppLocalizations.of(context)!
                                        .business_details,
                                    onTap: () {
                                      Navigator.pushNamed(context,
                                          RouteDefine.profileScreen.name,
                                          arguments: {
                                            AppStrings.isUpdateParamString: true
                                          });
                                    }) : 0.width,
                                state.isSubUserUpdateAdditionalInfo ? profileMenuTiles(
                                    title: AppLocalizations.of(context)!
                                        .more_details,
                                    onTap: () {
                                      Navigator.pushNamed(context,
                                          RouteDefine.moreDetailsScreen.name,
                                          arguments: {
                                            AppStrings.isUpdateParamString: true
                                          });
                                    }) : 0.width,
                               state.isSubUserUpdateTimeInfo? profileMenuTiles(
                                    title: AppLocalizations.of(context)!
                                        .activity_time,
                                    onTap: () {
                                      Navigator.pushNamed(context,
                                          RouteDefine.activityTimeScreen.name,
                                          arguments: {
                                            AppStrings.isUpdateParamString: true
                                          });
                                    }) : 0.width,
                                state.isSubUserSeeFormsFiles ? profileMenuTiles(
                                    title: AppLocalizations.of(context)!
                                        .files,
                                    onTap: () {
                                      Navigator.pushNamed(context,
                                          RouteDefine.fileUploadScreen.name,
                                          arguments: {
                                            AppStrings.isUpdateParamString: true
                                          });
                                    }) : 0.width,
                             state.isSubUserCanManageSubUser ? profileMenuTiles(
                                    title:
                                    AppLocalizations.of(context)!.sub_user,
                                    onTap: () {
                                      Navigator.pushNamed(context,
                                          RouteDefine.subUsersScreen.name,
                                        );
                                    }) : 0.width,
                              state.isSubUserCanManageSubUser ? profileMenuTiles(
                                    title:
                                    AppLocalizations.of(context)!.manage_credit_card,
                                    onTap: () {
                                      Navigator.pushNamed(context,
                                        RouteDefine.manageCreditCardScreen.name,
                                      );
                                    }) : 0.width,
                                 profileMenuTiles(
                                    title:
                                    AppLocalizations.of(context)!.bank_transfer_information,
                                    onTap: () {
                                      Navigator.pushNamed(context,
                                        RouteDefine.bankTransferScreen.name,
                                      );
                                    }) ,
                                profileMenuTiles(
                                    title:
                                        AppLocalizations.of(context)!.log_out,
                                    onTap: () {
                                      !state.isLogOutProcess
                                          ? logOutDialog(
                                              context: context,
                                              directionality: state.language)
                                          : const CupertinoActivityIndicator();
                                    }),
                                menuSwitchTile(
                                    title: AppLocalizations.of(context)!
                                        .app_language,
                                    isHebrewLang: state.isHebrewLanguage,
                                    onChanged: (bool value) {
                                      context.read<ProfileMenuBloc>().add(
                                          ProfileMenuEvent
                                              .changeAppLanguageEvent(
                                                  context: context));
                                    }),
                                AppConstants.bottomNavSpace.height,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    10.height,
                    Text('${AppLocalizations.of(context)!.application_version}${' '}${state.applicationVersion} (${state.buildNumber})',
                      style: AppStyles.rkRegularTextStyle(
                              size: AppConstants.smallFont,
                              color: AppColors.blackColor,
                        fontWeight: FontWeight.bold,
                      )
                    ),
                    20.height,
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget profileMenuTiles({required title, required void Function() onTap,bool isDelete = false}) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(AppConstants.radius_5)),
          boxShadow: [
            BoxShadow(
                color: AppColors.shadowColor.withOpacity(0.15),
                blurRadius: AppConstants.blur_10)
          ]),
      margin: const EdgeInsets.symmetric(
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
                    color: isDelete?AppColors.redColor:AppColors.blackColor),
              ),
              Icon(
                isDelete?Icons.delete:Icons.arrow_forward_ios,
                color:  isDelete?AppColors.redColor:AppColors.blackColor,
              ),
            ],
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
              const BorderRadius.all(Radius.circular(AppConstants.radius_5)),
          boxShadow: [
            BoxShadow(
                color: AppColors.shadowColor.withOpacity(0.15),
                blurRadius: AppConstants.blur_10)
          ]),
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

  void logOutDialog({
    required BuildContext context,
    required String directionality,
  }) {
    showDialog(
      context: context,
      builder: (context1) => BlocProvider.value(
        value: context.read<ProfileMenuBloc>(),
        child: BlocBuilder<ProfileMenuBloc, ProfileMenuState>(
          builder: (context, state) {
            ProfileMenuBloc bloc = context.read<ProfileMenuBloc>();
            return CommonAlertDialog(
              isLogOutProcess: state.isLogOutProcess,
              directionality: directionality,
              title: AppLocalizations.of(context)!.log_out,
              subTitle: AppLocalizations.of(context)!.are_you_sure,
              positiveTitle: AppLocalizations.of(context)!.yes,
              negativeTitle: AppLocalizations.of(context)!.no,
              negativeOnTap: () {
                Navigator.pop(context);
              },
              positiveOnTap: () async {
                bloc.add(ProfileMenuEvent.logOutEvent(context: context));
              },
            );
          },
        ),
      ),
    );
  }

  appUnderMaintenanceDialog({
    required BuildContext context,
    required ProfileMenuState state
  }) {
    if (!state.isDialogOpen){
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context1) =>
            BlocProvider.value(
              value: context.read<ProfileMenuBloc>(),
              child: BlocBuilder<ProfileMenuBloc, ProfileMenuState>(
                builder: (context, state) {
                  ProfileMenuBloc bloc = context.read<ProfileMenuBloc>();
                  return CustomOneButtonDialog(
                    isLoading: state.retryLoading,
                    directionality: state.language,
                    title: AppLocalizations.of(context)!.under_maintenance,
                    positiveTitle: AppLocalizations.of(context)!.retry,
                    positiveOnTap: () async {
                      bloc.add(ProfileMenuEvent.generalSettings(
                        context: context,
                        dialogContext: context1,
                        isRetryLoading: true
                      ));
                    },
                  );
                },
              ),
            ),
      );
    }
    else{
      context.read<ProfileMenuBloc>().add(ProfileMenuEvent.updateMaintenanceEvent(context: context));
    }
  }
}
