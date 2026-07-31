import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../models/comax_document_status.dart';
import '../core/services/comax_diagnosis_text.dart';
import '../core/constants/app_constants.dart';
import '../core/theme/app_colors.dart';
import '../gen_l10n/app_localizations.dart';
import '../core/utils/date_utils.dart';
import '../core/utils/number_utils.dart';
import '../models/invoice_document.dart';
import '../providers/model_provider.dart';
import 'status_badge.dart';

/// כרטיס מסמך ברשימה – תאריך, סטטוס, ופרטים (למוכן לעדכון/בוצע).
/// כולל רטט + אנימציית "לחיצה" קטנה כדי שהמשתמש ירגיש קליק.
class DocumentCard extends StatefulWidget {
  const DocumentCard({
    super.key,
    required this.document,
  });

  final InvoiceDocument document;

  @override
  State<DocumentCard> createState() => _DocumentCardState();
}

class _DocumentCardState extends State<DocumentCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final doc = widget.document;
    final showProcessingMeta = doc.status == DocumentStatus.processing ||
        doc.status == DocumentStatus.uploading;
    final showDetails = doc.status == DocumentStatus.readyForUpdate ||
        doc.status == DocumentStatus.completed ||
        doc.status == DocumentStatus.sentToCashRegister;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: AppColors.accentGreen.withValues(alpha: 0.06),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onHighlightChanged: (v) {
          if (v == _isPressed) return;
          // נותן פידבק מיידי בתחילת הלחיצה (חשוב כשכרטיס בתוך Dismissible).
          if (v) {
            HapticFeedback.lightImpact();
          }
          setState(() => _isPressed = v);
        },
        onTap: () {
          if (doc.status == DocumentStatus.processing ||
              doc.status == DocumentStatus.uploading) {
            context.push(AppConstants.routeDetails, extra: doc);
            return;
          }

          if (doc.status == DocumentStatus.error) {
            context.push(AppConstants.routeDetails, extra: doc);
            return;
          }

          context.push(AppConstants.routeDetails, extra: doc);
        },
        child: AnimatedScale(
          scale: _isPressed ? 0.98 : 1.0,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatDisplayDateTime(doc.createdAt),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    StatusBadge(
                      status: doc.status,
                      comaxStatus: doc.comaxStatus,
                      failureReason: describeIntakeFailure(
                        receiveErrorMessage: doc.comaxReceiveErrorMessage,
                        receiveError: doc.comaxReceiveError,
                        diagnosis: InvoiceDiagnosis.fromJsonOrNull(
                            doc.comaxDiagnosis),
                      ),
                    ),
                  ],
                ),
                if (showDetails || showProcessingMeta) ...[
                  const SizedBox(height: 12),
                if (doc.documentType != null ||
                    doc.companyName != null ||
                    doc.documentNumber != null) ...[
                    Row(
                      children: [
                        Icon(
                          (doc.documentType ?? '') == l10n.docTypeInvoice
                              ? CupertinoIcons.doc_text
                              : CupertinoIcons.cube_box,
                          size: 18,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          doc.documentType ?? '—',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doc.companyName ?? '—',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (doc.documentNumber != null) ...[
                      Text(
                        l10n.docNumberLabel,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        doc.documentNumber!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                    if (doc.documentDate != null)
                      Text(
                        l10n.dateLabel(doc.documentDate!),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    if ((doc.scanModel ?? '').trim().isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        availableModels[doc.scanModel] ?? doc.scanModel!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    if (doc.totalAmount != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        formatCurrency(doc.totalAmount!),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppColors.statusCompleted,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
