import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/app_colors.dart';
import '../gen_l10n/app_localizations.dart';
import '../providers/embedded_ui_provider.dart';
import '../router/app_router.dart';
import '../utils/embedded_app_bar.dart';
import '../widgets/gradient_button.dart';

/// מסך דיבוג להצגת ה-JSON שחזר מה-Cloud Function.
class JsonPreviewScreen extends ConsumerStatefulWidget {
  const JsonPreviewScreen({
    super.key,
    this.jsonText,
    this.embedded = false,
  });

  final String? jsonText;
  final bool embedded;

  @override
  ConsumerState<JsonPreviewScreen> createState() => _JsonPreviewScreenState();
}

class _JsonPreviewScreenState extends ConsumerState<JsonPreviewScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.jsonText ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _copy() async {
    final text = _controller.text;
    if (text.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.jsonCopiedSnackBar)),
    );
  }

  void _syncEmbeddedHeaderAction(AppLocalizations l10n) {
    if (!widget.embedded) return;

    final location =
        resolveEmbeddedDocScanLocation(ref.read(docScanRouterProvider));
    if (location != AppConstants.routeJsonPreview) return;

    final notifier = ref.read(embeddedDetailsHeaderActionsProvider.notifier);
    if (widget.jsonText != null && widget.jsonText!.isNotEmpty) {
      notifier.state = [
        EmbeddedDetailsHeaderAction(
          tooltip: l10n.copy,
          icon: CupertinoIcons.doc_on_clipboard,
          onPressed: _copy,
        ),
      ];
    } else {
      notifier.state = const [];
    }
  }

  PreferredSizeWidget? _buildStandaloneAppBar(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return AppBar(
      title: Text(l10n.jsonTitle),
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      foregroundColor: Colors.white,
      titleTextStyle: theme.textTheme.titleLarge?.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w600,
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
      actions: [
        IconButton(
          icon: const Icon(CupertinoIcons.doc_on_clipboard),
          onPressed: widget.jsonText == null ? null : _copy,
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
      appBar: widget.embedded ? null : _buildStandaloneAppBar(context, l10n, theme),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: widget.jsonText == null
            ? Center(child: Text(l10n.noJsonToShow))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      readOnly: true,
                      keyboardType: TextInputType.multiline,
                      textAlignVertical: TextAlignVertical.top,
                      maxLines: null,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: l10n.jsonContentLabel,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GradientButton(
                    label: l10n.copy,
                    icon: const Icon(CupertinoIcons.doc_on_clipboard),
                    colors: const [
                      AppColors.headerGradientStart,
                      AppColors.headerGradientEnd,
                    ],
                    onPressed: _copy,
                  ),
                ],
              ),
      ),
    );
  }
}
