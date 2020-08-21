import 'package:palplugin/src/database/entity/create_helper_entity.dart';
import 'package:palplugin/src/database/entity/trigger_type.dart';

class CreateHelperOnScreenVisitEntity extends CreateHelperEntity {
  String title;
  String theme;
  int languageId;

  CreateHelperOnScreenVisitEntity({String name, String type, int priority, this.title, this.theme, this.languageId})
    : super(
    name: name,
    type: type,
    triggerType: TriggerHelper.HELPER_ON_SCREEN_VISIT,
    priority: priority
  );
}