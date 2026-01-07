



import 'dart:io';
import 'dart:math';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../data/model/res_model/status_info_res_model/status_info_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../ui/utils/constants/app_colors.dart';
import '../../ui/utils/constants/app_constants.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/utils/constants/app_styles.dart';
import '../../ui/widget/sized_box_widget.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:another_flushbar/flushbar.dart';

import 'constants/app_strings.dart';

double getScreenHeight(BuildContext context) {
  final screenHeight = MediaQuery.of(context).size.height;
  return screenHeight;
}

double getScreenWidth(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  return screenWidth;
}

enum SnackBarType {
  success,
  failure,
}

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
    // Ensure the first digit (month) is not greater than 1
    text = '0$text$separator';
  } else if (text.length == 2 && int.parse(text) > 12) {
    // Ensure the entered month is valid (not greater than 12)
    text = '12$separator';
  } else if (text.length > 2) {
    text = '${text.substring(0, 2)}$separator${text.substring(2)}';
  }
  return text;
}

Future<String> getBottleTax() async {
  SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
  var value = preferencesHelper.getBottleTax().toString();
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
        decoration: BoxDecoration(color: AppColors.pesachBGColor, border: Border.all(color: AppColors.pesachBGColor), borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Text(
          AppLocalizations.of(context)!.pesach,
          style: AppStyles.rkRegularTextStyle(
            size: AppConstants.font_13,
          ),
        ));
  } else {
    return 0.height;
  }
}

class CustomSnackBar {
  static bool isSnackBarOpen = false;
  static void showSnackBar({
    required BuildContext context,
    required String title,
    required SnackBarType type,
  }) {
    Flushbar(
      backgroundColor: type == SnackBarType.success ? AppColors.mainColor.withOpacity(0.85) : AppColors.redColor.withOpacity(0.85),
      messageText: Text(title, style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.whiteColor, fontWeight: FontWeight.w400)),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(15),
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);
  }
}

printData(String? message) {
  // if(kDebugMode){
  debugPrint(message ?? '');
  // }
}

customShowUpdateDialog(BuildContext context, String directionality, String storeUrl) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context1) {
      return PopScope(
        canPop: false,
        child: AlertDialog(
          title: Text(AppLocalizations.of(context)!.new_version_app_update, style: AppStyles.rkRegularTextStyle(color: AppColors.blackColor, size: AppConstants.mediumFont)),
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
                  child: Text(
                    AppLocalizations.of(context)!.update,
                    style: AppStyles.rkRegularTextStyle(color: AppColors.whiteColor, size: AppConstants.font_14),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    },
  );
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

  // Pad string with zeros up to 9 digits
  id = id.length < 9 ? id.padLeft(9, '0') : id;

  int sum = 0;
  for (int i = 0; i < id.length; i++) {
    int digit = int.parse(id[i]);
    int step = digit * ((i % 2) + 1);
    sum += (step > 9) ? step - 9 : step;
  }

  return sum % 10 == 0;
}

Future<CroppedFile?> cropImage({required String path, CropStyle shape = CropStyle.rectangle, int quality = 100, bool? isLogoCrop = false}) async {
  return await ImageCropper().cropImage(
    sourcePath: path,
    cropStyle: shape,
    compressQuality: quality,
    uiSettings: [
      AndroidUiSettings(activeControlsWidgetColor: AppColors.mainColor, cropFrameColor: AppColors.greyColor, initAspectRatio: isLogoCrop ?? false ? CropAspectRatioPreset.ratio16x9 : CropAspectRatioPreset.square, hideBottomControls: true, showCropGrid: false, lockAspectRatio: false, toolbarColor: AppColors.blackColor, toolbarTitle: AppStrings.cropImageString, toolbarWidgetColor: AppColors.whiteColor),
      IOSUiSettings(
        title: AppStrings.cropImageString,
        aspectRatioLockEnabled: true,
        hidesNavigationBar: true,
        resetButtonHidden: true,
        rotateButtonsHidden: true,
        rotateClockwiseButtonHidden: true,
        aspectRatioPickerButtonHidden: false,
        aspectRatioLockDimensionSwapEnabled: true,
        cancelButtonTitle: AppStrings.cancelString,
        doneButtonTitle: AppStrings.doneString,
      ),
    ],
  );
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
    } else {
//for ios permission handling
    }
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: source);
    return pickedImage;
  } on PlatformException {
    return null;
  } catch (err) {}
  return null;
}

Future<String> scanBarcodeOrQRCode({required BuildContext context, required String cancelText, required ScanMode scanMode}) async {
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

  final formatted = NumberFormat.simpleCurrency(locale: local).format(number.abs()); // Format absolute value to avoid trailing minus

  final String result = isNegative ? '-$formatted' : formatted;

  return splitNumber(result);
}
String formatNumberPositiveToNegative({required String value, required String local}) {
  final double number = double.parse(value);
  final bool isNegative = number < 0;

  String formatted = NumberFormat.simpleCurrency(
    locale: local,
  ).format(number.abs());

  formatted = formatted.replaceAll(RegExp(r'\s+'), '');

  return isNegative ? ' -$formatted' : formatted;
}



String formatNumberForWallet({required String value, required String local, required BuildContext context}) {
  String result = (NumberFormat.compactSimpleCurrency(
    locale: local,
    decimalDigits: 1,
  ).format(double.parse(value)));

  String result1 = value.split('.')[0] + AppLocalizations.of(context)!.currency;

  return result1;
}

double vatCalculation({
  required double price,
  required double vat,
  double qty = 0,
  double deposit = 0,
}) {
  double result = price + ((price * vat) / 100) + (qty * deposit) + ((qty * deposit * vat) / 100);
  return result;
}

double vatCalculationRefund({
  required double price,
  required double vat,
  double qty = 0,
  double deposit = 0,
  double? refund, // refund is always negative
}) {
  double priceWithVat = price + ((price * vat) / 100);
  double depositWithVat = (qty * deposit) + ((qty * deposit * vat) / 100);

  double total = priceWithVat + depositWithVat;

  // Apply refund logic
  if (refund != null) {
    // refund is negative, so -refund is positive
    if (total <= -refund) {
      return 0; // refund greater than total
    } else {
      if(total <= -refund){
        return total + refund;
      }else {
        return total + refund;
      }
      // refund is negative, so subtract from total
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

double bottleDepositCalculationWithVatRefund({
  required double deposit,
  required double qty,
  double vatPercentage = 1,
  double? refund,
}) {
  double depositWithVat = (qty * deposit) + ((qty * deposit * vatPercentage) / 100);

  if (refund != null) {
    if (depositWithVat <= -refund) {
      return 0;
    } else {
      if (depositWithVat <= -refund) {
        return depositWithVat + refund;
      }else {
        return depositWithVat + refund;
      }

    }
  }

  return depositWithVat;
}

