import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_constants.dart';
import '../models/invoice_document.dart';
import '../screens/document_details_screen.dart';
import '../screens/json_preview_screen.dart';
import '../screens/images_preview_screen.dart';
import '../screens/excel_preview_screen.dart';
import '../screens/home_screen.dart';
import '../screens/pdf_preview_screen.dart';
import '../screens/processing_screen.dart';
import '../screens/scan_screen.dart';
import '../widgets/embedded_doc_scan_scaffold.dart';

final docScanRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppConstants.routeHome,
    debugLogDiagnostics: false,
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return EmbeddedDocScanScaffold(child: child);
        },
        routes: [
      GoRoute(
        path: AppConstants.routeHome,
        name: 'home',
        pageBuilder: (context, state) =>
            _buildPage(state, const HomeScreen(embedded: true)),
      ),
      GoRoute(
        path: AppConstants.routeScan,
        name: 'scan',
        pageBuilder: (context, state) =>
            _buildPage(state, const ScanScreen()),
      ),
      GoRoute(
        path: AppConstants.routeProcessing,
        name: 'processing',
        pageBuilder: (context, state) => _buildPage(
          state,
          ProcessingScreen(
            pdfPath: state.extra is String
                ? state.extra as String
                : state.extra is Map
                    ? (state.extra as Map)['pdfPath'] as String?
                    : null,
            imagePaths: state.extra is Map
                ? ((state.extra as Map)['imagePaths'] as List?)
                    ?.whereType<String>()
                    .toList()
                : null,
            didTryImageExport: state.extra is Map
                ? ((state.extra as Map)['didTryImageExport'] as bool?) ?? false
                : false,
            imageExportError: state.extra is Map
                ? (state.extra as Map)['imageExportError'] as String?
                : null,
            targetDocumentId: state.extra is Map
                ? (state.extra as Map)['targetDocumentId'] as String?
                : null,
            targetCreatedAt: state.extra is Map
                ? (() {
                    final v = (state.extra as Map)['targetCreatedAt'];
                    if (v is DateTime) return v;
                    if (v is String) return DateTime.tryParse(v);
                    return null;
                  }())
                : null,
            initialDocumentType: state.extra is Map
                ? (state.extra as Map)['initialDocumentType'] as String?
                : null,
            initialSupplierName: state.extra is Map
                ? (state.extra as Map)['initialSupplierName'] as String?
                : null,
          ),
        ),
      ),
      GoRoute(
        path: AppConstants.routeDetails,
        name: 'details',
        pageBuilder: (context, state) => _buildPage(
          state,
          DocumentDetailsScreen(
            embedded: true,
            document: state.extra is InvoiceDocument
                ? state.extra as InvoiceDocument
                : null,
          ),
        ),
      ),
      GoRoute(
        path: AppConstants.routePdfPreview,
        name: 'pdf_preview',
        pageBuilder: (context, state) => _buildPage(
          state,
          PdfPreviewScreen(
            embedded: true,
            document: state.extra is InvoiceDocument
                ? state.extra as InvoiceDocument
                : null,
          ),
        ),
      ),
      GoRoute(
        path: AppConstants.routeExcelPreview,
        name: 'excel_preview',
        pageBuilder: (context, state) {
          InvoiceDocument? doc;
          String? excelPath;
          if (state.extra is Map) {
            final m = state.extra as Map;
            doc = m['document'] as InvoiceDocument?;
            excelPath = m['excelPath'] as String?;
          }
          return _buildPage(
            state,
            ExcelPreviewScreen(
              embedded: true,
              document: doc,
              excelPath: excelPath,
            ),
          );
        },
      ),
      GoRoute(
        path: AppConstants.routeImagesPreview,
        name: 'images_preview',
        pageBuilder: (context, state) => _buildPage(
          state,
          ImagesPreviewScreen(
            embedded: true,
            document: state.extra is InvoiceDocument
                ? state.extra as InvoiceDocument
                : null,
          ),
        ),
      ),
      GoRoute(
        path: AppConstants.routeJsonPreview,
        name: 'json_preview',
        pageBuilder: (context, state) {
          String? jsonText;
          if (state.extra is Map) {
            jsonText = (state.extra as Map)['jsonText'] as String?;
          } else if (state.extra is String) {
            jsonText = state.extra as String;
          }
          return _buildPage(
            state,
            JsonPreviewScreen(
              embedded: true,
              jsonText: jsonText,
            ),
          );
        },
      ),
        ],
      ),
    ],
  );
});

CustomTransitionPage<void> _buildPage(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final offsetAnimation = Tween<Offset>(
        begin: const Offset(0.05, 0.0), // כניסה עדינה מימין לשמאל (RTL)
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: animation, curve: Curves.easeOut),
      );

      return FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: offsetAnimation,
          child: child,
        ),
      );
    },
  );
}
