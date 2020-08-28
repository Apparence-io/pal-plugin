import 'package:palplugin/src/database/entity/helper/helper_trigger_type.dart';
import 'package:palplugin/src/database/entity/helper/helper_type.dart';

class HelperEntity {
  String id;
  String name;
  HelperType type;
  HelperTriggerType triggerType;
  DateTime creationDate;
  DateTime lastUpdateDate;
  int priority;
  String pageId;
  int versionMinId;
  String versionMin;
  int versionMaxId;
  String versionMax;

  HelperEntity({
    this.id,
    this.name,
    this.type,
    this.triggerType,
    this.creationDate,
    this.lastUpdateDate,
    this.priority,
    this.pageId,
    this.versionMinId,
    this.versionMin,
    this.versionMaxId,
    this.versionMax,
  });
}
