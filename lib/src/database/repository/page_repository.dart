import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:palplugin/src/database/adapter/page_entity_adapter.dart';
import 'package:palplugin/src/database/entity/page_entity.dart';
import 'package:palplugin/src/database/entity/pageable.dart';
import 'package:palplugin/src/database/repository/base_repository.dart';
import 'package:palplugin/src/services/http_client/base_client.dart';

class PageRepository extends BaseHttpRepository {
  final PageEntityAdapter _adapter = PageEntityAdapter();

  PageRepository({@required HttpClient httpClient})
      : super(httpClient: httpClient);

  Future<PageEntity> createPage(
    final PageEntity createPage,
  ) async {
    final Response response = await this.httpClient.post('editor/pages',
        body: jsonEncode({
          'route': createPage.route,
        }));
    return this._adapter.parse(response.body);
  }

  Future<Pageable<PageEntity>> getPages() async {
    final Response response = await this.httpClient.get('editor/pages');
    return this._adapter.parsePage(response.body);
  }

  Future<PageEntity> getPage(final String route) {
    return this
        .httpClient
        .get('editor/pages?route=$route&pageSize=1')
        .then((res) {
      Pageable<PageEntity> pages = _adapter.parsePage(res.body);
      return (pages.entities != null && pages.entities.length > 0)
          ? pages.entities.first
          : null;
    });
  }

  Future<Pageable<PageEntity>> getClientPage(final String route) async {
    final Response response =
        await this.httpClient.get('client/pages?route=$route');
    return this._adapter.parsePage(response.body);
  }
}
