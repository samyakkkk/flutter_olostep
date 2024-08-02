import 'dart:convert';
import 'dart:io';

import 'package:flutter_olostep/src/exceptions.dart';
import 'package:flutter_olostep/src/model/scrape_request.dart';
import 'package:flutter_olostep/src/model/scrape_result.dart';
import 'package:flutter_olostep/src/scraping_events.dart';
import 'package:flutter_olostep/src/services/s3_service.dart';
import 'package:flutter_olostep/src/webview/macos_webview_manager.dart';
import 'package:flutter_olostep/src/webview/webview_manager.dart';
import 'package:flutter_olostep/src/webview/windows_webview_manager.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Olostep {
  String _nodeId;
  Olostep(
    this._nodeId, {
    this.onScrapingResult,
    this.onScrapingException,
    this.onStorageException,
  });

  WebSocketChannel? _channel;
  final _storageService = S3Service();
  WebViewManager? _webViewManager;

  OnScrapingResult? onScrapingResult;
  OnScrapingException? onScrapingException;
  OnStorageException? onStorageException;

  Future<void> sendDemoRequest(ScrapeRequest request) async {
    // _runScrapeRequest(request);
    _onMessage(jsonEncode(request.toJson()));
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
  void _onMessage(dynamic message) async {
    try {
      final data = jsonDecode(message);
      final url = data['url'];
      if (url != null) {
        ScrapeRequest scrapeRequest = ScrapeRequest.fromJson(data);
        ScrapeResult scrapeResult = await _runScrapeRequest(scrapeRequest);
        _postScrapeRequest(scrapeResult);
      }
    } on ScrapingException catch (e) {
      onScrapingException?.call(e);
    } on StorageException catch (e) {
      onStorageException?.call(e);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<ScrapeResult> _runScrapeRequest(ScrapeRequest scrapeRequest) async {
    try {
      final waitTime = scrapeRequest.waitBeforeScraping;
      final url = scrapeRequest.url;
      final result = await _webViewManager!.crawl(url, waitTime: waitTime);
      ScrapeResult scrapeResult = ScrapeResult(
        recordID: scrapeRequest.recordID,
        html: result['html'],
        markdown: result['markdown'],
      );
      return scrapeResult;
    } catch (e) {
      throw ScrapingException(e);
    }
  }

  Future<void> _postScrapeRequest(ScrapeResult scrapeResult) async {
    try {
      final signedUrl =
          await _storageService.getSignedUrls(scrapeResult.recordID);
      final htmlRequest = _storageService.uploadHtml(
          signedUrl['uploadURL_html']!, scrapeResult.html);
      final markdownRequest = _storageService.uploadMarkdown(
        signedUrl['uploadURL_markDown']!,
        scrapeResult.markdown,
      );
      final List<Future> requests = [htmlRequest, markdownRequest];
      if (scrapeResult.screenshot != null) {
        final screenshotRequest = _storageService.uploadImage(
          signedUrl['uploadURL_screenshot']!,
          scrapeResult.screenshot!,
        );
        requests.add(screenshotRequest);
      }

      await Future.wait(requests);
    } catch (e) {
      throw StorageException(e);
    }
  }
}
