import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_constants.dart';
import '../providers/embedded_ui_provider.dart';
import '../router/app_router.dart';
import '../gen_l10n/app_localizations.dart';
import '../utils/embedded_app_bar.dart';
import '../widgets/model_selector_sheet.dart';
import 'package:food_stock/ui/utils/constants/app_colors.dart' as fs;
import 'package:food_stock/ui/utils/constants/app_constants.dart' as fs;
import 'package:food_stock/ui/widget/common_app_bar.dart';

/// FoodStock-style scaffold + app bar for embedded doc-scan routes.
class EmbeddedDocScanScaffold extends ConsumerWidget {
  const EmbeddedDocScanScaffold({
    super.key,
    required this.child,
  });

  final Widget child;

  void _handleBack(BuildContext context, WidgetRef ref) {
    final router = ref.read(docScanRouterProvider);
    if (router.canPop()) {
      router.pop();
    } else {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  PreferredSizeWidget? _buildAppBar(
    BuildContext context,
    WidgetRef ref,
    String location,
  ) {
    final docL10n = AppLocalizations.of(context);
    final homeTitle = ref.watch(embeddedScanHomeTitleProvider);
    final showSettings = location == AppConstants.routeHome;
    final isDetails = location == AppConstants.routeDetails;
    final isJson = location == AppConstants.routeJsonPreview;
    final isExcel = location == AppConstants.routeExcelPreview;
    final isPdf = location == AppConstants.routePdfPreview;
    final isImages = location == AppConstants.routeImagesPreview;
    final hideAppBar = docScanRouteHasOwnAppBar(location);

    if (hideAppBar) {
      return null;
    }

    final title = isDetails
        ? docL10n.documentDetails
        : isJson
            ? docL10n.jsonTitle
            : isExcel
                ? docL10n.excelPreviewTitle
                : isPdf
                    ? docL10n.pdfPreviewTitle
                    : isImages
                        ? docL10n.scannedImagesPreviewTitle
                        : homeTitle;
    final headerActions = (isDetails || isJson || isExcel || isPdf || isImages)
        ? ref.watch(embeddedDetailsHeaderActionsProvider)
        : const <EmbeddedDetailsHeaderAction>[];

    // כפתור סיבוב המסך מוצג ליד חץ החזרה (בקשת המשתמש), שאר הכפתורים בצד השני.
    EmbeddedDetailsHeaderAction? rotateAction;
    final otherActions = <EmbeddedDetailsHeaderAction>[];
    for (final a in headerActions) {
      if (rotateAction == null && a.icon == Icons.screen_rotation) {
        rotateAction = a;
      } else {
        otherActions.add(a);
      }
    }

    Widget? leadingExtra;
    if (rotateAction != null) {
      leadingExtra = IconButton(
        icon: Icon(rotateAction.icon, size: 24),
        color: rotateAction.iconColor ?? fs.AppColors.blackColor,
        tooltip: rotateAction.tooltip,
        onPressed: rotateAction.onPressed,
      );
    }

    Widget? trailingWidget;
    if (otherActions.isNotEmpty) {
      trailingWidget = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final action in otherActions)
            IconButton(
              icon: Icon(action.icon, size: 24),
              color: action.iconColor ?? fs.AppColors.blackColor,
              tooltip: action.tooltip,
              onPressed: action.onPressed,
            ),
        ],
      );
    } else if (showSettings) {
      trailingWidget = IconButton(
        icon: const Icon(CupertinoIcons.settings, size: 24),
        color: fs.AppColors.blackColor,
        tooltip: Localizations.localeOf(context).languageCode == 'he'
            ? 'בחר מודל סריקה'
            : 'Choose scan model',
        onPressed: () => showDocScanModelSelector(context, ref),
      );
    }

    return PreferredSize(
      preferredSize: const Size.fromHeight(fs.AppConstants.appBarHeight),
      child: CommonAppBar(
        bgColor: fs.AppColors.pageColor,
        title: title,
        iconData: Icons.arrow_back_ios_sharp,
        onTap: () => _handleBack(context, ref),
        leadingExtra: leadingExtra,
        trailingWidget: trailingWidget,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = GoRouter.of(context);

    return ListenableBuilder(
      listenable: Listenable.merge([
        router.routerDelegate,
        router.routeInformationProvider,
      ]),
      builder: (context, _) {
        final location = resolveEmbeddedDocScanLocation(router);
        final appBar = _buildAppBar(context, ref, location);

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (didPop) return;
            _handleBack(context, ref);
          },
          child: Scaffold(
            backgroundColor: fs.AppColors.pageColor,
            appBar: appBar,
            body: child,
          ),
        );
      },
    );
  }
}
