import 'dart:async';
import 'dart:io';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webview_windows/webview_windows.dart' as windows_webview;
import 'package:html2md/html2md.dart' as html2md;
import 'dart:developer' as developer;


class WebViewManager {
  dynamic _webViewController;
  HeadlessInAppWebView? _headlessWebView;

  Future<void> initialize() async {
    developer.log("TEST ME");
    if (Platform.isWindows) {
      _webViewController = windows_webview.WebviewController();
      await _webViewController.initialize();
    } else if (Platform.isMacOS) {
      _headlessWebView = HeadlessInAppWebView(
        initialSettings: InAppWebViewSettings(
            useShouldOverrideUrlLoading: true,
            mediaPlaybackRequiresUserGesture: false,
        ),
        onWebViewCreated: (controller) {
          developer.log("Webview created!");
          _webViewController = controller;
        },
      );
      await _headlessWebView!.run();
    }

  }

  Future<void> loadUrl(String url) async {
    if (_webViewController == null) {
      throw Exception('WebViewController not initialized.');
    }
    if (Platform.isWindows) {
      await _webViewController.loadUrl(url);
    } else if (Platform.isMacOS) {
      await _webViewController.loadUrl(urlRequest: URLRequest(url: WebUri(url)));
    }
  }

  Future<String> extractHtml() async {
    developer.log("EXTRACT HTML");
    if (_webViewController == null) {
      throw Exception('WebViewController not initialized.');
    }
    // wait for 10 seconds
    // await Future.delayed(const Duration(seconds: 10));
    if (Platform.isWindows) {
      return await _webViewController.executeScript('document.documentElement.outerHTML');
    } else if (Platform.isMacOS) {
      final result = await _webViewController.evaluateJavascript(source: 'document.documentElement.outerHTML');
      return result?.toString() ?? '';
    }
    return '';
  }

  Future<Map<String, String>> preProcessCrawl(String url) async {
    await loadUrl(url);
    String html = await extractHtml();
    String markdown = _convertHtmlToMarkdown(html);
    return {
      'html': html,
      'markdown': markdown,
    };
  }

  String _convertHtmlToMarkdown(String html) {
    return html2md.convert(html);
  }
}
