import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';

import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../../bloc/connect_screen/connect_bloc.dart';
import '../../routes/app_routes.dart';
import '../utils/app_utils.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_img_path.dart';
import '../widget/custom_button_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConnectRoute {
  static Widget get route => const ConnectScreen();
}

class ConnectScreen extends StatelessWidget {
  const ConnectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConnectBloc(),

      child: ConnectScreenWidget(),
    );
  }
}


class ConnectScreenWidget extends StatelessWidget {
   ConnectScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ConnectBloc bloc = context.read<ConnectBloc>();
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: BlocBuilder<ConnectBloc, ConnectState>(
  builder: (context, state) {
    return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 38, right: 38),
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: getScreenHeight(context) * 0.15,
                  ),
                  SvgPicture.asset(
                    AppImagePath.splashLogo,
                    height: getScreenHeight(context) * 0.18,
                    width: getScreenWidth(context) * 0.48,
                  ),
                  SizedBox(
                    height: getScreenHeight(context) * 0.01,
                  ),
                  CustomButtonWidget(
                    buttonText: AppLocalizations.of(context)!.register,
                    bGColor: AppColors.mainColor,
                    onPressed: () {
                      Navigator.pushNamed(context, RouteDefine.loginScreen.name,
                          arguments: {AppStrings.isRegisterString: true});
                    },
                  ),
                  20.height,
                  CustomButtonWidget(
                    buttonText: AppLocalizations.of(context)!.login,
                    fontColors: AppColors.mainColor,
                    borderColor: AppColors.mainColor,
                    isFromConnectScreen: true,
                    onPressed: () {
                      Navigator.pushNamed(context, RouteDefine.loginScreen.name,
                          arguments: {AppStrings.isRegisterString: false});
                    },
                  ),
                  20.height,
                 GestureDetector(
                      onTap: (){
                        bloc.add(ConnectEvent.logInAsGuest(context: context));
                      },
                      child: Text(AppLocalizations.of(context)!.login_as_guest,style: TextStyle(color: AppColors.mainColor,
                      fontSize: AppConstants.mediumFont
                      )

                        ,))
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
}