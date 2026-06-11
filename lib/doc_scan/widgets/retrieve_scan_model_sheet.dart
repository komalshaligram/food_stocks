import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/app_colors.dart';
import '../gen_l10n/app_localizations.dart';
import '../models/invoice_document.dart';
import '../providers/documents_provider.dart';
import '../providers/model_provider.dart';
import '../utils/document_media_resolver.dart';

Future<void> showRetrieveScanModelSheet(
  BuildContext context,
  WidgetRef ref,
  InvoiceDocument doc,
) async {
  final l10n = AppLocalizations.of(context);
  var selectedKey = ref.read(selectedModelProvider);

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) {
      var isPreparingMedia = false;

      return StatefulBuilder(
        builder: (context, setModalState) {
          Future<void> onContinue() async {
            if (isPreparingMedia) return;

            setModalState(() => isPreparingMedia = true);

            try {
              InvoiceDocument latestDoc = doc;
              for (final item in ref.read(documentsProvider)) {
                if (item.id == doc.id) {
                  latestDoc = item;
                  break;
                }
              }

              final prepared =
                  await DocumentMediaResolver.ensureLocalMediaForRetry(latestDoc);

              if (!prepared.hasImages) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.unableToLoadImages)),
                  );
                }
                return;
              }

              ref.read(documentsProvider.notifier).upsert(
                    latestDoc.copyWith(
                      pdfPath: prepared.pdfPath ?? latestDoc.pdfPath,
                      imagePaths: prepared.imagePaths,
                    ),
                    syncToServer: false,
                  );

              if (!context.mounted) return;
              ref.read(selectedModelProvider.notifier).setModel(selectedKey);
              Navigator.of(sheetContext).pop();
              context.push(
                AppConstants.routeProcessing,
                extra: <String, Object?>{
                  'pdfPath': prepared.pdfPath ?? latestDoc.pdfPath,
                  'imagePaths': prepared.imagePaths,
                  'didTryImageExport': true,
                  'imageExportError': null,
                  'targetDocumentId': latestDoc.id,
                  'targetCreatedAt': latestDoc.createdAt,
                },
              );
            } finally {
              if (context.mounted) {
                setModalState(() => isPreparingMedia = false);
              }
            }
          }

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
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
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.accentGreen,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ...availableModels.entries.map((entry) {
                        final isSelected = entry.key == selectedKey;
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
                              fontWeight:
                                  isSelected ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                          onTap: isPreparingMedia
                              ? null
                              : () {
                                  setModalState(() => selectedKey = entry.key);
                                },
                        );
                      }),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: isPreparingMedia ? null : onContinue,
                          child: isPreparingMedia
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(l10n.continueButton),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

bool canShowRetrieveScanHeaderAction(InvoiceDocument doc) {
  return DocumentMediaResolver.hasImages(doc) &&
      doc.status != DocumentStatus.sentToCashRegister &&
      doc.status != DocumentStatus.uploading &&
      doc.status != DocumentStatus.processing &&
      doc.status != DocumentStatus.completed;
}
