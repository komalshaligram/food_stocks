import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import 'package:image_cropper/image_cropper.dart';

double getScreenHeight(BuildContext context) {
  final screenHeight = MediaQuery.of(context).size.height;
  return screenHeight;
}

double getScreenWidth(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  return screenWidth;
}

void showSnackBar(
    {required BuildContext context,
    required String title,
    required Color bgColor}) {
  final snackBar = SnackBar(
    content: Text(
      title,
      style: AppStyles.rkRegularTextStyle(
          size: AppConstants.smallFont,
          color: AppColors.whiteColor,
          fontWeight: FontWeight.w400),
    ),
    backgroundColor: bgColor,
    behavior: SnackBarBehavior.floating,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Future<CroppedFile?> cropImage(
    {required String path,
    CropStyle shape = CropStyle.rectangle,
    int quality = 100,
    bool? isLogoCrop = false}) async {
  return await ImageCropper().cropImage(
    sourcePath: path,
    cropStyle: shape,
    compressQuality: quality,
    uiSettings: [
      AndroidUiSettings(
          activeControlsWidgetColor: AppColors.mainColor,
          cropFrameColor: AppColors.greyColor,
          initAspectRatio: isLogoCrop ?? false
              ? CropAspectRatioPreset.ratio16x9
              : CropAspectRatioPreset.square,
          hideBottomControls: true,
          showCropGrid: false,
          lockAspectRatio: true,
          toolbarColor: AppColors.blackColor,
          toolbarTitle: AppStrings.cropImageString,
          toolbarWidgetColor: AppColors.whiteColor),
      IOSUiSettings(
        title: AppStrings.cropImageString,
        aspectRatioLockEnabled: true,
        // showCancelConfirmationDialog: true,
        hidesNavigationBar: true,
        resetButtonHidden: true,
        rotateButtonsHidden: true,
        rotateClockwiseButtonHidden: true,
        aspectRatioPickerButtonHidden: true,
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

Future<String> scanBarcodeOrQRCode(
    {required BuildContext context,
    required String cancelText,
    required ScanMode scanMode}) async {
  String barcodeSOrQRScanRes;
  try {
    barcodeSOrQRScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff20BF6B', cancelText, true, scanMode);
    print(barcodeSOrQRScanRes);
  } on PlatformException {
    barcodeSOrQRScanRes = 'Failed to get platform version.';
  }
  debugPrint('barcode = $barcodeSOrQRScanRes');
  return barcodeSOrQRScanRes;
}

bool isRTLContent({required BuildContext context}) {
  Locale locale = Localizations.localeOf(context);
  List<Locale> rtlLocales = [Locale('he')];
  debugPrint('rtl = ${rtlLocales.contains(locale) ? "true" : "false"}');
  return rtlLocales.contains(locale) ? true : false;
}