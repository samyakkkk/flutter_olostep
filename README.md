# FlutterOlostep

`FlutterOlostep` is a Dart package designed to manage and automate web scraping tasks on desktop platforms. It provides a simple interface to initiate scraping, handle the results, and manage errors gracefully.

## Features

- **Easy Integration**: Quickly integrate web scraping capabilities into your Flutter app.
- **Customizable Callbacks**: Easily handle results and errors with user-defined callbacks.
- **Automated Storage**: Automatically upload scrape results to a cloud storage service.

## Installation

Add `flutter_olostep` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_olostep: ^1.0.0
```

Run `flutter pub get` to install the package.

## Usage

### 1. Initialize `FlutterOlostep`

Start by creating an instance of `FlutterOlostep` with your unique node ID. You can also define optional callbacks to handle results and exceptions.

```dart
import 'package:flutter_olostep/flutter_olostep.dart';

final flutterOlostep = FlutterOlostep(
  'your_node_id',
  onScrapingResult: (result) {
    // Handle scraping results
  },
  onScrapingException: (exception) {
    // Handle scraping exceptions
  },
  onStorageException: (exception) {
    // Handle storage exceptions
  },
);
```

### 2. Start the Scraping Process

Use the `startCrawling()` method to initiate the scraping process.

```dart
await flutterOlostep.startCrawling();
```

### 3. Test a Scrape Request

You can test the scraping functionality with a specific request using the `testCrawl()` method.

```dart
final request = ScrapeRequest(
  recordID: 'example_record_id',
  url: 'https://example.com',
  // Additional parameters can be added here
);

await flutterOlostep.testCrawl(request);
```

### 4. Stop the Scraping Process

To terminate the scraping process, call the `stopCrawling()` method.

```dart
await flutterOlostep.stopCrawling();
```

## Callbacks

- **onScrapingResult**: Triggered when a scraping task is completed successfully.
- **onScrapingException**: Triggered if an error occurs during the scraping process.
- **onStorageException**: Triggered if an error occurs while storing the scraping results.

## Platform Support

This package supports macos and windows platforms. Mobile platforms are not supported.