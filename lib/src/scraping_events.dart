import 'package:flutter_olostep/src/exceptions.dart';
import 'package:flutter_olostep/src/model/scrape_result.dart';

typedef OnScrapingResult = void Function(ScrapeResult result);
typedef OnScrapingException = void Function(ScrapingException error);
typedef OnStorageException = void Function(OlostepException error);
