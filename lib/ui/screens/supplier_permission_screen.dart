import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/supplier_permission/supplier_permission_bloc.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../../ui/widget/permission_screen_widgets.dart';
import '../../ui/widget/sized_box_widget.dart';
import '../utils/app_utils.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_strings.dart';
import '../widget/common_app_bar.dart';

class SupplierPermissionRoute {
  static Widget get route => const SupplierPermissionScreen();
}

class SupplierPermissionScreen extends StatelessWidget {
  const SupplierPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
      create: (context) => SupplierPermissionBloc()
        ..add(SupplierPermissionEvent.getPermissionList(
            context: context,
            subUserId: args?[AppStrings.subUserIdString] ?? '')),
      child: const SupplierPermissionScreenWidget(),
    );
  }
}

class SupplierPermissionScreenWidget extends StatelessWidget {
  const SupplierPermissionScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    SupplierPermissionBloc bloc = context.read<SupplierPermissionBloc>();
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<SupplierPermissionBloc, SupplierPermissionState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.pageColor,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
            child: CommonAppBar(
              bgColor: AppColors.pageColor,
              title: l10n.supplier_permissions,
              iconData: Icons.arrow_back_ios_new_rounded,
              trailingWidget: PermissionScreenWidgets.appBarIcon(
                  Icons.local_shipping_outlined),
              onTap: () => Navigator.pop(context),
            ),
          ),
          body: SafeArea(
            child: state.isShimmering
                ? const PermissionScreenShimmerWidget()
                : state.supplierPermissionList.isEmpty
                    ? Center(child: noDataWidget(l10n.no_data))
                    : SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(
                          PermissionScreenWidgets.horizontalPadding,
                          8,
                          PermissionScreenWidgets.horizontalPadding,
                          100,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            PermissionScreenWidgets.selectAllButton(
                              text: !state.isSelectAll
                                  ? l10n.select_all.toUpperCase()
                                  : l10n.select_none.toUpperCase(),
                              onPressed: () => bloc.add(
                                  SupplierPermissionEvent.switchButtonEvent(
                                      context: context, index: -1)),
                            ),
                            16.height,
                            PermissionScreenWidgets.formCard(
                              child: Column(
                                children:
                                    PermissionScreenWidgets.intersperseDividers(
                                  List.generate(
                                      state.supplierPermissionList.length,
                                      (index) {
                                    final item =
                                        state.supplierPermissionList[index];
                                    return PermissionScreenWidgets.switchTile(
                                      title: item.title,
                                      value: item.isEnable,
                                      onChanged: (_) {
                                        bloc.add(SupplierPermissionEvent
                                            .switchButtonEvent(
                                                context: context,
                                                index: index));
                                      },
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
          ),
          bottomNavigationBar:
              state.isShimmering || state.supplierPermissionList.isEmpty
                  ? null
                  : PermissionScreenWidgets.bottomSaveBar(
                      text: l10n.save.toUpperCase(),
                      isLoading: state.isUpdateProcess,
                      onPressed: () => bloc.add(
                          SupplierPermissionEvent.updateSupplierPermissionEvent(
                              context: context)),
                    ),
        );
      },
    );
  }
}
