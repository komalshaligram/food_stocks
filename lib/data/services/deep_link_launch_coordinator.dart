import '../../routes/app_routes.dart';

class DeepLinkLaunchCoordinator {
  DeepLinkLaunchCoordinator._();

  static bool openedFromDeepLink = false;

  static bool isOpenAppLink(Uri uri) {
    return uri.host == 'tiny.tavili.net' && uri.path.startsWith('/openApp');
  }

  static void markOpenedFromDeepLink() {
    openedFromDeepLink = true;
  }

  static bool isSplashRoute(String? routeName) {
    return routeName == RouteDefine.splashScreen.name;
  }
}




