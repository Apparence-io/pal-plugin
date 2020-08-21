import 'package:palplugin/src/database/entity/create_helper_entity.dart';
import 'package:palplugin/src/database/entity/helper_type.dart';

class CreateHelperOnScreenVisitEntity extends CreateHelperEntity {
  String title;
  String theme;
  int languageId;

  CreateHelperOnScreenVisitEntity({String name, String triggerType, int priority, this.title, this.theme, this.languageId})
    : super(
    name: name,
    type: HelperType.HELPER_ON_SCREEN_VISIT,
    triggerType: triggerType,
    priority: priority
  );
}