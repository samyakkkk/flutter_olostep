import 'dart:io';
import 'dart:typed_data';

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
  // late final WebViewManager _webViewManager;
  // String? _htmlContent;
  // String? _markdownContent;
  // Uint8List? _imageContent;
  // final String _webUrl = 'https://www.olostep.com'; // socket mock url

  @override
  void initState() {
    // initWebViewManager();
    scrapper.startScraping();
    super.initState();
  }

  // Future<void> initWebViewManager() async {
  //   final storageService = S3Service();
  //   _webViewManager = Platform.isWindows
  //       ? WindowsWebViewManager()
  //       : Platform.isMacOS
  //           ? MacOSWebViewManager()
  //           : throw Exception(
  //               'Only Macos and Windows Platforms are supported.');
  //   await _webViewManager.initialize();
  // }

  // void _crawlWebPage() async {
  //   print('Crawling webpage... $_webUrl');
  //   Map<String, dynamic> result = await _webViewManager.crawl(_webUrl,
  //       screenshotSize: const Size(1024, 1024));
  //   setState(() {
  //     _htmlContent = result['html']!;
  //     _markdownContent = result['markdown']!;
  //     _imageContent = result['screenshot'];
  //   });
  // }

  final Olostep scrapper = Olostep("123");
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
                scrapper.sendDemoRequest(
                  ScrapeRequest(
                    recordID: '005ie7h3w5',
                    url:
                        'https://www.revolve.com/free-people-x-we-the-free-ziggy-denim-overal-in-parchment/dp/FREE-WC151/?d=Womens&page=1&lc=1&plpSrc=/r/Brands.jsp?aliasURL%3Ddenim-overalls/br/5aa7c6%26sc%3DOveralls%26s%3Dc%26c%3DDenim%26searchsynonym%3Dcream+overalls%26color%3Dwhite%26filters%3Dcolor%26lazyLoadedPlp%3Dtrue%26sortBy%3Dfeatured&itrownum=1&itcurrpage=1&itview=05',
                    waitBeforeScraping: 1000,
                  ),
                );
              },
              child: const Text('Demo request'),
            ),
          ),
          const SizedBox(height: 16.0),
          // if (_imageContent != null) ...[
          //   const Text('Image:', style: TextStyle(fontWeight: FontWeight.bold)),
          //   const SizedBox(height: 8.0),
          //   Image.memory(_imageContent!),
          //   const SizedBox(height: 16.0),
          // ],
          // if (_htmlContent != null) ...[
          //   const Text('HTML:', style: TextStyle(fontWeight: FontWeight.bold)),
          //   const SizedBox(height: 8.0),
          //   Text(_htmlContent!),
          //   const SizedBox(height: 16.0),
          // ],
          // if (_markdownContent != null) ...[
          //   const Text('Markdown:',
          //       style: TextStyle(fontWeight: FontWeight.bold)),
          //   const SizedBox(height: 8.0),
          //   Text(_markdownContent!),
          //   const SizedBox(height: 16.0),
          // ],
        ],
      ),
    );
  }
}
