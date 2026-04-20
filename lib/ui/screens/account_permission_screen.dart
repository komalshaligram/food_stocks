import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../ui/widget/order_summary_screen_shimmer_widget.dart';
import '../../ui/widget/sized_box_widget.dart';
import '../../bloc/account_permission/account_permission_bloc.dart';
import '../utils/app_utils.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_strings.dart';
import '../utils/constants/app_styles.dart';
import '../widget/common_app_bar.dart';
import '../widget/custom_button_widget.dart';

class AccountPermissionRoute {
  static Widget get route => const AccountPermissionScreen();
}

class AccountPermissionScreen extends StatelessWidget {
  const AccountPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
      create: (context) => AccountPermissionBloc()..add(AccountPermissionEvent.getPermissionList(context: context, subUserId: args?[AppStrings.subUserIdString] ?? '')),
      child: const AccountPermissionScreenWidget(),
    );
  }
}

class AccountPermissionScreenWidget extends StatelessWidget {
  const AccountPermissionScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    AccountPermissionBloc bloc = context.read<AccountPermissionBloc>();
    return BlocBuilder<AccountPermissionBloc, AccountPermissionState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: AppColors.pageColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
          child: CommonAppBar(
              bgColor: AppColors.pageColor,
              title: AppLocalizations.of(context)!.account_permission,
              iconData: Icons.arrow_back_ios_sharp,
              onTap: () {
                Navigator.pop(context);
              }),
        ),
        body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_10, vertical: AppConstants.padding_5),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: state.isShimmering
                    ? const OrderSummaryScreenShimmerWidget(itemCount: 10, containerHeight: 40)
                    : !state.isShimmering && state.permissionList.isEmpty
                        ? SizedBox(height: getScreenHeight(context) * 0.8, child: noDataWidget(AppLocalizations.of(context)!.no_data))
                        : Column(children: [
                            ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: state.permissionList.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                      padding: const EdgeInsets.only(bottom: AppConstants.padding_5),
                                      child: menuSwitchTile(
                                          title: state.permissionList[index].title,
                                          menuSwitchContext: context,
                                          isEnable: state.permissionList[index].isEnable,
                                          onChanged: (bool value) {
                                            bloc.add(AccountPermissionEvent.switchButtonEvent(context: context, index: index));
                                          }));
                                }),
                            20.height,
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_10),
                              child: CustomButtonWidget(
                                buttonText: AppLocalizations.of(context)!.save.toUpperCase(),
                                bGColor: AppColors.mainColor,
                                isLoading: state.isUpdateProcess,
                                onPressed: () {
                                  bloc.add(AccountPermissionEvent.updateAccountPermissionEvent(context: context));
                                },
                                fontColors: AppColors.whiteColor,
                              ),
                            ),
                            20.height,
                          ]),
              )),
        ),
      );
    });
  }

  Widget menuSwitchTile({required String title, required BuildContext menuSwitchContext, required bool isEnable, required void Function(bool)? onChanged}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        border: Border(bottom: BorderSide(color: AppColors.greyColor.withValues(alpha: 0.4))),
      ),
      margin: const EdgeInsets.symmetric(vertical: AppConstants.padding_5, horizontal: AppConstants.padding_10),
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          onChanged?.call(true);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_15, vertical: AppConstants.padding_5),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(child: Text(title, style: AppStyles.rkRegularTextStyle(size: AppConstants.font_17, color: AppColors.greyColor))),
            SizedBox(
              width: 45,
              child: Transform.scale(
                scaleX: 1,
                scaleY: 1,
                child: CupertinoSwitch(
                  onChanged: onChanged,
                  activeTrackColor: AppColors.mainColor,
                  thumbColor: AppColors.whiteColor,
                  inactiveTrackColor: AppColors.lightBorderColor,
                  value: isEnable,
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
