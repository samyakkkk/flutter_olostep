import 'dart:async';
import 'dart:ui';

abstract class WebViewManager {
  Future<void> initialize();
  Future<Map<String, dynamic>> crawl(String url,
      {Size? screenshotSize, int? waitTime});
  Future<void> dispose();
}
