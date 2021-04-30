import 'dart:convert';

import 'package:http/http.dart';
import 'package:pal/src/database/adapter/page_entity_adapter.dart' as Adapter;
import 'package:pal/src/database/entity/page_entity.dart';
import 'package:pal/src/database/entity/pageable.dart';
import 'package:pal/src/database/repository/base_repository.dart';
import 'package:pal/src/services/http_client/base_client.dart';

class PageRepository extends BaseHttpRepository {

  final Adapter.PageEntityAdapter _adapter = Adapter.PageEntityAdapter();

  PageRepository({required HttpClient httpClient})
      : super(httpClient: httpClient);

  Future<PageEntity> createPage(
    final PageEntity createPage,
  ) async {
    final Response response = await httpClient
      .post(Uri.parse('pal-business/editor/pages'),
        body: jsonEncode({
          'route': createPage.route,
        }));
    return this._adapter.parse(response.body);
  }

  Future<Pageable<PageEntity>> getPages() async {
    final Response response = await httpClient.get(Uri.parse('pal-business/editor/pages'));
    return _adapter.parsePage(response.body);
  }

  Future<PageEntity?> getPage(final String route) {
    return this
        .httpClient
        .get(Uri.parse('pal-business/editor/pages?route=$route&pageSize=1'))
        .then((res) {
          if(res.body.isEmpty) {
            return null;
          }
          Pageable<PageEntity>? pages = _adapter.parsePage(res.body);
          return pages.entities!.first;
        });
  }

  Future<Pageable<PageEntity>> getClientPage(final String route) async {
    final Response response =
        await this.httpClient.get(Uri.parse('pal-business/client/pages?route=$route'));
    return this._adapter.parsePage(response.body);
  }
}
