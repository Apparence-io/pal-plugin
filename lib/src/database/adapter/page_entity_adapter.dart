import 'package:palplugin/src/database/adapter/generic_adapter.dart';
import 'package:palplugin/src/database/entity/page_entity.dart';

class PageEntityAdapter extends GenericEntityAdapter<PageEntity> {
  @override
  PageEntity parseMap(Map<String, dynamic> map) {
    return PageEntity(
      id: map['id'],
      creationDate: DateTime.parse(map['creationDate']).toLocal(),
      lastUpdateDate: DateTime.parse(map['lastUpdateDate']).toLocal(),
      route: map['route'],
    );
  }
}
