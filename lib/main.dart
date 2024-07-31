import 'package:flutter/material.dart';
import 'classes/websocket_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('HTML Extractor Manager'),
        ),
        body: const HtmlExtractorWidget(),
      ),
    );
  }
}

class HtmlExtractorWidget extends StatefulWidget {
  const HtmlExtractorWidget({super.key});

  @override
  HtmlExtractorWidgetState createState() => HtmlExtractorWidgetState();
}

class HtmlExtractorWidgetState extends State<HtmlExtractorWidget> {
  final WebSocketManager _webSocketManager = WebSocketManager();
  String? _htmlContent;
  String? _markdownContent;
  final String _socketMockUrl =
      'https://en.wikipedia.org/wiki/Wikipedia:How_to_create_a_page'; // socket mock url

  void _mockWebSocketMessage() async {
    Map<String, String> result =
        await _webSocketManager.mockWebSocketMessage(_socketMockUrl);
    setState(() {
      _htmlContent = result['html']!;
      _markdownContent = result['markdown']!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: _mockWebSocketMessage,
            child: const Text('Mock WebSocket Message'),
          ),
          const SizedBox(height: 16.0),
          if (_htmlContent != null) ...[
            const Text('HTML Content:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Text(_htmlContent!),
            const SizedBox(height: 16.0),
          ],
          if (_markdownContent != null) ...[
            const Text('Markdown Content:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Text(_markdownContent!),
            const SizedBox(height: 16.0),
          ],
        ],
      ),
    );
  }
}
