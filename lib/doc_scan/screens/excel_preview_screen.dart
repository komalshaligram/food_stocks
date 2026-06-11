import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/app_colors.dart';
import '../gen_l10n/app_localizations.dart';
import '../models/invoice_document.dart';
import '../providers/embedded_ui_provider.dart';
import '../router/app_router.dart';
import '../utils/embedded_app_bar.dart';
import '../widgets/gradient_button.dart';

/// מסך תצוגת קובץ Excel שנוצר מייצוא המסמך + שיתוף (כמו PDF / תמונות).
class ExcelPreviewScreen extends ConsumerStatefulWidget {
  const ExcelPreviewScreen({
    super.key,
    this.document,
    this.excelPath,
    this.embedded = false,
  });

  final InvoiceDocument? document;
  final String? excelPath;
  final bool embedded;

  @override
  ConsumerState<ExcelPreviewScreen> createState() => _ExcelPreviewScreenState();
}

class _ExcelPreviewScreenState extends ConsumerState<ExcelPreviewScreen> {
  List<List<String>> _grid = const [];
  bool _sheetRtl = false;
  bool _isLoading = true;
  Object? _loadError;
  final TransformationController _zoomController = TransformationController();

  @override
  void initState() {
    super.initState();
    _loadExcel();
  }

  @override
  void dispose() {
    _zoomController.dispose();
    super.dispose();
  }

  void _copyCellToClipboard(String text, AppLocalizations l10n) {
    if (text.isEmpty) return;
    Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.copiedToClipboard),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _loadExcel() async {
    final path = widget.excelPath;
    if (path == null || path.isEmpty) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _loadError = 'no_path';
        });
      }
      return;
    }
    final file = File(path);
    if (!await file.exists()) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _loadError = 'not_found';
        });
      }
      return;
    }
    try {
      final bytes = await file.readAsBytes();
      final excel = Excel.decodeBytes(bytes);
      if (excel.tables.isEmpty) {
        throw StateError('empty workbook');
      }
      final sheet = excel.tables[excel.tables.keys.first]!;
      final rows = sheet.rows;
      final grid = <List<String>>[];
      for (final row in rows) {
        grid.add(
          row
              .map((d) => d?.value?.toString() ?? '')
              .toList(growable: false),
        );
      }
      if (mounted) {
        setState(() {
          _grid = grid;
          _sheetRtl = sheet.isRTL;
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

  Future<void> _shareExcel() async {
    final path = widget.excelPath;
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    if (path == null || path.isEmpty) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.pdfDemoHint)),
        );
      }
      return;
    }
    final file = File(path);
    if (!await file.exists()) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.fileNotFound)),
      );
      return;
    }
    try {
      await Share.shareXFiles(
        [XFile(path)],
        text: l10n.excelShareText,
        sharePositionOrigin: const Rect.fromLTWH(0, 0, 1, 1),
      );
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.shareError(e.toString()))),
      );
    }
  }

  void _syncEmbeddedHeaderAction(AppLocalizations l10n) {
    if (!widget.embedded) return;

    final location =
        resolveEmbeddedDocScanLocation(ref.read(docScanRouterProvider));
    if (location != AppConstants.routeExcelPreview) return;

    final notifier = ref.read(embeddedDetailsHeaderActionsProvider.notifier);
    final canShare =
        widget.excelPath != null && widget.excelPath!.isNotEmpty;
    if (canShare) {
      notifier.state = [
        EmbeddedDetailsHeaderAction(
          tooltip: l10n.share,
          icon: CupertinoIcons.share,
          onPressed: _shareExcel,
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
    final canShare =
        widget.excelPath != null && widget.excelPath!.isNotEmpty;

    return AppBar(
      title: Text(l10n.excelPreviewTitle),
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
          onPressed: canShare ? _shareExcel : null,
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
          : _loadError != null || _grid.isEmpty
              ? _buildPlaceholder(theme, l10n)
              : _buildGrid(theme, l10n),
    );
  }

  Widget _buildGrid(ThemeData theme, AppLocalizations l10n) {
    final textDirection = _sheetRtl ? TextDirection.rtl : TextDirection.ltr;
    final cellStyle = theme.textTheme.bodySmall?.copyWith(
      fontFamily: 'monospace',
      fontSize: 11,
      color: AppColors.textPrimary,
    );

    // constrained: true — הילד מקבל את גודל ה־viewport (בלי OverflowBox שמרכז
    // תוכן קטן). גלילה כפולה + InteractiveViewer לזום — בלי מרווחים מסביב לטבלה.
    return Directionality(
      textDirection: textDirection,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: InteractiveViewer(
              transformationController: _zoomController,
              minScale: 0.25,
              maxScale: 4,
              boundaryMargin: EdgeInsets.zero,
              constrained: true,
              alignment: Alignment.topLeft,
              clipBehavior: Clip.hardEdge,
              panEnabled: true,
              scaleEnabled: true,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                primary: false,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  primary: false,
                  child: Table(
                    defaultColumnWidth: const FixedColumnWidth(88),
                    border: TableBorder.all(
                      color: Colors.grey.shade300,
                      width: 0.5,
                    ),
                    children: [
                      for (var r = 0; r < _grid.length; r++)
                        TableRow(
                          children: [
                            for (var c = 0; c < _grid[r].length; c++)
                              _ExcelPreviewCell(
                                text: _grid[r][c],
                                style: cellStyle,
                                onCopyCell: () =>
                                    _copyCellToClipboard(_grid[r][c], l10n),
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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
                Icons.table_chart,
                size: 64,
                color: AppColors.accentGreen,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _loadError != null ? l10n.unableToLoadDocument : l10n.pdfAvailable,
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
              onPressed: widget.excelPath != null ? _shareExcel : null,
            ),
          ],
        ),
      ),
    );
  }
}

/// תא עם טקסט ניתן לבחירה (העתקה מהתפריט) + לחיצה כפולה להעתקת כל התא.
class _ExcelPreviewCell extends StatelessWidget {
  const _ExcelPreviewCell({
    required this.text,
    required this.style,
    required this.onCopyCell,
  });

  final String text;
  final TextStyle? style;
  final VoidCallback onCopyCell;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onDoubleTap: onCopyCell,
        child: SelectableText(
          text,
          style: style,
          maxLines: 6,
          minLines: 1,
        ),
      ),
    );
  }
}
