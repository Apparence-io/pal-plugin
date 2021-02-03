import 'package:pal/src/database/adapter/helper_entity_adapter.dart';
import 'package:pal/src/database/adapter/page_entity_adapter.dart';
import 'package:pal/src/database/entity/helper/helper_group_entity.dart';

import 'generic_adapter.dart';

class HelperGroupEntityAdapter extends GenericEntityAdapter<HelperGroupEntity> {

  @override
  HelperGroupEntity parseMap(Map<String, dynamic> map) {
    return HelperGroupEntity(
      id: map['id'],
      name: map['name'],
      priority: map['priority'],
      helpers: map.containsKey('helpers') ? new HelperEntityAdapter().parseDynamicArray(map['helpers']) : null,
      page: map.containsKey('page') ? new PageEntityAdapter().parseMap(map['page']) : null,
    );
  }
}