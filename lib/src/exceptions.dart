abstract class OlostepException implements Exception {
  final Object message;

  OlostepException(this.message);

  @override
  String toString() => 'OlostepException: $message';
}

class ScrapingException extends OlostepException {
  ScrapingException(super.message);
}

class StorageException extends OlostepException {
  StorageException(super.message);
}
