import 'package:pal/src/database/adapter/helper_entity_adapter.dart';
import 'package:pal/src/database/adapter/page_entity_adapter.dart';
import 'package:pal/src/database/entity/helper/helper_group_entity.dart';

import 'generic_adapter.dart';

class HelperGroupEntityAdapter extends GenericEntityAdapter<HelperGroupEntity> {

  @override
  HelperGroupEntity parseMap(Map<String, dynamic> map) {
    return HelperGroupEntity(
      id: map['id'],
      priority: map['priority'],
      helpers: new HelperEntityAdapter().parseDynamicArray(map['helpers']),
      page: map.containsKey('page') ? new PageEntityAdapter().parseMap(map['page']) : null,
    );
  }
}