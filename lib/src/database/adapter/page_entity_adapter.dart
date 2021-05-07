import 'package:pal/src/database/adapter/generic_adapter.dart';
import 'package:pal/src/database/entity/page_entity.dart';

class PageEntityAdapter extends GenericEntityAdapter<PageEntity> {
  @override
  PageEntity parseMap(Map<String, dynamic>? map) {
    return PageEntity(
      id: map!['id'],
      creationDate: map['creationDate'] != null ? DateTime.parse(map['creationDate']).toLocal() : null,
      lastUpdateDate: map['lastUpdateDate'] != null ? DateTime.parse(map['lastUpdateDate']).toLocal() : null,
      route: map['route'],
    );
  }
}
