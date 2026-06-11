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
  });

  final DocumentStatus status;

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
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final opacity = showPulse ? 0.6 + 0.4 * _pulseController.value : 1.0;
        return Container(
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
                  widget.status == DocumentStatus.uploading) ...[
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
            ],
          ),
        );
      },
    );
  }

  (String, Color, bool, bool) _statusConfig(AppLocalizations l10n) {
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
        return (l10n.statusCompleted, AppColors.statusCompleted, false, true);
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
