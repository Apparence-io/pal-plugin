import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pal/src/database/adapter/helper_entity_adapter.dart' as EntityAdapter;
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/pageable.dart';
import 'package:pal/src/database/repository/base_repository.dart';
import 'package:pal/src/services/http_client/base_client.dart';


class ClientHelperRepository extends BaseHttpRepository {

  final EntityAdapter.HelperEntityAdapter _adapter = EntityAdapter.HelperEntityAdapter();

  ClientHelperRepository({@required HttpClient httpClient})
      : super(httpClient: httpClient);

  Future<List<HelperEntity>> getAllHelpers({final int version}) {
    throw "not implemented yet";
  }

  Future<Pageable<HelperEntity>> getHelpers(
      final String pageId, final int page, final int pageSize) async {
    final Response response = await this
        .httpClient
        .get('editor/pages/$pageId/helpers?page=$page&pageSize=$pageSize');
    return this._adapter.parsePage(response.body);
  }

  Future<List<HelperEntity>> getClientHelpers(
      final String pageId, String version, String inAppUserId) async {
    final Response response = await this.httpClient.get(
        'client/pages/$pageId/helpers',
        headers: {"version": version, "inAppUserId": inAppUserId});
    return this._adapter.parseArray(response.body);
  }

}
