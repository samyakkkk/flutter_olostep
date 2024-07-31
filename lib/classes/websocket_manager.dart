import 'package:flutter_olostep/classes/webview_manager.dart';

class WebSocketManager {
  Future<Map<String, String>> mockWebSocketMessage(String url) async {
    final webViewManager = WebViewManager();
    await webViewManager.initialize();
    return await webViewManager.preProcessCrawl(url);
  }
}
