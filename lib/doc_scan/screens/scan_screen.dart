import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/config/app_config.dart';
import '../core/constants/app_constants.dart';
import '../core/theme/app_colors.dart';
import '../gen_l10n/app_localizations.dart';
import '../providers/locale_provider.dart';
import '../providers/scanner_provider.dart';
import '../widgets/gradient_button.dart';

/// מסך סריקה – מצב סריקה ומצב אישור (תצוגה מקדימה + שלח).
class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  bool _showConfirmation = false;
  bool _isScanning = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isRealScanner = useRealScanner;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.scan),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () => context.pop(),
        ),
      ),
      body: _showConfirmation
          ? _buildConfirmation(context, l10n, isRealScanner)
          : _buildScanArea(context, l10n, isRealScanner),
    );
  }

  Widget _buildScanArea(
      BuildContext context, AppLocalizations l10n, bool isRealScanner) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 280,
              decoration: BoxDecoration(
                color: AppColors.accentGreen.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.accentGreen.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.document_scanner,
                size: 80,
                color: AppColors.accentGreen.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.scanPlaceholder,
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.scanMockHint,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            GradientButton(
              label: l10n.scanButton,
              icon: const Icon(Icons.camera_alt),
              colors: const [
                AppColors.headerGradientStart,
                AppColors.headerGradientEnd,
              ],
              onPressed: _isScanning
                  ? null
                  : () async {
                      HapticFeedback.lightImpact();
                      if (!isRealScanner) {
                        setState(() => _showConfirmation = true);
                        return;
                      }
                      setState(() {
                        _isScanning = true;
                      });
                      final scanner = ref.read(scannerProvider);
                      final locale = resolveDocScanLocale(context);
                      final result = await scanner.startScan(locale: locale);
                      if (!mounted) return;
                      setState(() {
                        _isScanning = false;
                      });
                      if (!result.success) {
                        if (result.errorMessage != null &&
                            result.errorMessage!.isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(result.errorMessage!)),
                          );
                        }
                        return;
                      }
                      setState(() => _showConfirmation = true);
                    },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmation(
      BuildContext context, AppLocalizations l10n, bool isRealScanner) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            l10n.pageScanned,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 320,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(color: AppColors.background),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.picture_as_pdf,
                          size: 64,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.previewPlaceholder,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          GradientButton(
            label: l10n.send,
            icon: const Icon(Icons.send),
            colors: const [
              AppColors.headerGradientStart,
              AppColors.headerGradientEnd,
            ],
            onPressed: () async {
              HapticFeedback.lightImpact();
              String? pdfPath;
              List<String> imagePaths = const [];
              bool didTryImageExport = false;
              String? imageExportError;
              if (isRealScanner) {
                final scanner = ref.read(scannerProvider);
                didTryImageExport = true;

                final imageFiles = await scanner.generateImages('');
                final file = await scanner.generatePdf('');
                pdfPath = file?.path;
                imagePaths = imageFiles
                        ?.map((f) => f.path)
                        .whereType<String>()
                        .toList() ??
                    const [];

                if (imageFiles == null) {
                  imageExportError =
                      scanner.lastImageExportError ?? l10n.imageExportFailedNull;
                } else if (imagePaths.isEmpty) {
                  imageExportError = imageExportError ??
                      l10n.imageExportReturnedEmpty;
                }
              }
              context.push(
                AppConstants.routeProcessing,
                extra: {
                  'pdfPath': pdfPath,
                  'imagePaths': imagePaths,
                  'didTryImageExport': didTryImageExport,
                  'imageExportError': imageExportError,
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
