import 'dart:io';
import 'dart:math';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_detector/focus_detector.dart';
import '../../routes/app_routes.dart';
import '../../ui/screens/basket_screen.dart';
import '../../ui/screens/home_screen.dart';
import '../../ui/screens/profile_menu_screen.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/screens/store_screen.dart';
import '../../ui/screens/wallet_screen.dart';
import '../../ui/utils/constants/app_colors.dart';
import '../../ui/utils/constants/app_constants.dart';
import '../../ui/utils/constants/app_img_path.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/utils/constants/app_styles.dart';
import '../../ui/widget/fade_indexed_stack.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../bloc/bottom_nav/bottom_nav_bloc.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../widget/confetti.dart';

class BottomNavRoute {
  static Widget get route => const BottomNavScreen();
}

class BottomNavScreen extends StatelessWidget {
  const BottomNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
      create: (context) => BottomNavBloc()
        ..add(BottomNavEvent.getPreferencesDataEvent(
          context: context,
        )),
      child: BottomNavScreenWidget(
        basketScreen: args?[AppStrings.isBasketScreenString] ?? '',
        storeScreen: args?[AppStrings.pushNavigationString] ?? '',
        profileScreen: args?[AppStrings.pushNavigationString] ?? '',
      ),
    );
  }
}

class BottomNavScreenWidget extends StatelessWidget {
  final String storeScreen;
  final String basketScreen;
  final String profileScreen;
  BottomNavScreenWidget({super.key, this.storeScreen = '', this.basketScreen = '', this.profileScreen = ''});

  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    BottomNavBloc bloc = context.read<BottomNavBloc>();
    return BlocListener<BottomNavBloc, BottomNavState>(
      listener: (context, state) {
        bloc.add(BottomNavEvent.getPreferencesDataEvent(context: context));
        bloc.add(BottomNavEvent.updateCartCountEvent(context: context));
        bloc.add(BottomNavEvent.navigateToStoreScreenEvent(context: context, storeScreen: storeScreen, basketScreen: basketScreen, profileScreen: profileScreen));
      },
      child: BlocBuilder<BottomNavBloc, BottomNavState>(
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () {
              if (state.index == 0) {
                return Future.value(true);
              } else {
                bloc.add(BottomNavEvent.changePage(index: 0, context: context));
                return Future.value(false);
              }
            },
            child: Container(
              color: AppColors.pageColor,
              child: SafeArea(
                bottom: Platform.isAndroid,
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  backgroundColor: AppColors.pageColor,
                  bottomNavigationBar: Container(
                    decoration: BoxDecoration(color: Colors.transparent, boxShadow: [BoxShadow(color: AppColors.shadowColor.withOpacity(0.1), blurRadius: AppConstants.blur_10)]),
                    child: CurvedNavigationBar(
                      key: _bottomNavigationKey,
                      index: state.index == 4 && !state.isSubUserSeeWallet ? (state.index - 1) : state.index,
                      height: 65.0,
                      items: state.isSubUserSeeWallet
                          ? [
                              navItem(
                                pos: 0,
                                img: AppImagePath.home,
                                isRTL: context.rtl,
                                state: state,
                              ),
                              navItem(
                                pos: 1,
                                img: AppImagePath.store,
                                isRTL: context.rtl,
                                state: state,
                              ),
                              navItem(
                                pos: 2,
                                img: AppImagePath.cart,
                                isRTL: context.rtl,
                                state: state,
                                isCart: true,
                              ),
                              navItem(
                                pos: 3,
                                img: AppImagePath.wallet,
                                isRTL: context.rtl,
                                state: state,
                              ),
                              navItem(
                                pos: 4,
                                img: AppImagePath.profile,
                                isRTL: context.rtl,
                                state: state,
                              ),
                            ]
                          : [
                              navItem(
                                pos: 0,
                                img: AppImagePath.home,
                                isRTL: context.rtl,
                                state: state,
                              ),
                              navItem(
                                pos: 1,
                                img: AppImagePath.store,
                                isRTL: context.rtl,
                                state: state,
                              ),
                              navItem(
                                pos: 2,
                                img: AppImagePath.cart,
                                isRTL: context.rtl,
                                state: state,
                                isCart: true,
                              ),
                              navItem(
                                pos: 3,
                                img: AppImagePath.profile,
                                isRTL: context.rtl,
                                state: state,
                              ),
                            ],
                      color: AppColors.whiteColor,
                      buttonBackgroundColor: AppColors.whiteColor,
                      backgroundColor: Colors.transparent,
                      animationCurve: Curves.decelerate,
                      animationDuration: const Duration(milliseconds: 600),
                      onTap: (index) async {
                        SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
                        if (preferencesHelper.getGuestUser()) {
                          if (index == 1) {
                            bloc.add(BottomNavEvent.changePage(index: index, context: context));
                          } else {
                            Navigator.pushNamed(context, RouteDefine.connectScreen.name);
                          }
                        } else {
                          bloc.add(BottomNavEvent.changePage(index: index, context: context));
                        }
                      },
                      letIndexChange: (index) {
                        return true;
                      },
                    ),
                  ),
                  body: FocusDetector(
                    onFocusGained: () {
                      bloc.add(BottomNavEvent.updateCartCountEvent(context: context));
                      bloc.add(BottomNavEvent.getPreferencesDataEvent(context: context));
                    },
                    child: SafeArea(
                      child: Stack(
                        children: [
                          _pageContainers(screenHeight: getScreenHeight(context), screenWidth: getScreenWidth(context), state: state),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _pageContainers({required double screenHeight, required double screenWidth, required BottomNavState state}) {
    return SizedBox(
      height: screenHeight,
      width: screenWidth,
      child: FadeIndexedStack(
          index: state.index,
          children: state.isSubUserSeeWallet
              ? [
                  HomeScreen(
                    isSubCategory: 'false',
                  ),
                  const StoreScreen(),
                  const BasketScreen(),
                  const WalletScreen(),
                  const ProfileMenuScreen(),
                ]
              : [
                  HomeScreen(
                    isSubCategory: 'false',
                  ),
                  const StoreScreen(),
                  const BasketScreen(),
                  const ProfileMenuScreen()
                ]),
    );
  }

  Widget navItem({required int pos, required bool isRTL, required String img, bool isCart = false, required BottomNavState state}) {
    return GestureDetector(
      child: Stack(
        children: [
          Container(
            height: 50,
            width: 50,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(gradient: pos == (state.index) ? AppColors.appMainGradientColor : LinearGradient(colors: [AppColors.whiteColor, AppColors.whiteColor]), borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_100))),
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
                  pos == (state.index) ? AppColors.whiteColor : AppColors.navSelectedColor,
                  BlendMode.srcIn,
                ),
              ),
            )),
          ),
          isCart == false
              ? const SizedBox()
              : state.cartCount == 0
                  ? const SizedBox()
                  : state.index != 2
                      ? Positioned(
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
                                  gradient: state.index == 2 ? LinearGradient(colors: [AppColors.whiteColor, AppColors.whiteColor]) : AppColors.appMainGradientColor,
                                  borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_100)),
                                  border: Border.all(color: state.index == 2 ? AppColors.mainColor : AppColors.whiteColor, width: 1),
                                ),
                                child: Text(
                                  '${state.cartCount}',
                                  style: AppStyles.rkRegularTextStyle(size: AppConstants.font_10, color: state.index == 2 ? AppColors.mainColor : AppColors.whiteColor),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
          isCart
              ? state.isAnimation && state.index != 2
                  ? Positioned(
                      right: isRTL ? null : 0,
                      left: isRTL ? 0 : null,
                      child: SizedBox(
                        height: 50,
                        width: 25,
                        child: Visibility(
                          visible: state.duringCelebration,
                          child: IgnorePointer(
                            child: Confetti(
                              isStopped: !state.duringCelebration,
                              snippingCount: 10,
                              snipSize: 3.0,
                              colors: [AppColors.mainColor],
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox()
              : const SizedBox(),
        ],
      ),
    );
  }
}
