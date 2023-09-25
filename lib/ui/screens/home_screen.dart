import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_stock/bloc/home/home_bloc.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_img_path.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';

class HomeRoute {
  static Widget get route => const HomeScreen();
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(const HomeEvent.started()),
      child: const HomeScreenWidget(),
    );
  }
}

class HomeScreenWidget extends StatelessWidget {
  const HomeScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    HomeBloc bloc = context.read<HomeBloc>();
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {},
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.pageColor,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                boxShadow: [
                                  BoxShadow(
                                      color: AppColors.shadowColor,
                                      blurRadius: 10)
                                ],
                                shape: BoxShape.circle,
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: Image.asset(
                                AppImagePath.profileImage,
                              ),
                            ),
                            Image.asset(
                              AppImagePath.companyLogo,
                              height: 60,
                            ),
                          ],
                        ),
                        Container(
                          height: 60,
                          padding: const EdgeInsets.symmetric(horizontal: 3.0),
                          decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              boxShadow: [
                                BoxShadow(
                                    color: AppColors.shadowColor,
                                    blurRadius: 10)
                              ],
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(100.0))),
                          clipBehavior: Clip.hardEdge,
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 54,
                                width: 54,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.iconBGColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(100.0)),
                                ),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    SvgPicture.asset(
                                      AppImagePath.message,
                                      height: 26,
                                      width: 24,
                                      fit: BoxFit.scaleDown,
                                    ),
                                    Positioned(
                                        right: 7,
                                        top: 8,
                                        child: Container(
                                          height: 16,
                                          width: 16,
                                          decoration: BoxDecoration(
                                              color: AppColors.mainColor,
                                              border: Border.all(
                                                  color: AppColors.whiteColor,
                                                  width: 1),
                                              shape: BoxShape.circle),
                                          alignment: Alignment.center,
                                          child: Text('4',
                                              style:
                                                  AppStyles.rkRegularTextStyle(
                                                      size: 8,
                                                      color: AppColors
                                                          .whiteColor)),
                                        ))
                                  ],
                                ),
                              ),
                              SvgPicture.asset(
                                AppImagePath.moreVertical,
                                fit: BoxFit.scaleDown,
                                width: 54,
                                height: 54,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 21.0,
                    ),
                    Container(
                      width: screenWidth,
                      clipBehavior: Clip.hardEdge,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          boxShadow: [
                            BoxShadow(
                                color: AppColors.shadowColor, blurRadius: 10)
                          ],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10.0))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(child: Column()),
                          const SizedBox(width: 15.0,),
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5.0)),
                                      color: AppColors.iconBGColor),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(AppImagePath.credits,
                                          height: 50, fit: BoxFit.scaleDown),
                                      Column(
                                        textDirection: TextDirection.rtl,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Credits',
                                            style: AppStyles.rkRegularTextStyle(
                                                size: 10,
                                                color: AppColors.mainColor),
                                          ),
                                          Text(
                                            '20,000',
                                            style: AppStyles.rkRegularTextStyle(
                                                size: 16,
                                                color: AppColors.blackColor),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5.0)),
                                      color: AppColors.iconBGColor),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(AppImagePath.expense,
                                          height: 50, fit: BoxFit.scaleDown),
                                      Column(
                                        textDirection: TextDirection.ltr,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Last expenses",
                                            style: AppStyles.rkRegularTextStyle(
                                                size: 10,
                                                color: AppColors.mainColor),
                                          ),
                                          Text(
                                            '20,000',
                                            style: AppStyles.rkRegularTextStyle(
                                                size: 16,
                                                color: AppColors.blackColor),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10.0,),
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5.0)),
                                      color: AppColors.iconBGColor),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(AppImagePath.expense,
                                          height: 50, fit: BoxFit.scaleDown),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Current Expense',
                                            style: AppStyles.rkRegularTextStyle(
                                                size: 10,
                                                color: AppColors.mainColor),
                                          ),
                                          Text(
                                            '20,000',
                                            style: AppStyles.rkRegularTextStyle(
                                                size: 16,
                                                color: AppColors.blackColor),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5.0)),
                                      color: AppColors.iconBGColor),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(AppImagePath.orders,
                                          height: 50, fit: BoxFit.scaleDown),
                                      Column(

                                        textDirection: TextDirection.ltr,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Orders',
                                            style: AppStyles.rkRegularTextStyle(
                                                size: 10,
                                                color: AppColors.mainColor),
                                          ),
                                          Text(
                                            '18',
                                            style: AppStyles.rkRegularTextStyle(
                                                size: 16,
                                                color: AppColors.blackColor),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
