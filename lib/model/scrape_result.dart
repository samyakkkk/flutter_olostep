class ScrapeResult {
  final String html;
  final String markdown;
  final String recordID;

  ScrapeResult({
    required this.recordID,
    required this.html,
    required this.markdown,
  });

  factory ScrapeResult.fromJson(Map<String, dynamic> json) {
    return ScrapeResult(
      recordID: json['recordID'] as String,
      html: json['html'] as String,
      markdown: json['markdown'] as String,
    );
  }
}
