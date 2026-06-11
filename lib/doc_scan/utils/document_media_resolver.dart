import 'dart:io';

import 'package:food_stock/ui/utils/constants/app_urls.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../models/invoice_document.dart';

enum DocumentMediaSourceType { localFile, networkUrl }

class ResolvedDocumentMedia {
  const ResolvedDocumentMedia({
    required this.type,
    required this.pathOrUrl,
  });

  final DocumentMediaSourceType type;
  final String pathOrUrl;

  bool get isLocal => type == DocumentMediaSourceType.localFile;
  bool get isNetwork => type == DocumentMediaSourceType.networkUrl;
}

/// Resolves scanned document PDF/images: local files first, then S3.
class DocumentMediaResolver {
  DocumentMediaResolver._();

  static const String storageKeyPrefix = 'clientScannedDocs/';

  static bool isRemoteStorageReference(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return false;
    return trimmed.startsWith(storageKeyPrefix) ||
        trimmed.startsWith('http://') ||
        trimmed.startsWith('https://');
  }

  static String toPublicUrl(String reference) {
    final trimmed = reference.trim();
    if (trimmed.isEmpty) return trimmed;
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }

    const base = AppUrlEndPoints.scannedDocsBaseUrl;
    final normalizedBase = base.endsWith('/') ? base : '$base/';
    final key = trimmed.startsWith('/') ? trimmed.substring(1) : trimmed;
    return '$normalizedBase$key';
  }

  static Future<ResolvedDocumentMedia?> resolvePdf(InvoiceDocument document) async {
    final localPath = (document.pdfPath ?? '').trim();
    if (localPath.isNotEmpty && !isRemoteStorageReference(localPath)) {
      if (await File(localPath).exists()) {
        return ResolvedDocumentMedia(
          type: DocumentMediaSourceType.localFile,
          pathOrUrl: localPath,
        );
      }
    }

    final remoteKey = _firstNonEmpty([
      document.pdfUrl,
      isRemoteStorageReference(localPath) ? localPath : null,
    ]);
    if (remoteKey == null) return null;

    return ResolvedDocumentMedia(
      type: DocumentMediaSourceType.networkUrl,
      pathOrUrl: toPublicUrl(remoteKey),
    );
  }

  static Future<List<ResolvedDocumentMedia>> resolveImages(
    InvoiceDocument document,
  ) async {
    final localPaths = document.imagePaths
        .map((path) => path.trim())
        .where((path) => path.isNotEmpty)
        .toList();
    final remoteKeys = document.imageUrls
        .map((path) => path.trim())
        .where((path) => path.isNotEmpty)
        .toList();

    if (localPaths.isNotEmpty) {
      final resolved = <ResolvedDocumentMedia>[];
      for (var index = 0; index < localPaths.length; index++) {
        final path = localPaths[index];
        if (!isRemoteStorageReference(path) && await File(path).exists()) {
          resolved.add(
            ResolvedDocumentMedia(
              type: DocumentMediaSourceType.localFile,
              pathOrUrl: path,
            ),
          );
          continue;
        }

        final remoteKey = index < remoteKeys.length
            ? remoteKeys[index]
            : (isRemoteStorageReference(path) ? path : null);
        if (remoteKey != null) {
          resolved.add(
            ResolvedDocumentMedia(
              type: DocumentMediaSourceType.networkUrl,
              pathOrUrl: toPublicUrl(remoteKey),
            ),
          );
        }
      }

      if (resolved.isNotEmpty) {
        return resolved;
      }
    }

    if (remoteKeys.isNotEmpty) {
      return remoteKeys
          .map(
            (key) => ResolvedDocumentMedia(
              type: DocumentMediaSourceType.networkUrl,
              pathOrUrl: toPublicUrl(key),
            ),
          )
          .toList(growable: false);
    }

    return localPaths
        .where(isRemoteStorageReference)
        .map(
          (key) => ResolvedDocumentMedia(
            type: DocumentMediaSourceType.networkUrl,
            pathOrUrl: toPublicUrl(key),
          ),
        )
        .toList(growable: false);
  }

  static Future<File?> downloadToTempFile({
    required String url,
    required String fileName,
  }) async {
    try {
      final dir = await getTemporaryDirectory();
      final safeName = fileName.replaceAll(RegExp(r'[^\w.\-]'), '_');
      return downloadToFile(
        url: url,
        targetFile: File('${dir.path}/$safeName'),
      );
    } catch (_) {
      return null;
    }
  }

  static Future<File?> downloadToFile({
    required String url,
    required File targetFile,
  }) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) return null;

      await targetFile.parent.create(recursive: true);
      await targetFile.writeAsBytes(response.bodyBytes, flush: true);
      return targetFile;
    } catch (_) {
      return null;
    }
  }

  /// Downloads missing scan images (and PDF) from S3 into app documents storage.
  static Future<EnsureLocalMediaResult> ensureLocalMediaForRetry(
    InvoiceDocument document,
  ) async {
    final imagePaths = await _ensureLocalImagePaths(document);
    final pdfPath = await _ensureLocalPdfPath(document);

    return EnsureLocalMediaResult(
      imagePaths: imagePaths.paths,
      pdfPath: pdfPath,
      imagesDownloaded: imagePaths.downloadedCount,
      pdfDownloaded: pdfPath != null && pdfPath != document.pdfPath,
    );
  }

  static Future<Directory> _documentMediaDir(String documentId) async {
    final root = await getApplicationDocumentsDirectory();
    final dir = Directory('${root.path}/scanned_media/$documentId');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  static Future<({List<String> paths, int downloadedCount})>
      _ensureLocalImagePaths(
    InvoiceDocument document,
  ) async {
    final resolved = await resolveImages(document);
    if (resolved.isEmpty) {
      return (paths: const <String>[], downloadedCount: 0);
    }

    final dir = await _documentMediaDir(document.id);
    final localPaths = <String>[];
    var downloadedCount = 0;

    for (var index = 0; index < resolved.length; index++) {
      final media = resolved[index];
      if (media.isLocal) {
        localPaths.add(media.pathOrUrl);
        continue;
      }

      final extension = _guessExtension(media.pathOrUrl);
      final targetFile = File('${dir.path}/image_$index$extension');
      if (await targetFile.exists() && await targetFile.length() > 0) {
        localPaths.add(targetFile.path);
        continue;
      }

      final downloaded = await downloadToFile(
        url: media.pathOrUrl,
        targetFile: targetFile,
      );
      if (downloaded == null) continue;

      downloadedCount++;
      localPaths.add(downloaded.path);
    }

    return (paths: localPaths, downloadedCount: downloadedCount);
  }

  static Future<String?> _ensureLocalPdfPath(InvoiceDocument document) async {
    final localPath = (document.pdfPath ?? '').trim();
    if (localPath.isNotEmpty && !isRemoteStorageReference(localPath)) {
      if (await File(localPath).exists()) {
        return localPath;
      }
    }

    final resolved = await resolvePdf(document);
    if (resolved == null) {
      return localPath.isNotEmpty && !isRemoteStorageReference(localPath)
          ? localPath
          : null;
    }
    if (resolved.isLocal) return resolved.pathOrUrl;

    final dir = await _documentMediaDir(document.id);
    final targetFile = File('${dir.path}/document${_guessExtension(resolved.pathOrUrl)}');
    if (await targetFile.exists() && await targetFile.length() > 0) {
      return targetFile.path;
    }

    final downloaded = await downloadToFile(
      url: resolved.pathOrUrl,
      targetFile: targetFile,
    );
    return downloaded?.path;
  }

  static String _guessExtension(String value) {
    final uri = Uri.tryParse(value);
    final path = uri?.path ?? value;
    final dotIndex = path.lastIndexOf('.');
    if (dotIndex == -1 || dotIndex == path.length - 1) {
      return '.jpg';
    }
    final ext = path.substring(dotIndex).toLowerCase();
    if (ext.length > 6) return '.jpg';
    return ext;
  }

  static String? _firstNonEmpty(List<String?> values) {
    for (final value in values) {
      final trimmed = value?.trim() ?? '';
      if (trimmed.isNotEmpty) return trimmed;
    }
    return null;
  }

  static bool hasPdf(InvoiceDocument document) {
    return _firstNonEmpty([document.pdfPath, document.pdfUrl]) != null;
  }

  static bool hasImages(InvoiceDocument document) {
    return document.imagePaths.any((path) => path.trim().isNotEmpty) ||
        document.imageUrls.any((path) => path.trim().isNotEmpty);
  }
}

class EnsureLocalMediaResult {
  const EnsureLocalMediaResult({
    required this.imagePaths,
    required this.pdfPath,
    required this.imagesDownloaded,
    required this.pdfDownloaded,
  });

  final List<String> imagePaths;
  final String? pdfPath;
  final int imagesDownloaded;
  final bool pdfDownloaded;

  bool get hasImages => imagePaths.isNotEmpty;
}
