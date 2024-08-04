import 'dart:ui';

class ScrapeRequest {
  final String url;
  final int waitBeforeScraping;
  final bool? htmlVisualizer;
  final Size? windowSize;
  final String recordID;
  final bool saveHtml;
  final bool saveMarkdown;
  final String htmlTransformer;
  final String orgId;

  ScrapeRequest({
    required this.url,
    this.waitBeforeScraping = 0,
    this.htmlVisualizer,
    this.windowSize,
    required this.recordID,
    this.saveHtml = true,
    this.saveMarkdown = true,
    this.htmlTransformer = 'none',
    required this.orgId,
  });

  // Factory constructor to create a ScrapeRequest from a JSON map
  factory ScrapeRequest.fromJson(Map<String, dynamic> json) {
    return ScrapeRequest(
      url: json['url'] as String,
      orgId: json['orgId'] as String,
      waitBeforeScraping: json['waitBeforeScraping'] as int,
      htmlVisualizer: json['htmlVisualizer'] as bool?,
      // TODO: convert windowSize to Size then uncomment below
      // windowSize: json['windowSize'] as String?,
      recordID: json['recordID'] as String,
      saveHtml: json['saveHtml'] as bool? ?? true,
      saveMarkdown: json['saveMarkdown'] as bool? ?? true,
      htmlTransformer: json['htmlTransformer'] as String? ?? 'none',
    );
  }

  // Convert the ScrapeRequest to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'waitBeforeScraping': waitBeforeScraping,
      'htmlVisualizer': htmlVisualizer,
      'windowSize': windowSize,
      'recordID': recordID,
      'saveHtml': saveHtml,
      'saveMarkdown': saveMarkdown,
      'htmlTransformer': htmlTransformer,
      'orgId': orgId,
    };
  }

  @override
  String toString() {
    return 'ScrapeRequest(url: $url, waitBeforeScraping: $waitBeforeScraping, htmlVisualizer: $htmlVisualizer, windowSize: $windowSize, recordID: $recordID)';
  }
}
