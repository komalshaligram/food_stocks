import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../gen_l10n/app_localizations.dart';
import '../providers/locale_provider.dart';
import '../providers/model_provider.dart';

void showDocScanModelSelector(BuildContext context, WidgetRef ref) {
  final currentModel = ref.read(selectedModelProvider);
  final locale = resolveDocScanLocale(context);
  final isRtl = isDocScanRtlLocale(locale);

  showModalBottomSheet<void>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      return Theme(
        data: AppTheme.light,
        child: Localizations(
          locale: locale,
          delegates: AppLocalizations.localizationsDelegates,
          child: Directionality(
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            child: Builder(
              builder: (localizedCtx) {
                final l10n = AppLocalizations.of(localizedCtx);
                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
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
                        const SizedBox(height: 12),
                        Text(
                          l10n.chooseScanModelTitle,
                          style: Theme.of(localizedCtx)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.accentGreen,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ...availableModels.entries.map((entry) {
                          final isSelected = entry.key == currentModel;
                          return ListTile(
                            leading: Icon(
                              isSelected
                                  ? CupertinoIcons.checkmark_circle_fill
                                  : CupertinoIcons.circle,
                              color: isSelected
                                  ? AppColors.accentGreen
                                  : AppColors.textSecondary,
                            ),
                            title: Text(
                              entry.value,
                              style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                            onTap: () {
                              ref
                                  .read(selectedModelProvider.notifier)
                                  .setModel(entry.key);
                              Navigator.of(localizedCtx).pop();
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    },
  );
}
