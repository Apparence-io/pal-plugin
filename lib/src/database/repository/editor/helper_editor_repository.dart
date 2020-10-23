import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:palplugin/src/database/adapter/helper_entity_adapter.dart';
import 'package:palplugin/src/database/entity/helper/helper_entity.dart';
import 'package:palplugin/src/database/entity/pageable.dart';
import 'package:palplugin/src/database/repository/base_repository.dart';
import 'package:palplugin/src/services/http_client/base_client.dart';

class EditorHelperRepository extends BaseHttpRepository {
  final HelperEntityAdapter _adapter = HelperEntityAdapter();

  EditorHelperRepository({
    @required HttpClient httpClient,
  }) : super(httpClient: httpClient);

  Future<HelperEntity> createHelper(
      final String pageId, final HelperEntity createHelper) async {
    final Response response = await this
        .httpClient
        .post('editor/pages/$pageId/helpers', body: jsonEncode(createHelper));
    if (response == null || response.body == null)
      throw new UnknownHttpError("NO_RESULT");
    return this._adapter.parse(response.body);
  }

  Future<Pageable<HelperEntity>> getPage(
      String pageId, int page, int pageSize) async {
    final Response response = await this
        .httpClient
        .get('editor/pages/$pageId/helpers?page=$page&pageSize=$pageSize');
    return this._adapter.parsePage(response.body);
  }

  Future<void> updateHelperPriority(
    final String pageId,
    final Map<String, int> priority,
  ) async {
     await this.httpClient.patch(
           'editor/pages/$pageId/helpers/priorities',
           body: jsonEncode(priority),
         );
  }
}
