import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../providers/suppliers_provider.dart' show normalizeHebrewForSearch;

/// בורר עם חיפוש (Bottom sheet) — מחזיר את הפריט שנבחר, או null אם בוטל.
/// משמש לבחירת ספק / מחלקה / קבוצה.
Future<T?> showSearchablePicker<T>({
  required BuildContext context,
  required String title,
  required String searchHint,
  required List<T> items,
  required String Function(T) labelOf,
  String Function(T)? sublabelOf,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => _SearchablePickerSheet<T>(
      title: title,
      searchHint: searchHint,
      items: items,
      labelOf: labelOf,
      sublabelOf: sublabelOf,
    ),
  );
}

/// תוכן הבורר כ-StatefulWidget — כך מצב החיפוש (ה-controller) **שורד** rebuilds של
/// ה-bottom sheet (למשל כשהמקלדת נפתחת ו-`viewInsets` משתנה). זה התיקון לבאג שבו
/// ההקלדה לא סיננה את הרשימה.
class _SearchablePickerSheet<T> extends StatefulWidget {
  const _SearchablePickerSheet({
    required this.title,
    required this.searchHint,
    required this.items,
    required this.labelOf,
    this.sublabelOf,
  });

  final String title;
  final String searchHint;
  final List<T> items;
  final String Function(T) labelOf;
  final String Function(T)? sublabelOf;

  @override
  State<_SearchablePickerSheet<T>> createState() =>
      _SearchablePickerSheetState<T>();
}

class _SearchablePickerSheetState<T> extends State<_SearchablePickerSheet<T>> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _key(T item) {
    final sub = widget.sublabelOf?.call(item) ?? '';
    return normalizeHebrewForSearch('${widget.labelOf(item)} $sub');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final q = normalizeHebrewForSearch(_controller.text);
    final words = q.split(' ').where((w) => w.isNotEmpty).toList();
    final filtered = words.isEmpty
        ? widget.items
        : widget.items.where((it) {
            final k = _key(it);
            return words.every((w) => k.contains(w));
          }).toList();

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: FractionallySizedBox(
        heightFactor: 0.7,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
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
                const SizedBox(height: 8),
                Row(
                  children: [
                    const SizedBox(width: 40),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.accentGreen,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      child: IconButton(
                        icon: const Icon(CupertinoIcons.xmark, size: 20),
                        color: AppColors.textSecondary,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _controller,
                  autofocus: true,
                  // מכבים autocorrect/הצעות — אחרת מקלדת עברית ב-iOS "אוגרת" את המילה
                  // (composing) ולא משחררת ל-onChanged עד רווח, וההקלדה לא מסננת.
                  autocorrect: false,
                  enableSuggestions: false,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.search,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: widget.searchHint,
                    prefixIcon: const Icon(CupertinoIcons.search, size: 20),
                    suffixIcon: _controller.text.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(CupertinoIcons.clear_circled_solid,
                                size: 18),
                            color: AppColors.textSecondary,
                            onPressed: () =>
                                setState(() => _controller.clear()),
                          ),
                    isDense: true,
                    filled: true,
                    fillColor: const Color(0xFFF1F5F9),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: AppColors.accentGreen, width: 1.4),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Text(
                            '—',
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        )
                      : ListView.separated(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) => const Divider(
                              height: 1, color: AppColors.divider),
                          itemBuilder: (ctx, i) {
                            final it = filtered[i];
                            final sub = widget.sublabelOf?.call(it);
                            return ListTile(
                              dense: true,
                              title: Text(widget.labelOf(it)),
                              subtitle: (sub != null && sub.isNotEmpty)
                                  ? Text(sub)
                                  : null,
                              onTap: () => Navigator.of(context).pop(it),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
