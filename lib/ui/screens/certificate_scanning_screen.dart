import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_stock/doc_scan/bootstrap/doc_scan_bootstrap.dart';
import 'package:food_stock/doc_scan/doc_scan_shell.dart';
import 'package:food_stock/doc_scan/providers/embedded_ui_provider.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';

import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../widget/common_app_bar.dart';

class CertificateScanningRoute {
  static Widget get route => const CertificateScanningScreen();
}

class CertificateScanningScreen extends StatefulWidget {
  const CertificateScanningScreen({super.key});

  @override
  State<CertificateScanningScreen> createState() => _CertificateScanningScreenState();
}

class _CertificateScanningScreenState extends State<CertificateScanningScreen> {
  late final Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = DocScanBootstrap.ensureInitialized();
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, {VoidCallback? onBack}) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
      child: CommonAppBar(
          bgColor: AppColors.pageColor,
          title: AppLocalizations.of(context)!.certificate_scanning,
          iconData: Icons.arrow_back_ios_sharp,
          onTap: onBack ?? () => Navigator.pop(context)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: _initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Scaffold(
                backgroundColor: AppColors.pageColor, appBar: _buildAppBar(context), body: const Center(child: CircularProgressIndicator()));
          }

          if (snapshot.hasError) {
            return Scaffold(
              backgroundColor: AppColors.pageColor,
              appBar: _buildAppBar(context),
              body: Center(child: Padding(padding: const EdgeInsets.all(24), child: Text(snapshot.error.toString(), textAlign: TextAlign.center))),
            );
          }

          final homeTitle = AppLocalizations.of(context)!.certificate_scanning;
          return ProviderScope(overrides: [embeddedScanHomeTitleProvider.overrideWithValue(homeTitle)], child: const DocScanShell());
        });
  }
}
