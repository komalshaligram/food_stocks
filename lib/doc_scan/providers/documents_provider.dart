import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/client_scanned_certificate_sync_service.dart';
import '../core/storage/documents_storage.dart';
import '../models/invoice_document.dart';

/// מזהה המסמך הנוכחי (נצפה/נערך) – לשימוש עתידי.
final currentDocumentProvider = StateProvider<String?>((ref) => null);

/// רשימת המסמכים — נטענת מהשרת + מיזוג עם אחסון מקומי.
final documentsProvider =
    StateNotifierProvider<DocumentsNotifier, List<InvoiceDocument>>((ref) {
  return DocumentsNotifier()..loadFromStorage();
});

bool _hasRealScanPayload(InvoiceDocument doc) {
  final hasPdf = (doc.pdfPath ?? '').trim().isNotEmpty;
  final hasImages = doc.imagePaths.isNotEmpty;
  return hasPdf || hasImages;
}

bool _isKnownDemoDocument(InvoiceDocument doc) {
  final docNumber = (doc.documentNumber ?? '').toUpperCase();
  final companyName = (doc.companyName ?? '').trim();
  final companyId = (doc.companyId ?? '').trim();
  final pdfPath = (doc.pdfPath ?? '').toLowerCase();

  return docNumber.startsWith('DEMO') ||
      (companyName == 'חברה בע"מ' && companyId == '00-000000-0') ||
      pdfPath.contains('mock_scan_');
}

bool _isDisplayableRealScannedDocument(InvoiceDocument doc) {
  if (_isKnownDemoDocument(doc)) return false;
  return _hasRealScanPayload(doc);
}

List<InvoiceDocument> _sortedByCreatedDesc(List<InvoiceDocument> list) {
  final copy = List<InvoiceDocument>.from(list);
  copy.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return copy;
}

class DocumentsNotifier extends StateNotifier<List<InvoiceDocument>> {
  DocumentsNotifier() : super(const []);

  final ClientScannedCertificateSyncService _syncService =
      ClientScannedCertificateSyncService();

  void _emit(List<InvoiceDocument> next, {InvoiceDocument? syncDocument}) {
    final filtered = next
        .where(_isDisplayableRealScannedDocument)
        .toList(growable: false);
    state = _sortedByCreatedDesc(filtered);
    DocumentsStorage.save(state);
    if (syncDocument != null) {
      final metadataOnly =
          syncDocument.status == DocumentStatus.uploading;
      unawaited(
        _syncService.sync(
          syncDocument,
          uploadFiles: !metadataOnly,
        ),
      );
    }
  }

  /// טוען מהשרver, מתמזג עם מקומי, ושומר (pull-to-refresh / הפעלה).
  Future<void> loadFromStorage() async {
    final local = await DocumentsStorage.load();
    final remote = await _syncService.fetchAll();
    final merged = _mergeLocalAndRemote(local, remote);
    _emit(merged);
  }

  List<InvoiceDocument> _mergeLocalAndRemote(
    List<InvoiceDocument> local,
    List<InvoiceDocument> remote,
  ) {
    final byId = <String, InvoiceDocument>{
      for (final doc in local) doc.id: doc,
    };

    for (final remoteDoc in remote) {
      final existing = byId[remoteDoc.id];
      if (existing == null) {
        byId[remoteDoc.id] = remoteDoc;
        continue;
      }
      byId[remoteDoc.id] = _mergeDocument(existing, remoteDoc);
    }

    return byId.values.toList(growable: false);
  }

  InvoiceDocument _mergeDocument(
    InvoiceDocument local,
    InvoiceDocument remote,
  ) {
    final localPdf = (local.pdfPath ?? '').trim();
    final localImages = local.imagePaths
        .where((path) => path.trim().isNotEmpty)
        .toList(growable: false);
    final remotePdfUrl = (remote.pdfUrl ?? '').trim();
    final remoteImageUrls = remote.imageUrls
        .where((path) => path.trim().isNotEmpty)
        .toList(growable: false);
    final localImageUrls = local.imageUrls
        .where((path) => path.trim().isNotEmpty)
        .toList(growable: false);

    return remote.copyWith(
      pdfPath: localPdf.isNotEmpty ? local.pdfPath : remote.pdfPath,
      pdfUrl: remotePdfUrl.isNotEmpty ? remote.pdfUrl : local.pdfUrl,
      imagePaths:
          localImages.isNotEmpty ? localImages : remote.imagePaths,
      imageUrls:
          remoteImageUrls.isNotEmpty ? remoteImageUrls : localImageUrls,
      jobId: remote.jobId ?? local.jobId,
    );
  }

  /// הוספת מסמך חדש.
  void addDocument(InvoiceDocument document) {
    if (state.any((d) => d.id == document.id)) return;
    _emit([...state, document], syncDocument: document);
  }

  /// עדכון מסמך קיים (לפי id).
  void updateDocument(InvoiceDocument document) {
    final index = state.indexWhere((d) => d.id == document.id);
    if (index == -1) return;
    final updated = [...state];
    updated[index] = document;
    _emit(updated, syncDocument: document);
  }

  /// מחיקת מסמך לפי מזהה (מקומי + soft delete בשרת).
  Future<void> deleteById(String id) async {
    await _syncService.delete(id);
    deleteDocument(id);
  }

  /// מחיקת מסמך לפי מזהה — מקומי בלבד.
  void deleteDocument(String id) {
    _emit(state.where((d) => d.id != id).toList(growable: false));
  }

  /// עדכון סטטוס של מסמך לפי מזהה.
  void updateStatus(String id, DocumentStatus newStatus) {
    final index = state.indexWhere((d) => d.id == id);
    if (index == -1) return;
    final updated = [...state];
    final changed = updated[index].copyWith(status: newStatus);
    updated[index] = changed;
    _emit(updated, syncDocument: changed);
  }

  /// החזרת מסמך בודד לפי מזהה.
  InvoiceDocument? getDocument(String id) {
    try {
      return state.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  /// הוספה או עדכון של מסמך ברשימה לפי מזהה (תאימות לאחור).
  void upsert(InvoiceDocument document, {bool syncToServer = true}) {
    final index = state.indexWhere((d) => d.id == document.id);
    if (index == -1) {
      if (state.any((d) => d.id == document.id)) return;
      _emit(
        [...state, document],
        syncDocument: syncToServer ? document : null,
      );
    } else {
      final updated = [...state];
      updated[index] = document;
      _emit(
        updated,
        syncDocument: syncToServer ? document : null,
      );
    }
  }
}
