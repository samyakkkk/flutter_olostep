import 'package:flutter/material.dart';
import 'package:flutter_olostep/flutter_olostep.dart';

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
  final FlutterOlostep olostep = FlutterOlostep("123");

  @override
  void initState() {
    // TODO: Enable after sucessfull test requests.
    olostep.startCrawling();

    olostep.onScrapingResult = (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Scraping result: ${result.recordID}'),
        ),
      );
    };
    olostep.onScrapingException = (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Scraping error: ${error.message}'),
        ),
      );
    };
    olostep.onStorageException = (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Storage error: $error'),
        ),
      );
    };

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                olostep.testCrawl(
                  ScrapeRequest(
                    recordID: '005ie7h3w5',
                    url: 'https://www.olostep.com/',
                    waitBeforeScraping: 1,
                    saveHtml: true,
                    saveMarkdown: true,
                    htmlVisualizer: true,
                    orgId: 'podqi',
                    htmlTransformer: 'none',
                  ),
                );
              },
              child: const Text('Demo request'),
            ),
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
