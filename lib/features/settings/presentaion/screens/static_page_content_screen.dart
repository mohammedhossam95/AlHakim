import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/utils/enums.dart';
import 'package:alhakim/features/settings/presentaion/widgets/custom_app_bar.dart';
import 'package:alhakim/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StaticPageScreen extends StatefulWidget {
  final StaticPageType type;

  const StaticPageScreen({super.key, required this.type});

  @override
  State<StaticPageScreen> createState() => _StaticPageScreenState();
}

class _StaticPageScreenState extends State<StaticPageScreen> {
  late final WebViewController controller;
  bool isLoading = true;

  String get pageUrl {
    switch (widget.type) {
      case StaticPageType.privacy:
        return 'https://alhakim-eg.com/privacy-policy';

      case StaticPageType.faq:
        return 'https://alhakim-eg.com/faq';

      case StaticPageType.aboutUs:
        return 'https://alhakim-eg.com/about-us';

      default:
        return 'https://alhakim-eg.com/';
    }
  }

  String get pageTitle {
    switch (widget.type) {
      case StaticPageType.privacy:
        return "privacy_policy".tr;

      case StaticPageType.faq:
        return "public_questions".tr;

      case StaticPageType.aboutUs:
        return "how_we".tr;
      default:
        return "alhakim".tr;
    }
  }

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) {
              setState(() {
                isLoading = true;
              });
            }
          },

          onPageFinished: (_) {
            if (mounted) {
              setState(() {
                isLoading = false;
              });
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(pageUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: CustomAppBar(title: pageTitle, isInTabBar: false),
            ),

            Expanded(
              child: Stack(
                children: [
                  WebViewWidget(controller: controller),

                  if (isLoading)
                    Center(
                      child: CircularProgressIndicator(color: colors.main),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
