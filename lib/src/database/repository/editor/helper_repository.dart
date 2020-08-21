import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:palplugin/src/database/adapter/helper_entity_adapter.dart';
import 'package:palplugin/src/database/entity/create_helper_entity.dart';
import 'package:palplugin/src/database/entity/helper_entity.dart';
import 'package:palplugin/src/database/entity/pageable.dart';
import 'package:palplugin/src/database/repository/editor/base_repository.dart';
import 'package:palplugin/src/services/http_client/base_client.dart';

class HelperRepository extends BaseHttpRepository {
  final HelperEntityAdapter _adapter = HelperEntityAdapter();

  HelperRepository({@required HttpClient httpClient})
      : super(httpClient: httpClient);

  Future<HelperEntity> createHelper(final int versionId, final String pageId, final CreateHelperEntity createHelper) async {
    final Response response =
    await this.httpClient.post("/versions/$versionId/pages/$pageId/helpers", body: jsonEncode(createHelper));
    return this._adapter.parse(response.body);
  }

  Future<Pageable<HelperEntity>> getHelpers(final String route) async {
    final Response response =
        await this.httpClient.get("/pages/helpers?route=$route");
    return this._adapter.parsePage(response.body);
  }
}
