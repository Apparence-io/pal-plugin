
import 'package:palplugin/src/database/adapter/generic_adapter.dart';
import 'package:palplugin/src/database/entity/helper_on_screen_visit.dart';
import 'package:palplugin/src/database/entity/helper_type.dart';

class HelperEntityAdapter extends GenericEntityAdapter {
  @override
  parseMap(Map<String, dynamic> map) {
    final HelperType helperType = getTriggerHelperType(map["type"]);
    switch (helperType) {
      case HelperType.HELPER_ON_SCREEN_VISIT:
        return HelperOnScreenVisitEntity(
          id: map["id"],
          name: map["name"],
          type: helperType,
          triggerType: map["triggerType"],
          creationDate: DateTime.parse(map["creationDate"]).toLocal(),
          lastUpdateDate: DateTime.parse(map["lastUpdateDate"]).toLocal(),
          priority: map["priority"],
          pageId: map["pageId"],
          versionId: map["versionId"],
          versionMin: map["versionMin"],
          versionMax: map["versionMax"],
          title: map["title"],
          theme: map["theme"],
          languageId: map["languageId"],
        );
    }
  }
}
