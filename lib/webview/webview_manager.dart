import 'dart:async';

abstract class WebViewManager {
  Future<void> initialize();
  Future<Map<String, String>> crawl(String url);
}
