import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// לוקאל נוכחי – עברית (RTL) או אנגלית (LTR).
/// במצב standalone (TaviliDocScan) ניתן לשנות דרך [localeProvider].
/// כשהמודול מוטמע ב-FoodStock, [DocScanShell] מסנכרן לפי שפת האפליקות.
final localeProvider = StateProvider<Locale>((ref) => const Locale('he', 'IL'));

/// לוקאל עברית.
const Locale localeHe = Locale('he', 'IL');

/// לוקאל אנגלית.
const Locale localeEn = Locale('en');

/// Maps the nearest [Localizations] (doc-scan or app) to a supported doc-scan locale.
Locale resolveDocScanLocale(BuildContext context) {
  final code = Localizations.localeOf(context).languageCode;
  return code == 'he' ? localeHe : localeEn;
}

/// FoodStock [MaterialApp] locale — use in [DocScanShell] before nesting doc-scan l10n.
Locale resolveDocScanLocaleFromApp(BuildContext context) {
  final code = Localizations.localeOf(context).languageCode;
  return code == 'he' ? localeHe : localeEn;
}

bool isDocScanRtlLocale(Locale locale) => locale.languageCode == 'he';
