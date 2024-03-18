import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/bloc/app_content/app_content_bloc.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/widget/common_shimmer_widget.dart';
import 'package:food_stock/ui/widget/custom_button_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:html/parser.dart';

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
            appContentId: args?[AppStrings.appContentIdString] ?? '',
            appContentName: args?[AppStrings.appContentNameString] ?? '')),
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
                bgColor: AppColors.pageColor,
                title: '${state.contentName}',
                iconData: Icons.arrow_back_ios_sharp,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                  physics: state.isShimmering
                      ? NeverScrollableScrollPhysics()
                      : AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.padding_10,
                        vertical: AppConstants.padding_5),
                    child: state.isShimmering
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppConstants.padding_10),
                            child: Column(
                              children: [
                                10.height,
                                CommonShimmerWidget(
                                  child: Container(
                                    height: getScreenHeight(context),
                                    width: getScreenWidth(context),
                                    decoration: BoxDecoration(
                                        color: AppColors.whiteColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                AppConstants.radius_10))),
                                  ),
                                ),
                                20.height,
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              Text(
                                '${state.appContentDetails.title}',
                                style: AppStyles.rkRegularTextStyle(
                                    size: AppConstants.smallFont,
                                    color: AppColors.blackColor),
                              ),
                              Text(
                                '${state.appContentDetails.subTitle}',
                                style: AppStyles.rkRegularTextStyle(
                                    size: AppConstants.font_12,
                                    color: AppColors.textColor),
                              ),
                              Container(
                                width: getScreenWidth(context),
                                margin: EdgeInsets.only(
                                    left: AppConstants.padding_10,
                                    right: AppConstants.padding_10,
                                    top: AppConstants.padding_10),
                                padding: EdgeInsets.symmetric(
                                    vertical: AppConstants.padding_15,
                                    horizontal: AppConstants.padding_30),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(AppConstants.radius_5)),
                                    color: AppColors.whiteColor,
                                    boxShadow: [
                                      BoxShadow(
                                          color: AppColors.shadowColor
                                              .withOpacity(0.15),
                                          blurRadius: AppConstants.blur_10)
                                    ]),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${parse(state.appContentDetails.fullText ?? '').body?.text}',
                                      style: AppStyles.rkRegularTextStyle(
                                          size: AppConstants.smallFont,
                                          color: AppColors.blackColor),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: AppConstants.radius_20,
                                    horizontal: AppConstants.padding_8),
                                child: Column(
                                  children: [
                                    CustomButtonWidget(
                                        onPressed: () {
                                          Navigator.pop(context);
                                    buttonEvent(state.appContentDetails.id!);
                                        },
                                        buttonText:
                                            '${state.appContentDetails.textForButton1}',
                                        bGColor: AppColors.mainColor,
                                        fontColors: AppColors.whiteColor),
                                    10.height,
                                    state.appContentDetails.textForButton2 !=
                                            null
                                        ? CustomButtonWidget(
                                            onPressed: () {

                                            },
                                            buttonText:
                                                '${state.appContentDetails.textForButton2}',
                                            bGColor: AppColors.mainColor,
                                            fontColors: AppColors.whiteColor)
                                        : 0.width,
                                  ],
                                ),
                              )
                            ],
                          ),
                  )),
            ),
          );
        },
      ),
    );
  }

  void buttonEvent(String id) {

    switch (id) {
      case '658d0e87a1bb68d47f70dd09':
        debugPrint(
            '______ about the app');
        break;
      case '658d0e5aa1bb68d47f70dd03':
        debugPrint('______ contact us');
        break;
      case '658d0e0ea1bb68d47f70dcfd':
        debugPrint(
            '______ terms and conditions');
        break;
    }
  }

}
