import 'package:pal/src/database/entity/graphic_entity.dart';
import 'generic_adapter.dart';

class ProjectGalleryEntityAdapter extends GenericEntityAdapter<GraphicEntity> {
  @override
  GraphicEntity parseMap(Map<String, dynamic>? map) {
    return GraphicEntity(
      id: map!['id'],
      url: map['url'],
      uploadedDate: DateTime.parse(map['uploadedDate']).toLocal(),
    );
  }
}