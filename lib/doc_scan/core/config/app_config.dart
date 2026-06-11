import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

// --- Scanner ---

/// ML Kit on Android; VisionKit on iOS; mock elsewhere.
bool get useRealScanner => Platform.isAndroid || Platform.isIOS;

// --- API Food Stock (Scan Invoice) – שלב 2 ---

String get apiBaseUrl =>
    dotenv.env['API_BASE_URL']?.trim() ??
    'https://devapi.foodstock.shtibel.com/api';

String get apiEmail => dotenv.env['API_EMAIL']?.trim() ?? '';

String get apiPassword => dotenv.env['API_PASSWORD']?.trim() ?? '';

String get apiClientId => dotenv.env['API_CLIENT_ID']?.trim() ?? '';

String get apiOcrStatusId => dotenv.env['API_OCR_STATUS_ID']?.trim() ?? '';
