import 'package:flutter_olostep/src/services/s3_service.dart';
import 'package:test/test.dart';

main() {
  final url =
      'https://olostep-p2p-html.s3.amazonaws.com/text_005ie7h3w5.txt?AWSAccessKeyId=ASIAWPDNREIEGPHWGWL4&Content-Type=text%2Fhtml&Expires=1722665386&Signature=wvBcfHyDiyeMcGy3%2FhrvXmAk4vg%3D&X-Amzn-Trace-Id=Root%3D1-66adc87e-6e4806b644bc7310388c83b3%3BParent%3D373ac7a701168aa8%3BSampled%3D0%3BLineage%3D2a3aeaba%3A0&x-amz-acl=public-read&x-amz-security-token=IQoJb3JpZ2luX2VjELf%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLWVhc3QtMSJGMEQCH0DON38avGNpPHMGnIiKZRd3wMr8CafXffPI8XWE7cYCIQDIQVhiAP1Peicq8MkEssCWZdlw%2FWvPWBPV3Qro72i7TiqmAwif%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F8BEAMaDDQ0NDc1ODgyNzUyOCIMvEGbXki0%2B9hJL2COKvoCAouKaXtfyxY6d8tUL%2FKT2cDqLU9ujNeV0Pc9x9ifoDmdsZb3g9Eq3oHSToQSzrfiEi3mxHMJGrN5e4CIs09tMa%2F46Ti1es6b6fywdveLlTi0pPzUUaiU7tBgHa4yYa5tWpqR60MfKLI26ibQTMnaTmungdu0Yg197bcF%2B3we6PPvZzc3Sa6n148O3ZEtMEurMTQ46nK96d1wE1nsfWF0rbpuQu2O9MOg4dmn8bFEPS70ZLn86md1HvxHa0M6MYAbkaM%2BjRoJ936BsaQDae294IMoUpVGsfEaxayJRvPeQtLLRh%2Frc7BaP378JV0jIjmFz5LynBN%2BJnhJc95impjPHxi6XzArkGcq9UDflSliLV72nZbcMBrU0hIJgJWs36c5DI36cLdBCtObyIUOB61UF%2FuDTSHMDTDEApsAGIhhx%2FZQ4iWk6Pd9B7W4%2F6nSw8juD7E3ajV02nGUhmmj%2BUhPDyg4Jf7VG%2BItSR5KsWQo0mVpGZIb6727NJcrMP6Qt7UGOp4B8nGPwe6O448vgHU9e4DND%2BM4VEGeC%2FXCtOBAoj%2BpTyMtXjXqH6NJMQwgN%2BqI6u8hWtBatsnAaIhuBazg4zCBttEwT%2FnyWX5M9mi1DieHoH6S9u8J7nuY3DdxSnu8OLu7DGvM6WJo2jrymKTr0c6MJTsDDGcWwRs9IczDoHJC2tXvmFf75bHCnl6kx6iP9xiW%2FB5jWK8EiYb%2BrNvotWo%3D';

  test('s3 verify', () async {
    final s3 = S3Service();
    await s3.uploadHtml(url, '<html></html>');
  });
}
