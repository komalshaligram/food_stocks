import 'package:package_info_plus/package_info_plus.dart';
import '../storage/shared_preferences_helper.dart';

class AppVersionService {
  AppVersionService._();

  static Future<void> saveCurrentVersion(
    SharedPreferencesHelper preferences,
  ) async {
    final packageInfo = await PackageInfo.fromPlatform();
    await preferences.setAppVersion(version: packageInfo.version);
  }
}
