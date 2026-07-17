import 'package:flutter/material.dart';

/// צבעי האפליקציה – יש להשתמש רק כאן, לא לקודד צבעים בווידג'טים.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF1A73E8);
  static const Color secondary = Color(0xFF34A853);

  /// גרדיאנט ראשי (כותרת + כפתור סריקה)
  static const Color headerGradientStart = Color(0xFF225591);
  static const Color headerGradientEnd = Color(0xFF88C240);

  /// צבע הדגשה ירוק במסכים משניים (סplash, סריקה, עיבוד, PDF)
  static const Color accentGreen = Color(0xFF6BA357);

  /// רקע כללי – בהיר ונקי
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);

  /// סטטוס: סורק נתוני מסמך
  static const Color statusScanning = Color(0xFFF9A825);
  /// סטטוס: מוכן לעדכון
  static const Color statusReadyForUpdate = Color(0xFF1A73E8);
  /// סטטוס: נשמר, טרם נשלח לקופה — ניטרלי בכוונה, הירוק שמור ל"נשלח לקופה".
  static const Color statusCompleted = Color(0xFF5F6368);

  /// סטטוס: נשלח לקופה
  static const Color statusSentToCashRegister = Color(0xFF34A853);

  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color divider = Color(0xFFE2E8F0);

  // אדום לשגיאות/אזהרות (למשל ברקוד שאינו קיים בקטלוג).
  static const Color error = Color(0xFFD32F2F);

  /// אזהרה רכה — "ממולא אוטומטית, כדאי לאמת". לא חוסם, בניגוד ל-[error].
  static const Color warning = Color(0xFFF9A825);
}
