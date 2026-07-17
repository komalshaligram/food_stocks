import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_constants.dart';
import 'core/services/doc_scan_notifications.dart';
import 'core/theme/app_theme.dart';
import 'gen_l10n/app_localizations.dart';
import 'providers/documents_provider.dart';
import 'providers/locale_provider.dart';
import 'router/app_router.dart';

/// Embeds the doc-scan GoRouter inside the certificate scanning screen body.
class DocScanShell extends ConsumerStatefulWidget {
  const DocScanShell({super.key});

  @override
  ConsumerState<DocScanShell> createState() => _DocScanShellState();
}

class _DocScanShellState extends ConsumerState<DocScanShell> {
  @override
  void initState() {
    super.initState();
    // מטפל בהקשה על התראה: פותח את מסך פרטי המסמך הרלוונטי. גם על cold-start
    // (אפליקציה שנפתחה מהקשה על התראה) — init בודק getNotificationAppLaunchDetails.
    DocScanNotifications.instance.shellMounted = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      DocScanNotifications.instance.init(onTap: _openDocument);
      // אם הגיעה לחיצה לפני שה-shell היה mounted (cold start / פתיחה במסך אחר).
      final pending = DocScanNotifications.instance.consumePending();
      if (pending != null) _openDocument(pending);
    });
  }

  @override
  void dispose() {
    DocScanNotifications.instance.shellMounted = false;
    super.dispose();
  }

  void _openDocument(String documentId, {int attempt = 0}) {
    // עוד לא mounted — נשמר כ"ממתין" ויטופל ב-initState כשה-shell יעלה.
    if (!mounted) {
      DocScanNotifications.instance.pendingDocumentId = documentId;
      return;
    }
    final doc = ref.read(documentsProvider.notifier).getDocument(documentId);
    if (doc == null) {
      // כש-shell עולה מחדש, documentsProvider נטען מהאחסון אסינכרונית — המסמך
      // עדיין לא שם. משאירים pending ומנסים שוב עד שהטעינה מסתיימת.
      DocScanNotifications.instance.pendingDocumentId = documentId;
      if (attempt < 20) {
        Future<void>.delayed(const Duration(milliseconds: 250), () {
          if (mounted) _openDocument(documentId, attempt: attempt + 1);
        });
      }
      return;
    }
    // נמצא — לנקות pending ולנווט.
    DocScanNotifications.instance.pendingDocumentId = null;
    final router = ref.read(docScanRouterProvider);
    // חוזרים לבית קודם כדי לא לערום details על details אם כבר פתוח אחד.
    router.go(AppConstants.routeHome);
    router.push(AppConstants.routeDetails, extra: doc);
  }

  @override
  Widget build(BuildContext context) {
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
