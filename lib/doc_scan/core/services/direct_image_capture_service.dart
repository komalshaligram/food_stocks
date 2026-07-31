import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../gen_l10n/app_localizations.dart';
import '../constants/app_constants.dart';
import '../platform/native_scanner_channel.dart';
import '../theme/app_colors.dart';

enum ScanCaptureSource { camera, gallery }

/// Direct capture — camera (VisionKit on iOS) or gallery, multi-page, crop + rotate.
class DirectImageCaptureService {
  static const int _imageQuality = 90;
  final ImagePicker _picker = ImagePicker();

  Future<List<File>?> captureFromCamera(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    if (!await _ensureCameraPermission(context, l10n)) return null;

    final pages = <File>[];
    while (pages.length < AppConstants.maxScanPages) {
      if (!context.mounted) return pages.isEmpty ? null : pages;

      final picked = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: _imageQuality,
      );
      if (picked == null) {
        return pages.isEmpty ? null : pages;
      }

      final cropped = await _cropPage(context, l10n, picked.path);
      if (cropped == null) {
        if (pages.isEmpty) continue;
        final keep = await _confirmAddAnotherPage(context, l10n, pages.length);
        if (!keep) return pages;
        continue;
      }

      final saved = await _persistImage(File(cropped.path));
      if (saved != null) pages.add(saved);

      if (pages.length >= AppConstants.maxScanPages) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                l10n.scanMaxPagesReached(AppConstants.maxScanPages),
              ),
            ),
          );
        }
        break;
      }

      if (!context.mounted) return pages;
      final addMore = await _confirmAddAnotherPage(context, l10n, pages.length);
      if (!addMore) break;
    }

    return pages.isEmpty ? null : pages;
  }

  /// iOS only — Apple VisionKit document scanner (no fallback to regular camera).
  Future<List<File>?> captureFromVisionKit() async {
    if (!Platform.isIOS) return null;

    final paths = await NativeScannerChannel.captureDocumentScan();
    if (paths.isEmpty) return null;

    final files = <File>[];
    for (final path in paths) {
      final file = File(path);
      if (file.existsSync()) files.add(file);
    }
    return files.isEmpty ? null : files;
  }

  Future<List<File>?> captureFromGallery(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    if (!await _ensureGalleryPermission(context, l10n)) return null;
    if (!context.mounted) return null;

    const remaining = AppConstants.maxScanPages;
    final picked = await _picker.pickMultiImage(
      imageQuality: _imageQuality,
      limit: remaining,
    );
    if (picked.isEmpty) return null;

    final pages = <File>[];
    for (var i = 0; i < picked.length; i++) {
      if (!context.mounted) break;

      final cropped = await _cropPage(
        context,
        l10n,
        picked[i].path,
        currentIndex: i + 1,
        totalCount: picked.length,
      );
      if (cropped == null) continue;

      final saved = await _persistImage(File(cropped.path));
      if (saved != null) pages.add(saved);
    }

    return pages.isEmpty ? null : pages;
  }

  Future<CroppedFile?> _cropPage(
    BuildContext context,
    AppLocalizations l10n,
    String sourcePath, {
    int? currentIndex,
    int? totalCount,
  }) async {
    final title = currentIndex != null && totalCount != null
        ? l10n.scanCropPageCounter(currentIndex, totalCount)
        : l10n.scanCropPageTitle;

    return ImageCropper().cropImage(
      sourcePath: sourcePath,
      compressQuality: _imageQuality,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: title,
          toolbarColor: AppColors.headerGradientStart,
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: AppColors.accentGreen,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          hideBottomControls: false,
        ),
        IOSUiSettings(
          title: title,
          cancelButtonTitle: l10n.cancel,
          doneButtonTitle: l10n.docutainButtonEditFinishTitle,
          aspectRatioLockEnabled: false,
        ),
      ],
    );
  }

  Future<bool> _confirmAddAnotherPage(
    BuildContext context,
    AppLocalizations l10n,
    int pageCount,
  ) async {
    final isIos = Theme.of(context).platform == TargetPlatform.iOS;
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => isIos
          ? CupertinoAlertDialog(
              title: Text(l10n.scanAddAnotherPageTitle),
              content: Text(l10n.scanAddAnotherPageMessage(pageCount)),
              actions: [
                CupertinoDialogAction(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text(l10n.scanFinishCapture),
                ),
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: Text(l10n.scanAddPage),
                ),
              ],
            )
          : AlertDialog(
              title: Text(l10n.scanAddAnotherPageTitle),
              content: Text(l10n.scanAddAnotherPageMessage(pageCount)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text(l10n.scanFinishCapture),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: Text(l10n.scanAddPage),
                ),
              ],
            ),
    );
    return result ?? false;
  }

  Future<File?> _persistImage(File source) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final scansDir = Directory('${dir.path}/doc_scan_pages');
      if (!await scansDir.exists()) {
        await scansDir.create(recursive: true);
      }
      final ts = DateTime.now().millisecondsSinceEpoch;
      final target = File('${scansDir.path}/page_$ts.jpg');
      await source.copy(target.path);
      return target;
    } catch (_) {
      return source.existsSync() ? source : null;
    }
  }

  Future<bool> _ensureCameraPermission(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    if (!Platform.isAndroid) return true;

    final info = await DeviceInfoPlugin().androidInfo;
    if (info.version.sdkInt >= 30) return true;

    if (await Permission.camera.isPermanentlyDenied) {
      if (context.mounted) _showPermissionSnackBar(context, l10n);
      return false;
    }
    if (!await Permission.camera.request().isGranted) {
      if (context.mounted) _showPermissionSnackBar(context, l10n);
      return false;
    }
    return true;
  }

  Future<bool> _ensureGalleryPermission(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    if (!Platform.isAndroid) return true;

    final info = await DeviceInfoPlugin().androidInfo;
    if (info.version.sdkInt >= 33) return true;
    if (info.version.sdkInt >= 30) {
      if (await Permission.photos.isPermanentlyDenied) {
        if (context.mounted) _showPermissionSnackBar(context, l10n);
        return false;
      }
      if (!await Permission.photos.request().isGranted) {
        if (context.mounted) _showPermissionSnackBar(context, l10n);
        return false;
      }
      return true;
    }

    if (await Permission.storage.isPermanentlyDenied) {
      if (context.mounted) _showPermissionSnackBar(context, l10n);
      return false;
    }
    if (!await Permission.storage.request().isGranted) {
      if (context.mounted) _showPermissionSnackBar(context, l10n);
      return false;
    }
    return true;
  }

  void _showPermissionSnackBar(BuildContext context, AppLocalizations l10n) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.scanPermissionDenied)),
    );
  }
}
