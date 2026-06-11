
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Home-screen title when doc-scan is embedded inside FoodStock.
final embeddedScanHomeTitleProvider = Provider<String>(
  (ref) => 'Certificate Scanning',
);

/// Trailing header actions for embedded sub-screens (rescan, delete, share, etc.).
class EmbeddedDetailsHeaderAction {
  const EmbeddedDetailsHeaderAction({
    required this.tooltip,
    required this.onPressed,
    this.icon = CupertinoIcons.refresh,
    this.iconColor,
  });

  final String tooltip;
  final VoidCallback onPressed;
  final IconData icon;
  final Color? iconColor;
}

final embeddedDetailsHeaderActionsProvider =
    StateProvider<List<EmbeddedDetailsHeaderAction>>((ref) => const []);
