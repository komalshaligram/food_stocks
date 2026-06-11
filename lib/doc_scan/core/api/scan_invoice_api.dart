import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http_parser;

import '../config/app_config.dart';

/// תוצאת התחברות.
class LoginResult {
  const LoginResult({this.accessToken, this.error});
  final String? accessToken;
  final String? error;
}

/// תוצאת העלאת קובץ.
class UploadResult {
  const UploadResult({this.imagePath, this.error});
  /// הנתיב שהשרת מחזיר (לשליחה ב־Create Scan Invoice).
  final String? imagePath;
  final String? error;
}

/// תוצאת יצירת חשבונית סרוקה.
class CreateScanInvoiceResult {
  const CreateScanInvoiceResult({this.scanInvoiceId, this.error});
  final String? scanInvoiceId;
  final String? error;
}

/// לקוח API להעלאת חשבונית סרוקה – Login, File Upload, Create Scan Invoice.
class ScanInvoiceApi {
  ScanInvoiceApi({
    String? baseUrl,
    String? email,
    String? password,
    String? clientId,
    String? ocrStatusId,
  })  : baseUrl = baseUrl ?? apiBaseUrl,
        email = email ?? apiEmail,
        password = password ?? apiPassword,
        clientId = clientId ?? apiClientId,
        ocrStatusId = ocrStatusId ?? apiOcrStatusId;

  final String baseUrl;
  final String email;
  final String password;
  final String clientId;
  final String ocrStatusId;

  String get _loginUrl => '$baseUrl/v1/auth/login';
  String get _uploadUrl => '$baseUrl/v1/files/upload';
  String get _createScanInvoiceUrl => '$baseUrl/v1/scan-invoice/createScanInvoice';

  /// התחברות – מחזיר accessToken.
  Future<LoginResult> login() async {
    try {
      final res = await http.post(
        Uri.parse(_loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      final data = jsonDecode(res.body) as Map<String, dynamic>?;
      // שרת יכול להחזיר 200 עם status:403 ו־message (אימות נכשל)
      final bodyStatus = data?['status'];
      final message = data?['message'] as String?;
      if (bodyStatus == 403 || message != null && message.contains('INVALIDCREDENTIALS')) {
        return const LoginResult(error: 'Invalid login details (403)');
      }
      if (res.statusCode != 200) {
        return LoginResult(error: 'Login failed: ${res.statusCode}');
      }
      final authToken = data?['data']?['authToken'] as Map<String, dynamic>?;
      final token = authToken?['accessToken'] as String?;
      if (token == null || token.isEmpty) {
        return LoginResult(error: message ?? 'No access token in response');
      }
      return LoginResult(accessToken: token);
    } catch (e) {
      return LoginResult(error: e.toString());
    }
  }

  /// העלאת קובץ PDF – מחזיר את הנתיב שהשרת מחזיר (לשימוש ב־images).
  /// אם מועבר [accessToken] שולחים Authorization: Bearer (חלק מהשרתים דורשים).
  Future<UploadResult> uploadFile(File file, {String? accessToken}) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(_uploadUrl));
      if (accessToken != null && accessToken.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $accessToken';
      }
      request.files.add(
        await http.MultipartFile.fromPath(
          'invoiceImage',
          file.path,
          contentType: http_parser.MediaType('application', 'pdf'),
        ),
      );
      final streamed = await request.send();
      final res = await http.Response.fromStream(streamed);
      if (res.statusCode != 200 && res.statusCode != 201) {
        return UploadResult(
          error: 'Upload failed: ${res.statusCode}. ${res.body}',
        );
      }
      final data = jsonDecode(res.body) as Map<String, dynamic>?;
      if (data == null) return const UploadResult(error: 'Invalid upload response');
      // File Upload מחזיר filepath – לשליחה ב־Create Scan Invoice (images).
      String? path = data['filepath'] as String?;
      path ??= data['filePath'] as String?;
      path ??= data['data'] is Map ? (data['data'] as Map)['filepath'] as String? : null;
      path ??= data['data'] is Map ? (data['data'] as Map)['filePath'] as String? : null;
      path ??= data['path'] as String?;
      path ??= data['data'] is Map ? (data['data'] as Map)['path'] as String? : null;
      if (path == null || path.isEmpty) {
        return const UploadResult(error: 'No filepath in upload response');
      }
      return UploadResult(imagePath: path);
    } catch (e) {
      return UploadResult(error: e.toString());
    }
  }

  /// יצירת רשומת חשבונית סרוקה (עם הנתיבים מהעלאה).
  Future<CreateScanInvoiceResult> createScanInvoice({
    required String accessToken,
    required List<String> images,
  }) async {
    try {
      final body = jsonEncode({
        'clientId': clientId,
        'ocrStatusId': ocrStatusId,
        'images': images,
        'scanInvoiceProducts': <Object>[],
      });
      final res = await http.post(
        Uri.parse(_createScanInvoiceUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: body,
      );
      if (res.statusCode != 200 && res.statusCode != 201) {
        return CreateScanInvoiceResult(
          error: 'Create failed: ${res.statusCode}. ${res.body}',
        );
      }
      final data = jsonDecode(res.body) as Map<String, dynamic>?;
      final id = data?['data']?['id'] ?? data?['id'];
      return CreateScanInvoiceResult(scanInvoiceId: id?.toString());
    } catch (e) {
      return CreateScanInvoiceResult(error: e.toString());
    }
  }

  /// ריצת כל הזרימה: Login → Upload → CreateScanInvoice.
  Future<CreateScanInvoiceResult> uploadPdfAndCreateScanInvoice(File pdfFile) async {
    final loginResult = await login();
    final token = loginResult.accessToken;
    if (token == null) {
      return CreateScanInvoiceResult(error: loginResult.error ?? 'Login failed');
    }
    final uploadResult = await uploadFile(pdfFile, accessToken: token);
    final path = uploadResult.imagePath;
    if (path == null) {
      return CreateScanInvoiceResult(error: uploadResult.error ?? 'Upload failed');
    }
    return createScanInvoice(accessToken: token, images: [path]);
  }
}
