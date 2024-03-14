import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/bloc/menu/menu_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import 'package:food_stock/ui/widget/common_app_bar.dart';
import 'package:food_stock/ui/widget/delayed_widget.dart';
import 'package:food_stock/ui/widget/question_and_answer_screen_shimmer_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../widget/refresh_widget.dart';

class MenuRoute {
  static Widget get route => const MenuScreen();
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MenuBloc()..add(MenuEvent.getAppContentListEvent(context: context)),
      child: const MenuScreenWidget(),
    );
  }
}

class MenuScreenWidget extends StatelessWidget {
  const MenuScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MenuBloc, MenuState>(
      listener: (context, state) {},
      child: BlocBuilder<MenuBloc, MenuState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.pageColor,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(AppConstants.appBarHeight),
              child: CommonAppBar(
                bgColor: AppColors.pageColor,
                title: AppLocalizations.of(context)!.menu,
                iconData: Icons.close,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: SafeArea(
              child: SmartRefresher(
                enablePullDown: true,
                controller: state.refreshController,
                header: RefreshWidget(),
                footer: CustomFooter(
                  builder: (context, mode) =>
                      QuestionAndAnswerScreenShimmerWidget(),
                ),
                enablePullUp: !state.isBottomOfAppContents,
                onRefresh: () {
                  context
                      .read<MenuBloc>()
                      .add(MenuEvent.refreshListEvent(context: context));
                },
                onLoading: () {
                  context
                      .read<MenuBloc>()
                      .add(MenuEvent.getAppContentListEvent(context: context));
                },
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    5.height,
                    state.isShimmering
                        ? QuestionAndAnswerScreenShimmerWidget()
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.contentList.length + 2,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return AppContentTile(
                                  index: index,
                                  title: index == 0
                                      ? AppLocalizations.of(context)!.my_orders
                                      : index == 1
                                          ? AppLocalizations.of(context)!
                                              .questions_and_answers
                                          : state.contentList[index - 2]
                                                  .contentName ??
                                              '',
                                  onTap: () {
                                    index == 0
                                        ? Navigator.pushNamed(context,
                                            RouteDefine.orderScreen.name)
                                        : index == 1
                                            ? Navigator.pushNamed(
                                                context,
                                                RouteDefine
                                                    .questionAndAnswerScreen
                                                    .name)
                                            : Navigator.pushNamed(
                                                context,
                                                RouteDefine
                                                    .appContentScreen.name,
                                                arguments: {
                                                    AppStrings
                                                            .appContentIdString:
                                                        state
                                                                .contentList[
                                                                    index - 2]
                                                                .id ??
                                                            '',
                                                    AppStrings
                                                            .appContentNameString:
                                                        state
                                                                .contentList[
                                                                    index - 2]
                                                                .contentName ??
                                                            ''
                                                  });
                                  });
                            },
                          ),


                  ],
                )),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget AppContentTile(
      {required int index,
      required String title,
      required void Function() onTap}) {
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
    );
  }
}
