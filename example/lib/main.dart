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
  @override
  void initState() {
    // initWebViewManager();
    scrapper.startScraping();
    scrapper.onScrapingResult = (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Scraping result: ${result.recordID}'),
        ),
      );
    };
    scrapper.onScrapingException = (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Scraping error: ${error.message}'),
        ),
      );
    };
    scrapper.onStorageException = (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Storage error: $error'),
        ),
      );
    };
    super.initState();
  }

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
        ],
      ),
    );
  }
}
