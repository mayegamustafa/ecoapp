import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PaymentBrowser extends InAppBrowser {
  PaymentBrowser({
    this.onUrlOverride,
    this.title,
  });

  final Future<NavigationActionPolicy> Function(
      Uri? uri, VoidCallback callClose)? onUrlOverride;

  final String? title;

  @override
  Future<NavigationActionPolicy?>? shouldOverrideUrlLoading(navigationAction) {
    final uri = navigationAction.request.url!;

    return onUrlOverride?.call(uri, close) ??
        super.shouldOverrideUrlLoading(navigationAction);
  }

  Future<void> openUrl(String url) async {
    return openUrlRequest(
      urlRequest: URLRequest(url: WebUri(url)),
      settings: settings,
    );
  }

  static Future<void> setupBrowser() async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
    }
  }

  InAppBrowserClassSettings get settings => InAppBrowserClassSettings(
        browserSettings: InAppBrowserSettings(
          hideUrlBar: false,
          toolbarTopFixedTitle: title,
        ),
        webViewSettings: InAppWebViewSettings(
          useShouldOverrideUrlLoading: true,
        ),
      );
}
