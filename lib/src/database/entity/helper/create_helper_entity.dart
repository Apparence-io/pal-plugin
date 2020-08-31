import 'package:palplugin/src/database/entity/helper/helper_trigger_type.dart';
import 'package:palplugin/src/database/entity/helper/helper_type.dart';

abstract class CreateHelperEntity {
  String name;
  HelperType type;
  HelperTriggerType triggerType;
  int priority;
  int versionMinId;
  int versionMaxId;

  CreateHelperEntity({
    this.name,
    this.type,
    this.triggerType,
    this.priority,
    this.versionMinId,
    this.versionMaxId,
  });
}
