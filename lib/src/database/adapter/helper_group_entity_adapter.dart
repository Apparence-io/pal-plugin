import 'package:pal/src/database/adapter/helper_entity_adapter.dart';
import 'package:pal/src/database/adapter/page_entity_adapter.dart';
import 'package:pal/src/database/entity/helper/helper_group_entity.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';

import 'generic_adapter.dart';

class HelperGroupEntityAdapter extends GenericEntityAdapter<HelperGroupEntity> {

  @override
  HelperGroupEntity parseMap(Map<String, dynamic> map) {
    final HelperTriggerType helperTriggerType = map.containsKey('triggerType') 
      ? getHelperTriggerType(map['triggerType']) : null;
    return HelperGroupEntity(
      id: map['id'],
      name: map['name'],
      priority: map['priority'],
      creationDate: DateTime.parse(map['creationDate']).toLocal(),
      minVersion: map['minVersion'],
      triggerType: helperTriggerType,
      maxVersion:map.containsKey('maxVersion') ? map['maxVersion'] : null,
      helpers: map.containsKey('helpers') ? new HelperEntityAdapter().parseDynamicArray(map['helpers']) : null,
      page: map.containsKey('page') ? new PageEntityAdapter().parseMap(map['page']) : null,
    );
  }
}