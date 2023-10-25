import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/bloc/menu/menu_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import 'package:food_stock/ui/widget/common_app_bar.dart';

class MenuRoute {
  static Widget get route => const MenuScreen();
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MenuBloc(),
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
                title: AppLocalizations.of(context)!.menu,
                iconData: Icons.close,
                onTap: () {
                  Navigator.pushNamed(context,
                      RouteDefine.bottomNavScreen.name);
                },
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  menuTiles(
                      title: AppLocalizations.of(context)!.my_orders,
                      onTap: () => Navigator.pushNamed(
                          context, RouteDefine.orderScreen.name)),
                  menuTiles(
                      title:
                          AppLocalizations.of(context)!.questions_and_answers,
                      onTap: () => Navigator.pushNamed(
                          context, RouteDefine.questionAndAnswerScreen.name)),
                  menuTiles(
                      title: AppLocalizations.of(context)!.terms_of_use,
                      onTap: () => Navigator.pushNamed(
                          context, RouteDefine.termsOfUseScreen.name)),
                  menuTiles(
                      title: AppLocalizations.of(context)!.contact_us,
                      onTap: () => Navigator.pushNamed(
                          context, RouteDefine.contactScreen.name)),
                  menuTiles(
                      title: AppLocalizations.of(context)!.about_the_app,
                      onTap: () => Navigator.pushNamed(
                          context, RouteDefine.aboutAppScreen.name)),
                  menuTiles(
                      title: AppLocalizations.of(context)!.logout,
                      onTap: () => context
                          .read<MenuBloc>()
                          .add(MenuEvent.logOutEvent(context: context))),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget menuTiles({required title, required void Function() onTap}) {
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
                    size: AppConstants.smallFont, color: AppColors.blackColor),
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
