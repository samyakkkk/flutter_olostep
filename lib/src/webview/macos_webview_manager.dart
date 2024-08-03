import 'dart:async';
import 'dart:ui';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'dart:developer' as developer;

import 'webview_manager.dart';

class MacOSWebViewManager extends WebViewManager {
  HeadlessInAppWebView? _headlessWebView;
  InAppWebViewController? _webViewController;
  Completer<void>? _pageLoadCompleter;

  @override
  Future<void> initialize() async {
    developer.log("Initializing macOS WebView");
    _headlessWebView = HeadlessInAppWebView(onWebViewCreated: (controller) {
      developer.log("Webview created!");
      _webViewController = controller;
    }, onLoadStop: (controller, url) async {
      developer.log("Page loaded: $url");
      _pageLoadCompleter?.complete();
    }, onProgressChanged: (_, int x) {
      print("progress change : $x");
    });

    await _headlessWebView!.run();
  }

  @override
  Future<Map<String, dynamic>> crawl(String url,
      {Size? screenshotSize, int? waitTime}) async {
    if (screenshotSize != null) await _headlessWebView!.setSize(screenshotSize);
    await _loadUrlAndWait(url);
    await Future.delayed(Duration(milliseconds: waitTime ?? 0));
    final result = await _webViewController!
        .evaluateJavascript(source: 'document.documentElement.outerHTML');
    final html = result?.toString() ?? '';
    final markdown = _convertHtmlToMarkdown(html);
    final screenshot = await _webViewController!.takeScreenshot();
    return {'html': html, 'markdown': markdown, 'screenshot': screenshot};
  }

  Future<void> _loadUrlAndWait(String url) async {
    _pageLoadCompleter = Completer<void>();
    print('sending loadUrl Requests');
    await _webViewController!.loadUrl(urlRequest: URLRequest(url: WebUri(url)));
    print('sending loadUrl rquest sent');
    await _pageLoadCompleter!.future;
    print('load url future completed');
  }

  String _convertHtmlToMarkdown(String html) {
    return html2md.convert(html);
  }

  @override
  Future<void> dispose() async {
    await _headlessWebView?.dispose();
    _headlessWebView = null;
    _webViewController = null;
  }
}
