import 'package:flutter/material.dart';
import 'package:food_stock/ui/screens/bottom_nav_screen.dart';
import 'package:food_stock/ui/screens/home_screen.dart';
import 'package:food_stock/ui/screens/login_screen.dart';
import 'package:food_stock/ui/screens/operation_time_screen.dart';
import 'package:food_stock/ui/screens/splash_screen.dart';
import '../ui/screens/connect_screen.dart';

import '../ui/screens/file_upload_screen.dart';
import '../ui/screens/profile_screen.dart';
import '../ui/screens/profile_screen_3.dart';


enum RouteDefine {
  ///ADD NAME OF ROUTE SCREEN
  splashScreen,
  loginScreen,
  registerScreen,
  connectScreen,
  profileScreen,

  profileScreen3,
  operationTimeScreen,

  bottomNavScreen,
  homeScreen,
  fileUploadScreen

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
      RouteDefine.fileUploadScreen.name: (_) => FileUploadScreenRoute.route,

      RouteDefine.loginScreen.name: (_) => LogInRoute.route,
      RouteDefine.bottomNavScreen.name: (_) => BottomNavRoute.route,
      RouteDefine.homeScreen.name: (_) => HomeRoute.route,
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
