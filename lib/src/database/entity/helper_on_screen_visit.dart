
import 'package:palplugin/src/database/entity/helper_entity.dart';

class HelperOnScreenVisitEntity extends HelperEntity {
  String title;
  String theme;
  int languageId;

  HelperOnScreenVisitEntity(
      {String id,
      String name,
      String type,
      DateTime creationDate,
      DateTime lastUpdateDate,
      int priority,
      String pageId,
      int versionId,
      String versionMin,
      String versionMax,
      String title,
      String theme,
      int languageId})
      : super(
            id: id,
            name: name,
            type: type,
            creationDate: creationDate,
            lastUpdateDate: lastUpdateDate,
            priority: priority,
            pageId: pageId,
            versionId: versionId,
            versionMin: versionMin,
            versionMax: versionMax) {
    this.title = title;
    this.theme = theme;
    this.languageId = languageId;
  }
}
