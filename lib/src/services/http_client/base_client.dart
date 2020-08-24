import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:palplugin/src/services/http_client/adapters/error_adapter.dart';

abstract class BaseHttpClient {}

/// use this Http client for every request on the app to be authenticated
/// intercept request and add user token if present
/// if token is expired calls refresh token endpoint and save new token
class HttpClient extends http.BaseClient implements BaseHttpClient {
  static const String BASE_URL = ""; //TODO add prod url
  final http.Client _client = new http.Client();
  final String _baseUrl;
  final String _token;

  factory HttpClient.create(final String token, {final baseUrl}) =>
      HttpClient._private(token, baseUrl: baseUrl);

  HttpClient._private(final String token, {final baseUrl})
      : assert(token != null && token != ""),
        this._baseUrl = baseUrl ?? BASE_URL,
        this._token = token;

  @override
  Future<http.StreamedResponse> send(final http.BaseRequest request) async {
    request.headers['Authorization'] = 'Bearer ${this._token}';
    return this._client.send(request);
  }

  Future<Response> _checkResponse(final Response response) async {
    if (response.statusCode >= 200 && response.statusCode < 300)
      return response;
    else if (response.statusCode >= 400 && response.statusCode < 500) {
      final String errorCode = ErrorAdapter().parse(response.body);

      throw UnreachableHttpError('Http 4XX error, network or bad gateway',
          code: errorCode);
    } else if (response.statusCode >= 500 && response.statusCode < 600) {
      print("... ==> 500 error ");
      throw InternalHttpError(
          'Http 500 error, internal error ${response.toString()}');
    } else {
      throw UnknownHttpError('e');
    }
  }

  @override
  Future<Response> post(final url,
      {Map<String, String> headers,
      final body,
      final Encoding encoding}) async {
    headers = _initHeader(headers);

    return this._checkResponse(await super.post('${this._baseUrl}/$url',
        headers: headers, body: body, encoding: encoding));
  }

  @override
  Future<Response> delete(final url,
      {final Map<String, String> headers}) async {
    return this._checkResponse(
        await super.delete('${this._baseUrl}/$url', headers: headers));
  }

  @override
  Future<Response> put(final url,
      {Map<String, String> headers,
      final body,
      final Encoding encoding}) async {
    headers = _initHeader(headers);

    return this._checkResponse(await super.put('${this._baseUrl}/$url',
        headers: headers, body: body, encoding: encoding));
  }

  Map<String, String> _initHeader(Map<String, String> headers) {
    if (headers == null || headers['Content-Type'] == null) {
      headers = new Map()
        ..putIfAbsent('Content-Type', () => 'application/json');
    } else if (headers['Content-Type'] == null) {
      headers = headers..putIfAbsent('Content-Type', () => 'application/json');
    }
    return headers;
  }

  @override
  Future<Response> get(final url, {final Map<String, String> headers}) async {
    return this._checkResponse(
        await super.get('${this._baseUrl}/$url', headers: headers));
  }
}

class InternalHttpError implements Exception {
  String message;

  InternalHttpError(this.message);

  String toString() {
    if (message == null) return "InternalHttpError";
    return "Exception: $message";
  }
}

class UnreachableHttpError implements Exception {
  String message;

  String code;

  UnreachableHttpError(this.message, {this.code});

  String toString() {
    if (message == null) return "UnreacheableHttpError";
    return "Exception: $message";
  }
}

class UnknownHttpError implements Exception {
  String message;

  UnknownHttpError(this.message);

  String toString() {
    if (message == null) return "UnknownHttpError";
    return "Exception: $message";
  }
}