import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/bloc/menu/menu_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';

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
            appBar: AppBar(
              leading: InkWell(
                onTap: () {},
                child: Icon(
                  Icons.close,
                  color: AppColors.blackColor,
                ),
              ),
              title: Text(
                AppLocalizations.of(context)!.menu,
                style: AppStyles.rkRegularTextStyle(
                    size: AppConstants.smallFont, color: AppColors.blackColor),
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                    menuTiles(title: AppLocalizations.of(context)!.my_orders, onTap: () {}),
                    menuTiles(title: AppLocalizations.of(context)!.questions_and_answers, onTap: () {}),
                    menuTiles(title: AppLocalizations.of(context)!.terms_of_use, onTap: () {}),
                    menuTiles(title: AppLocalizations.of(context)!.contact, onTap: () {}),
                    menuTiles(title: AppLocalizations.of(context)!.about_the_app, onTap: () {}),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget menuTiles({required title, required void Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'data',
              style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont),
            ),
            Icon(
              Icons.arrow_back_ios,
              color: AppColors.blackColor,
            ),
          ],
        ),
      ),
    );
  }
}
