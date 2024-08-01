import 'dart:convert';
import 'dart:io';

import 'package:flutter_olostep/model/scrape_request.dart';
import 'package:flutter_olostep/model/scrape_result.dart';
import 'package:flutter_olostep/services/s3_service.dart';
import 'package:flutter_olostep/webview/macos_webview_manager.dart';
import 'package:flutter_olostep/webview/webview_manager.dart';
import 'package:flutter_olostep/webview/windows_webview_manager.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Scrapper {
  WebSocketChannel? _channel;
  final storageService = S3Service();
  WebViewManager? webViewManager;

  Future<void> sendDemoRequest() async {
    final scrapeRequest = ScrapeRequest(
      recordID: '005ie7h3w5',
      url: 'https://en.wikipedia.org/wiki/Kaiser_Permanente',
      waitBeforeScraping: 1000,
    );
    _runScrapeRequest(scrapeRequest);
  }

  Future<void> startScraping() async {
    webViewManager = Platform.isWindows
        ? WindowsWebViewManager()
        : Platform.isMacOS
            ? MacOSWebViewManager()
            : throw Exception(
                'Only Macos and Windows Platforms are supported.');
    await webViewManager!.initialize();
    _startListening();
  }

  Future<void> _startListening() async {
    // TODO: Replace this with a random generated node_id
    final _nodeId = "232";

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
    final result = await webViewManager!.crawl(url, waitTime: waitTime);
    ScrapeResult scrapeResult = ScrapeResult(
      recordID: scrapeRequest.recordID,
      html: result['html'],
      markdown: result['markdown'],
    );
    _postScrapeRequest(scrapeResult);
  }

  Future<void> _postScrapeRequest(ScrapeResult scrapeResult) async {
    final signedUrl =
        await storageService!.getSignedUrls(scrapeResult.recordID);
    final htmlRequest = storageService!
        .uploadHtml(signedUrl['uploadURL_html']!, scrapeResult.html);
    final markdownRequest = storageService!.uploadMarkdown(
      signedUrl['uploadURL_markDown']!,
      scrapeResult.markdown,
    );
    await Future.wait([htmlRequest, markdownRequest]);
  }
}
