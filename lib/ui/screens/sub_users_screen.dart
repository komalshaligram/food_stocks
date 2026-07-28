import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import 'package:focus_detector/focus_detector.dart';
import '../../ui/widget/sized_box_widget.dart';
import '../../ui/widget/sub_users_screen_shimmer_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../bloc/sub_users/sub_users_bloc.dart';
import '../../routes/app_routes.dart';
import '../utils/app_utils.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_strings.dart';
import '../utils/constants/app_styles.dart';
import '../widget/common_app_bar.dart';
import '../widget/refresh_widget.dart';

class SubUsersRoute {
  static Widget get route => const SubUserScreen();
}

class SubUserScreen extends StatelessWidget {
  const SubUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => SubUsersBloc()..add(SubUsersEvent.getSubUserList(context: context)), child: const SubUserScreenWidget());
  }
}

class SubUserScreenWidget extends StatelessWidget {
  const SubUserScreenWidget({super.key});

  static const double _horizontalPadding = 16;

  @override
  Widget build(BuildContext context) {
    SubUsersBloc bloc = context.read<SubUsersBloc>();
    return BlocBuilder<SubUsersBloc, SubUsersState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: AppColors.pageColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
          child: CommonAppBar(
              bgColor: AppColors.pageColor,
              title: AppLocalizations.of(context)!.sub_user,
              iconData: Icons.arrow_back_ios_new_rounded,
              trailingWidget: !state.isShimmering ? _buildNewUserButton(context, bloc) : null,
              onTap: () => Navigator.pop(context)),
        ),
        body: FocusDetector(
          onFocusGained: () {
            context.read<SubUsersBloc>().add(SubUsersEvent.getSubUserList(context: context));
          },
          child: SafeArea(
            child: SmartRefresher(
              enablePullDown: true,
              controller: state.refreshController,
              header: const RefreshWidget(),
              footer: CustomFooter(builder: (context, mode) {
                if (mode == LoadStatus.loading) {
                  return const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Center(child: CupertinoActivityIndicator()));
                }
                return const SizedBox.shrink();
              }),
              enablePullUp: !state.isBottomOfProducts,
              onRefresh: () {
                context.read<SubUsersBloc>().add(SubUsersEvent.refreshListEvent(context: context));
              },
              onLoading: () {
                context.read<SubUsersBloc>().add(SubUsersEvent.getSubUserList(context: context));
              },
              child: state.isShimmering
                  ? const SubUsersScreenShimmerWidget()
                  : state.subUserList.isEmpty
                      ? ListView(physics: const AlwaysScrollableScrollPhysics(), children: [_buildEmptyState(context)])
                      : ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(_horizontalPadding, 8, _horizontalPadding, 16),
                          itemCount: state.subUserList.length,
                          itemBuilder: (context, index) {
                            final user = state.subUserList[index];
                            return subUserTile(
                                title: user.contactName ?? '',
                                phoneNumber: user.phoneNumber ?? '',
                                onTap: () {
                                  bloc.add(SubUsersEvent.popEvent(context: context));
                                  Navigator.pushNamed(context, RouteDefine.subUsersProfileScreen.name, arguments: {
                                    AppStrings.isUpdateParamString: true,
                                    AppStrings.subUserIdString: user.id ?? '',
                                    AppStrings.subUserEmailString: user.email ?? '',
                                    AppStrings.subUserPhoneNumberString: user.phoneNumber ?? '',
                                    AppStrings.subUserIsraelIdString: user.israelId ?? '',
                                    AppStrings.subUserNameString: user.contactName ?? '',
                                    AppStrings.profileImageString: user.profileImage ?? ''
                                  });
                                });
                          },
                          separatorBuilder: (_, __) => 12.height),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildNewUserButton(BuildContext context, SubUsersBloc bloc) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => bloc.add(SubUsersEvent.userApproveEvent(context: context)),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(gradient: AppColors.appMainGradientColor, borderRadius: BorderRadius.circular(12)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.person_add_alt_1_rounded, color: AppColors.whiteColor, size: 18),
            const SizedBox(width: 4),
            Text(AppLocalizations.of(context)!.new_user,
                style: AppStyles.rkRegularTextStyle(size: AppConstants.font_13, color: AppColors.whiteColor, fontWeight: FontWeight.w500))
          ]),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return SizedBox(
      height: getScreenHeight(context) * 0.7,
      child: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(color: AppColors.mainColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(16)),
              child: Icon(Icons.people_outline_rounded, size: 28, color: AppColors.mainColor)),
          16.height,
          Text(AppLocalizations.of(context)!.no_data,
              style: AppStyles.rkRegularTextStyle(size: AppConstants.font_15, color: AppColors.blackColor.withValues(alpha: 0.55)))
        ]),
      ),
    );
  }

  Widget subUserTile({required String title, required String phoneNumber, required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 2))]),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          child: Row(children: [
            Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(color: AppColors.mainColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                child: Icon(Icons.person_outline_rounded, size: 22, color: AppColors.mainColor)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title,
                    style: AppStyles.rkRegularTextStyle(
                        size: AppConstants.font_15, color: AppColors.blackColor.withValues(alpha: 0.88), fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                if (phoneNumber.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(phoneNumber,
                      style: AppStyles.rkRegularTextStyle(size: AppConstants.font_13, color: AppColors.blackColor.withValues(alpha: 0.45)),
                      textDirection: TextDirection.ltr)
                ]
              ]),
            ),
            Icon(Icons.chevron_right, size: 22, color: AppColors.blackColor.withValues(alpha: 0.25))
          ]),
        ),
      ),
    );
  }
}
