import 'package:food_stock/data/model/app_config.dart';

class EnvironmentConfig {
  final AppConfig stagAppConfig = AppConfig(
      appName: "TAVILI",
      flavor: "stag",
      baseUrl: "https://api.foodstock.shtibel.com/api",
     );

  final AppConfig devAppConfig = AppConfig(
      appName: "TAVILI DEV",
      flavor: "dev",
      baseUrl: "https://devapi.foodstock.shtibel.com/api",
    );
}
