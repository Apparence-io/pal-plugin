import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pal/src/database/adapter/helper_entity_adapter.dart' as EntityAdapter;
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/pageable.dart';
import 'package:pal/src/database/repository/base_repository.dart';
import 'package:pal/src/services/http_client/base_client.dart';

class EditorHelperRepository extends BaseHttpRepository {

  final EntityAdapter.HelperEntityAdapter _adapter = EntityAdapter.HelperEntityAdapter();

  EditorHelperRepository({
    @required HttpClient httpClient,
  }) : super(httpClient: httpClient);

  Future<HelperEntity> createHelper(
      final String pageId, final HelperEntity createHelper) async {
    final payload = jsonEncode(createHelper);
    final Response response = await this.httpClient.post(
          'editor/pages/$pageId/helpers',
          body: payload,
        );
    if (response == null || response.body == null)
      throw new UnknownHttpError("NO_RESULT");
    return this._adapter.parse(response.body);
  }

  Future<HelperEntity> updateHelper(
    final String pageId,
    final HelperEntity updatedHelper,
  ) async {
    final payload = jsonEncode(updatedHelper);
    final Response response = await this.httpClient.put(
          'editor/pages/$pageId/helpers/${updatedHelper?.id}',
          body: payload);
    if (response == null || response.body == null)
      throw new UnknownHttpError('NO_RESULT');
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

  Future<void> deleteHelper(
    final String pageId,
    final String helperId,
  ) async {
    await this.httpClient.delete(
          'editor/pages/$pageId/helpers/$helperId',
        );
  }
}
