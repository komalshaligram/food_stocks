import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'gen_l10n/app_localizations.dart';
import 'providers/locale_provider.dart';
import 'router/app_router.dart';

/// Embeds the doc-scan GoRouter inside the certificate scanning screen body.
class DocScanShell extends ConsumerWidget {
  const DocScanShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(docScanRouterProvider);
    // Follow FoodStock app language from profile settings (ancestor MaterialApp).
    final locale = resolveDocScanLocaleFromApp(context);
    final isRtl = isDocScanRtlLocale(locale);

    final storedLocale = ref.read(localeProvider);
    if (storedLocale.languageCode != locale.languageCode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(localeProvider.notifier).state = locale;
      });
    }

    return Theme(
      data: AppTheme.light,
      child: Localizations(
        locale: locale,
        delegates: AppLocalizations.localizationsDelegates,
        child: Directionality(
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: Router.withConfig(config: router),
        ),
      ),
    );
  }
}
