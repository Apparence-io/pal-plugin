import 'package:palplugin/src/database/entity/helper_type.dart';

class HelperEntity {
  String id;
  String name;
  HelperType type;
  String triggerType;
  DateTime creationDate;
  DateTime lastUpdateDate;
  int priority;
  String pageId;
  int versionId;
  String versionMin;
  String versionMax;

  HelperEntity(
      {this.id,
      this.name,
      this.type,
      this.triggerType,
      this.creationDate,
      this.lastUpdateDate,
      this.priority,
      this.pageId,
      this.versionId,
      this.versionMin,
      this.versionMax});
}
