import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../bloc/webview/webview_bloc.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../widget/common_app_bar.dart';

class WebViewRoute {
  static Widget get route => const WebViewScreen();
}

class WebViewScreen extends StatelessWidget {
  const WebViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WebviewBloc()
        ..add(WebViewEvent.generalSettings(
          context: context,
          dialogContext: context,
          isRetryLoading: false,
        )),
      child: const WebViewScreenWidget(),
    );
  }
}

class WebViewScreenWidget extends StatelessWidget {
  const WebViewScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WebviewBloc, WebViewState>(
      builder: (context, state) {
        final bool showShimmer =
            state.isShimmering ||
                state.baseUrl == null ||
                state.baseUrl!.isEmpty;

        return Scaffold(
          backgroundColor: AppColors.pageColor,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
            child: CommonAppBar(
              bgColor: AppColors.pageColor,
              title: state.language == 'en'
                  ? (state.screenEnglishTitle ?? "")
                  : (state.screenHebrewTitle ?? ""),
              iconData: Icons.arrow_back_ios,
              onTap: () => Navigator.pop(context),
            ),
          ),
          body: SafeArea(
            child: Stack(
              children: [
                if (!showShimmer)
                  CustomWebView(
                    url: "${state.baseUrl}${state.userId ?? ''}",
                  ),
                if (showShimmer) const WebViewShimmer(),
              ],
            ),
          ),
        );
      },
    );
  }
}

///////////////////////////////////////////////////
/// Shimmer Widget (UI like your screenshot)
///////////////////////////////////////////////////
class WebViewShimmer extends StatelessWidget {
  const WebViewShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _box(height: 26, width: double.infinity),
            const SizedBox(height: 16),
            _box(height: 48, width: double.infinity),
            const SizedBox(height: 16),
            _box(height: 44, width: double.infinity),
            const SizedBox(height: 24),

            Expanded(
              child: GridView.builder(
                itemCount: 20,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 2.5,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _box({required double height, required double width}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

///////////////////////////////////////////////////
/// Custom WebView
///////////////////////////////////////////////////
class CustomWebView extends StatefulWidget {
  final String url;
  const CustomWebView({super.key, required this.url});

  @override
  State<CustomWebView> createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  late final WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            setState(() => isLoading = true);
          },
          onPageFinished: (_) {
            setState(() => isLoading = false);
          },
          onWebResourceError: (_) {
            setState(() => isLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: controller),
        if (isLoading) const WebViewShimmer(),
      ],
    );
  }
}
