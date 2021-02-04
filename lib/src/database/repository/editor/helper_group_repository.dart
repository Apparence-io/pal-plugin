import 'package:flutter/material.dart';
import 'package:pal/src/database/entity/helper/helper_group_entity.dart';
import 'package:pal/src/services/http_client/base_client.dart';

import '../base_repository.dart';
import 'package:pal/src/database/adapter/helper_group_entity_adapter.dart' as EntityAdapter;

class EditorHelperGroupRepository extends BaseHttpRepository {

  final EntityAdapter.HelperGroupEntityAdapter _adapter = EntityAdapter
    .HelperGroupEntityAdapter();

  EditorHelperGroupRepository({
    @required HttpClient httpClient,
  }) : super(httpClient: httpClient);

  Future<List<HelperGroupEntity>> listHelperGroups({String routeName}) async {
    var response =  await httpClient.get('pal-business/editor/groups?routeName=$routeName');
    if (response == null || response.body == null)
      throw new UnknownHttpError("NO_RESULT");
    try {
      return _adapter.parseArray(response.body);
    } catch (e) {
      throw "UNPARSABLE RESPONSE $e";
    }
  }

  Future<HelperGroupEntity> create(String pageId, String name, int minVersionId, int maxVersionId) async {
    var response = await httpClient.post('pal-business/editor/pages/$pageId/groups',
      body: {
        "name": name,
        "minVersionId": minVersionId,
        "maxVersionId": maxVersionId,
      }
    );
    if (response == null || response.body == null)
      throw new UnknownHttpError("NO_RESULT");
    try {
      return _adapter.parse(response.body);
    } catch (e) {
      throw "UNPARSABLE RESPONSE $e";
    }
  }

}