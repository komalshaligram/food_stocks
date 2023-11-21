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
      child: const BottomNavScreenWidget(),
    );
  }
}

class BottomNavScreenWidget extends StatelessWidget {
  const BottomNavScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    BottomNavBloc bloc = context.read<BottomNavBloc>();
    return BlocListener<BottomNavBloc, BottomNavState>(
      listener: (context, state) {
        bloc.add(BottomNavEvent.updateCartCountEvent());
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
                        bottom: 25,
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
                                  state: state,
                                  onTap: () => bloc.add(
                                      BottomNavEvent.changePage(index: 4))),
                              _navItem(
                                  pos: 3,
                                  img: AppImagePath.store,
                                  state: state,
                                  onTap: () => bloc.add(
                                      BottomNavEvent.changePage(index: 3))),
                              _navItem(
                                  pos: 2,
                                  img: AppImagePath.cart,
                                  state: state,
                                  isCart: true,
                                  onTap: () => bloc.add(
                                      BottomNavEvent.changePage(index: 2))),
                              _navItem(
                                  pos: 1,
                                  img: AppImagePath.wallet,
                                  state: state,
                                  onTap: () => bloc.add(
                                      BottomNavEvent.changePage(index: 1))),
                              _navItem(
                                  pos: 0,
                                  img: AppImagePath.profile,
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

  Widget _pageContainers(
      {required double screenHeight,
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
      required String img,
      bool isCart = false,
      required void Function() onTap,
      required BottomNavState state}) {
    return Stack(
      children: [
        Container(
          height: 50,
          width: 50,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              color: pos == state.index
                  ? AppColors.navSelectedColor
                  : AppColors.whiteColor,
              borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_100))),
          child: InkWell(
            // splashColor: Colors.transparent,
            // highlightColor: Colors.transparent,
            onTap: onTap,
            child: Center(
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
                )),
          ),
        ),
        isCart == false
            ? const SizedBox()
            : state.cartCount == 0
                ? const SizedBox()
                : Positioned(
                    top: 5,
                    right: 0,
                    child: Container(
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
                  )
      ],
    );
  }
}
