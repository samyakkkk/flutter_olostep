import 'dart:async';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'dart:developer' as developer;

import 'webview_manager.dart';

class MacOSWebViewManager extends WebViewManager {
  HeadlessInAppWebView? _headlessWebView;
  late final InAppWebViewController _webViewController;
  Completer<void>? _pageLoadCompleter;

  @override
  Future<void> initialize() async {
    developer.log("Initializing macOS WebView");
    _headlessWebView = HeadlessInAppWebView(
      initialSettings: InAppWebViewSettings(isInspectable: true),
      onWebViewCreated: (controller) {
        developer.log("Webview created!");
        _webViewController = controller;
      },
      onLoadStop: (controller, url) async {
        developer.log("Page loaded: $url");
        _pageLoadCompleter?.complete();
      },
    );
    await _headlessWebView!.run();
  }

  @override
  Future<Map<String, String>> crawl(String url) async {
    await _loadUrlAndWait(url);
    final result = await _webViewController.evaluateJavascript(
        source: 'document.documentElement.outerHTML');
    String html = result?.toString() ?? '';
    String markdown = _convertHtmlToMarkdown(html);
    return {
      'html': html,
      'markdown': markdown,
    };
  }

  Future<void> _loadUrlAndWait(String url) async {
    _pageLoadCompleter = Completer<void>();
    await _webViewController.loadUrl(urlRequest: URLRequest(url: WebUri(url)));
    await _pageLoadCompleter!.future;
  }

  String _convertHtmlToMarkdown(String html) {
    return html2md.convert(html);
  }
}
