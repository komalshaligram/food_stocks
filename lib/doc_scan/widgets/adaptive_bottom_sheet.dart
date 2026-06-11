import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<T?> showAdaptiveBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isScrollControlled = false,
  ShapeBorder? shape,
  Color? backgroundColor,
}) {
  final isIos = Theme.of(context).platform == TargetPlatform.iOS;
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    isDismissible: true,
    enableDrag: true,
    useSafeArea: true,
    shape: shape,
    backgroundColor: backgroundColor,
    builder: (sheetContext) {
      final child = Builder(builder: builder);
      if (!isIos) return child;
      return CupertinoTheme(
        data: const CupertinoThemeData(),
        child: child,
      );
    },
  );
}
