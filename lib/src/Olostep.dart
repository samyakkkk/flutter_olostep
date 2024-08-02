import 'dart:convert';
import 'dart:io';

import 'package:flutter_olostep/src/model/scrape_request.dart';
import 'package:flutter_olostep/src/model/scrape_result.dart';
import 'package:flutter_olostep/src/services/s3_service.dart';
import 'package:flutter_olostep/src/webview/macos_webview_manager.dart';
import 'package:flutter_olostep/src/webview/webview_manager.dart';
import 'package:flutter_olostep/src/webview/windows_webview_manager.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Olostep {
  String _nodeId;
  Olostep(this._nodeId);
  WebSocketChannel? _channel;
  final _storageService = S3Service();
  WebViewManager? _webViewManager;

  Future<void> sendDemoRequest(ScrapeRequest request) async {
    _runScrapeRequest(request);
  }

  Future<void> startScraping() async {
    _webViewManager = Platform.isWindows
        ? WindowsWebViewManager()
        : Platform.isMacOS
            ? MacOSWebViewManager()
            : throw Exception(
                'Only Macos and Windows Platforms are supported.');
    await _webViewManager!.initialize();
    _startListening();
  }

  Future<void> _startListening() async {
    final url =
        'wss://7joy2r59rf.execute-api.us-east-1.amazonaws.com/production/?node_id=$_nodeId';
    _channel = WebSocketChannel.connect(Uri.parse(url));

    _channel!.stream.listen((message) {
      _onMessage(message);
    });
  }

  // Handle incoming messages
  void _onMessage(dynamic message) {
    final data = jsonDecode(message);
    final url = data['url'];
    if (url != null) {
      ScrapeRequest scrapeRequest = ScrapeRequest.fromJson(data);
      _runScrapeRequest(scrapeRequest);
    }
  }

  Future<void> _runScrapeRequest(ScrapeRequest scrapeRequest) async {
    final waitTime = scrapeRequest.waitBeforeScraping;
    final url = scrapeRequest.url;
    final result = await _webViewManager!.crawl(url, waitTime: waitTime);
    ScrapeResult scrapeResult = ScrapeResult(
      recordID: scrapeRequest.recordID,
      html: result['html'],
      markdown: result['markdown'],
    );
    _postScrapeRequest(scrapeResult);
  }

  Future<void> _postScrapeRequest(ScrapeResult scrapeResult) async {
    final signedUrl =
        await _storageService.getSignedUrls(scrapeResult.recordID);
    final htmlRequest = _storageService.uploadHtml(
        signedUrl['uploadURL_html']!, scrapeResult.html);
    final markdownRequest = _storageService.uploadMarkdown(
      signedUrl['uploadURL_markDown']!,
      scrapeResult.markdown,
    );
    await Future.wait([htmlRequest, markdownRequest]);
  }
}
