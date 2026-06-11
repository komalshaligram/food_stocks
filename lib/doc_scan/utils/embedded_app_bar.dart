import 'package:go_router/go_router.dart';

import '../core/constants/app_constants.dart';

/// Active top-level doc-scan path (e.g. `/details`, `/json_preview`).
String resolveEmbeddedDocScanLocation(GoRouter router) {
  try {
    final path = router.state.uri.path;
    if (path.isNotEmpty) {
      return path;
    }
  } catch (_) {}

  try {
    final fullPath = router.state.fullPath;
    if (fullPath != null && fullPath.isNotEmpty) {
      return fullPath;
    }
  } catch (_) {}

  try {
    final matches = router.routerDelegate.currentConfiguration;
    if (matches.isNotEmpty) {
      return matches.last.matchedLocation;
    }
  } catch (_) {}

  return AppConstants.routeHome;
}

bool docScanRouteHasOwnAppBar(String location) {
  return location == AppConstants.routeScan;
}
