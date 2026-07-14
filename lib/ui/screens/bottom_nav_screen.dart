import 'dart:io';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_detector/focus_detector.dart';
import '../../bloc/bottom_nav/bottom_nav_bloc.dart';
import 'basket/basket_screen.dart';
import '../../ui/screens/home_screen.dart';
import '../../ui/screens/profile_menu_screen.dart';
import '../../ui/screens/store_screen.dart';
import '../../ui/screens/wallet_screen.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_colors.dart';
import '../../ui/utils/constants/app_img_path.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/widget/bottom_nav_tab_item_widget.dart';
import '../../ui/widget/fade_indexed_stack.dart';

class BottomNavRoute {
  static Widget get route => const BottomNavScreen();
}

class BottomNavScreen extends StatelessWidget {
  const BottomNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>?;

    final basketScreen = args?[AppStrings.isBasketScreenString] ?? '';
    final pushNavigation = args?[AppStrings.pushNavigationString] ?? '';

    return BlocProvider(
      create: (context) => BottomNavBloc()
        ..add(BottomNavEvent.started(
            context: context,
            basketScreen: basketScreen,
            storeScreen: pushNavigation,
            profileScreen: pushNavigation)),
      child: const BottomNavScreenWidget(),
    );
  }
}

class BottomNavScreenWidget extends StatelessWidget {
  const BottomNavScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavBloc, BottomNavState>(
        buildWhen: (previous, current) =>
            previous.index != current.index ||
            previous.cartCount != current.cartCount ||
            previous.isAnimation != current.isAnimation ||
            previous.duringCelebration != current.duringCelebration ||
            previous.isSubUserSeeWallet != current.isSubUserSeeWallet ||
            previous.isGuestUser != current.isGuestUser,
        builder: (context, state) {
          final bloc = context.read<BottomNavBloc>();
          final navPages = state.visibleNavPages;

          return PopScope(
            canPop: state.index == 0,
            onPopInvokedWithResult: (didPop, _) {
              if (didPop) return;
              bloc.add(BottomNavEvent.changePage(index: 0, context: context));
            },
            child: Container(
              color: AppColors.pageColor,
              child: SafeArea(
                bottom: Platform.isAndroid,
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  backgroundColor: AppColors.pageColor,
                  bottomNavigationBar: Container(
                    decoration:
                        BoxDecoration(color: Colors.transparent, boxShadow: [
                      BoxShadow(
                          color: AppColors.shadowColor.withValues(alpha: 0.1),
                          blurRadius: 10)
                    ]),
                    child: CurvedNavigationBar(
                      index: state.selectedNavIndex,
                      height: 65.0,
                      items: _buildNavItems(context, state),
                      color: AppColors.whiteColor,
                      buttonBackgroundColor: AppColors.whiteColor,
                      backgroundColor: Colors.transparent,
                      animationCurve: Curves.decelerate,
                      animationDuration: const Duration(milliseconds: 600),
                      onTap: (navIndex) {
                        // Guest / permission rules are handled inside BottomNavBloc.
                        bloc.add(BottomNavEvent.changePage(
                            index: navPages[navIndex], context: context));
                      },
                      letIndexChange: (_) => true,
                    ),
                  ),
                  body: FocusDetector(
                    onFocusGained: () {
                      // Badge + wallet visibility stay in BottomNavBloc only.
                      bloc.add(BottomNavEvent.updateCartCountEvent(
                          context: context));
                      bloc.add(BottomNavEvent.getPreferencesDataEvent(
                          context: context));
                    },
                    child: SafeArea(child: _PageContainers(state: state)),
                  ),
                ),
              ),
            ),
          );
        });
  }

  List<Widget> _buildNavItems(BuildContext context, BottomNavState state) {
    final isRtl = context.rtl;
    final selected = state.index;

    final items = <Widget>[
      BottomNavTabItem(
          imagePath: AppImagePath.home,
          isSelected: selected == 0,
          isRtl: isRtl),
      BottomNavTabItem(
        imagePath: AppImagePath.cart,
        isSelected: selected == 2,
        isRtl: isRtl,
        isCart: true,
        cartCount: state.cartCount,
        showCartBadge: state.showCartBadge,
        showCartAnimation: state.isAnimation,
        showCelebration: state.duringCelebration,
      )
    ];

    if (state.isSubUserSeeWallet) {
      items.add(BottomNavTabItem(
          imagePath: AppImagePath.wallet,
          isSelected: selected == 3,
          isRtl: isRtl));
      items.add(BottomNavTabItem(
          imagePath: AppImagePath.profile,
          isSelected: selected == 4,
          isRtl: isRtl));
    } else {
      items.add(BottomNavTabItem(
          imagePath: AppImagePath.profile,
          isSelected: selected == 3,
          isRtl: isRtl));
    }
    return items;
  }
}

class _PageContainers extends StatelessWidget {
  const _PageContainers({required this.state});

  final BottomNavState state;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getScreenHeight(context),
      width: getScreenWidth(context),
      child: FadeIndexedStack(
          index: state.index,
          children: state.isSubUserSeeWallet
              ? const [
                  HomeScreen(isSubCategory: 'false'),
                  StoreScreen(),
                  BasketScreen(),
                  WalletScreen(),
                  ProfileMenuScreen()
                ]
              : const [
                  HomeScreen(isSubCategory: 'false'),
                  StoreScreen(),
                  BasketScreen(),
                  ProfileMenuScreen()
                ]),
    );
  }
}
