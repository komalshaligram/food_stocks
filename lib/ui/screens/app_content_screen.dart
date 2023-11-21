import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/bloc/app_content/app_content_bloc.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';

import '../utils/themes/app_constants.dart';
import '../utils/themes/app_styles.dart';
import '../widget/common_app_bar.dart';

class AppContentRoute {
  static Widget get route => AppContentScreen();
}

class AppContentScreen extends StatelessWidget {
  const AppContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
      create: (context) => AppContentBloc()
        ..add(AppContentEvent.getAppContentDetailsEvent(
            context: context,
            appContentId: args?[AppStrings.appContentIdString] ?? '')),
      child: AboutAppScreenWidget(),
    );
  }
}

class AboutAppScreenWidget extends StatelessWidget {
  const AboutAppScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppContentBloc, AppContentState>(
      listener: (context, state) {},
      child: BlocBuilder<AppContentBloc, AppContentState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.pageColor,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(AppConstants.appBarHeight),
              child: CommonAppBar(
                title: '${state.appContentDetails.contentName}',
                iconData: Icons.arrow_back_ios_sharp,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        left: AppConstants.padding_10,
                        right: AppConstants.padding_10,
                        top: AppConstants.padding_15),
                    padding: EdgeInsets.symmetric(
                        vertical: AppConstants.padding_15,
                        horizontal: AppConstants.padding_30),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(AppConstants.radius_5)),
                        color: AppColors.whiteColor,
                        boxShadow: [
                          BoxShadow(
                              color: AppColors.shadowColor.withOpacity(0.15),
                              blurRadius: AppConstants.blur_10)
                        ]),
                    child: Column(
                      children: [
                        Text(
                          '${state.appContentDetails.title}',
                          style: AppStyles.rkRegularTextStyle(
                              size: AppConstants.smallFont,
                              color: AppColors.blackColor),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
            ),
          );
        },
      ),
    );
  }
}
