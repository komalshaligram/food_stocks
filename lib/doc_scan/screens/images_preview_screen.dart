import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/app_colors.dart';
import '../gen_l10n/app_localizations.dart';
import '../models/invoice_document.dart';
import '../providers/embedded_ui_provider.dart';
import '../router/app_router.dart';
import '../utils/document_media_resolver.dart';
import '../utils/embedded_app_bar.dart';
import '../widgets/gradient_button.dart';

/// מסך תצוגת תמונות סרוקות — קובץ מקומי או S3.
class ImagesPreviewScreen extends ConsumerStatefulWidget {
  const ImagesPreviewScreen({
    super.key,
    this.document,
    this.embedded = false,
  });

  final InvoiceDocument? document;
  final bool embedded;

  @override
  ConsumerState<ImagesPreviewScreen> createState() =>
      _ImagesPreviewScreenState();
}

class _ImagesPreviewScreenState extends ConsumerState<ImagesPreviewScreen> {
  List<ResolvedDocumentMedia> _resolvedImages = const [];
  bool _isLoading = true;
  Object? _loadError;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    try {
      final document = widget.document;
      if (document == null) {
        setState(() {
          _resolvedImages = const [];
          _isLoading = false;
        });
        return;
      }

      final resolved = await DocumentMediaResolver.resolveImages(document);
      if (mounted) {
        setState(() {
          _resolvedImages = resolved;
          _isLoading = false;
          _loadError = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _loadError = e;
        });
      }
    }
  }

  Future<void> _shareImages() async {
    if (_resolvedImages.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).pdfDemoHint)),
        );
      }
      return;
    }

    final l10n = AppLocalizations.of(context);
    try {
      final files = <XFile>[];
      for (var index = 0; index < _resolvedImages.length; index++) {
        final media = _resolvedImages[index];
        if (media.isLocal) {
          files.add(XFile(media.pathOrUrl));
          continue;
        }

        final downloaded = await DocumentMediaResolver.downloadToTempFile(
          url: media.pathOrUrl,
          fileName: 'scanned_image_$index.jpg',
        );
        if (downloaded != null) {
          files.add(XFile(downloaded.path));
        }
      }

      if (files.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.fileNotFound)),
          );
        }
        return;
      }

      await Share.shareXFiles(
        files,
        text: l10n.scannedImagesShareText,
        sharePositionOrigin: const Rect.fromLTWH(0, 0, 1, 1),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.shareError(e.toString()))),
        );
      }
    }
  }

  bool get _canShare => _resolvedImages.isNotEmpty;

  void _syncEmbeddedHeaderAction(AppLocalizations l10n) {
    if (!widget.embedded) return;

    final location =
        resolveEmbeddedDocScanLocation(ref.read(docScanRouterProvider));
    if (location != AppConstants.routeImagesPreview) return;

    final notifier = ref.read(embeddedDetailsHeaderActionsProvider.notifier);
    if (_canShare) {
      notifier.state = [
        EmbeddedDetailsHeaderAction(
          tooltip: l10n.share,
          icon: CupertinoIcons.share,
          onPressed: _shareImages,
        ),
      ];
    } else {
      notifier.state = const [];
    }
  }

  PreferredSizeWidget _buildStandaloneAppBar(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return AppBar(
      title: Text(l10n.scannedImagesPreviewTitle),
      leading: IconButton(
        icon: const Icon(
          CupertinoIcons.back,
          size: 20,
        ),
        onPressed: () => context.pop(),
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [
              AppColors.headerGradientStart,
              AppColors.headerGradientEnd,
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      foregroundColor: Colors.white,
      titleTextStyle: theme.textTheme.titleLarge?.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      actions: [
        IconButton(
          icon: const Icon(CupertinoIcons.share),
          onPressed: _canShare ? _shareImages : null,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    if (widget.embedded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _syncEmbeddedHeaderAction(l10n);
      });
    }

    return Scaffold(
      appBar: widget.embedded
          ? null
          : _buildStandaloneAppBar(context, l10n, theme),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _resolvedImages.isEmpty
              ? _buildPlaceholder(theme, l10n)
              : _buildPager(theme),
    );
  }

  Widget _buildImage(ResolvedDocumentMedia media) {
    if (media.isLocal) {
      return Image.file(
        File(media.pathOrUrl),
        fit: BoxFit.contain,
      );
    }

    return CachedNetworkImage(
      imageUrl: media.pathOrUrl,
      fit: BoxFit.contain,
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => const Icon(
        CupertinoIcons.exclamationmark_triangle,
        size: 48,
        color: AppColors.textSecondary,
      ),
    );
  }

  Widget _buildPager(ThemeData theme) {
    return Column(
      children: [
        if (_resolvedImages.length > 1)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              '${_currentPage + 1}/${_resolvedImages.length}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        Expanded(
          child: PageView.builder(
            itemCount: _resolvedImages.length,
            onPageChanged: (value) => setState(() => _currentPage = value),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: InteractiveViewer(
                  child: _buildImage(_resolvedImages[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder(ThemeData theme, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.accentGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                CupertinoIcons.photo,
                size: 64,
                color: AppColors.accentGreen,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _loadError != null ? l10n.unableToLoadImages : l10n.noImagesToShow,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.pdfDemoHint,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            GradientButton(
              label: l10n.share,
              icon: const Icon(CupertinoIcons.share),
              colors: const [
                AppColors.headerGradientStart,
                AppColors.headerGradientEnd,
              ],
              onPressed: _resolvedImages.isNotEmpty ? _shareImages : null,
            ),
          ],
        ),
      ),
    );
  }
}
