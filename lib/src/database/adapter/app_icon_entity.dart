import 'package:pal/src/database/entity/app_icon_entity.dart';
import 'generic_adapter.dart';

class AppIconEntityAdapter extends GenericEntityAdapter<AppIconEntity> {
  @override
  AppIconEntity parseMap(Map<String, dynamic>? map) {
    return AppIconEntity(
      id: map!['id'],
      url: map['url'],
    );
  }
}