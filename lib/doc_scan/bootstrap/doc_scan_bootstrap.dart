import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../firebase_options.dart';

/// Lazy initialization for the embedded document-scan feature.
class DocScanBootstrap {
  DocScanBootstrap._();

  static const String firebaseAppName = 'docScan';

  static bool _initialized = false;
  static FirebaseApp? _firebaseApp;

  static FirebaseApp get firebaseApp {
    final app = _firebaseApp;
    if (app == null) {
      throw StateError('DocScanBootstrap.ensureInitialized() was not called');
    }
    return app;
  }

  static Future<void> ensureInitialized() async {
    if (_initialized) return;

    GoogleFonts.config.allowRuntimeFetching = false;
    await initializeDateFormatting('he', null);

    if (kIsWeb) {
      throw UnsupportedError('Document scanning is not supported on web');
    }

    try {
      _firebaseApp = Firebase.app(firebaseAppName);
    } on FirebaseException {
      _firebaseApp = await Firebase.initializeApp(
        name: firebaseAppName,
        options: DocScanFirebaseOptions.currentPlatform,
      );
    }

    final auth = FirebaseAuth.instanceFor(app: _firebaseApp!);
    if (auth.currentUser == null) {
      await auth.signInAnonymously();
    }

    _initialized = true;
  }
}
