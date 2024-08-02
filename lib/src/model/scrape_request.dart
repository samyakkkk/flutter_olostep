class ScrapeRequest {
  final String url;
  final int waitBeforeScraping;
  final String? htmlVisualizer;
  final String? windowSize;
  final String recordID;

  ScrapeRequest({
    required this.url,
    required this.waitBeforeScraping,
      this.htmlVisualizer,
    this.windowSize,
    required this.recordID,
  });

  // Factory constructor to create a ScrapeRequest from a JSON map
  factory ScrapeRequest.fromJson(Map<String, dynamic> json) {
    return ScrapeRequest(
      url: json['url'] as String,
      waitBeforeScraping: json['waitBeforeScraping'] as int,
      htmlVisualizer: json['htmlVisualizer'] as String,
      windowSize: json['windowSize'] as String,
      recordID: json['recordID'] as String,
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
    };
  }

  @override
  String toString() {
    return 'ScrapeRequest(url: $url, waitBeforeScraping: $waitBeforeScraping, htmlVisualizer: $htmlVisualizer, windowSize: $windowSize, recordID: $recordID)';
  }
}
