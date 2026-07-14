import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../../bloc/connect_screen/connect_bloc.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/constants/app_colors.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/widget/custom_button_widget.dart';
import '../../ui/widget/sized_box_widget.dart';
import '../utils/app_utils.dart';
import '../utils/constants/app_img_path.dart';

class ConnectRoute {
  static Widget get route => const ConnectScreen();
}

class ConnectScreen extends StatelessWidget {
  const ConnectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => ConnectBloc(), child: const ConnectScreenWidget());
  }
}

class ConnectScreenWidget extends StatelessWidget {
  const ConnectScreenWidget({super.key});

  void _onLoginPressed(BuildContext context) {
    Navigator.pushNamed(context, RouteDefine.loginScreen.name,
        arguments: {AppStrings.isRegisterString: false});
  }

  void _onGuestLoginPressed(BuildContext context) {
    context
        .read<ConnectBloc>()
        .add(ConnectEvent.logInAsGuest(context: context));
  }

  @override
  Widget build(BuildContext context) {
    Widget buttonWidget(
            {required bool enabled,
            required VoidCallback onPressed,
            bool? isLoading,
            required String buttonText}) =>
        CustomButtonWidget(
          buttonText: buttonText,
          fontColors: AppColors.mainColor,
          borderColor: AppColors.mainColor,
          isFromConnectScreen: true,
          isLoading: isLoading ?? false,
          loadingColor: AppColors.mainColor,
          enable: enabled,
          onPressed: enabled ? onPressed : null,
        );

    return PopScope(
      canPop: false,
      child: BlocBuilder<ConnectBloc, ConnectState>(builder: (context, state) {
        final bool isGuestLoading = state.isLoading;
        final bool areButtonsEnabled = !isGuestLoading;

        return Scaffold(
          backgroundColor: AppColors.pageColor,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 38, right: 38),
              child: Center(
                child: Column(children: [
                  SizedBox(height: getScreenHeight(context) * 0.15),
                  SvgPicture.asset(AppImagePath.splashLogo,
                      height: getScreenHeight(context) * 0.18,
                      width: getScreenWidth(context) * 0.48),
                  SizedBox(height: getScreenHeight(context) * 0.01),
                  buttonWidget(
                      enabled: areButtonsEnabled,
                      onPressed: () => _onLoginPressed(context),
                      buttonText: AppLocalizations.of(context)!.login),
                  20.height,
                  if (Platform.isIOS)
                    buttonWidget(
                        enabled: areButtonsEnabled,
                        isLoading: isGuestLoading,
                        onPressed: () => _onGuestLoginPressed(context),
                        buttonText:
                            AppLocalizations.of(context)!.login_as_guest)
                ]),
              ),
            ),
          ),
        );
      }),
    );
  }
}
