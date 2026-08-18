import '../../ui/utils/club_agent.dart';
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
import '../../ui/utils/constants/app_colors.dart';
import '../../ui/utils/constants/app_constants.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/utils/constants/app_styles.dart';
import '../../ui/widget/sized_box_widget.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../utils/constants/app_img_path.dart';
import '../utils/constants/app_urls.dart';
import '../widget/dialogs/common_alert_dialog.dart';
import '../widget/dialogs/common_dialog_with_one_button.dart';
import '../widget/customer_service_contact_widget.dart';

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
          ..add(ProfileMenuEvent.getStatusInfoEvent(context: context)),
        child: const ProfileMenuScreenWidget());
  }
}

class ProfileMenuScreenWidget extends StatelessWidget {
  const ProfileMenuScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ProfileMenuBloc bloc = context.read<ProfileMenuBloc>();
    return BlocListener<ProfileMenuBloc, ProfileMenuState>(
      listenWhen: (previous, current) {
        if (current.isAccountPermissionShimmering) {}
        if (current.isAppOnMaintenance && !current.isDialogOpen) {
          appUnderMaintenanceDialog(context: context, state: current);
          BlocProvider.of<ProfileMenuBloc>(context).add(ProfileMenuEvent.updateMaintenanceEvent(context: context));
        }
        if (previous.isHebrewLanguage != current.isHebrewLanguage) {
          return true;
        } else {
          return false;
        }
      },
      listener: (context, state) async {
        context.read<BottomNavBloc>().add(BottomNavEvent.changePage(index: 0, context: context));
      },
      child: BlocBuilder<ProfileMenuBloc, ProfileMenuState>(builder: (context, state) {
        return FocusDetector(
          onFocusGained: () {
            bloc.add(ProfileMenuEvent.userApproveEvent(context: context));
            bloc.add(ProfileMenuEvent.getPermissionList(context: context));
            bloc.add(const ProfileMenuEvent.getPreferenceDataEvent());
            bloc.add(const ProfileMenuEvent.getAppLanguage());
            bloc.add(ProfileMenuEvent.generalSettings(context: context, dialogContext: context, isRetryLoading: false));
            bloc.add(ProfileMenuEvent.getProfileDetailsEvent(context: context));
          },
          child: Scaffold(
            backgroundColor: AppColors.pageColor,
            body: SafeArea(
              child: Column(mainAxisSize: MainAxisSize.max, children: [
                12.height,
                _buildProfileHeader(state),
                Expanded(
                  child: Stack(children: [
                    SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: AnimationLimiter(
                        child: Column(
                            children: AnimationConfiguration.toStaggeredList(
                                duration: const Duration(milliseconds: 400),
                                childAnimationBuilder: (widget) => SlideAnimation(
                                    duration: const Duration(milliseconds: 400), verticalOffset: 24, child: FadeInAnimation(child: widget)),
                                children: _buildMenuContent(context, state))),
                      ),
                    ),
                    state.isLoading
                        ? Positioned.fill(
                            child: Center(
                              child: SizedBox(
                                  height: 120,
                                  width: 120,
                                  child: CupertinoActivityIndicator(color: AppColors.mainColor, radius: AppConstants.radius_20)),
                            ),
                          )
                        : 0.width
                  ]),
                ),
                10.height,
                Text('${AppLocalizations.of(context)!.application_version}${' '}${state.applicationVersion} (${state.buildNumber})',
                    style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.blackColor.withValues(alpha: 0.45))),
                10.height
              ]),
            ),
          ),
        );
      }),
    );
  }

  static const double _menuHorizontalMargin = 16;
  static const double _menuGroupRadius = 16;

  Widget _buildProfileHeader(ProfileMenuState state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: _menuHorizontalMargin),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, 4))]),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(2.5),
          decoration: BoxDecoration(shape: BoxShape.circle, gradient: AppColors.appMainGradientColor),
          child: Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.whiteColor),
              clipBehavior: Clip.hardEdge,
              child: state.userImageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: '${AppUrlEndPoints.baseFileUrl}${state.userImageUrl}',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const CupertinoActivityIndicator(),
                      errorWidget: (context, url, error) => SvgPicture.asset(AppImagePath.placeholderProfile, fit: BoxFit.cover))
                  : SvgPicture.asset(AppImagePath.placeholderProfile, fit: BoxFit.scaleDown)),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(state.userName,
              style: AppStyles.rkBoldTextStyle(size: AppConstants.font_17, color: AppColors.blackColor),
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
        ),
        const SizedBox(width: 8),
        ClubAgent.isClubClient(state.clubAgentId)
            ? Image.asset(AppImagePath.clubAgentBlueLogo, fit: BoxFit.contain, width: 48, height: 48)
            : SvgPicture.asset(AppImagePath.splashLogo, fit: BoxFit.contain, width: 48, height: 48)
      ]),
    );
  }

  List<Widget> _buildMenuContent(BuildContext context, ProfileMenuState state) {
    final l10n = AppLocalizations.of(context)!;
    final activityTiles = <Widget>[];
    final settingsTiles = <Widget>[];
    final otherTiles = <Widget>[];

    void addTile(List<Widget> group, {required String title, required VoidCallback onTap, required IconData icon, bool isDestructive = false}) {
      group.add(profileMenuTile(title: title, onTap: onTap, icon: icon, isDestructive: isDestructive));
    }

    if (state.isCanScanDocuments) {
      addTile(activityTiles, title: l10n.certificate_scanning, icon: Icons.document_scanner_outlined, onTap: () {
        Navigator.pushNamed(context, RouteDefine.certificateScanningScreen.name);
      });
    }
    if (state.isSubUserSeeOrder) {
      addTile(activityTiles, title: l10n.my_orders, icon: Icons.receipt_long_outlined, onTap: () {
        Navigator.pushNamed(context, RouteDefine.orderScreen.name, arguments: {AppStrings.pushNavigationString: 'profileScreen'});
      });
    }
    if (state.isCanSeeInvoices) {
      addTile(activityTiles, title: l10n.my_accounting_card, icon: Icons.account_balance_wallet_outlined, onTap: () {
        Navigator.pushNamed(context, RouteDefine.myAccountingCardScreen.name);
      });
    }
    if (state.isSubUserSeeReturns) {
      addTile(activityTiles, title: l10n.returns, icon: Icons.assignment_return_outlined, onTap: () {
        Navigator.pushNamed(context, RouteDefine.returnListScreen.name, arguments: {AppStrings.pushNavigationString: 'profileScreen'});
      });
    }

    if (state.isSubUserUpdateBusinessInfo) {
      addTile(settingsTiles, title: l10n.business_details, icon: Icons.person_outline_rounded, onTap: () {
        Navigator.pushNamed(context, RouteDefine.profileScreen.name, arguments: {AppStrings.isUpdateParamString: true});
      });
    }
    if (state.isSubUserUpdateAdditionalInfo) {
      addTile(settingsTiles, title: l10n.more_details, icon: Icons.storefront_outlined, onTap: () {
        Navigator.pushNamed(context, RouteDefine.moreDetailsScreen.name, arguments: {AppStrings.isUpdateParamString: true});
      });
    }
    if (state.isSubUserUpdateTimeInfo) {
      addTile(settingsTiles, title: l10n.activity_time, icon: Icons.schedule_outlined, onTap: () {
        Navigator.pushNamed(context, RouteDefine.activityTimeScreen.name, arguments: {AppStrings.isUpdateParamString: true});
      });
    }
    if (state.isSubUserSeeFormsFiles) {
      addTile(settingsTiles, title: l10n.files, icon: Icons.folder_open_outlined, onTap: () {
        Navigator.pushNamed(context, RouteDefine.fileUploadScreen.name,
            arguments: {AppStrings.isUpdateParamString: true, AppStrings.isRegisterFileString: false});
      });
    }
    if (state.isSubUserCanManageSubUser) {
      addTile(settingsTiles, title: l10n.sub_user, icon: Icons.people_outline_rounded, onTap: () {
        Navigator.pushNamed(context, RouteDefine.subUsersScreen.name);
      });
      addTile(settingsTiles, title: l10n.manage_credit_card, icon: Icons.credit_card_outlined, onTap: () {
        Navigator.pushNamed(context, RouteDefine.manageCreditCardScreen.name);
      });
    }

    addTile(otherTiles, title: l10n.bank_transfer_information, icon: Icons.account_balance_outlined, onTap: () {
      Navigator.pushNamed(context, RouteDefine.bankTransferScreen.name);
    });
    if (state.isAgent!) {
      addTile(otherTiles, title: l10n.my_clients, icon: Icons.groups_outlined, onTap: () {
        Navigator.pushNamed(context, RouteDefine.myClientsScreen.name, arguments: {AppStrings.pushNavigationString: 'profileScreen'});
      });
    }
    addTile(otherTiles, title: l10n.customer_service, icon: Icons.headset_mic_outlined, onTap: () {
      showCustomerServiceBottomSheet(
          context: context, customerServicePhone: state.customerServicePhone, customerServiceWhatsApp: state.customerServiceWhatsApp);
    });
    if (state.isAgentSwitchToAssignedStore!) {
      addTile(otherTiles, title: l10n.switch_back_to_agent_view, icon: Icons.swap_horiz_rounded, onTap: () {
        if (state.isLoading) return;
        context.read<ProfileMenuBloc>().add(ProfileMenuEvent.switchAccountEvent(context: context));
      });
    }

    final sections = <Widget>[
      16.height,
      if (activityTiles.isNotEmpty) profileMenuGroup(children: activityTiles),
      if (settingsTiles.isNotEmpty) profileMenuGroup(children: settingsTiles),
      if (otherTiles.isNotEmpty) profileMenuGroup(children: otherTiles),
      menuSwitchTile(
          title: l10n.app_language,
          isHebrewLang: state.isHebrewLanguage,
          onChanged: (bool value) {
            context.read<ProfileMenuBloc>().add(ProfileMenuEvent.changeAppLanguageEvent(context: context));
          }),
      profileMenuGroup(children: [
        profileMenuTile(
            title: l10n.log_out,
            icon: Icons.logout_rounded,
            isDestructive: true,
            onTap: () {
              if (!state.isLogOutProcess) {
                logOutDialog(context: context, directionality: state.language);
              }
            })
      ]),
      AppConstants.bottomNavSpace.height
    ];

    return sections;
  }

  Widget profileMenuGroup({required List<Widget> children}) {
    if (children.isEmpty) return 0.width;
    return Container(
        margin: const EdgeInsets.fromLTRB(_menuHorizontalMargin, 0, _menuHorizontalMargin, 12),
        decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(_menuGroupRadius),
            boxShadow: [BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 2))]),
        clipBehavior: Clip.antiAlias,
        child: Column(mainAxisSize: MainAxisSize.min, children: _intersperseDividers(children)));
  }

  List<Widget> _intersperseDividers(List<Widget> children) {
    if (children.length <= 1) return children;
    final result = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      result.add(children[i]);
      if (i < children.length - 1) {
        result.add(Divider(height: 1, thickness: 1, indent: 68, color: AppColors.lightBorderColor.withValues(alpha: 0.6)));
      }
    }
    return result;
  }

  Widget profileMenuTile({required String title, required VoidCallback onTap, required IconData icon, bool isDestructive = false}) {
    final accentColor = isDestructive ? AppColors.redColor : AppColors.mainColor;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          child: Row(children: [
            Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(color: accentColor.withValues(alpha: isDestructive ? 0.1 : 0.12), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, size: 21, color: accentColor)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(title,
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.font_15,
                      color: isDestructive ? AppColors.redColor : AppColors.blackColor.withValues(alpha: 0.88),
                      fontWeight: FontWeight.w500)),
            ),
            Icon(Icons.chevron_right,
                size: 22, color: isDestructive ? AppColors.redColor.withValues(alpha: 0.5) : AppColors.blackColor.withValues(alpha: 0.25))
          ]),
        ),
      ),
    );
  }

  Widget menuSwitchTile({required String title, required bool isHebrewLang, required void Function(bool)? onChanged}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(_menuHorizontalMargin, 0, _menuHorizontalMargin, 12),
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(_menuGroupRadius),
          boxShadow: [BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 2))]),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(_menuGroupRadius),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () => onChanged?.call(true),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(children: [
              Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(color: AppColors.mainColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                  child: Icon(Icons.language_rounded, size: 21, color: AppColors.mainColor)),
              const SizedBox(width: 14),
              Expanded(
                child: Text(title,
                    style: AppStyles.rkRegularTextStyle(
                        size: AppConstants.font_15, color: AppColors.blackColor.withValues(alpha: 0.88), fontWeight: FontWeight.w500)),
              ),
              Transform.scale(
                scale: 0.88,
                child: CupertinoSwitch(
                    value: isHebrewLang,
                    onChanged: onChanged,
                    activeTrackColor: AppColors.mainColor,
                    thumbColor: AppColors.whiteColor,
                    inactiveTrackColor: AppColors.lightBorderColor),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  void logOutDialog({required BuildContext context, required String directionality}) {
    showDialog(
      context: context,
      builder: (context1) => BlocProvider.value(
        value: context.read<ProfileMenuBloc>(),
        child: BlocBuilder<ProfileMenuBloc, ProfileMenuState>(builder: (context, state) {
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
              });
        }),
      ),
    );
  }

  appUnderMaintenanceDialog({required BuildContext context, required ProfileMenuState state}) {
    if (!state.isDialogOpen) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context1) => BlocProvider.value(
          value: context.read<ProfileMenuBloc>(),
          child: BlocBuilder<ProfileMenuBloc, ProfileMenuState>(builder: (context, state) {
            ProfileMenuBloc bloc = context.read<ProfileMenuBloc>();
            return CustomOneButtonDialog(
                isLoading: state.retryLoading,
                directionality: state.language,
                title: AppLocalizations.of(context)!.under_maintenance,
                positiveTitle: AppLocalizations.of(context)!.retry,
                positiveOnTap: () async {
                  bloc.add(ProfileMenuEvent.generalSettings(context: context, dialogContext: context1, isRetryLoading: true));
                });
          }),
        ),
      );
    } else {
      context.read<ProfileMenuBloc>().add(ProfileMenuEvent.updateMaintenanceEvent(context: context));
    }
  }
}
