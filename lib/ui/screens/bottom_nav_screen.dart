import 'dart:math';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:food_stock/ui/screens/basket_screen.dart';
import 'package:food_stock/ui/screens/home_screen.dart';
import 'package:food_stock/ui/screens/profile_menu_screen.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/screens/store_screen.dart';
import 'package:food_stock/ui/screens/wallet_screen.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_img_path.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import 'package:food_stock/ui/widget/fade_indexed_stack.dart';

import '../../bloc/bottom_nav/bottom_nav_bloc.dart';

class BottomNavRoute {
  static Widget get route => const BottomNavScreen();
}

class BottomNavScreen extends StatelessWidget {
  const BottomNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomNavBloc(),
      child:  BottomNavScreenWidget(),
    );
  }
}

class BottomNavScreenWidget extends StatelessWidget {
   BottomNavScreenWidget({super.key});


  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    BottomNavBloc bloc = context.read<BottomNavBloc>();
    return BlocListener<BottomNavBloc, BottomNavState>(
      listener: (context, state) {
        // bloc.add(BottomNavEvent.updateCartCountEvent());
      },
      child: BlocBuilder<BottomNavBloc, BottomNavState>(
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () {
              if (state.index == 0) {
                return Future.value(true);
              } else {
                bloc.add(BottomNavEvent.changePage(index: 0));
                return Future.value(false);
              }
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: AppColors.pageColor,
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Container(
                  height: 95,
                  color: AppColors.pageColor,
                  child: CurvedNavigationBar(

                    key: _bottomNavigationKey,
                    index: state.index,
                    height: 60.0,
                    items:  [
                      _navItem(
                      pos: 0,
                      img: AppImagePath.home,
                      isRTL: context.rtl,
                      state: state,
                      ),
                  _navItem(
                      pos: 1,
                      img: AppImagePath.store,
                      isRTL: context.rtl,
                      state: state,
                  ),
                  _navItem(
                      pos: 2,
                      img: AppImagePath.cart,
                      isRTL: context.rtl,
                      state: state,
                      isCart: true,
                  ),
                  _navItem(
                      pos: 3,
                      img: AppImagePath.wallet,
                      isRTL: context.rtl,
                      state: state,
                  ),
                  _navItem(
                      pos: 4,
                      img: AppImagePath.profile,
                      isRTL: context.rtl,
                      state: state,
                  ),
                  ],
                    color: Colors.white,
                    buttonBackgroundColor: Colors.white,
                    backgroundColor: AppColors.pageColor,
                    animationCurve: Curves.easeInOut,
                    animationDuration: Duration(milliseconds: 200),
                    onTap: (index) {
                      bloc.add(
                          BottomNavEvent.changePage(index: index));
                    },
                    letIndexChange: (index) => true,

                  ),
                ),
              ),
              body: FocusDetector(
                onFocusGained: () {
                  bloc.add(BottomNavEvent.updateCartCountEvent());
                },
                child: SafeArea(
                  child: Stack(
                    children: [
                      _pageContainers(
                          screenHeight: getScreenHeight(context),
                          screenWidth: getScreenWidth(context),
                          state: state),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _pageContainers({required double screenHeight,
    required double screenWidth,
    required BottomNavState state}) {
    return Container(
      height: screenHeight,
      width: screenWidth,
      child: FadeIndexedStack(
        index: state.index,
        children: const [
          HomeScreen(),
          StoreScreen(),
          BasketScreen(),
          WalletScreen(),
          ProfileMenuScreen(),
        ],
      ),
    );
  }

  Widget _navItem(
      {required int pos,
      required bool isRTL,
      required String img,
      bool isCart = false,
     // required void Function() onTap,
      required BottomNavState state}) {
    return GestureDetector(
    //  onTap: onTap,
      child: Stack(
        children: [
          Container(
            height: 50,
            width: 50,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                color: pos == state.index
                    ? AppColors.mainColor
                    : AppColors.whiteColor,
                borderRadius: const BorderRadius.all(
                    Radius.circular(AppConstants.radius_100))),
            child: Center(
                child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(isRTL ? pi : 0),
              child: SvgPicture.asset(
                img,
                height: 26,
                width: 26,
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    pos == state.index
                        ? AppColors.whiteColor
                        : AppColors.navSelectedColor,
                    BlendMode.srcIn,
                ),
              ),
            )),
          ),
          isCart == false
              ? const SizedBox()
              : state.cartCount == 0
                  ? const SizedBox()
                  : Positioned(
                      top: 5,
                      right: isRTL ? null : 0,
                      left: isRTL ? 0 : null,
                      child: Stack(
                        children: [
                          Container(
                            height: 18,
                            width: 24,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                               color: state.index == 2 ?  AppColors.navSelectedColor : AppColors.notificationColor,
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(AppConstants.radius_100)),
                              border:
                                  Border.all(color: AppColors.whiteColor, width: 1),
                            ),
                            child: Text(
                              '${state.cartCount}',
                              style: AppStyles.rkRegularTextStyle(
                                  size: 10, color: AppColors.whiteColor),
                            ),
                          ),
                        ],
                      ),
                    ),
        ],
      ),
    );
  }
}







































/*
import 'dart:math';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:food_stock/ui/screens/basket_screen.dart';
import 'package:food_stock/ui/screens/home_screen.dart';
import 'package:food_stock/ui/screens/profile_menu_screen.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/screens/store_screen.dart';
import 'package:food_stock/ui/screens/wallet_screen.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_img_path.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import 'package:food_stock/ui/widget/fade_indexed_stack.dart';

import '../../bloc/bottom_nav/bottom_nav_bloc.dart';

class BottomNavRoute {
  static Widget get route => const BottomNavScreen();
}

class BottomNavScreen extends StatelessWidget {
  const BottomNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomNavBloc(),
      child:  BottomNavScreenWidget(),
    );
  }
}

class BottomNavScreenWidget extends StatelessWidget {
  BottomNavScreenWidget({super.key});


  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    BottomNavBloc bloc = context.read<BottomNavBloc>();
    return BlocListener<BottomNavBloc, BottomNavState>(
      listener: (context, state) {
        // bloc.add(BottomNavEvent.updateCartCountEvent());
      },
      child: BlocBuilder<BottomNavBloc, BottomNavState>(
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () {
              if (state.index == 4) {
                return Future.value(true);
              } else {
                bloc.add(BottomNavEvent.changePage(index: 4));
                return Future.value(false);
              }
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: AppColors.pageColor,
              body: FocusDetector(
                onFocusGained: () {
                  bloc.add(BottomNavEvent.updateCartCountEvent());
                },
                child: SafeArea(
                  child: Stack(
                    children: [
                      _pageContainers(
                          screenHeight: getScreenHeight(context),
                          screenWidth: getScreenWidth(context),
                          state: state),
                      Positioned(
                        bottom: 12,
                        left: 24,
                        right: 24,
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            boxShadow: [
                              BoxShadow(
                                  color: AppColors.shadowColor.withOpacity(0.3),
                                  blurRadius: AppConstants.blur_10)
                            ],
                            borderRadius: const BorderRadius.all(
                                Radius.circular(AppConstants.radius_100)),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _navItem(
                                  pos: 4,
                                  img: AppImagePath.home,
                                  isRTL: context.rtl,
                                  state: state,
                                  onTap: () => bloc.add(
                                      BottomNavEvent.changePage(index: 4))),
                              _navItem(
                                  pos: 3,
                                  img: AppImagePath.store,
                                  isRTL: context.rtl,
                                  state: state,
                                  onTap: () => bloc.add(
                                      BottomNavEvent.changePage(index: 3))),
                              _navItem(
                                  pos: 2,
                                  img: AppImagePath.cart,
                                  isRTL: context.rtl,
                                  state: state,
                                  isCart: true,
                                  onTap: () => bloc.add(
                                      BottomNavEvent.changePage(index: 2))),
                              _navItem(
                                  pos: 1,
                                  img: AppImagePath.wallet,
                                  isRTL: context.rtl,
                                  state: state,
                                  onTap: () => bloc.add(
                                      BottomNavEvent.changePage(index: 1))),
                              _navItem(
                                  pos: 0,
                                  img: AppImagePath.profile,
                                  isRTL: context.rtl,
                                  state: state,
                                  onTap: () => bloc.add(
                                      BottomNavEvent.changePage(index: 0))),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _pageContainers({required double screenHeight,
    required double screenWidth,
    required BottomNavState state}) {
    return Container(
      height: screenHeight,
      width: screenWidth,
      child: FadeIndexedStack(
        index: state.index,
        children: const [
          ProfileMenuScreen(),
          WalletScreen(),
          BasketScreen(),
          StoreScreen(),
          HomeScreen(),
        ],
      ),
    );
  }

  Widget _navItem(
      {required int pos,
        required bool isRTL,
        required String img,
        bool isCart = false,
        required void Function() onTap,
        required BottomNavState state}) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            height: 50,
            width: 50,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                color: pos == state.index
                    ? AppColors.navSelectedColor
                    : AppColors.whiteColor,
                borderRadius: const BorderRadius.all(
                    Radius.circular(AppConstants.radius_100))),
            child: Center(
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(isRTL ? pi : 0),
                  child: SvgPicture.asset(
                    img,
                    height: 26,
                    width: 26,
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        pos == state.index
                            ? AppColors.whiteColor
                            : AppColors.navSelectedColor,
                        BlendMode.srcIn),
                  ),
                )),
          ),
          isCart == false
              ? const SizedBox()
              : state.cartCount == 0
              ? const SizedBox()
              : Positioned(
            top: 5,
            right: isRTL ? null : 0,
            left: isRTL ? 0 : null,
            child: Stack(
              children: [
                Container(
                  height: 16,
                  width: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.notificationColor,
                    borderRadius: const BorderRadius.all(
                        Radius.circular(AppConstants.radius_100)),
                    border:
                    Border.all(color: AppColors.whiteColor, width: 1),
                  ),
                  child: Text(
                    '${state.cartCount}',
                    style: AppStyles.rkRegularTextStyle(
                        size: 10, color: AppColors.whiteColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }}
*/
