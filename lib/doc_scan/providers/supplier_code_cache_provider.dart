import 'package:flutter_riverpod/flutter_riverpod.dart';

/// זיכרון מקומי (לכל משך הסשן) של בחירת ספק לפי ח.פ.: { supplierTaxId -> supplierCode }.
///
/// כשהמשתמש בוחר ספק מתוך ההצעות (במקרה שהח.פ. שעל החשבונית שייך לישות אחרת מזו
/// שמוגדרת ב-Comax), שומרים כאן את הקוד שנבחר. בפעם הבאה שמגיעה חשבונית עם אותו ח.פ.,
/// שולחים את supplierCode אוטומטית בלי לשאול שוב.
final supplierCodeCacheProvider =
    StateProvider<Map<String, String>>((ref) => <String, String>{});
