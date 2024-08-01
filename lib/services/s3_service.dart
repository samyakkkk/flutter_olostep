import 'dart:convert';
import 'package:http/http.dart' as http;
import 'storage_service.dart';

class S3Service implements StorageService {
  // TODO: Should come from constants file
  final String _getS3SignedUrlsUrl =
      'https://5xub3rkd3rqg6ebumgrvkjrm6u0jgqnw.lambda-url.us-east-1.on.aws/';

  @override
  Future<Map<String, String>> getSignedUrls(String recordID) async {
    final response =
        await http.get(Uri.parse('$_getS3SignedUrlsUrl?recordID=$recordID'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return {
        'uploadURL_htmlVisualizer': data['uploadURL_htmlVisualizer'] as String,
        'uploadURL_html': data['uploadURL_html'] as String,
        'uploadURL_markDown': data['uploadURL_markDown'] as String,
      };
    } else {
      throw Exception('Failed to fetch signed URLs');
    }
  }

  @override
  Future<void> uploadHtml(String htmlUrlSigned, String content) async {
    print('Uploading HTML to $htmlUrlSigned');
    print('Content: $content');
    final response = await http.put(
      Uri.parse(htmlUrlSigned),
      headers: {
        'Content-Type': 'text/html',
        'x-amz-acl': 'public-read',
      },
      body: content,
    );
    print(response.statusCode);
    if (response.statusCode != 200) {
      throw Exception('Failed to upload HTML');
    }
  }

  @override
  Future<void> uploadMarkdown(String markdownUrlSigned, String content) async {
    final response = await http.put(
      Uri.parse(markdownUrlSigned),
      headers: {
        'Content-Type': 'text/markdown',
        'x-amz-acl': 'public-read',
      },
      body: content,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to upload Markdown');
    }
  }

  @override
  Future<void> uploadImage(String imageUrlSigned, String base64Image) async {
    final byteData = base64Decode(base64Image.split(',')[1]);
    final response = await http.put(
      Uri.parse(imageUrlSigned),
      headers: {
        'Content-Type': 'image/png',
        'Content-Encoding': 'base64',
        'x-amz-acl': 'public-read',
      },
      body: byteData,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to upload image');
    }
  }
}
