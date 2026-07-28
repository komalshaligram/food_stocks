import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/widget/my_clients_screen_shimmer_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../bloc/my_clients/my_clients_bloc.dart';
import '../../data/model/res_model/get_agent_clients_permitted_suppliers_res_model/get_agent_clients_permitted_suppliers_res_model.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_img_path.dart';
import '../utils/constants/app_styles.dart';
import '../utils/constants/app_urls.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_shimmer_widget.dart';
import '../widget/refresh_widget.dart';

class MyClientsRoute {
  static Widget get route => const MyClientsScreen();
}

class MyClientsScreen extends StatelessWidget {
  const MyClientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyClientsBloc()
        ..add(MyClientsEvent.getAgentClientsListEvent(context: context)),
      child: const MyClientsScreenWidget(),
    );
  }
}

class MyClientsScreenWidget extends StatelessWidget {
  const MyClientsScreenWidget({super.key});

  static const double _horizontalPadding = 16;

  @override
  Widget build(BuildContext context) {
    return BlocListener<MyClientsBloc, MyClientsState>(
      listener: (context, state) {},
      child:
          BlocBuilder<MyClientsBloc, MyClientsState>(builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.pageColor,
          resizeToAvoidBottomInset: true,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
            child: CommonAppBar(
              bgColor: AppColors.pageColor,
              title: AppLocalizations.of(context)!.my_clients,
              iconData: Icons.arrow_back_ios_new_rounded,
              trailingWidget: _buildAppBarIcon(),
              onTap: () => Navigator.pop(context),
            ),
          ),
          body: SafeArea(
            child: SmartRefresher(
              physics: const ClampingScrollPhysics(),
              enablePullDown: true,
              controller: state.refreshController,
              header: const RefreshWidget(),
              footer: CustomFooter(
                builder: (context, mode) {
                  if (mode == LoadStatus.loading) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CupertinoActivityIndicator()),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              enablePullUp: !state.isBottomOfProducts,
              onRefresh: () => context
                  .read<MyClientsBloc>()
                  .add(MyClientsEvent.refreshListEvent(context: context)),
              onLoading: () => context.read<MyClientsBloc>().add(
                  MyClientsEvent.getAgentClientsListEvent(context: context)),
              child: Stack(
                children: [
                  state.isShimmering
                      ? const MyClientsScreenShimmerWidget()
                      : Column(
                          children: [
                            _buildSearchField(context, state),
                            if (state.filteredClientsList.isNotEmpty)
                              _buildClientList(context, state)
                            else
                              Expanded(child: _buildEmptyState(context)),
                          ],
                        ),
                  if (state.isLoading)
                    Positioned.fill(
                      child: ColoredBox(
                        color: Colors.black.withValues(alpha: 0.04),
                        child: Center(
                            child: CupertinoActivityIndicator(
                                color: AppColors.mainColor,
                                radius: AppConstants.radius_20)),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildAppBarIcon() {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: AppColors.mainColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(Icons.groups_outlined, size: 21, color: AppColors.mainColor),
    );
  }

  Widget _buildSearchField(BuildContext context, MyClientsState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          _horizontalPadding, 8, _horizontalPadding, 12),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: state.searchController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                    color: AppColors.mainColor.withValues(alpha: 0.4))),
            filled: true,
            fillColor: AppColors.whiteColor,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            hintText: AppLocalizations.of(context)!.search,
            hintStyle: AppStyles.rkRegularTextStyle(
                size: AppConstants.font_14,
                color: AppColors.blackColor.withValues(alpha: 0.4)),
            prefixIcon: Icon(Icons.search_rounded,
                color: AppColors.blackColor.withValues(alpha: 0.35)),
            suffixIcon: state.searchQuery.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      state.searchController.clear();
                      context
                          .read<MyClientsBloc>()
                          .add(const MyClientsEvent.searchClients(query: ''));
                    },
                    icon: Icon(Icons.close_rounded,
                        color: AppColors.blackColor.withValues(alpha: 0.4)),
                  )
                : null,
          ),
          onChanged: (val) => context
              .read<MyClientsBloc>()
              .add(MyClientsEvent.searchClients(query: val)),
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: AppColors.mainColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.groups_outlined,
                size: 28, color: AppColors.mainColor),
          ),
          16.height,
          Text(
            AppLocalizations.of(context)!.no_data,
            style: AppStyles.rkRegularTextStyle(
                size: AppConstants.font_15,
                color: AppColors.blackColor.withValues(alpha: 0.55)),
          ),
        ],
      ),
    );
  }

  Widget _buildClientList(BuildContext context, MyClientsState state) {
    final clientsList = state.filteredClientsList;
    return Expanded(
      child: AnimationLimiter(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(
              _horizontalPadding, 0, _horizontalPadding, 16),
          itemCount: clientsList.length,
          separatorBuilder: (_, __) => 12.height,
          physics: const ClampingScrollPhysics(),
          itemBuilder: (context, index) => AnimationConfiguration.staggeredList(
            duration: const Duration(milliseconds: 400),
            position: index,
            child: SlideAnimation(
              verticalOffset: 24,
              child: FadeInAnimation(
                child: _buildClientCard(context, state, clientsList[index]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClientCard(
      BuildContext context, MyClientsState state, AgentStore client) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: AppColors.mainColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.storefront_outlined,
                size: 22, color: AppColors.mainColor),
          ),
          14.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  client.storeName ?? '',
                  style: AppStyles.rkBoldTextStyle(
                      size: AppConstants.font_15, color: AppColors.blackColor),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if ((client.storeRepresentativeName ?? '').isNotEmpty) ...[
                  4.height,
                  Text(
                    client.storeRepresentativeName ?? '',
                    style: AppStyles.rkRegularTextStyle(
                        size: AppConstants.font_13,
                        color: AppColors.blackColor.withValues(alpha: 0.7)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if ((client.address ?? '').isNotEmpty) ...[
                  4.height,
                  Text(
                    client.address ?? '',
                    style: AppStyles.rkRegularTextStyle(
                        size: AppConstants.font_12,
                        color: AppColors.blackColor.withValues(alpha: 0.45)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          8.width,
          Column(
            children: [
              _buildActionChip(
                label: l10n.clients_switch,
                isPrimary: true,
                onTap: () {
                  context
                      .read<MyClientsBloc>()
                      .add(MyClientsEvent.switchAccountEvent(
                        context: context,
                        clientsId: client.id!,
                        clientName: client.storeName ?? '',
                        businessName: client.storeRepresentativeName,
                      ));
                },
              ),
              8.height,
              _buildActionChip(
                label: l10n.clients_set_minimum,
                isPrimary: false,
                onTap: () => supplierListDialog(
                    context: context, state: state, client: client),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionChip(
      {required String label,
      required bool isPrimary,
      required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 108,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          decoration: BoxDecoration(
            gradient: isPrimary ? AppColors.appMainGradientColor : null,
            color: isPrimary ? null : AppColors.clubAgentBGColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppStyles.rkRegularTextStyle(
                size: AppConstants.font_12,
                color: AppColors.whiteColor,
                fontWeight: FontWeight.w500),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  void supplierListDialog(
      {required BuildContext context,
      required MyClientsState state,
      required AgentStore client}) {
    final supplierCount = client.suppliers?.length ?? 0;
    final sheetSize = getSheetSize(supplierCount);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      isDismissible: true,
      enableDrag: true,
      builder: (sheetContext) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: sheetSize,
          minChildSize: sheetSize,
          maxChildSize: supplierCount > 4 ? 0.9 : sheetSize,
          builder: (context1, scrollController) {
            return SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  color: AppColors.pageColor,
                ),
                child: client.suppliers == null || client.suppliers!.isEmpty
                    ? noDataWidget(
                        AppLocalizations.of(context)!.no_suppliers_found)
                    : Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () =>
                                      Navigator.of(sheetContext).pop(),
                                  icon: const Icon(Icons.close_rounded)),
                              Expanded(
                                child: Text(
                                  AppLocalizations.of(context)!.select_supplier,
                                  textAlign: TextAlign.center,
                                  style: AppStyles.rkBoldTextStyle(
                                      size: AppConstants.font_17,
                                      color: AppColors.blackColor),
                                ),
                              ),
                              const SizedBox(width: 48),
                            ],
                          ),
                          8.height,
                          Expanded(
                            child: ListView.separated(
                              controller: scrollController,
                              physics: const ClampingScrollPhysics(),
                              itemCount: client.suppliers!.length,
                              separatorBuilder: (_, __) => 10.height,
                              itemBuilder:
                                  (supplierListContext, suppliersIndex) {
                                final supplier =
                                    client.suppliers![suppliersIndex];
                                return Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => _onSupplierSelected(
                                      sheetContext: sheetContext,
                                      parentContext: context,
                                      client: client,
                                      supplier: supplier,
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: AppColors.whiteColor,
                                        borderRadius: BorderRadius.circular(14),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.shadowColor
                                                .withValues(alpha: 0.06),
                                            blurRadius: 12,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: AppColors
                                                      .lightBorderColor),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            padding: const EdgeInsets.all(4),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.network(
                                                "${AppUrlEndPoints.baseFileUrl}${supplier.logo}",
                                                height: 40,
                                                width: 40,
                                                fit: BoxFit.contain,
                                                loadingBuilder: (context, child,
                                                    loadingProgress) {
                                                  if (loadingProgress
                                                          ?.cumulativeBytesLoaded !=
                                                      loadingProgress
                                                          ?.expectedTotalBytes) {
                                                    return CommonShimmerWidget(
                                                      child: Container(
                                                          height: 40,
                                                          width: 40,
                                                          color: AppColors
                                                              .pageColor),
                                                    );
                                                  }
                                                  return child;
                                                },
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Image.asset(
                                                      AppImagePath
                                                          .imageNotAvailable5,
                                                      fit: BoxFit.cover,
                                                      height: 40,
                                                      width: 40);
                                                },
                                              ),
                                            ),
                                          ),
                                          12.width,
                                          Expanded(
                                            child: Text(
                                              supplier.supplierName!,
                                              style:
                                                  AppStyles.rkRegularTextStyle(
                                                      size:
                                                          AppConstants.font_14,
                                                      color:
                                                          AppColors.blackColor,
                                                      fontWeight:
                                                          FontWeight.w500),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          8.width,
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: supplier.isNoMinimum! ==
                                                      true
                                                  ? AppColors.notificationColor
                                                      .withValues(alpha: 0.15)
                                                  : AppColors.clubAgentBGColor
                                                      .withValues(alpha: 0.15),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              supplier.isNoMinimum! == true
                                                  ? AppLocalizations.of(
                                                          context)!
                                                      .clients_no_minimum
                                                  : '${AppLocalizations.of(context)!.clients_minimum_order} ${supplier.minOrderAmount} ₪',
                                              style:
                                                  AppStyles.rkRegularTextStyle(
                                                size: AppConstants.font_12,
                                                color: supplier.isNoMinimum! ==
                                                        true
                                                    ? AppColors.statusOpenColor
                                                    : AppColors
                                                        .clubAgentBGColor,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Icon(Icons.chevron_left_rounded,
                                              color: AppColors.blackColor
                                                  .withValues(alpha: 0.35)),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
              ),
            );
          },
        );
      },
    );
  }

  void _onSupplierSelected({
    required BuildContext sheetContext,
    required BuildContext parentContext,
    required AgentStore client,
    required Supplier supplier,
  }) {
    Navigator.of(sheetContext).pop();
    Future.delayed(const Duration(milliseconds: 200), () {
      confirmationDialog(
        context: parentContext,
        clientId: client.id!,
        supplierId: supplier.id!,
        isMinimum: supplier.isNoMinimum!,
      );
    });
  }

  double getSheetSize(int length) {
    if (length == 1) return 0.2;
    if (length == 2) return 0.3;
    return 0.5;
  }

  void confirmationDialog(
      {required BuildContext context,
      required String clientId,
      required String supplierId,
      required bool isMinimum}) {
    final language = context.read<MyClientsBloc>().state.language;
    final message = isMinimum
        ? AppLocalizations.of(context)!.confirmation_minimum
        : AppLocalizations.of(context)!.confirmation_no_minimum;

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 28),
          child: Directionality(
            textDirection:
                language == 'en' ? TextDirection.ltr : TextDirection.rtl,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor.withValues(alpha: 0.12),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.mainColor.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Icon(Icons.help_outline_rounded,
                          color: AppColors.mainColor, size: 30),
                    ),
                  ),
                  16.height,
                  Text(
                    AppLocalizations.of(context)!.are_you_sure,
                    textAlign: TextAlign.center,
                    style: AppStyles.rkBoldTextStyle(
                        size: AppConstants.font_17,
                        color: AppColors.blackColor),
                  ),
                  12.height,
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.font_14,
                      color: AppColors.blackColor.withValues(alpha: 0.65),
                    ).copyWith(height: 1.45),
                  ),
                  24.height,
                  _dialogButton(
                    AppLocalizations.of(context)!.yes,
                    () {
                      Navigator.of(dialogContext).pop();
                      Future.delayed(const Duration(milliseconds: 100), () {
                        context.read<MyClientsBloc>().add(
                              MyClientsEvent.updateAgentClientsNoMinimumEvent(
                                context: context,
                                clientsId: clientId,
                                supplierId: supplierId,
                                isNoMinimum: isMinimum ? false : true,
                              ),
                            );
                      });
                    },
                  ),
                  10.height,
                  _dialogButton(
                    AppLocalizations.of(context)!.no,
                    () => Navigator.of(dialogContext).pop(),
                    outlined: true,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _dialogButton(String title, VoidCallback onTap,
      {bool outlined = false}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: outlined ? null : AppColors.appMainGradientColor,
            color: outlined ? AppColors.pageColor : null,
            borderRadius: BorderRadius.circular(14),
            border:
                outlined ? Border.all(color: AppColors.lightBorderColor) : null,
          ),
          child: Text(
            title,
            style: AppStyles.rkRegularTextStyle(
              size: AppConstants.font_15,
              color: outlined
                  ? AppColors.blackColor.withValues(alpha: 0.7)
                  : AppColors.whiteColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
