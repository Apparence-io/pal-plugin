import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pal/src/database/adapter/helper_entity_adapter.dart'
    as HelperEntityAdapter;
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_group_entity.dart';
import 'package:pal/src/services/http_client/base_client.dart';

import '../base_repository.dart';
import 'package:pal/src/database/adapter/helper_group_entity_adapter.dart'
    as GroupEntityAdapter;

class EditorHelperGroupRepository extends BaseHttpRepository {
  final GroupEntityAdapter.HelperGroupEntityAdapter _groupAdapter =
      GroupEntityAdapter.HelperGroupEntityAdapter();
  final HelperEntityAdapter.HelperEntityAdapter _helperAdapter =
      HelperEntityAdapter.HelperEntityAdapter();

  EditorHelperGroupRepository({
    @required HttpClient httpClient,
  }) : super(httpClient: httpClient);

  Future<List<HelperGroupEntity>> listHelperGroups(String pageId) async {
    var response;
    try {
      response =
          await httpClient.get(Uri.parse('pal-business/editor/pages/$pageId/groups'));
      if (response == null || response.body == null)
        throw new UnknownHttpError("NO_RESULT");
    } catch (e) {
      throw new UnknownHttpError("NETWORK ERROR $e");
    }
    try {
      return _groupAdapter.parseArray(response.body);
    } catch (e) {
      throw "UNPARSABLE RESPONSE $e";
    }
  }

  Future<HelperGroupEntity> create(String pageId, String name, int minVersionId,
      int maxVersionId, String triggerType) async {
    var payload = jsonEncode({
      "name": name,
      "triggerType": triggerType,
      "versionMinId": minVersionId,
      "versionMaxId": maxVersionId,
    });
    var response = await httpClient
        .post(Uri.parse('pal-business/editor/pages/$pageId/groups'), body: payload);
    if (response == null || response.body == null)
      throw new UnknownHttpError("NO_RESULT");
    try {
      return _groupAdapter.parse(response.body);
    } catch (e) {
      throw "UNPARSABLE RESPONSE $e";
    }
  }

  Future<List<HelperEntity>> listGroupHelpers(String groupId) async {
    var response;
    try {
      response =
          await httpClient.get(Uri.parse('pal-business/editor/groups/$groupId/helpers'));
      if (response == null || response.body == null)
        throw new UnknownHttpError("NO_RESULT");
    } catch (e) {
      throw new UnknownHttpError("NETWORK ERROR $e");
    }
    try {
      return _helperAdapter.parseArray(response.body);
    } catch (e) {
      throw "UNPARSABLE RESPONSE $e";
    }
  }

  Future<HelperGroupEntity> getGroupDetails(String groupId) async {
    var response;
    try {
      response = await httpClient.get(Uri.parse('pal-business/editor/groups/$groupId'));
      if (response == null || response.body == null)
        throw new UnknownHttpError("NO_RESULT");
    } catch (e) {
      throw new UnknownHttpError("NETWORK ERROR $e");
    }
    try {
      return _groupAdapter.parse(response.body);
    } catch (e) {
      throw "UNPARSABLE RESPONSE $e";
    }
  }

  Future updateGroup(String id, int maxVersionId, int minVersionId, String name,
      String type) async {
    var response;
    try {
      response = await httpClient.put(Uri.parse('pal-business/editor/groups/$id'),
          body: jsonEncode({
            "versionMinId": minVersionId,
            "versionMaxId": maxVersionId,
            "triggerType": type,
            "name": name
          }));
      if (response == null || response.body == null)
        throw new UnknownHttpError("NO_RESULT");
    } catch (e) {
      throw new UnknownHttpError("NETWORK ERROR $e");
    }
    return;
  }

  Future deleteGroup(String groupId) async {
    try {
      return await httpClient.delete(Uri.parse('pal-business/editor/groups/$groupId'));
    } catch (e) {
      throw new UnknownHttpError("NETWORK ERROR $e");
    }
  }
}
