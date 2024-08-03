import 'dart:async';
import 'dart:ui';
import 'package:webview_windows/webview_windows.dart' as windows_webview;
import 'package:html2md/html2md.dart' as html2md;
import 'dart:developer' as developer;

import 'webview_manager.dart';

class WindowsWebViewManager extends WebViewManager {
  windows_webview.WebviewController? _webViewController;

  @override
  Future<void> initialize() async {
    developer.log("Initializing Windows WebView");
    _webViewController = windows_webview.WebviewController();
    await _webViewController!.initialize();
  }

  @override
  Future<Map<String, dynamic>> crawl(String url,
      {Size? screenshotSize, int? waitTime}) async {
    try {
      bool domContentLoaded = false;
      final loadingStateStream = _webViewController!.loadingState;
      loadingStateStream.listen((loadingState) {
        if (loadingState == windows_webview.LoadingState.navigationCompleted) {
          domContentLoaded = true;
        }
      });
      await _webViewController!.loadUrl(url);

      while (!domContentLoaded) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      await Future.delayed(Duration(milliseconds: waitTime ?? 0));

      // Now get the HTML content
      String html = await _webViewController!
          .executeScript('document.documentElement.outerHTML');
      String markdown = _convertHtmlToMarkdown(html);
      return {
        'html': html,
        'markdown': markdown,
      };
    } catch (e) {
      developer.log(e.toString());
      throw Exception('Error crawling webpage');
    }
  }

  String _convertHtmlToMarkdown(String html) {
    return html2md.convert(html);
  }

  @override
  Future<void> dispose() async {
    await _webViewController?.dispose();
    _webViewController = null;
  }
}
