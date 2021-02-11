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


  var _mock1 = '''[
      {"id":"JKLSDJDLS23", "priority":1, "name":"Group 01", "triggerType":"ON_SCREEN_VISIT", "creationDate":"2020-04-23T18:25:43.511Z", "minVersion":"1.0.1", "maxVersion": null},
      {"id":"JKLSDJDLS24", "priority":2, "name":"Group 02", "triggerType":"ON_NEW_UPDATE", "creationDate":"2020-14-23T18:25:43.511Z", "minVersion":"1.0.1", "maxVersion": null},
      {"id":"JKLSDJDLS25", "priority":3, "name":"Group 03", "triggerType":"ON_NEW_UPDATE", "creationDate":"2020-05-23T18:25:43.511Z", "minVersion":"1.0.1", "maxVersion": "1.0.2"},
      {"id":"JKLSDJDLS26", "priority":4, "name":"Group 04", "triggerType":"ON_NEW_UPDATE", "creationDate":"2020-06-23T18:25:43.511Z", "minVersion":"1.0.1", "maxVersion": "1.0.2"},
      {"id":"JKLSDJDLS27", "priority":5, "name":"Group 05", "triggerType":"ON_NEW_UPDATE", "creationDate":"2020-01-23T18:25:43.511Z", "minVersion":"1.0.1", "maxVersion": "1.0.2"},
      {"id":"JKLSDJDLS27", "priority":10, "name":"Group 08", "triggerType":"ON_NEW_UPDATE", "creationDate":"2020-01-23T18:25:43.511Z", "minVersion":"1.0.1", "maxVersion": "1.0.2"},
      {"id":"JKLSDJDLS27", "priority":11, "name":"Group 09", "triggerType":"ON_NEW_UPDATE", "creationDate":"2020-01-23T18:25:43.511Z", "minVersion":"1.0.1", "maxVersion": "1.0.2"},
      {"id":"JKLSDJDLS28", "priority":6, "name":"Group 06", "triggerType":"ON_SCREEN_VISIT", "creationDate":"2020-12-23T18:25:43.511Z", "minVersion":"1.0.1", "maxVersion": "1.0.2"}
    ]''';

  Future<List<HelperGroupEntity>> listHelperGroups({String routeName}) async {
    // return _adapter.parseArray(_mock1);
    var response;
    try {
      response =  await httpClient.get('pal-business/editor/groups?routeName=$routeName');
      if (response == null || response.body == null)
        throw new UnknownHttpError("NO_RESULT");
    } catch (e) {
      throw new UnknownHttpError("NETWORK ERROR $e");
    }
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