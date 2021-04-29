import 'package:pal/src/database/adapter/helper_group_entity_adapter.dart';
import 'package:pal/src/database/entity/helper/schema_entity.dart';

import 'generic_adapter.dart';

class SchemaEntityAdapter extends GenericEntityAdapter<SchemaEntity> {

  @override
  SchemaEntity parseMap(Map<String, dynamic>? map) {
    return SchemaEntity(
      projectId: map!['projectId'],
      groups: new HelperGroupEntityAdapter().parseDynamicArray(map['groups']),
      schemaVersion: map['schemaVersion'],
    );
  }
}