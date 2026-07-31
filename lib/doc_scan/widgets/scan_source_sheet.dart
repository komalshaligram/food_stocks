import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/services/direct_image_capture_service.dart';
import '../core/theme/app_colors.dart';
import '../gen_l10n/app_localizations.dart';
import 'adaptive_bottom_sheet.dart';

Future<ScanCaptureSource?> showScanSourceSheet(BuildContext context) {
  final l10n = AppLocalizations.of(context);

  return showAdaptiveBottomSheet<ScanCaptureSource>(
    context: context,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.scanSourceTitle,
                textAlign: TextAlign.center,
                style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
              ),
              const SizedBox(height: 20),
              _ScanSourceTile(
                icon: CupertinoIcons.camera,
                label: l10n.scanSourceCamera,
                onTap: () => Navigator.of(ctx).pop(ScanCaptureSource.camera),
              ),
              const SizedBox(height: 12),
              _ScanSourceTile(
                icon: CupertinoIcons.photo_on_rectangle,
                label: l10n.scanSourceGallery,
                onTap: () => Navigator.of(ctx).pop(ScanCaptureSource.gallery),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _ScanSourceTile extends StatelessWidget {
  const _ScanSourceTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.accentGreen.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.accentGreen, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                ),
              ),
              const Icon(
                CupertinoIcons.chevron_left,
                color: AppColors.textSecondary,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
