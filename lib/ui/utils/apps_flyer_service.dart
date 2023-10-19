import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppsFlyerService{

  Future<void> setup() async{
    AppsflyerSdk _appsflyerSdk;
    final AppsFlyerOptions options = AppsFlyerOptions(
        afDevKey: dotenv.env["DEV_KEY"]??'',
        showDebug: true,
        timeToWaitForATTUserAuthorization: 15);
    _appsflyerSdk = AppsflyerSdk(options);
    _appsflyerSdk.initSdk(registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: true,
        registerOnDeepLinkingCallback: false);
    _appsflyerSdk.onAppOpenAttribution((res) {
      print("onAppOpenAttribution res: " + res.toString());
      return _appsflyerSdk.logEvent('App Open', res);
    });
    _appsflyerSdk.onInstallConversionData((res) {
      print("onInstallConversionData res: " + res.toString());
      return _appsflyerSdk.logEvent('App Install', res);
    });
  }

}
