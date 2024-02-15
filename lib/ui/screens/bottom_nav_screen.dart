import 'dart:math';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:food_stock/routes/app_routes.dart';
import 'package:food_stock/ui/screens/basket_screen.dart';
import 'package:food_stock/ui/screens/home_screen.dart';
import 'package:food_stock/ui/screens/profile_menu_screen.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/screens/store_screen.dart';
import 'package:food_stock/ui/screens/wallet_screen.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_img_path.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import 'package:food_stock/ui/widget/fade_indexed_stack.dart';
import '../../bloc/bottom_nav/bottom_nav_bloc.dart';
import '../widget/confetti.dart';

class BottomNavRoute {
  static Widget get route => const BottomNavScreen();
}

class BottomNavScreen extends StatelessWidget {
  const BottomNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map?;
    debugPrint('bottom nav args = $args');
    return BlocProvider(
      create: (context) => BottomNavBloc()..add(BottomNavEvent.NavigateToStoreScreenEvent(context: context, storeScreen: '')),
      child: BottomNavScreenWidget(storeScreen: args?[AppStrings.pushNavigationString] ?? ''),
    );
  }
}

class BottomNavScreenWidget extends StatelessWidget {
  String storeScreen;

  BottomNavScreenWidget({super.key, this.storeScreen = ''});

  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    BottomNavBloc bloc = context.read<BottomNavBloc>();
    return BlocListener<BottomNavBloc, BottomNavState>(
      listenWhen: (previous, current) => current.pushNotificationPath != '',
      listener: (context, state) {
      if(state.isGuestUser){
        debugPrint('Guest User');
        }
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
              bottomNavigationBar: Container(
                decoration:
                    BoxDecoration(color: Colors.transparent, boxShadow: [
                  BoxShadow(
                      color: AppColors.shadowColor.withOpacity(0.1),
                      blurRadius: AppConstants.blur_10)
                ]),
                child: CurvedNavigationBar(
                  key: _bottomNavigationKey,
                  index: storeScreen == '' ? state.index : 1,
                  height: 65.0,
                cartCount: state.cartCount,
                isRTL: context.rtl,
                  items: [
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
                  color: AppColors.whiteColor,
                  buttonBackgroundColor: AppColors.whiteColor,
                  backgroundColor: Colors.transparent,
                  animationCurve: Curves.decelerate,
                  animationDuration: Duration(milliseconds: 600),
                  onTap: (index) {
                    storeScreen = '';
                    print('index____${index}');
                    if(state.isGuestUser && index != 1){
                      Navigator.pushNamed(context, RouteDefine.connectScreen.name);
                    }
                    else{
                      bloc.add(BottomNavEvent.changePage(index: index));
                    }

                  },
                  letIndexChange: (index) => true,
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
                          state: state
                      ) ,
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



  Widget _pageContainers(
      {required double screenHeight,
      required double screenWidth,
      required BottomNavState state}) {
    print('gusujduser____${state.isGuestUser}');

    return Container(
      height: screenHeight,
      width: screenWidth,
      child: FadeIndexedStack(
        index: storeScreen == '' ? state.index : 1,
        children: [
          HomeScreen() ,
          StoreScreen(),
          BasketScreen(),
          WalletScreen(),
          ProfileMenuScreen(),
        ]
      ),
    );
  }

  Widget _navItem(
      {required int pos,
      required bool isRTL,
      required String img,
      bool isCart = false,
      required BottomNavState state}) {
    return GestureDetector(
      child: Stack(
        children: [
          Container(
            height: 50,
            width: 50,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              gradient: pos == (storeScreen == '' ? state.index : 1 )?AppColors.appMainGradientColor:LinearGradient(colors: [AppColors.whiteColor,AppColors.whiteColor]),
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
                  pos == (storeScreen == '' ? state.index : 1 )
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
                                  gradient: state.index == 2
                                    ? LinearGradient(colors: [AppColors.whiteColor,AppColors.whiteColor]):AppColors.appMainGradientColor,
                                /*  color: state.index == 2
                                      ? AppColors.whiteColor
                                      : AppColors.notificationColor,*/
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(AppConstants.radius_100)),
                                  border: Border.all(
                                      color: state.index == 2
                                          ? AppColors.mainColor
                                          : AppColors.whiteColor,
                                      width: 1),
                                ),
                                child: Text(
                                  '${state.cartCount}',
                                  style: AppStyles.rkRegularTextStyle(
                                      size: 10,
                                      color: state.index == 2
                                          ? AppColors.mainColor
                                          : AppColors.whiteColor),
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(),
          isCart ?  state.isAnimation  && state.index != 2 ? Positioned(
         //   top: 5,
            right: isRTL ? null : 0,
            left: isRTL ? 0 : null,
            child: SizedBox(
              height: 50,
              width: 25,
              child: Visibility(
                visible:state.duringCelebration,
                child: IgnorePointer(
                  child: Confetti(
                    isStopped:!state.duringCelebration,
                    snippingsCount: 10,
                    snipSize: 3.0,
                    colors:[AppColors.mainColor],
                  ),
                ),
              ),
            ),
          ):SizedBox() : SizedBox(),
        ],
      ),
    );
  }
}
