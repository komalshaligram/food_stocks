

import 'package:flutter/material.dart';
import 'package:food_stock/ui/screens/about_app_screen.dart';
import 'package:food_stock/ui/screens/bottom_nav_screen.dart';
import 'package:food_stock/ui/screens/contact_screen.dart';
import 'package:food_stock/ui/screens/home_screen.dart';
import 'package:food_stock/ui/screens/login_screen.dart';
import 'package:food_stock/ui/screens/message_content_screen.dart';
import 'package:food_stock/ui/screens/message_screen.dart';
import 'package:food_stock/ui/screens/operation_time_screen.dart';
import 'package:food_stock/ui/screens/order_screen.dart';
import 'package:food_stock/ui/screens/question_and_answer_screen.dart';
import 'package:food_stock/ui/screens/otp_screen.dart';
import 'package:food_stock/ui/screens/splash_screen.dart';
import 'package:food_stock/ui/screens/terms_of_use_screen.dart';

import '../ui/screens/basket_screen.dart';
import '../ui/screens/connect_screen.dart';
import '../ui/screens/menu_screen.dart';
import '../ui/screens/profile_screen.dart';
import '../ui/screens/profile_screen_3.dart';
import '../ui/screens/store_screen.dart';
import '../ui/screens/wallet_screen.dart';

enum RouteDefine {
  ///ADD NAME OF ROUTE SCREEN
  ///
  splashScreen,
  loginScreen,
  registerScreen,
  connectScreen,
  profileScreen,
  profileScreen3,
  operationTimeScreen,
  bottomNavScreen,
  homeScreen,
  basketScreen,
  walletScreen,
  orderScreen,
  termsOfUseScreen,
  questionAndAnswerScreen,
  contactScreen,
  aboutAppScreen,
  messageScreen,
  messageContentScreen,
  storeScreen,
  otpScreen,

}

class AppRouting {
  static MaterialPageRoute generateRoute(RouteSettings settings) {
    final routes = <String, WidgetBuilder>{
      ///ADD ROUTE
      RouteDefine.splashScreen.name: (_) => SplashRoute.route,
      RouteDefine.connectScreen.name: (_) => ConnectRoute.route,

      RouteDefine.profileScreen.name: (_) => ProfileRoute.route,
      RouteDefine.profileScreen3.name: (_) => Profile3Route.route,
      RouteDefine.operationTimeScreen.name: (_) => OperationTimeScreenRoute.route,

      RouteDefine.loginScreen.name: (_) => LogInRoute.route,
    //  RouteDefine.registerScreen.name: (_) => RegisterRoute.route,
      RouteDefine.bottomNavScreen.name: (_) => BottomNavRoute.route,
      RouteDefine.homeScreen.name: (_) => HomeRoute.route,
      RouteDefine.menuScreen.name: (_) => MenuRoute.route,
      RouteDefine.basketScreen.name: (_) => BasketRoute.route,
      RouteDefine.walletScreen.name: (_) => WalletRoute.route,
      RouteDefine.storeScreen.name: (_) => StoreRoute.route,
      RouteDefine.orderScreen.name: (_) => OrderRoute.route,
      RouteDefine.termsOfUseScreen.name: (_) => TermsOfUseRoute.route,
      RouteDefine.questionAndAnswerScreen.name: (_) => QuestionAndAnswerRoute.route,
      RouteDefine.contactScreen.name: (_) => ContactRoute.route,
      RouteDefine.aboutAppScreen.name: (_) => AboutAppRoute.route,
      RouteDefine.messageScreen.name: (_) => MessageRoute.route,
      RouteDefine.messageContentScreen.name: (_) => MessageContentRoute.route,
      RouteDefine.otpScreen.name:(_)=>OTPRoute.route
    };

    final routeBuilder = routes[settings.name];

    return MaterialPageRoute(
      builder: (context) => routeBuilder!(context),
      settings: RouteSettings(name: settings.name),
    );
  }
}

extension RouteExt on Object {
  String get name => toString().substring(toString().indexOf('.') + 1);
}
