import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../gen_l10n/app_localizations.dart';
import '../models/invoice_document.dart';

/// תג סטטוס מסמך – צבע ותווית לפי סטטוס. אנימציית דופק ל"סורק".
class StatusBadge extends StatefulWidget {
  const StatusBadge({
    super.key,
    required this.status,
    this.comaxStatus,
    this.failureReason,
  });

  final DocumentStatus status;

  /// סטטוס הקליטה ל-Comax (`processing`/`queued`/`received`/`failed`/...). כשהמסמך
  /// נשלח וממשיך ברקע (in-flight) — הבאדג' מציג "נשמר, נשלח לקופה ברקע" במקום
  /// הסטטוס המקומי, כדי שהמשתמש ידע שהשליחה יצאה לדרך.
  final String? comaxStatus;

  /// סיבת הכישלון **להצגה** (מ-`describeIntakeFailure`). כשקיימת, התג הופך
  /// ללחיץ בכישלון ופותח אותה בדיאלוג.
  ///
  /// ⚠️ חייב להיות `receiveErrorMessage` ולא `receiveError` — האחרון הוא קוד
  /// מכונה. ראו `foodstockComaxCrawler/docs/API.md` §5ג.
  final String? failureReason;

  /// ערכי comaxStatus שמשמעם "נשלח וממשיך ברקע" (טרם סופי).
  static const Set<String> _comaxInFlight = {
    'pending',
    'processing',
    'queued',
    'receiving',
  };

  /// ערכי comaxStatus שמשמעם "ניסיון הקליטה נכשל" (סופי, אך ניתן לשלוח שוב).
  static const Set<String> _comaxFailed = {
    'failed',
    'not_received',
    'rejected',
  };

  @override
  State<StatusBadge> createState() => _StatusBadgeState();
}

class _StatusBadgeState extends State<StatusBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final (label, color, showPulse, showCheck) = _statusConfig(l10n);
    final reason = widget.failureReason?.trim();
    final canExplain = _isComaxFailed && reason != null && reason.isNotEmpty;
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final opacity = showPulse ? 0.6 + 0.4 * _pulseController.value : 1.0;
        final badge = Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(opacity),
            borderRadius: BorderRadius.circular(20),
          ),
          // mainAxisSize.min + FlexFit.loose: כשאין רוחב סופי (Row חיצוני בלי Expanded),
          // Flexible לא יכול להתרחב — זה מונע "unbounded width" + flex.
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.status == DocumentStatus.processing ||
                  widget.status == DocumentStatus.uploading ||
                  _isComaxInFlight) ...[
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const SizedBox(width: 6),
              ],
              if (showCheck) ...[
                const Icon(CupertinoIcons.check_mark_circled_solid, size: 16, color: Colors.white),
                const SizedBox(width: 4),
              ],
              Flexible(
                fit: FlexFit.loose,
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (canExplain) ...[
                const SizedBox(width: 4),
                const Icon(CupertinoIcons.info_circle,
                    size: 13, color: Colors.white),
              ],
            ],
          ),
        );

        if (!canExplain) return badge;
        return GestureDetector(
          onTap: () => _showFailureReason(reason),
          child: badge,
        );
      },
    );
  }

  /// מציג את סיבת הכישלון כפי שנוסחה בקרולר. בלי זה המשתמש רואה רק
  /// "קליטה נכשלה, נסה שנית" ואין לו שום דרך לדעת מה בעצם קרה.
  ///
  /// 🔴 **ה-l10n נקרא כאן, מה-context של הווידג'ט — לא בתוך ה-builder.**
  /// `doc_scan` מוטמע באפליקציה הראשית, ו-`showDialog` בונה מתחת ל-Navigator
  /// הראשי — context שנמצא **מעל** ה-delegate של המודול. קריאה ל-
  /// `AppLocalizations.of(ctx)` שם מחזירה null, והגטר המיוצר (nullable-getter:
  /// false) עושה `!` וקורס ב-"Null check operator used on a null value".
  /// זו הסיבה שכל שאר הדיאלוגים במודול מקבלים `l10n` כפרמטר מבחוץ.
  void _showFailureReason(String reason) {
    final l10n = AppLocalizations.of(context);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(CupertinoIcons.exclamationmark_triangle_fill,
                color: AppColors.error, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(l10n.statusIntakeFailedRetry)),
          ],
        ),
        content: SingleChildScrollView(child: Text(reason)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  bool get _isComaxInFlight =>
      widget.comaxStatus != null &&
      StatusBadge._comaxInFlight.contains(widget.comaxStatus);

  bool get _isComaxFailed =>
      widget.comaxStatus != null &&
      StatusBadge._comaxFailed.contains(widget.comaxStatus);

  (String, Color, bool, bool) _statusConfig(AppLocalizations l10n) {
    // נשלח לקופה וממשיך ברקע — גובר על הסטטוס המקומי (למשל "נשמר, טרם נשלח לקופה").
    if (_isComaxInFlight) {
      return (l10n.statusSentInBackground, Colors.blue.shade700, true, false);
    }
    // ניסיון הקליטה נכשל — גובר על הסטטוס המקומי (שנשאר "נשמר, טרם נשלח לקופה",
    // כי בכישלון לא משנים את DocumentStatus כדי לאפשר "נסה שנית"/עריכה+שליחה חוזרת).
    if (_isComaxFailed) {
      return (l10n.statusIntakeFailedRetry, Colors.red.shade700, false, false);
    }
    switch (widget.status) {
      case DocumentStatus.scanning:
        return (l10n.statusScanning, AppColors.statusScanning, true, false);
      case DocumentStatus.uploading:
        return (l10n.statusUploading, AppColors.statusScanning, false, false);
      case DocumentStatus.processing:
        return (l10n.statusProcessing, Colors.orange.shade700, false, false);
      case DocumentStatus.readyForUpdate:
        return (l10n.statusReadyForUpdate, AppColors.statusReadyForUpdate, false, false);
      case DocumentStatus.completed:
        return (l10n.statusCompleted, AppColors.statusCompleted, false, false);
      case DocumentStatus.sentToCashRegister:
        return (l10n.statusSentToCashRegister,
            AppColors.statusSentToCashRegister, false, true);
      case DocumentStatus.error:
        return (l10n.statusError, Colors.red.shade700, false, false);
      case DocumentStatus.deleted:
        return (l10n.statusDeleted, Colors.grey.shade600, false, false);
    }
  }
}
