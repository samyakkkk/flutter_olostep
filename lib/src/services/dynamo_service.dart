import 'dart:convert';

import 'package:http/http.dart' as http;

class UploadResult {
  final String recordID;
  final String url;
  final String orgId;

  UploadResult({
    required this.recordID,
    required this.url,
    required this.orgId,
  });
}

class DynamoService {
  static const String baseUrl =
      "https://zuaq4uywadlj75qqkfns3bmoom0xpaiz.lambda-url.us-east-1.on.aws/";

  Future<void> updateDynamo(UploadResult uploadResult) async {
    final bodyData = {
      "recordID": uploadResult.recordID,
      "url": uploadResult.url,
      "orgId": uploadResult.orgId,
    };

    final requestOptions = http.Request("POST", Uri.parse(baseUrl))
      ..headers["Content-Type"] = "text/plain"
      ..body = jsonEncode(bodyData);

    print("[updateDynamo]: Sending data to server =>");
    print(bodyData);

    try {
      final response = await http.Client().send(requestOptions);
      if (response.statusCode == 200) {
        final data = await response.stream.bytesToString();
        print("Response from server: $data");
      } else {
        throw Exception("Network response was not ok");
      }
    } catch (error) {
      throw Exception("Failed to report: $error");
    }
  }
}
