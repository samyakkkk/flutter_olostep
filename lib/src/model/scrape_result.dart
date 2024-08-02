import 'dart:typed_data';

class ScrapeResult {
  final String html;
  final String markdown;
  final String recordID;
  final Uint8List? screenshot;

  ScrapeResult({
    required this.recordID,
    required this.html,
    required this.markdown,
    this.screenshot,
  });

  factory ScrapeResult.fromJson(Map<String, dynamic> json) {
    return ScrapeResult(
      recordID: json['recordID'] as String,
      html: json['html'] as String,
      markdown: json['markdown'] as String,
      screenshot: json['screenshot'] as Uint8List?,
    );
  }
}
