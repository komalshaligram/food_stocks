import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../bootstrap/doc_scan_bootstrap.dart';
import '../core/services/document_parser_service.dart';

final documentParserProvider = Provider<DocumentParserService>((ref) {
  return DocumentParserService(app: DocScanBootstrap.firebaseApp);
});
