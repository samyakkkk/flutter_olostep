import 'dart:async';
import 'dart:developer' as developer;
import 'dart:typed_data';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_olostep/flutter_olostep.dart';
import 'package:html2md/html2md.dart' as html2md;

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
      developer.log("progress change : $x");
    });

    await _headlessWebView!.run();
  }

  @override
  Future<Map<String, dynamic>> crawl(
    ScrapeRequest request,
  ) async {
    if (request.windowSize != null) {
      await _headlessWebView!.setSize(request.windowSize!);
    }
    await _loadUrlAndWait(request.url);
    await Future.delayed(Duration(seconds: request.waitBeforeScraping));
    final result = await _webViewController!
        .evaluateJavascript(source: 'document.documentElement.outerHTML');
    final html = result?.toString() ?? '';
    final markdown = _convertHtmlToMarkdown(html);
    Uint8List? screenshot;
    if (request.htmlVisualizer ?? false) {
      screenshot = await _webViewController!.takeScreenshot();
    }
    final finalUri = await _webViewController!.getUrl();
    final String? finalUrl = finalUri?.uriValue.toString();

    return {
      'html': html,
      'markdown': markdown,
      'screenshot': screenshot,
      'finalUrl': finalUrl,
    };
  }

  Future<void> _loadUrlAndWait(String url) async {
    _pageLoadCompleter = Completer<void>();
    developer.log('sending loadUrl Requests');
    await _webViewController!.loadUrl(urlRequest: URLRequest(url: WebUri(url)));
    developer.log('sending loadUrl rquest sent');
    await _pageLoadCompleter!.future;
    developer.log('load url future completed');
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
