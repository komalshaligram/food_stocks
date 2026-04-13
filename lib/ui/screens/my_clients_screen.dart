import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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
import '../widget/order_summary_screen_shimmer_widget.dart';
import '../widget/refresh_widget.dart';

class MyClientsRoute {
  static Widget get route => const MyClientsScreen();
}

class MyClientsScreen extends StatelessWidget {
  const MyClientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => MyClientsBloc()..add(MyClientsEvent.getAgentClientsListEvent(context: context)), child: const MyClientsScreenWidget());
  }
}

class MyClientsScreenWidget extends StatelessWidget {
  const MyClientsScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MyClientsBloc, MyClientsState>(
      listener: (context, state) {},
      child: BlocBuilder<MyClientsBloc, MyClientsState>(builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.pageColor,
          resizeToAvoidBottomInset: true,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
            child: CommonAppBar(
                bgColor: AppColors.pageColor,
                title: AppLocalizations.of(context)!.my_clients,
                iconData: Icons.arrow_back_ios_sharp,
                onTap: () {
                  Navigator.pop(context);
                }),
          ),
          body: SafeArea(
            child: SmartRefresher(
              enablePullDown: true,
              controller: state.refreshController,
              physics: const ClampingScrollPhysics(),
              header: const RefreshWidget(),
              footer: CustomFooter(builder: (context, mode) => const OrderSummaryScreenShimmerWidget(itemCount: 2)),
              enablePullUp: !state.isBottomOfProducts,
              onRefresh: () {
                context.read<MyClientsBloc>().add(MyClientsEvent.refreshListEvent(context: context));
              },
              onLoading: () {
                context.read<MyClientsBloc>().add(MyClientsEvent.getAgentClientsListEvent(context: context));
              },
              child: Stack(children: [
                state.isShimmering
                    ? const OrderSummaryScreenShimmerWidget(itemCount: 10)
                    : Column(children: [
                        searchWidget(context),
                        state.filteredClientsList.isNotEmpty
                            ? clientListWidget(state: state, context: context, clientsList: state.filteredClientsList)
                            : Expanded(
                                child: noDataWidget(AppLocalizations.of(context)!.no_data),
                              ),
                      ]),
                state.isLoading
                    ? Positioned.fill(
                        child: Center(
                        child: SizedBox(height: 120, width: 120, child: CupertinoActivityIndicator(color: AppColors.mainColor, radius: AppConstants.radius_20)),
                      ))
                    : 0.width
              ]),
            ),
          ),
        );
      }),
    );
  }

  Widget searchWidget(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(horizontal: AppConstants.padding_10, vertical: AppConstants.padding_10),
        width: getScreenWidth(context),
        height: 60,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_10, vertical: AppConstants.padding_10),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_100)),
          color: AppColors.whiteColor,
          border: Border.all(color: AppColors.borderColor.withValues(alpha: 0.5)),
          boxShadow: [BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.3), blurRadius: 2)],
        ),
        child: BlocBuilder<MyClientsBloc, MyClientsState>(builder: (context, state) {
          return TextField(
            controller: state.searchController,
            decoration: InputDecoration(
              border: AppStyles.searchFieldStyle(),
              enabledBorder: AppStyles.searchFieldStyle(),
              focusedBorder: AppStyles.searchFieldStyle(),
              filled: true,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              hintText: AppLocalizations.of(context)!.search,
              fillColor: AppColors.pageColor,
              prefixIcon: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(context.rtl ? pi : 0),
                child: Icon(Icons.search, color: AppColors.greyColor),
              ),
              suffixIcon: state.searchQuery.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        state.searchController.clear();
                        context.read<MyClientsBloc>().add(const MyClientsEvent.searchClients(query: ''));
                      },
                      child: const Icon(Icons.close),
                    )
                  : null,
            ),
            onChanged: (val) {
              context.read<MyClientsBloc>().add(MyClientsEvent.searchClients(query: val));
            },
            onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
          );
        }),
      );

  Widget clientListWidget({required MyClientsState state, required BuildContext context, required List<AgentStore> clientsList}) {
    return Expanded(
      child: AnimationLimiter(
        child: ListView.builder(
          itemCount: state.filteredClientsList.length,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemBuilder: (context, index) => AnimationConfiguration.staggeredList(
            duration: const Duration(seconds: 1),
            position: index,
            child: SlideAnimation(
              verticalOffset: 44.0,
              child: FadeInAnimation(
                child: Container(
                  margin: const EdgeInsets.all(AppConstants.padding_10),
                  padding: const EdgeInsets.all(AppConstants.padding_15),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    boxShadow: [BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.15), blurRadius: AppConstants.blur_10)],
                    borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_5)),
                  ),
                  child: Row(children: [
                    Expanded(
                      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(
                          clientsList[index].storeName ?? '',
                          style: AppStyles.rkRegularTextStyle(size: AppConstants.normalFont, color: AppColors.blackColor, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        Text(
                          clientsList[index].storeRepresentativeName ?? '',
                          style: AppStyles.rkRegularTextStyle(size: AppConstants.mediumFont, color: AppColors.blackColor, fontWeight: FontWeight.normal),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        Text(
                          clientsList[index].address ?? '',
                          style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.greyColor, fontWeight: FontWeight.normal),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ]),
                    ),
                    10.width,
                    Column(children: [
                      GestureDetector(
                        onTap: () {
                          context.read<MyClientsBloc>().add(MyClientsEvent.switchAccountEvent(
                                context: context,
                                clientsId: clientsList[index].id!,
                                clientName: (clientsList[index].storeName ?? ''),
                                businessName: clientsList[index].storeRepresentativeName,
                              ));
                        },
                        child: Container(
                          width: 115,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_10, horizontal: AppConstants.padding_2),
                          decoration: BoxDecoration(gradient: AppColors.appMainGradientColor, borderRadius: BorderRadius.circular(AppConstants.radius_10)),
                          child: Text(
                            AppLocalizations.of(context)!.clients_switch,
                            style: AppStyles.rkRegularTextStyle(size: AppConstants.font_12, color: AppColors.whiteColor, fontWeight: FontWeight.normal),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                      5.height,
                      GestureDetector(
                        onTap: () {
                          supplierListDialog(context: context, state: state, index: index);
                        },
                        child: Container(
                          width: 115,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_10, horizontal: AppConstants.padding_2),
                          decoration: BoxDecoration(color: AppColors.clubAgentBGColor, borderRadius: BorderRadius.circular(AppConstants.radius_10)),
                          child: Text(
                            AppLocalizations.of(context)!.clients_set_minimum,
                            style: AppStyles.rkRegularTextStyle(size: AppConstants.font_12, color: AppColors.whiteColor, fontWeight: FontWeight.normal),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ])
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  supplierListDialog({required BuildContext context, required MyClientsState state, required int index}) {
    showMaterialModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        expand: true,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppConstants.radius_10))),
        isDismissible: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        enableDrag: true,
        builder: (context1) {
          return SafeArea(
            bottom: true,
            child: DraggableScrollableSheet(
                expand: true,
                initialChildSize: state.clientsList[index].suppliers!.length == 1
                    ? 0.2
                    : state.clientsList[index].suppliers!.length == 2
                        ? 0.3
                        : 0.5,
                minChildSize: state.clientsList[index].suppliers!.length == 1
                    ? 0.2
                    : state.clientsList[index].suppliers!.length == 2
                        ? 0.3
                        : 0.5,
                maxChildSize: state.clientsList[index].suppliers!.length > 4 ? 0.9 : 0.5,
                builder: (BuildContext context1, ScrollController scrollController) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_10, horizontal: AppConstants.padding_2),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(AppConstants.radius_30), topRight: Radius.circular(AppConstants.radius_30)),
                      color: AppColors.whiteColor,
                    ),
                    child: state.clientsList[index].suppliers == null || state.clientsList[index].suppliers!.isEmpty
                        ? noDataWidget(AppLocalizations.of(context)!.no_suppliers_found)
                        : Column(children: [
                            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                              Expanded(child: 0.width),
                              Expanded(
                                flex: 4,
                                child: Text(
                                  AppLocalizations.of(context)!.select_supplier,
                                  textAlign: TextAlign.center,
                                  style: AppStyles.rkBoldTextStyle(size: AppConstants.normalFont, color: AppColors.blackColor, fontWeight: FontWeight.w600),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context1).pop();
                                    },
                                    child: Icon(Icons.close, size: 30, color: AppColors.blackColor)),
                              ),
                            ]),
                            Expanded(
                              child: AnimationLimiter(
                                child: ListView.builder(
                                  itemCount: state.clientsList[index].suppliers!.length,
                                  controller: scrollController,
                                  physics: const ClampingScrollPhysics(),
                                  itemBuilder: (supplierListContext, suppliersIndex) => AnimationConfiguration.staggeredList(
                                    duration: const Duration(milliseconds: 500),
                                    position: suppliersIndex,
                                    child: SlideAnimation(
                                      verticalOffset: 44.0,
                                      child: FadeInAnimation(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_8, horizontal: AppConstants.padding_15),
                                          child: Container(
                                            width: MediaQuery.of(context).size.width / 1.13,
                                            padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_15, horizontal: AppConstants.padding_10),
                                            decoration: BoxDecoration(
                                              color: AppColors.whiteColor,
                                              boxShadow: [BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.15), blurRadius: AppConstants.blur_10)],
                                              borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_5)),
                                            ),
                                            child: Row(children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(color: AppColors.borderColor, width: 1),
                                                    borderRadius: BorderRadius.circular(
                                                      AppConstants.radius_50,
                                                    )),
                                                padding: const EdgeInsets.all(AppConstants.padding_2),
                                                child: ClipOval(
                                                  child: Image.network("${AppUrlEndPoints.baseFileUrl}${state.clientsList[index].suppliers![suppliersIndex].logo}", height: 40, width: 40, fit: BoxFit.contain, loadingBuilder: (
                                                    context,
                                                    child,
                                                    loadingProgress,
                                                  ) {
                                                    if (loadingProgress?.cumulativeBytesLoaded != loadingProgress?.expectedTotalBytes) {
                                                      return CommonShimmerWidget(
                                                        child: Container(
                                                          height: 40,
                                                          width: 40,
                                                          decoration: BoxDecoration(
                                                            color: AppColors.whiteColor,
                                                            borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_10)),
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                    return child;
                                                  }, errorBuilder: (context, error, stackTrace) {
                                                    return Image.asset(AppImagePath.imageNotAvailable5, fit: BoxFit.cover, height: 40, width: 40);
                                                  }),
                                                ),
                                              ),
                                              10.width,
                                              Text(
                                                state.clientsList[index].suppliers![suppliersIndex].supplierName!,
                                                style: AppStyles.rkBoldTextStyle(size: AppConstants.smallFont, color: AppColors.blackColor),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                              const Spacer(),
                                              Directionality(
                                                textDirection: state.language == 'en' ? TextDirection.ltr : TextDirection.rtl,
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_2, horizontal: AppConstants.padding_10),
                                                  decoration: BoxDecoration(
                                                      color: state.clientsList[index].suppliers![suppliersIndex].isNoMinimum! == true
                                                          ? AppColors.notificationColor.withValues(alpha: 0.3)
                                                          : AppColors.clubAgentBGColor.withValues(
                                                              alpha: 0.3,
                                                            ),
                                                      borderRadius: BorderRadius.circular(
                                                        AppConstants.radius_10,
                                                      )),
                                                  child: Text(
                                                    state.clientsList[index].suppliers![suppliersIndex].isNoMinimum! == true ? AppLocalizations.of(context)!.clients_no_minimum : '${AppLocalizations.of(context)!.clients_minimum_order} ${state.clientsList[index].suppliers![suppliersIndex].minOrderAmount} ₪',
                                                    style: AppStyles.rkRegularTextStyle(
                                                      size: AppConstants.font_12,
                                                      color: state.clientsList[index].suppliers![suppliersIndex].isNoMinimum! == true ? AppColors.statusOpenColor : AppColors.clubAgentBGColor,
                                                      fontWeight: FontWeight.normal,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              ),
                                              10.width,
                                              GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context1).pop();
                                                    Future.delayed(const Duration(milliseconds: 200), () {
                                                      confirmationDialog(
                                                        context: context,
                                                        clientId: state.clientsList[index].id!,
                                                        supplierId: state.clientsList[index].suppliers![suppliersIndex].id!,
                                                        isMinimum: state.clientsList[index].suppliers![suppliersIndex].isNoMinimum!,
                                                      );
                                                    });
                                                  },
                                                  child: Icon(Icons.arrow_forward_ios, color: AppColors.blackColor, size: 20))
                                            ]),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                  );
                }),
          );
        });
  }

  confirmationDialog({required BuildContext context, required String clientId, required String supplierId, required bool isMinimum}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => AlertDialog(
        contentPadding: const EdgeInsets.all(AppConstants.padding_20),
        surfaceTintColor: AppColors.whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radius_20)),
        title: Text(
          isMinimum ? AppLocalizations.of(context)!.confirmation_minimum : AppLocalizations.of(context)!.confirmation_no_minimum,
          style: AppStyles.rkRegularTextStyle(color: AppColors.blackColor, size: AppConstants.smallFont),
        ),
        content: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
          buttonWidget(context, AppLocalizations.of(context)!.yes, buttonTap: () {
            Navigator.of(dialogContext).pop();
            Future.delayed(const Duration(milliseconds: 100), () {
              context.read<MyClientsBloc>().add(
                    MyClientsEvent.updateAgentClientsNoMinimumEvent(context: context, clientsId: clientId, supplierId: supplierId, isNoMinimum: isMinimum ? false : true),
                  );
            });
          }),
          10.width,
          buttonWidget(context, AppLocalizations.of(context)!.no, buttonTap: () {
            Navigator.of(dialogContext).pop();
          }),
        ]),
      ),
    );
  }

  Widget buttonWidget(BuildContext context, String buttonTitle, {required Null Function() buttonTap}) => InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: buttonTap,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.padding_8),
        width: MediaQuery.of(context).size.width / 3,
        decoration: BoxDecoration(gradient: AppColors.appMainGradientColor, borderRadius: BorderRadius.circular(AppConstants.radius_5)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(buttonTitle, style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.whiteColor))],
        ),
      ));
}
