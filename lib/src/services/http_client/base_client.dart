import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:pal/src/services/http_client/adapters/error_adapter.dart';

abstract class BaseHttpClient {}

/// use this Http client for every request on the app to be authenticated
/// intercept request and add user token if present
/// if token is expired calls refresh token endpoint and save new token
class HttpClient extends http.BaseClient implements BaseHttpClient {
  
  final http.Client _client;
  
  final String _baseUrl;
  
  final String _token;

  factory HttpClient.create(final String url, final String token) =>
      HttpClient.internal(url, token);

  @visibleForTesting
  HttpClient.internal(final String url, final String token, {http.Client? httpClient, bool testMode = false})
      : this._baseUrl = url,
        this._client = httpClient ?? new http.Client(),
        this._token = token {
    if(!testMode)  {
      assert(url.isNotEmpty);
      assert(token.isNotEmpty);
    }    
  }

  @override
  Future<http.StreamedResponse> send(final http.BaseRequest request) async {
    request.headers['Authorization'] = 'Bearer ${this._token}';
    return this._client.send(request);
  }

  Future<Response> _checkResponse(final Response response) async {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      String? errorCode;
      try {
        errorCode = ErrorAdapter().parse(response.body);
      } catch(_) {}
      throw UnreachableHttpError('Http ${response.statusCode} error, network or bad gateway : ${response.request?.url}',
          code: errorCode);
    } else if (response.statusCode >= 500 && response.statusCode < 600) {
      debugPrint("... ==> 500 error ${response.body}");
      throw InternalHttpError(
          'Http 500 error, internal error ${response.toString()}');
    } else {
      throw UnknownHttpError('e');
    }
  }

  @override
  Future<Response> post(final url,
      {Map<String, String>? headers,
      final body,
      final Encoding? encoding}) async {
    headers = _initHeader(headers);
    return this._checkResponse(
      await super.post(
        Uri.parse('${this._baseUrl}/$url'),
        headers: headers,
        body: body,
        encoding: encoding,
      ),
    );
  }

  @override
  Future<Response> delete(
    final Uri url, 
    { final Map<String, String>? headers,
      final body,
      final Encoding? encoding
    }
  ) async {
    return this._checkResponse(
        await super.delete(Uri.parse('${this._baseUrl}/$url'), headers: headers));
  }

  @override
  Future<Response> put(final url,
      {Map<String, String>? headers,
      final body,
      final Encoding? encoding}) async {
    headers = _initHeader(headers);
    var res = await super.put(Uri.parse('${this._baseUrl}/$url'),
      headers: headers, 
      body: body, 
      encoding: encoding);
    return this._checkResponse(res);
  }

  @override
  Future<Response> patch(final url,
      {Map<String, String>? headers,
      final body,
      final Encoding? encoding}) async {
    headers = _initHeader(headers);
    return this._checkResponse(await super.patch(Uri.parse('${this._baseUrl}/$url'),
        headers: headers, body: body, encoding: encoding));
  }

  Map<String, String> _initHeader(Map<String, String>? headers) {
    if (headers == null) {
      headers = new Map();
    }
    headers..putIfAbsent('Content-Type', () => 'application/json');

    return headers;
  }

  @override
  Future<Response> get(final url, {final Map<String, String?>? headers}) async {
    return this._checkResponse(
        await super.get(Uri.parse('${this._baseUrl}/$url'), headers: headers as Map<String, String>?));
  }

  Future<http.StreamedResponse> multipartImage(url,
      {Map<String, String>? fields,
      Map<String, String>? headers,
      required List<int> fileData,
      String? imageType,
      String? filename,
      required String fileFieldName,
      String httpMethod = "POST"}) async {
    var request = new http.MultipartRequest(
        httpMethod, Uri.parse('${this._baseUrl}/$url'));
    if (fields != null) {
      request.fields.addAll(fields);
    }
    if (headers != null) {
      request.headers.addAll(headers);
    }
    var multipartFile = http.MultipartFile.fromBytes(
      fileFieldName,
      fileData,
      filename: filename,
      contentType: MediaType.parse("image/$imageType"),
    );
    request.files.add(multipartFile);
    request.headers['Authorization'] = 'Bearer ${this._token}';
    return request.send();
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

  String? code;

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
