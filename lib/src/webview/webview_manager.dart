import 'dart:async';

import 'package:flutter_olostep/flutter_olostep.dart';

abstract class WebViewManager {
  Future<void> initialize();
  Future<Map<String, dynamic>> crawl(ScrapeRequest request);
  Future<void> dispose();
}
