import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:food_stock/data/storage/shared_preferences_helper.dart';
import 'package:food_stock/ui/utils/constants/app_urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/invoice_document.dart';

/// Sync + list API for scanned certificates on FoodStock Backend.
class ClientScannedCertificateSyncService {
  static const String _storageKeyPrefix = 'clientScannedDocs/';

  String _basename(String filePath) {
    final normalized = filePath.replaceAll('\\', '/');
    final index = normalized.lastIndexOf('/');
    if (index == -1 || index == normalized.length - 1) {
      return normalized;
    }
    return normalized.substring(index + 1);
  }

  Future<Dio?> _authorizedDio({bool forMultipart = false}) async {
    final prefs = SharedPreferencesHelper(
      prefs: await SharedPreferences.getInstance(),
    );
    final token = prefs.getAuthToken();
    if (token.isEmpty) {
      return null;
    }

    final headers = <String, dynamic>{
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    if (!forMultipart) {
      headers[HttpHeaders.contentTypeHeader] = 'application/json';
    }

    return Dio(
      BaseOptions(
        baseUrl: AppUrlEndPoints.baseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        headers: headers,
      ),
    );
  }

  bool _isRemoteStorageKey(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return false;
    return trimmed.startsWith(_storageKeyPrefix) ||
        trimmed.startsWith('http://') ||
        trimmed.startsWith('https://');
  }

  Future<String?> _uploadLocalFile({
    required Dio dio,
    required String clientId,
    required String documentId,
    required File file,
    required String fileRole,
  }) async {
    try {
      final formData = FormData.fromMap({
        'clientId': clientId,
        'documentId': documentId,
        'fileRole': fileRole,
        'file': await MultipartFile.fromFile(
          file.path,
          filename: _basename(file.path),
        ),
      });

      final response = await dio.post(
        AppUrlEndPoints.uploadClientScannedCertificateUrl,
        data: formData,
      );

      final payload = response.data;
      if (payload is! Map<String, dynamic>) {
        return null;
      }

      final status = payload['status'];
      if (status != null && status != 200) {
        debugPrint('[ScannedCertSync] upload failed status=$status');
        return null;
      }

      final data = payload['data'];
      if (data is Map<String, dynamic>) {
        final filepath = data['filepath']?.toString().trim();
        if (filepath != null && filepath.isNotEmpty) {
          return filepath;
        }
      }

      final directPath = payload['filepath']?.toString().trim();
      return directPath != null && directPath.isNotEmpty ? directPath : null;
    } on DioException catch (e) {
      debugPrint(
        '[ScannedCertSync] upload failed: '
        '${e.response?.statusCode} ${e.response?.data ?? e.message}',
      );
      return null;
    } catch (e) {
      debugPrint('[ScannedCertSync] upload failed: $e');
      return null;
    }
  }

  Future<({String? pdfUrl, List<String> imageUrls})> _resolveStorageKeys({
    required InvoiceDocument document,
    required String clientId,
    required Dio dio,
  }) async {
    String? pdfUrl;
    final pdfPath = (document.pdfPath ?? '').trim();
    if (pdfPath.isNotEmpty) {
      if (_isRemoteStorageKey(pdfPath)) {
        pdfUrl = pdfPath;
      } else {
        final file = File(pdfPath);
        if (await file.exists()) {
          pdfUrl = await _uploadLocalFile(
            dio: dio,
            clientId: clientId,
            documentId: document.id,
            file: file,
            fileRole: 'pdf',
          );
        }
      }
    }

    final imageUrls = <String>[];
    var imageIndex = 0;
    for (final imagePath in document.imagePaths) {
      final trimmed = imagePath.trim();
      if (trimmed.isEmpty) continue;

      if (_isRemoteStorageKey(trimmed)) {
        imageUrls.add(trimmed);
        imageIndex++;
        continue;
      }

      final file = File(trimmed);
      if (!await file.exists()) continue;

      final uploadedKey = await _uploadLocalFile(
        dio: dio,
        clientId: clientId,
        documentId: document.id,
        file: file,
        fileRole: 'image_$imageIndex',
      );
      imageIndex++;
      if (uploadedKey != null) {
        imageUrls.add(uploadedKey);
      }
    }

    return (pdfUrl: pdfUrl, imageUrls: imageUrls);
  }

  /// Uploads local PDF/images to FoodStock S3. Returns storage keys.
  Future<({String? pdfUrl, List<String> imageUrls})> uploadFiles(
    InvoiceDocument document,
  ) async {
    final prefs = SharedPreferencesHelper(
      prefs: await SharedPreferences.getInstance(),
    );
    final clientId = prefs.getUserId();
    if (clientId.isEmpty) {
      debugPrint('[ScannedCertSync] uploadFiles skipped: missing clientId');
      return (pdfUrl: null as String?, imageUrls: const <String>[]);
    }

    final dio = await _authorizedDio(forMultipart: true);
    if (dio == null) {
      debugPrint('[ScannedCertSync] uploadFiles skipped: user not logged in');
      return (pdfUrl: null as String?, imageUrls: const <String>[]);
    }

    return _resolveStorageKeys(
      document: document,
      clientId: clientId,
      dio: dio,
    );
  }

  Future<bool> sync(
    InvoiceDocument document, {
    String? pdfUrl,
    List<String>? imageUrls,
    bool uploadFiles = true,
  }) async {
    final prefs = SharedPreferencesHelper(
      prefs: await SharedPreferences.getInstance(),
    );
    final clientId = prefs.getUserId();
    if (clientId.isEmpty) {
      debugPrint('[ScannedCertSync] skipped: missing clientId');
      return false;
    }

    final dio = await _authorizedDio(forMultipart: true);
    if (dio == null) {
      debugPrint('[ScannedCertSync] skipped: user not logged in');
      return false;
    }

    final ({String? pdfUrl, List<String> imageUrls}) storageKeys;
    if (!uploadFiles) {
      storageKeys = (
        pdfUrl: pdfUrl,
        imageUrls: imageUrls ?? const <String>[],
      );
    } else if (pdfUrl != null || (imageUrls?.isNotEmpty ?? false)) {
      storageKeys = (
        pdfUrl: pdfUrl,
        imageUrls: imageUrls ?? const <String>[],
      );
    } else {
      storageKeys = await _resolveStorageKeys(
        document: document,
        clientId: clientId,
        dio: dio,
      );
    }

    final body = <String, dynamic>{
      ...document.toJson(),
      'clientId': clientId,
      if (storageKeys.pdfUrl != null) 'pdfUrl': storageKeys.pdfUrl,
      if (storageKeys.imageUrls.isNotEmpty)
        'imageUrls': storageKeys.imageUrls,
    };
    if (prefs.getSubUser()) {
      final subUserId = prefs.getSubUserId();
      if (subUserId.isNotEmpty) {
        body['subUserId'] = subUserId;
      }
    }

    try {
      final response = await dio.post(
        AppUrlEndPoints.syncClientScannedCertificateUrl,
        data: body,
        options: Options(
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        ),
      );
      debugPrint(
        '[ScannedCertSync] synced doc=${document.id} '
        'status=${document.status.name} http=${response.statusCode}',
      );
      return response.statusCode == 200;
    } on DioException catch (e) {
      debugPrint(
        '[ScannedCertSync] failed doc=${document.id}: '
        '${e.response?.statusCode} ${e.response?.data ?? e.message}',
      );
      return false;
    } catch (e) {
      debugPrint('[ScannedCertSync] failed doc=${document.id}: $e');
      return false;
    }
  }

  /// Loads client scanned certificates from the server (empty list if unavailable).
  Future<List<InvoiceDocument>> fetchAll() async {
    final dio = await _authorizedDio();
    if (dio == null) {
      debugPrint('[ScannedCertSync] fetchAll skipped: user not logged in');
      return const [];
    }

    try {
      final response = await dio.post(
        AppUrlEndPoints.getAllClientScannedCertificatesUrl,
        data: const {
          'pageNum': 1,
          'pageLimit': 200,
          'sortField': 'mobileCreatedAt',
          'sortOrder': 'desc',
        },
      );
      final payload = response.data;
      if (payload is! Map<String, dynamic>) {
        return const [];
      }

      final status = payload['status'];
      if (status != 200) {
        debugPrint('[ScannedCertSync] fetchAll failed status=$status');
        return const [];
      }

      final data = payload['data'];
      if (data is! Map<String, dynamic>) {
        return const [];
      }

      final records = data['records'];
      if (records is! List) {
        return const [];
      }

      final documents = <InvoiceDocument>[];
      for (final raw in records) {
        if (raw is! Map<String, dynamic>) continue;
        try {
          documents.add(InvoiceDocument.fromJson(raw));
        } catch (e) {
          debugPrint('[ScannedCertSync] fetchAll parse error: $e');
        }
      }

      debugPrint('[ScannedCertSync] fetchAll loaded ${documents.length} docs');
      return documents;
    } on DioException catch (e) {
      debugPrint(
        '[ScannedCertSync] fetchAll failed: '
        '${e.response?.statusCode} ${e.response?.data ?? e.message}',
      );
      return const [];
    } catch (e) {
      debugPrint('[ScannedCertSync] fetchAll failed: $e');
      return const [];
    }
  }

  /// Soft-delete on server by mobile document id (`InvoiceDocument.id`).
  Future<bool> delete(String mobileDocumentId) async {
    final prefs = SharedPreferencesHelper(
      prefs: await SharedPreferences.getInstance(),
    );
    final clientId = prefs.getUserId();
    if (clientId.isEmpty) {
      debugPrint('[ScannedCertSync] delete skipped: missing clientId');
      return false;
    }

    final dio = await _authorizedDio();
    if (dio == null) {
      debugPrint('[ScannedCertSync] delete skipped: user not logged in');
      return false;
    }

    try {
      final response = await dio.post(
        AppUrlEndPoints.deleteClientScannedCertificateUrl,
        data: {
          'id': mobileDocumentId,
          'clientId': clientId,
        },
      );
      debugPrint(
        '[ScannedCertSync] deleted doc=$mobileDocumentId status=${response.statusCode}',
      );
      return response.statusCode == 200;
    } on DioException catch (e) {
      debugPrint(
        '[ScannedCertSync] delete failed doc=$mobileDocumentId: '
        '${e.response?.statusCode} ${e.response?.data ?? e.message}',
      );
      return false;
    } catch (e) {
      debugPrint('[ScannedCertSync] delete failed doc=$mobileDocumentId: $e');
      return false;
    }
  }
}
