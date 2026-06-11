import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../gen_l10n/app_localizations.dart';
import 'adaptive_bottom_sheet.dart';
import 'gradient_button.dart';

/// שדה עריכה עם תווית ואייקון – לשימוש בטפסים.
class EditableField extends StatelessWidget {
  const EditableField({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.isBold = false,
    this.valueColor,
    this.isEditable = false,
    this.keyboardType,
    this.onTap,
    this.onChanged,
  });

  final String label;
  final String value;
  final IconData? icon;
  final bool isBold;
  final Color? valueColor;
  final bool isEditable;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;
  /// עדכון ערך בלחיצה – מציג דיאלוג עריכה. אם מוגדר, לחיצה על השדה תפתח עריכה.
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canEdit = onChanged != null;
    return InkWell(
      onTap: canEdit
          ? () => _showEditDialog(
                context,
                label: label,
                value: value,
                theme: theme,
                keyboardType: keyboardType,
                onSaved: onChanged!,
              )
          : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.accentGreen.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: AppColors.textSecondary),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  if (isEditable && !canEdit)
                    TextFormField(
                      initialValue: value,
                      keyboardType: keyboardType,
                      decoration: const InputDecoration(
                        isDense: true,
                        border: UnderlineInputBorder(),
                      ),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight:
                            isBold ? FontWeight.w700 : FontWeight.w500,
                        color: valueColor ?? AppColors.textPrimary,
                      ),
                    )
                  else
                    Text(
                      value,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: isBold
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: valueColor ?? AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _showEditDialog(
    BuildContext context, {
    required String label,
    required String value,
    required ThemeData theme,
    TextInputType? keyboardType,
    required ValueChanged<String> onSaved,
  }) {
    final isNumericKeyboard =
        keyboardType == TextInputType.number ||
        keyboardType == const TextInputType.numberWithOptions(decimal: true) ||
        keyboardType == const TextInputType.numberWithOptions(decimal: true, signed: true);
    final initialText = isNumericKeyboard
        ? value
            // שומרים רק ספרות/סימן מינוס/נקודה עשרונית כדי למנוע רווחים/סימני מטבע.
            .replaceAll(RegExp(r'[^0-9.\-]'), '')
        : value;
    final controller = TextEditingController(text: initialText);
    final isIos = Theme.of(context).platform == TargetPlatform.iOS;
    showAdaptiveBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.accentGreen,
                  ),
                ),
                const SizedBox(height: 16),
                isIos
                    ? CupertinoTextField(
                        controller: controller,
                        keyboardType: keyboardType,
                        autofocus: true,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        onSubmitted: (_) {
                          onSaved(controller.text);
                          Navigator.of(ctx).pop();
                        },
                      )
                    : TextField(
                        controller: controller,
                        keyboardType: keyboardType,
                        autofocus: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.accentGreen,
                            ),
                          ),
                        ),
                        onSubmitted: (_) {
                          onSaved(controller.text);
                          Navigator.of(ctx).pop();
                        },
                      ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: isIos
                          ? CupertinoButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: Text(
                                AppLocalizations.of(ctx).cancel,
                                style: const TextStyle(color: AppColors.accentGreen),
                              ),
                            )
                          : OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.accentGreen,
                              ),
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: Text(AppLocalizations.of(ctx).cancel),
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GradientButton(
                        label: AppLocalizations.of(ctx).update,
                        colors: const [
                          AppColors.headerGradientStart,
                          AppColors.headerGradientEnd,
                        ],
                        onPressed: () {
                          onSaved(controller.text);
                          Navigator.of(ctx).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
