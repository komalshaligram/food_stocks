import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_colors.dart';
import '../gen_l10n/app_localizations.dart';
import '../models/supplier.dart';
import '../providers/suppliers_provider.dart';
import 'adaptive_bottom_sheet.dart';
import 'searchable_picker.dart';

/// תוצאת בחירת פרטי המסמך לפני הסריקה (§6/§13): סוג מסמך + שם ספק.
/// הבחירה הזו תיווצר על המסמך ותגבר על מה שיחולץ ב-OCR.
class PreScanSetup {
  const PreScanSetup({
    required this.documentType,
    required this.supplierName,
  });

  final String documentType;
  final String supplierName;
}

/// בוחר לפני סריקה: סוג מסמך (דרופדאון) + שם ספק (חיפוש מתוך רשימת הספקים).
/// מחזיר [PreScanSetup] רק כשנבחרו שניהם, או null אם בוטל.
/// אינו נוגע במנגנון הצילום — לאחר הבחירה ממשיכים בזרימת הצילום הקיימת.
Future<PreScanSetup?> showPreScanSetupSheet(
  BuildContext context,
  WidgetRef ref,
) {
  // ודא שרשימת הספקים נטענת (אם עוד לא).
  ref.read(suppliersProvider.notifier).load();

  var supplierName = '';

  // סוגי מסמך — כרגע רק "חשבונית מס/כניסה" פעיל; השאר מושבתים ("לא פעיל כרגע").
  List<({String label, bool active})> documentTypeOptions(
          AppLocalizations l10n) =>
      [
        (label: l10n.docTypeTaxInvoice, active: true),
        (label: l10n.docTypeReturnInvoice, active: false),
        (label: l10n.docTypeEntryCertificate, active: false),
        (label: l10n.docTypeReturnCertificate, active: false),
      ];

  // ברירת מחדל: האפשרות הפעילה היחידה (כדי שלא צריך לבחור ידנית).
  String? selectedType = AppLocalizations.of(context).docTypeTaxInvoice;

  return showAdaptiveBottomSheet<PreScanSetup>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      final theme = Theme.of(ctx);
      final l10n = AppLocalizations.of(ctx);
      return StatefulBuilder(
        builder: (ctx, setSheet) {
          final maxSheetHeight = MediaQuery.of(ctx).size.height * 0.82;
          final options = documentTypeOptions(l10n);
          final canContinue =
              selectedType != null && supplierName.trim().isNotEmpty;

          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
            ),
            child: SafeArea(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxSheetHeight),
                child: SingleChildScrollView(
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
                        l10n.preScanDocumentDetailsTitle,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.accentGreen,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.documentTypeLabel,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        // initialValue: selectedType,
                        isExpanded: true,
                        items: options
                            .map(
                              (opt) => DropdownMenuItem<String>(
                                value: opt.label,
                                // אפשרויות שאינן פעילות — מושבתות ומסומנות.
                                enabled: opt.active,
                                child: Text(
                                  opt.active
                                      ? opt.label
                                      : '${opt.label}  (${l10n.docTypeInactiveSuffix})',
                                  style: TextStyle(
                                    color: opt.active
                                        ? AppColors.textPrimary
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setSheet(() => selectedType = value);
                        },
                        decoration: InputDecoration(
                          hintText: l10n.chooseDocumentType,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: AppColors.accentGreen),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.supplierNameLabel,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // שדה ספק — לחיצה פותחת מסך חיפוש נוח (תיבת חיפוש + רשימה נגללת).
                      _SupplierPickerField(
                        ref: ref,
                        value: supplierName,
                        hint: l10n.supplierNameHint,
                        onPicked: (name) =>
                            setSheet(() => supplierName = name),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        l10n.supplierQuickTip,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.of(ctx).pop(null),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.accentGreen,
                                side: const BorderSide(
                                    color: AppColors.accentGreen),
                              ),
                              child: Text(l10n.clear),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FilledButton(
                              onPressed: canContinue
                                  ? () => Navigator.of(ctx).pop(
                                        PreScanSetup(
                                          documentType: selectedType!,
                                          supplierName: supplierName.trim(),
                                        ),
                                      )
                                  : null,
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.accentGreen,
                              ),
                              child: Text(l10n.select),
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
        },
      );
    },
  );
}

/// שדה בחירת ספק "ידידותי": נראה כמו שדה טקסט, ובלחיצה פותח מסך חיפוש נגלל
/// (תיבת חיפוש עברית-סלחני + רשימת כל הספקים). מציג מצב טעינה בפעם הראשונה.
class _SupplierPickerField extends StatefulWidget {
  const _SupplierPickerField({
    required this.ref,
    required this.value,
    required this.hint,
    required this.onPicked,
  });

  final WidgetRef ref;
  final String value;
  final String hint;
  final ValueChanged<String> onPicked;

  @override
  State<_SupplierPickerField> createState() => _SupplierPickerFieldState();
}

class _SupplierPickerFieldState extends State<_SupplierPickerField> {
  bool _loading = false;

  Future<void> _open() async {
    final l10n = AppLocalizations.of(context);
    // ודא שרשימת הספקים נטענה (מציג spinner בשדה רק בפעם הראשונה).
    if (!widget.ref.read(suppliersProvider).loaded) {
      setState(() => _loading = true);
      await widget.ref.read(suppliersProvider.notifier).load();
      if (!mounted) return;
      setState(() => _loading = false);
    }
    final sState = widget.ref.read(suppliersProvider);
    if (!mounted) return;
    if (sState.suppliers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.suppliersLoadError)),
      );
      return;
    }
    final picked = await showSearchablePicker<Supplier>(
      context: context,
      title: l10n.supplierNameLabel,
      searchHint: l10n.supplierNameHint,
      items: sState.suppliers,
      labelOf: (s) => s.name,
      sublabelOf: (s) => s.code,
    );
    if (picked != null) widget.onPicked(picked.name);
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = widget.value.trim().isNotEmpty;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: _loading ? null : _open,
      child: InputDecorator(
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.divider),
          ),
          prefixIcon: const Icon(CupertinoIcons.search,
              color: AppColors.accentGreen),
          suffixIcon: _loading
              ? const Padding(
                  padding: EdgeInsets.all(12),
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : const Icon(CupertinoIcons.chevron_down,
                  size: 18, color: AppColors.textSecondary),
        ),
        child: Text(
          hasValue ? widget.value : widget.hint,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: hasValue ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
