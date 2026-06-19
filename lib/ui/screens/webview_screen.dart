import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/constants/app_strings.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:shimmer/shimmer.dart';
import '../../bloc/webview/webview_bloc.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../widget/common_app_bar.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';

class WebViewRoute {
  static Widget get route => const WebViewScreen();
}

class WebViewScreen extends StatelessWidget {
  const WebViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WebviewBloc()..add(WebViewEvent.generalSettings(context: context, dialogContext: context, isRetryLoading: false)),
      child: const WebViewScreenWidget(),
    );
  }
}

class WebViewScreenWidget extends StatelessWidget {
  const WebViewScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WebviewBloc, WebViewState>(builder: (context, state) {
      final bool showShimmer = state.isShimmering || state.baseUrl == null || state.baseUrl!.isEmpty;

      return Scaffold(
        backgroundColor: AppColors.pageColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
          child: CommonAppBar(
            bgColor: AppColors.pageColor,
            title: state.language == 'en' ? (state.screenEnglishTitle ?? "") : (state.screenHebrewTitle ?? ""),
            iconData: Icons.arrow_back_ios,
            onTap: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: Stack(children: [
            if (!showShimmer) CustomWebView(url: "${state.baseUrl}${state.userId ?? ''}"),
            if (showShimmer) const WebViewShimmer(),
          ]),
        ),
      );
    });
  }
}

class WebViewShimmer extends StatelessWidget {
  const WebViewShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _box(height: 26, width: double.infinity),
          16.height,
          _box(height: 48, width: double.infinity),
          16.height,
          _box(height: 44, width: double.infinity),
          24.height,
          Expanded(
            child: GridView.builder(
                itemCount: 20,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 2.5),
                itemBuilder: (context, index) {
                  return Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppConstants.radius_15)));
                }),
          ),
        ]),
      ),
    );
  }

  Widget _box({required double height, required double width}) {
    return Container(height: height, width: width, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)));
  }
}

class CustomWebView extends StatefulWidget {
  final String url;
  const CustomWebView({super.key, required this.url});

  @override
  State<CustomWebView> createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  bool isLoading = true;

  Future<void> _saveCsvFile(String base64Data, String? suggestedFilename) async {
    const prefix = 'base64,';
    final startIndex = base64Data.indexOf(prefix) + prefix.length;
    if (startIndex < prefix.length) {
      return;
    }
    final cleanBase64 = base64Data.substring(startIndex);
    final bytes = base64Decode(cleanBase64);

    final now = DateTime.now();
    final formattedDate = '${now.day.toString().padLeft(2, '0')}_'
        '${_getMonthName(now.month)}_'
        '${now.year}_'
        '${now.hour.toString().padLeft(2, '0')}_'
        '${now.minute.toString().padLeft(2, '0')}';

    String fileName;
    if (suggestedFilename != null && suggestedFilename.isNotEmpty && suggestedFilename.toLowerCase().endsWith('.csv')) {
      final nameWithoutExt = suggestedFilename.substring(0, suggestedFilename.length - 4);
      fileName = '${nameWithoutExt}_$formattedDate.csv';
    } else {
      fileName = 'export_$formattedDate.csv';
    }

    late Directory targetDir;
    late String saveMessage;

    if (Platform.isAndroid) {
      targetDir = Directory('/storage/emulated/0/Download');
      if (!await targetDir.exists()) {
        await targetDir.create(recursive: true);
      }
      saveMessage = 'CSV downloaded!\nSaved as: $fileName\nCheck your Downloads folder';
    } else {
      final appDocDir = await getApplicationDocumentsDirectory();
      targetDir = Directory('${appDocDir.path}/Downloads');
      if (!await targetDir.exists()) {
        await targetDir.create(recursive: true);
      }
      saveMessage = 'CSV saved!\n$fileName\nCheck Files app → On My iPhone → ${AppStrings.appName} → Downloads';
    }

    final filePath = '${targetDir.path}/$fileName';
    final file = File(filePath);
    await file.writeAsBytes(bytes);

    if (!mounted) return;
    CustomSnackBar.showSnackBar(context: context, title: saveMessage, type: SnackBarType.success);
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(widget.url)),
          initialSettings: InAppWebViewSettings(javaScriptEnabled: true),
          onWebViewCreated: (controller) {
            controller.addJavaScriptHandler(
                handlerName: 'downloadCsvHandler',
                callback: (args) async {
                  if (args.isNotEmpty) {
                    final String base64 = args[0] as String;
                    final String filename = args.length > 1 ? args[1] as String : 'export_${DateTime.now().millisecondsSinceEpoch}.csv';
                    await _saveCsvFile(base64, filename);
                  }
                });
          },
          onLoadStop: (controller, url) async {
            setState(() => isLoading = false);

            await controller.evaluateJavascript(source: '''
              (function() {
                // Override common blob download patterns
                const originalCreateObjectURL = URL.createObjectURL;
                URL.createObjectURL = function(blob) {
                  const reader = new FileReader();
                  reader.onload = function() {
                    const base64 = reader.result;
                    const filename = blob.name || 'export.csv'; // If blob has name, or fallback
                    if (window.flutter_inappwebview?.callHandler) {
                      window.flutter_inappwebview.callHandler('downloadCsvHandler', base64, filename);
                    }
                  };
                  reader.readAsDataURL(blob);
                  // Prevent default download/navigation
                  return '#'; // Return dummy URL to block navigation
                };

                // Optional: Intercept <a download> clicks (common for CSV export)
                document.addEventListener('click', function(e) {
                  if (e.target.tagName === 'A' && e.target.hasAttribute('download')) {
                    const href = e.target.href;
                    if (href.startsWith('blob:')) {
                      e.preventDefault();
                      fetch(href)
                        .then(res => res.blob())
                        .then(blob => {
                          const reader = new FileReader();
                          reader.onload = function() {
                            const base64 = reader.result;
                            const filename = e.target.download || 'export.csv';
                            if (window.flutter_inappwebview?.callHandler) {
                              window.flutter_inappwebview.callHandler('downloadCsvHandler', base64, filename);
                            }
                          };
                          reader.readAsDataURL(blob);
                        });
                    }
                  }
                }, true);
              })();
            ''');
          },
          onLoadStart: (controller, url) => setState(() => isLoading = true)),
      if (isLoading) const WebViewShimmer(),
    ]);
  }
}
