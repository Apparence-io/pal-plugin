import 'package:pal/src/database/entity/version_entity.dart';

import 'generic_adapter.dart';

class VersionEntityAdapter extends GenericEntityAdapter<VersionEntity> {
  @override
  VersionEntity parseMap(Map<String, dynamic>? map) {
    return VersionEntity(
      id: map!['id'],
      name: map['name']
    );
  }
}