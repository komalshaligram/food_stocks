import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../../ui/widget/permission_screen_widgets.dart';
import '../../ui/widget/sized_box_widget.dart';
import '../../bloc/account_permission/account_permission_bloc.dart';
import '../utils/app_utils.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_strings.dart';
import '../widget/common_app_bar.dart';

class AccountPermissionRoute {
  static Widget get route => const AccountPermissionScreen();
}

class AccountPermissionScreen extends StatelessWidget {
  const AccountPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
        create: (context) => AccountPermissionBloc()
          ..add(AccountPermissionEvent.getPermissionList(context: context, subUserId: args?[AppStrings.subUserIdString] ?? '')),
        child: const AccountPermissionScreenWidget());
  }
}

class AccountPermissionScreenWidget extends StatelessWidget {
  const AccountPermissionScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    AccountPermissionBloc bloc = context.read<AccountPermissionBloc>();
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<AccountPermissionBloc, AccountPermissionState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: AppColors.pageColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
          child: CommonAppBar(
              bgColor: AppColors.pageColor,
              title: l10n.account_permission,
              iconData: Icons.arrow_back_ios_new_rounded,
              trailingWidget: PermissionScreenWidgets.appBarIcon(Icons.admin_panel_settings_outlined),
              onTap: () => Navigator.pop(context)),
        ),
        body: SafeArea(
          child: state.isShimmering
              ? const PermissionScreenShimmerWidget()
              : state.permissionList.isEmpty
                  ? Center(child: noDataWidget(l10n.no_data))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(PermissionScreenWidgets.horizontalPadding, 8, PermissionScreenWidgets.horizontalPadding, 32),
                      physics: const ClampingScrollPhysics(),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                        PermissionScreenWidgets.formCard(
                            child: Column(
                                children: PermissionScreenWidgets.intersperseDividers(
                          List.generate(state.permissionList.length, (index) {
                            final item = state.permissionList[index];
                            return PermissionScreenWidgets.switchTile(
                                title: item.title,
                                value: item.isEnable,
                                onChanged: (_) {
                                  bloc.add(AccountPermissionEvent.switchButtonEvent(context: context, index: index));
                                });
                          }),
                        ))),
                        24.height,
                        PermissionScreenWidgets.saveButton(
                            text: l10n.save.toUpperCase(),
                            isLoading: state.isUpdateProcess,
                            onPressed: () {
                              bloc.add(AccountPermissionEvent.updateAccountPermissionEvent(context: context));
                            })
                      ])),
        ),
      );
    });
  }
}
