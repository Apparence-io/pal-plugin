import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';
import 'package:pal/src/services/http_client/base_client.dart';


class MockHttpClient extends Mock implements http.Client {}


void main() {
  group('HttpClient tests with token', () {
    var httpMockClient = new MockHttpClient();

    var baseUrl = 'baseUrl';
    HttpClient httpClient = new HttpClient.internal(
      '$baseUrl',
      'JLKJDLSJDLKSJDLSD',
      httpClient: httpMockClient,
    );

    setUp(() {
      reset(httpMockClient);
    });

    testWidgets('GET, returning code 200 => sends request with token on correct url', (WidgetTester tester) async {
      await tester.runAsync(() async {
        when(httpMockClient.send(any)).thenAnswer((_) => new Future<http.StreamedResponse>(
            () => new http.StreamedResponse(new Stream.fromFuture(Future<List<int>>(() => new List())), 200))
        );
        var res = await httpClient.get('test');
        expect(true, res != null);
        expect(res.statusCode, 200);

        var capturedCall = verify(httpMockClient.send(captureAny)).captured;
        expect(capturedCall[0].url.toString(), equals('$baseUrl/test'));
        expect(capturedCall[0].headers['Authorization'], equals('Bearer JLKJDLSJDLKSJDLSD'));
      });
    });

    testWidgets('POST, returning code 200 => sends request with token on correct url', (WidgetTester tester) async {
      await tester.runAsync(() async {
        when(httpMockClient.send(any)).thenAnswer((_) => new Future<http.StreamedResponse>(
            () => new http.StreamedResponse(new Stream.fromFuture(Future<List<int>>(() => new List())), 200))
        );
        var res = await httpClient.post('test');
        expect(true, res != null);
        expect(res.statusCode, 200);

        var capturedCall = verify(httpMockClient.send(captureAny)).captured;
        expect(capturedCall[0].url.toString(), equals('$baseUrl/test'));
        expect(capturedCall[0].headers['Authorization'], equals('Bearer JLKJDLSJDLKSJDLSD'));
      });
    });

    testWidgets('PUT, returning code 200 => sends request with token on correct url', (WidgetTester tester) async {
      await tester.runAsync(() async {
        when(httpMockClient.send(any)).thenAnswer((_) => new Future<http.StreamedResponse>(
            () => new http.StreamedResponse(new Stream.fromFuture(Future<List<int>>(() => new List())), 200))
        );
        var res = await httpClient.put('test');
        expect(true, res != null);
        expect(res.statusCode, 200);

        var capturedCall = verify(httpMockClient.send(captureAny)).captured;
        expect(capturedCall[0].url.toString(), equals('$baseUrl/test'));
        expect(capturedCall[0].headers['Authorization'], equals('Bearer JLKJDLSJDLKSJDLSD'));
      });
    });

    testWidgets('DELETE, returning code 200 => sends request with token on correct url', (WidgetTester tester) async {
      await tester.runAsync(() async {
        when(httpMockClient.send(any)).thenAnswer((_) => new Future<http.StreamedResponse>(
            () => new http.StreamedResponse(new Stream.fromFuture(Future<List<int>>(() => new List())), 200))
        );
        var res = await httpClient.delete('test');
        expect(true, res != null);
        expect(res.statusCode, 200);

        var capturedCall = verify(httpMockClient.send(captureAny)).captured;
        expect(capturedCall[0].url.toString(), equals('$baseUrl/test'));
        expect(capturedCall[0].headers['Authorization'], equals('Bearer JLKJDLSJDLKSJDLSD'));
      });
    });

    testWidgets('http 500 should throw InternalHttpError', (WidgetTester tester) async {
      await tester.runAsync(() async {
        when(httpMockClient.send(any)).thenAnswer((_) => new Future<http.StreamedResponse>(
            () => new http.StreamedResponse(new Stream.fromFuture(Future<List<int>>(() => new List())), 500))
        );
        try {
          await httpClient.get('test');
          expect(false, true);
        } catch(e) {
          expect(e is InternalHttpError, equals(true), reason: 'e is InternalHttpError');
        }
      });
    });

    testWidgets('http 400 should throw UnreacheableHttpError', (WidgetTester tester) async {
      await tester.runAsync(() async {
        when(httpMockClient.send(any)).thenAnswer((_) => new Future<http.StreamedResponse>(
            () => new http.StreamedResponse(new Stream.fromFuture(Future<List<int>>(() => new List())), 400))
        );
        try {
          await httpClient.get('test');
          expect(false, true);
        } catch(e) {
          expect(e is UnreachableHttpError, isTrue, reason: 'e is UnreachableHttpError');
        }
      });
    });

  });


}
