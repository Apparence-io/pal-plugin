import 'package:palplugin/src/database/adapter/generic_adapter.dart';
import 'package:palplugin/src/database/entity/helper/helper_entity.dart';
import 'package:palplugin/src/database/entity/helper/helper_full_screen_entity.dart';
import 'package:palplugin/src/database/entity/helper/helper_trigger_type.dart';
import 'package:palplugin/src/database/entity/helper/helper_type.dart';

class HelperEntityAdapter extends GenericEntityAdapter<HelperEntity> {
  @override
  HelperEntity parseMap(Map<String, dynamic> map) {
    final HelperType helperType = getHelperType(map['type']);
    final HelperTriggerType helperTriggerType = getHelperTriggerType(map['triggerType']);

    return HelperFullScreenEntity(
      id: map['id'],
      name: map['name'],
      type: helperType,
      triggerType: helperTriggerType,
      creationDate: DateTime.parse(map['creationDate']).toLocal(),
      lastUpdateDate: DateTime.parse(map['lastUpdateDate']).toLocal(),
      priority: map['priority'],
      pageId: map['pageId'],
      versionMinId: map['versionMinId'],
      versionMin: map['versionMin'],
      versionMaxId: map['versionMaxId'],
      versionMax: map['versionMax'],
      title: map['title'],
      fontColor: map['fontColor'],
      backgroundColor: map['backgroundColor'],
      borderColor: map['borderColor'],
      languageId: map['languageId'],
    );
  }
}
