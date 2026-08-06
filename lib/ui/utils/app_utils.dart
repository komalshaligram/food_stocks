import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:store_version_checker/store_version_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../data/model/res_model/get_all_cart_res_model/get_all_cart_res_model.dart';
import '../../data/model/res_model/status_info_res_model/status_info_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/constants/app_colors.dart';
import '../../ui/utils/constants/app_constants.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/utils/constants/app_styles.dart';
import '../../ui/widget/sized_box_widget.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import 'package:food_stock/main.dart' show navigatorKey;
import 'package:another_flushbar/flushbar.dart';
import 'constants/app_img_path.dart';
import 'constants/app_urls.dart';

double getScreenHeight(BuildContext context) {
  final screenHeight = MediaQuery.of(context).size.height;
  return screenHeight;
}

double getScreenWidth(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  return screenWidth;
}

enum SnackBarType { success, failure }

bool isTablet(BuildContext context) {
  bool isTablet = false;
  if (MediaQuery.of(context).size.height > 800 && MediaQuery.of(context).size.height > 500) {
    isTablet = true;
  } else {
    return false;
  }
  return isTablet;
}

String maskCreditCardNumber(String cardNumber) {
  var firstDigits = cardNumber.substring(0, 4);
  var lastDigits = cardNumber.substring(cardNumber.length - 4, cardNumber.length);
  var requiredMask = 'X' * (16 - firstDigits.length);
  var maskedString = requiredMask + lastDigits;
  var maskedCardNumberWithSpaces = maskedString.replaceAllMapped(RegExp(r'.{4}'), (match) => '${match.group(0)}-');
  return maskedCardNumberWithSpaces.toString().substring(0, maskedCardNumberWithSpaces.length - 1);
}

String formatExpiryDate(String text) {
  String separator = '/';
  if (text.length == 1 && int.parse(text) > 1) {
    text = '0$text$separator';
  } else if (text.length == 2 && int.parse(text) > 12) {
    text = '12$separator';
  } else if (text.length > 2) {
    text = '${text.substring(0, 2)}$separator${text.substring(2)}';
  }
  return text;
}

Future<String> getBottleTax() async {
  SharedPreferencesHelper preferences = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
  var value = preferences.getBottleTax().toString();
  return Future.value(value.toString());
}

Color getStatusColor(List<StatusData> statusList, String status) {
  if (status.isEmpty) {
    return AppColors.mainColor;
  }
  String color = statusList.where((e) => e.statusNameKey == status).first.statusColor ?? '';
  final hexCode = color.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}

String getStatus(List<StatusData> statusList, String currentStatus, String language) {
  String status = '';
  if (currentStatus.isEmpty) {
    return status;
  }
  if (language == AppStrings.hebrewString) {
    status = statusList.where((e) => e.statusNameKey == currentStatus).first.statusNameHebrew ?? '';
  } else {
    status = statusList.where((e) => e.statusNameKey == currentStatus).first.statusNameEnglish ?? '';
  }
  return status;
}

String getLocalizedReason({required String apiReason, required BuildContext context}) {
  final l10n = AppLocalizations.of(context);
  if (l10n == null) {
    return apiReason;
  }

  final map = {
    'Product did not arrive at all': l10n.product_did_not_arrive_at_all,
    'המוצר לא הגיע בכלל': l10n.product_did_not_arrive_at_all,
    'Product arrived damaged': l10n.product_arrived_damaged,
    'המוצר הגיע פגום': l10n.product_arrived_damaged,
    'Product arrived incomplete': l10n.product_arrived_incomplete,
    'המוצר הגיע לא שלם': l10n.product_arrived_incomplete,
    'Expiration date issue': l10n.expiration_date_issue,
    'בעיית תאריך תפוגה': l10n.expiration_date_issue,
    'Wrong product received': l10n.wrong_product_received,
    'התקבל מוצר שגוי': l10n.wrong_product_received
  };
  return map[apiReason.trim()] ?? apiReason;
}

double getChildAspectRatio(BuildContext context, bool isSaleOn) {
  return !isSaleOn
      ? AppConstants.productGridAspectRatio8
      : Platform.isAndroid
          ? getScreenHeight(context) > 900
              ? AppConstants.productGridAspectRatio9
              : getScreenHeight(context) > 820 && getScreenHeight(context) < 900
                  ? AppConstants.productGridAspectRatio51
                  : AppConstants.productGridAspectRatio51
          : getScreenHeight(context) > 820
              ? AppConstants.productGridAspectRatio51
              : AppConstants.productGridAspectRatio51;
}

double getItemHeight(BuildContext context, bool isSaleOn) {
  return getScreenHeight(context) > 1000 && getScreenWidth(context) > 700
      ? 350
      : getScreenHeight(context) < 1000 && getScreenHeight(context) > 800 && getScreenWidth(context) > 550
          ? 260
          : isSaleOn
              ? AppConstants.salesProductItemHeight
              : AppConstants.withoutSaleItemHeight;
}

double getItemWidth(BuildContext context) {
  return getScreenHeight(context) > 1000 && getScreenWidth(context) > 700
      ? 190
      : getScreenWidth(context) > 500
          ? 160
          : 140;
}

Widget isPesachLabelShow(bool isPesach, BuildContext context) {
  if (isPesach) {
    return Container(
        padding: const EdgeInsets.only(left: 5, right: 5),
        decoration: BoxDecoration(
            color: AppColors.pesachBGColor,
            border: Border.all(color: AppColors.pesachBGColor),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Text(AppLocalizations.of(context)!.pesach, style: AppStyles.rkRegularTextStyle(size: AppConstants.font_13)));
  } else {
    return 0.height;
  }
}

class CustomSnackBar {
  static bool isSnackBarOpen = false;
  static Flushbar? _activeFlushbar;

  static void showSnackBar({required BuildContext context, required String title, required SnackBarType type}) {
    if (!context.mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!context.mounted) return;
      try {
        if (_activeFlushbar != null) {
          await _activeFlushbar!.dismiss(true);
          _activeFlushbar = null;
        }
      } catch (_) {}

      if (!context.mounted) return;
      final flushbar = Flushbar(
          backgroundColor: type == SnackBarType.success ? AppColors.mainColor.withValues(alpha: 0.85) : AppColors.redColor.withValues(alpha: 0.85),
          messageText: Text(title,
              style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.whiteColor, fontWeight: FontWeight.w400)),
          padding: const EdgeInsets.all(AppConstants.padding_10),
          margin: const EdgeInsets.all(AppConstants.padding_20),
          borderRadius: BorderRadius.circular(AppConstants.radius_15),
          duration: const Duration(seconds: 3),
          flushbarPosition: FlushbarPosition.TOP);
      _activeFlushbar = flushbar;
      try {
        await flushbar.show(context);
      } catch (e) {
        printData('Flushbar show failed: $e');
      } finally {
        if (identical(_activeFlushbar, flushbar)) {
          _activeFlushbar = null;
        }
      }
    });
  }
}

printData(String? message) {
  debugPrint(message ?? '');
}

int otpCooldownSeconds(int sendCount) {
  if (sendCount <= 1) return 30;
  if (sendCount == 2) return 60;
  return 180;
}

bool isStoreVersionNewer(String currentVersion, String storeVersion) {
  List<int> parse(String raw) {
    final cleaned = raw.trim().replaceAll(RegExp(r'[^0-9.]'), '');
    if (cleaned.isEmpty) return [0];
    return cleaned.split('.').where((part) => part.isNotEmpty).map((part) => int.tryParse(part) ?? 0).toList();
  }

  final current = parse(currentVersion);
  final store = parse(storeVersion);
  final maxLen = current.length > store.length ? current.length : store.length;

  for (var i = 0; i < maxLen; i++) {
    final left = i < current.length ? current[i] : 0;
    final right = i < store.length ? store[i] : 0;
    if (left < right) return true;
    if (left > right) return false;
  }
  return false;
}

bool _updateDialogShownInSession = false;
bool _updateDialogShowing = false;
bool _updateCheckInProgress = false;
int _updateDialogPresentGeneration = 0;
String? _pendingUpdateLanguage;
String? _pendingUpdateStoreUrl;

BuildContext? _resolveUpdateDialogContext(BuildContext? context) {
  final root = navigatorKey.currentContext;
  if (root != null && root.mounted) return root;
  if (context != null && context.mounted) return context;
  return null;
}

bool _isNavigatorOverlayReady() {
  final nav = navigatorKey.currentState;
  return nav != null && nav.mounted && nav.overlay?.mounted == true;
}

Future<void> _waitForNavigatorReady() async {
  for (var attempt = 0; attempt < 30; attempt++) {
    if (_isNavigatorOverlayReady()) return;
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }
}

Future<void> _waitForUpdateCheckSlot() async {
  for (var attempt = 0; attempt < 40; attempt++) {
    if (_updateDialogShownInSession) return;
    if (!_updateCheckInProgress) return;
    await Future<void>.delayed(const Duration(milliseconds: 150));
  }
}

Future<void> scheduleAppUpdateCheckIfNeeded() async {
  final preferences = SharedPreferencesHelper(
    prefs: await SharedPreferences.getInstance(),
  );
  for (var attempt = 0; attempt < 5; attempt++) {
    if (_resolveUpdateDialogContext(null) != null) break;
    await Future<void>.delayed(const Duration(milliseconds: 300));
  }
  await checkAndShowAppUpdateIfNeeded(
    language: preferences.getAppLanguage(),
  );
}

Future<void> scheduleScreenUpdateCheck(BuildContext? context) async {
  await _waitForNavigatorReady();
  final preferences = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
  await checkAndShowAppUpdateIfNeeded(context: _resolveUpdateDialogContext(context), language: preferences.getAppLanguage());
  await _flushPendingUpdateDialog();
}

void _queuePendingUpdateDialog(String language, String storeUrl) {
  _pendingUpdateLanguage = language;
  _pendingUpdateStoreUrl = storeUrl;
}

Future<void> _flushPendingUpdateDialog() async {
  final language = _pendingUpdateLanguage;
  final storeUrl = _pendingUpdateStoreUrl;
  if (language == null || storeUrl == null) return;
  if (_updateDialogShownInSession) {
    _pendingUpdateLanguage = null;
    _pendingUpdateStoreUrl = null;
    return;
  }

  final shown = await _presentUpdateDialog(context: null, directionality: language, storeUrl: storeUrl);
  if (shown) {
    _pendingUpdateLanguage = null;
    _pendingUpdateStoreUrl = null;
  }
}

void _showUpdateDialogOrQueue({required BuildContext? context, required String language, required String storeUrl}) {
  if (_updateDialogShownInSession) return;
  _queuePendingUpdateDialog(language, storeUrl);
  unawaited(_presentUpdateDialog(context: context, directionality: language, storeUrl: storeUrl).then((shown) {
    if (shown) {
      _pendingUpdateLanguage = null;
      _pendingUpdateStoreUrl = null;
    }
  }));
}

Future<bool> _presentUpdateDialog({required BuildContext? context, required String directionality, required String storeUrl}) async {
  if (_updateDialogShownInSession) return true;
  if (_updateDialogShowing) return false;

  final generation = ++_updateDialogPresentGeneration;

  for (var attempt = 0; attempt < 40; attempt++) {
    if (generation != _updateDialogPresentGeneration) return false;
    if (_updateDialogShownInSession) return true;

    await _waitForNavigatorReady();
    final dialogContext = _resolveUpdateDialogContext(context);
    if (dialogContext == null || !dialogContext.mounted) {
      await Future<void>.delayed(const Duration(milliseconds: 150));
      continue;
    }

    try {
      _updateDialogShowing = true;
      showDialog<void>(
          barrierDismissible: false,
          context: dialogContext,
          useRootNavigator: true,
          builder: (dialogContext) {
            return PopScope(
              canPop: false,
              child: AlertDialog(
                  title: Text(AppLocalizations.of(dialogContext)!.new_version_app_update,
                      style: AppStyles.rkRegularTextStyle(color: AppColors.blackColor, size: AppConstants.mediumFont)),
                  actions: [
                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          _launchUrl(storeUrl);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                          alignment: Alignment.center,
                          width: AppConstants.containerHeight_80,
                          decoration: BoxDecoration(gradient: AppColors.appMainGradientColor, borderRadius: BorderRadius.circular(8.0)),
                          child: Text(AppLocalizations.of(dialogContext)!.update,
                              style: AppStyles.rkRegularTextStyle(color: AppColors.whiteColor, size: AppConstants.font_14)),
                        ),
                      ),
                    )
                  ]),
            );
          }).whenComplete(() {
        _updateDialogShowing = false;
      });
      _updateDialogShownInSession = true;
      return true;
    } catch (e) {
      printData('Update dialog show failed (attempt $attempt): $e');
      _updateDialogShowing = false;
      await Future<void>.delayed(const Duration(milliseconds: 200));
    }
  }

  return false;
}

void customShowUpdateDialog(BuildContext context, String directionality, String storeUrl) {
  _showUpdateDialogOrQueue(context: context, language: directionality, storeUrl: storeUrl);
}

void showUpdateDialogIfStoreNewer(
    {required BuildContext? context,
    required String language,
    required String currentVersion,
    required String? newVersion,
    required String? appUrl,
    required String androidFallbackUrl,
    required String iosFallbackUrl}) {
  final storeVersion = newVersion?.trim();
  if (storeVersion == null || storeVersion.isEmpty) {
    printData('Update dialog skipped: empty store version');
    return;
  }

  final shouldUpdate = isStoreVersionNewer(currentVersion, storeVersion);
  printData('Update compare: current=$currentVersion store=$storeVersion shouldUpdate=$shouldUpdate');

  if (!shouldUpdate) return;

  if (Platform.isAndroid) {
    _showUpdateDialogOrQueue(context: context, language: language, storeUrl: appUrl ?? androidFallbackUrl);
  } else if (Platform.isIOS) {
    _showUpdateDialogOrQueue(context: context, language: language, storeUrl: appUrl ?? iosFallbackUrl);
  }
}

const String kAndroidPlayStorePackageId = 'com.foodstock.dev';
const String kAndroidPlayStoreUrl = 'https://play.google.com/store/apps/details?id=$kAndroidPlayStorePackageId';
const String kIosAppStoreUrl = 'https://apps.apple.com/ua/app/tavili/id6468264054';

Future<String?> fetchPlayStoreVersionName(String packageId) async {
  const locales = ['en-US', 'en-GB', 'he-IL'];
  final patterns = [
    RegExp(r'\[\[\["([0-9]+\.[0-9]+(?:\.[0-9]+)?)"\]\]'),
    RegExp(r'Current Version</div>.*?>([0-9]+\.[0-9]+(?:\.[0-9]+)?)<', dotAll: true),
    RegExp(r'"softwareVersion"\s*:\s*"([0-9]+\.[0-9]+(?:\.[0-9]+)?)"')
  ];

  for (final locale in locales) {
    try {
      final uri = Uri.parse('https://play.google.com/store/apps/details?id=$packageId&hl=$locale');
      final response = await http.get(uri, headers: const {
        'User-Agent': 'Mozilla/5.0 (Linux; Android 13) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36'
      }).timeout(const Duration(seconds: 12));
      if (response.statusCode != 200) continue;

      for (final pattern in patterns) {
        final match = pattern.firstMatch(response.body);
        final version = match?.group(1)?.trim();
        if (version != null && version.isNotEmpty) {
          return version;
        }
      }
    } catch (e) {
      printData('Play Store scrape failed ($locale): $e');
    }
  }
  return null;
}

Future<void> checkAndShowAppUpdateIfNeeded({BuildContext? context, required String language}) async {
  if (_updateDialogShownInSession) {
    printData('Update check skipped: dialog already shown');
    return;
  }
  if (_updateCheckInProgress) {
    await _waitForUpdateCheckSlot();
    if (_updateDialogShownInSession || _updateCheckInProgress) {
      printData('Update check skipped: dialog shown or check still in progress');
      return;
    }
  }

  _updateCheckInProgress = true;
  try {
    if (Platform.isAndroid) {
      final packageInfo = await PackageInfo.fromPlatform();
      final installedVersion = packageInfo.version;
      final installer = packageInfo.installerStore?.toLowerCase() ?? '';
      final fromPlayStore = installer.contains('vending') || installer.contains('google') || installer == 'com.android.vending';

      if (fromPlayStore) {
        try {
          final updateInfo = await InAppUpdate.checkForUpdate();
          printData('InAppUpdate availability: ${updateInfo.updateAvailability}');
          if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
            _showUpdateDialogOrQueue(context: context, language: language, storeUrl: kAndroidPlayStoreUrl);
            return;
          }
        } catch (e) {
          printData('InAppUpdate check failed: $e');
        }
      } else {
        printData('Skipping InAppUpdate (installer=$installer) — not a Play install');
      }

      try {
        final checker = StoreVersionChecker();
        final value = await checker.checkUpdate();
        printData('StoreVersionChecker current=${value.currentVersion} store=${value.newVersion} error=${value.errorMessage}');

        var storeVersion = value.newVersion?.trim();
        if (storeVersion == null || storeVersion.isEmpty) {
          storeVersion = await fetchPlayStoreVersionName(kAndroidPlayStorePackageId);
          printData('Play Store scrape version: $storeVersion');
        }

        showUpdateDialogIfStoreNewer(
            context: context,
            language: language,
            currentVersion: value.currentVersion.isNotEmpty ? value.currentVersion : installedVersion,
            newVersion: storeVersion,
            appUrl: value.appURL,
            androidFallbackUrl: kAndroidPlayStoreUrl,
            iosFallbackUrl: kIosAppStoreUrl);
      } catch (e) {
        printData('Android store version check failed: $e');
        final scraped = await fetchPlayStoreVersionName(kAndroidPlayStorePackageId);
        if (scraped == null) return;
        showUpdateDialogIfStoreNewer(
            context: context,
            language: language,
            currentVersion: installedVersion,
            newVersion: scraped,
            appUrl: kAndroidPlayStoreUrl,
            androidFallbackUrl: kAndroidPlayStoreUrl,
            iosFallbackUrl: kIosAppStoreUrl);
      }
      return;
    }

    if (Platform.isIOS) {
      final checker = StoreVersionChecker();
      final value = await checker.checkUpdate();
      showUpdateDialogIfStoreNewer(
          context: context,
          language: language,
          currentVersion: value.currentVersion,
          newVersion: value.newVersion,
          appUrl: value.appURL,
          androidFallbackUrl: kAndroidPlayStoreUrl,
          iosFallbackUrl: kIosAppStoreUrl);
    }
  } catch (e) {
    printData('checkAndShowAppUpdateIfNeeded failed: $e');
  } finally {
    _updateCheckInProgress = false;
  }
}

String normalizeWhatsAppPhone(String phoneNumber) {
  final digits = phoneNumber.replaceAll(RegExp(r'\D'), '');
  if (digits.isEmpty) {
    return '';
  }
  if (digits.startsWith('972')) {
    return digits;
  }
  if (digits.startsWith('0')) {
    return '972${digits.substring(1)}';
  }
  return '972$digits';
}

Future<bool> openPhoneCall(String phoneNumber) async {
  final digits = phoneNumber.replaceAll(RegExp(r'\D'), '');
  if (digits.isEmpty) {
    return false;
  }
  final uri = Uri(scheme: 'tel', path: digits);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
    return true;
  }
  return false;
}

Future<bool> openWhatsAppChat(String phoneNumber) async {
  final intlPhone = normalizeWhatsAppPhone(phoneNumber);
  if (intlPhone.isEmpty) {
    return false;
  }
  final appUri = Uri.parse('whatsapp://send?phone=$intlPhone');
  if (await canLaunchUrl(appUri)) {
    await launchUrl(appUri, mode: LaunchMode.externalApplication);
    return true;
  }
  final webUri = Uri.parse('https://wa.me/$intlPhone');
  if (await canLaunchUrl(webUri)) {
    await launchUrl(webUri, mode: LaunchMode.externalApplication);
    return true;
  }
  return false;
}

Future<void> _launchUrl(String storeUrl) async {
  Uri url = Uri.parse(storeUrl);
  try {
    launchUrl(url);
  } on PlatformException catch (e) {
    printData(e.toString());
  } finally {
    launchUrl(url);
  }
}

bool isValidIsraeliID(String id) {
  id = id.trim();
  if (id.length > 9 || id.length < 5 || int.tryParse(id) == null) return false;
  id = id.length < 9 ? id.padLeft(9, '0') : id;

  int sum = 0;
  for (int i = 0; i < id.length; i++) {
    int digit = int.parse(id[i]);
    int step = digit * ((i % 2) + 1);
    sum += (step > 9) ? step - 9 : step;
  }
  return sum % 10 == 0;
}

Future<CroppedFile?> cropImage(
    {required String path, CropStyle shape = CropStyle.rectangle, int quality = 100, bool lockAspectRatio = true, bool? isLogoCrop = false}) async {
  return await ImageCropper().cropImage(sourcePath: path, compressQuality: quality, uiSettings: [
    AndroidUiSettings(
        activeControlsWidgetColor: AppColors.mainColor,
        cropFrameColor: AppColors.greyColor,
        initAspectRatio: isLogoCrop ?? false ? CropAspectRatioPreset.ratio16x9 : CropAspectRatioPreset.square,
        hideBottomControls: true,
        showCropGrid: false,
        lockAspectRatio: false,
        toolbarColor: AppColors.blackColor,
        toolbarTitle: AppStrings.cropImageString,
        toolbarWidgetColor: AppColors.whiteColor),
    IOSUiSettings(
        title: AppStrings.cropImageString,
        aspectRatioLockEnabled: lockAspectRatio,
        hidesNavigationBar: true,
        resetButtonHidden: true,
        rotateButtonsHidden: true,
        rotateClockwiseButtonHidden: true,
        aspectRatioPickerButtonHidden: false,
        aspectRatioLockDimensionSwapEnabled: true,
        cancelButtonTitle: AppStrings.cancelString,
        doneButtonTitle: AppStrings.doneString)
  ]);
}

String getFileSizeString({required int bytes, int decimals = 0}) {
  if (bytes <= 0) {
    return '0 bytes';
  }
  const suffixList = [" Bytes", " KB", " MB", " GB", " TB"];
  int i = (log(bytes) / log(1024)).floor();
  return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixList[i];
}

Future<XFile?> openImagePicker(ImageSource source) async {
  try {
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.version.sdkInt < 30) {
        if (source == ImageSource.camera) {
          if (await Permission.camera.isPermanentlyDenied) {
            return null;
          }
          if (!(await Permission.camera.request().isGranted)) {
            return null;
          }
        } else {
          if (await Permission.photos.isPermanentlyDenied) {
            return null;
          }
          if (!(await Permission.photos.request().isGranted)) {
            return null;
          }
        }
      }
    }
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: source);
    return pickedImage;
  } on PlatformException {
    return null;
  } catch (_) {}
  return null;
}

Future<bool> ensureBarcodeScannerCameraPermission(BuildContext context) async {
  if (Platform.isIOS) {
    return true;
  }

  if (await Permission.camera.isGranted) {
    return true;
  }

  if (await Permission.camera.isPermanentlyDenied) {
    if (context.mounted) {
      CustomSnackBar.showSnackBar(context: context, title: AppLocalizations.of(context)!.camera_permission, type: SnackBarType.failure);
    }
    return false;
  }

  final status = await Permission.camera.request();
  if (status.isGranted) {
    return true;
  }

  if (context.mounted) {
    CustomSnackBar.showSnackBar(context: context, title: AppLocalizations.of(context)!.camera_permission, type: SnackBarType.failure);
  }
  return false;
}

Future<String> scanBarcodeOrQRCode({required BuildContext context, required String cancelText, required ScanMode scanMode}) async {
  if (!await ensureBarcodeScannerCameraPermission(context)) {
    return '-1';
  }

  String barcodeSOrQRScanRes;
  try {
    barcodeSOrQRScanRes = await FlutterBarcodeScanner.scanBarcode('#ff20BF6B', cancelText, true, scanMode);
    printData(barcodeSOrQRScanRes);
  } on PlatformException {
    barcodeSOrQRScanRes = 'Failed to get platform version.';
  }
  printData('barcode = $barcodeSOrQRScanRes');
  return barcodeSOrQRScanRes;
}

bool isRTLContent({required BuildContext context}) {
  Locale locale = Localizations.localeOf(context);
  List<Locale> rtlLocales = [const Locale(AppStrings.hebrewString)];
  return rtlLocales.contains(locale) ? true : false;
}

extension RTLExtension on BuildContext {
  bool get rtl => [const Locale(AppStrings.hebrewString)].contains(Localizations.localeOf(this)) ? true : false;
}

String splitNumber(String price) {
  var splitPrice = price.split(".");
  if (splitPrice[1] == "00") {
    return splitPrice[0];
  } else {
    return price.toString();
  }
}

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
  String toLocalization() => contains('.') ? split('.')[1].toLowerCase() : this;
}

String formatNumber({required String value, required String local}) {
  final double number = double.parse(value);
  final bool isNegative = number < 0;
  final formatted = NumberFormat.simpleCurrency(locale: local).format(number.abs());
  final String result = isNegative ? '-$formatted' : formatted;
  return splitNumber(result);
}

String formatSignedNumber(dynamic value) {
  final double amount = value is num ? value.toDouble() : double.tryParse(value?.toString() ?? '0') ?? 0;
  final formatted = NumberFormat.decimalPattern('en_IN').format(amount.abs());
  return amount.isNegative ? '-$formatted ₪' : '$formatted ₪';
}

String formatNumberPositiveToNegative({required String value, required String local}) {
  final double number = double.parse(value);
  final bool isNegative = number < 0;
  String formatted = NumberFormat.simpleCurrency(locale: local).format(number.abs());
  formatted = formatted.replaceAll(RegExp(r'\s+'), '');
  return isNegative ? ' -$formatted' : formatted;
}

String formatNumberForWallet({required String value, required String local, required BuildContext context}) {
  final currency = AppLocalizations.of(context)?.currency ?? '₪';
  final parsed = double.tryParse(value) ?? 0;
  final integerPart = value.contains('.') ? value.split('.').first : parsed.toStringAsFixed(0);
  return '$integerPart$currency';
}

double vatCalculation({required double price, required double vat, double qty = 0, double deposit = 0}) {
  double result = price + ((price * vat) / 100) + (qty * deposit) + ((qty * deposit * vat) / 100);
  return result;
}

double vatCalculationRefund({required double price, required double vat, double qty = 0, double deposit = 0, double? refund}) {
  double priceWithVat = price + ((price * vat) / 100);
  double depositWithVat = (qty * deposit) + ((qty * deposit * vat) / 100);
  double total = priceWithVat + depositWithVat;

  if (refund != null) {
    if (total <= -refund) {
      return 0;
    } else {
      if (total <= -refund) {
        return total + refund;
      } else {
        return total + refund;
      }
    }
  }
  return total;
}

double totalVatAmountCalculation({required double price, required double vat, double qty = 0, double deposit = 0}) {
  double result = ((price * vat) / 100) + ((qty * deposit * vat) / 100);
  return result;
}

double bottleDepositCalculation({double units = 1, required double deposit, required double qty}) {
  double result = qty * deposit * units;
  return result;
}

double bottleDepositCalculationWithVat({required double deposit, required double qty, double vatPercentage = 1}) {
  double result = (qty * deposit) + ((qty * deposit * vatPercentage) / 100);
  return result;
}

/// Minimum-order progress excludes VAT: bottle deposit + subject to VAT + not subject to VAT.
double minimumOrderProgressAmount({
  double bottleTax = 0,
  double bottleQuantities = 0,
  double amountSubjectToVat = 0,
  double amountNotSubjectToVat = 0,
}) {
  return bottleDepositCalculation(deposit: bottleTax, qty: bottleQuantities) + amountSubjectToVat + amountNotSubjectToVat;
}

double sumProductTotalVatAmounts(Iterable<double?> productTotalVatAmounts) {
  return productTotalVatAmounts.fold<double>(0, (sum, amount) => sum + (amount ?? 0));
}

double calculateBasketGrandTotal(
    {required double productsTotalWithVat, required double bottleTax, required double vatPercentage, required int bottleQuantities}) {
  if (bottleQuantities <= 0) {
    return productsTotalWithVat;
  }

  return productsTotalWithVat + bottleDepositCalculationWithVat(deposit: bottleTax, qty: bottleQuantities.toDouble(), vatPercentage: vatPercentage);
}

String formatInvoiceDate(String date) {
  if (date.isEmpty) return '';
  if (date.length > 10) {
    return date.substring(0, 10);
  }
  return date;
}

Widget getPaymentStatusWidget(String status, BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_3, horizontal: AppConstants.padding_8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.radius_50),
          color: status == AppStrings.openText
              ? AppColors.statusOpenColor
              : status == AppStrings.closedText
                  ? AppColors.statusCloseColor
                  : status == AppStrings.inProgressText
                      ? AppColors.statusInProgressColor
                      : AppColors.statusPartiallyClosedColor),
      child: Text(
          status == AppStrings.openText
              ? AppLocalizations.of(context)!.invoice_open
              : status == AppStrings.closedText
                  ? AppLocalizations.of(context)!.invoice_close
                  : status == AppStrings.inProgressText
                      ? AppLocalizations.of(context)!.in_progress_text
                      : AppLocalizations.of(context)!.partially_closed_text,
          style: AppStyles.rkRegularTextStyle(size: AppConstants.font_12, color: AppColors.whiteColor, fontWeight: FontWeight.w400)),
    );

Widget titleText(BuildContext context, String title) => Text(title,
    style: AppStyles.rkBoldTextStyle(size: AppConstants.smallFont, color: AppColors.blackColor, fontWeight: FontWeight.bold),
    maxLines: 1,
    overflow: TextOverflow.ellipsis);

Widget subTitleValueText(BuildContext context, String subTitle) => Text(subTitle,
    style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.blackColor, fontWeight: FontWeight.normal),
    maxLines: 1,
    overflow: TextOverflow.ellipsis);

Widget titleGreenText(BuildContext context, String title, ltr) => Directionality(
      textDirection: ltr,
      child: Text(title,
          textAlign: TextAlign.center,
          style: AppStyles.rkBoldTextStyle(size: AppConstants.smallFont, color: AppColors.notificationColor, fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
    );

Future<Map<String, int>> fetchCartQuantities(BuildContext context) async {
  SharedPreferencesHelper preferences = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
  try {
    if (!preferences.getGuestUser()) {
      final cartRes = await DioClient(context).post('${AppUrlEndPoints.getAllCartUrl}${preferences.getCartId()}');
      final cartResponse = GetAllCartResModel.fromJson(cartRes);

      if (cartResponse.status == AppConstants.code_200) {
        final items = cartResponse.data?.data ?? [];
        return {for (var item in items) item.id ?? '': item.totalQuantity ?? 0};
      }
    }
  } catch (_) {}
  return {};
}

Widget noDataWidget(String title) => Center(
    child: Text(title, textAlign: TextAlign.center, style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.textColor)));

Widget noDataWithEmpty(String title, BuildContext context) =>
    Container(height: getScreenHeight(context) - 80, width: getScreenWidth(context), alignment: Alignment.center, child: noDataWidget(title));

Widget cartImageWidget() => Container(
      height: 50,
      width: 50,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent, width: 1),
          gradient: AppColors.appMainGradientColor,
          borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_100))),
      child: Center(
        child: SvgPicture.asset(AppImagePath.cart,
            height: 26, width: 26, fit: BoxFit.cover, colorFilter: ColorFilter.mode(AppColors.whiteColor, BlendMode.srcIn)),
      ),
    );

void inProgressSnackBarWidget(BuildContext context) =>
    CustomSnackBar.showSnackBar(context: context, title: AppStrings.getLocalizedStrings('Oops! in progress', context), type: SnackBarType.success);

Widget smartRefreshCustomHeaderWidget() => CustomHeader(
    refreshStyle: RefreshStyle.Behind,
    builder: (c, m) {
      return Container(
          height: 30,
          width: 30,
          margin: const EdgeInsets.only(top: 90, bottom: AppConstants.padding_30),
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.1), blurRadius: AppConstants.blur_10)],
              color: AppColors.whiteColor,
              shape: BoxShape.circle),
          child: CupertinoActivityIndicator(color: AppColors.mainColor, radius: AppConstants.radius_10));
    });

Widget imageNotAvailableWidget(double size) => Container(
    width: size, height: size, color: AppColors.whiteColor, alignment: Alignment.center, child: Image.asset(AppImagePath.imageNotAvailable5));

Widget loaderWidget(double size) =>
    Center(child: SizedBox(width: size, height: size, child: CupertinoActivityIndicator(color: AppColors.blackColor)));

Widget invoiceOrderNumberWidget(String title) => Stack(alignment: Alignment.bottomLeft, children: [
      Text(title,
          style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.notificationColor, fontWeight: FontWeight.w400),
          maxLines: 2,
          overflow: TextOverflow.ellipsis),
      Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(height: 1, color: AppColors.notificationColor, margin: const EdgeInsets.only(top: AppConstants.padding_3))),
    ]);

int normalizeWeekdayIndex(int day) {
  if (day < 0) {
    return -1;
  }
  if (day == 0) {
    return 0;
  }
  if (day <= 7) {
    return day % 7;
  }
  return -1;
}

String weekdayLabel(BuildContext context, int day, {AppLocalizations? l10n}) {
  final localizations = l10n ?? AppLocalizations.of(context);
  if (localizations == null) {
    return '';
  }
  switch (normalizeWeekdayIndex(day)) {
    case 0:
      return localizations.sunday;
    case 1:
      return localizations.monday;
    case 2:
      return localizations.tuesday;
    case 3:
      return localizations.wednesday;
    case 4:
      return localizations.thursday;
    case 5:
      return localizations.friday_and_holiday_eves;
    case 6:
      return localizations.saturday_and_holidays;
    default:
      return '';
  }
}
