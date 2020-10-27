import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:palplugin/src/database/adapter/helper_entity_adapter.dart';
import 'package:palplugin/src/database/entity/helper/helper_entity.dart';
import 'package:palplugin/src/database/entity/pageable.dart';
import 'package:palplugin/src/database/repository/base_repository.dart';
import 'package:palplugin/src/services/http_client/base_client.dart';

class HelperRepository extends BaseHttpRepository {
  final HelperEntityAdapter _adapter = HelperEntityAdapter();

  HelperRepository({@required HttpClient httpClient})
      : super(httpClient: httpClient);

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

  Future clientTriggerHelper(final String pageId, final String helperId,
      final String inAppUserId, final bool positiveFeedback) async {
    this
        .httpClient
        .post('client/pages/$pageId/helpers/$helperId/triggered-helpers',
            body: jsonEncode({
              'positiveFeedback': positiveFeedback,
            }),
            headers: {"inAppUserId": inAppUserId}).then((value) {
      return;
    });
  }
}
