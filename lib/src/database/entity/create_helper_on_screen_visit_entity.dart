import 'package:palplugin/src/database/entity/create_helper_entity.dart';
import 'package:palplugin/src/database/entity/helper_type.dart';

class CreateHelperOnScreenVisitEntity extends CreateHelperEntity {
  String title;
  String theme;
  int languageId;

  CreateHelperOnScreenVisitEntity(
      {String name, String triggerType, int priority, int versionMinId, int versionMaxId, this.title, this.theme, this.languageId})
    : super(
    name: name,
    type: HelperType.HELPER_ON_SCREEN_VISIT,
    triggerType: triggerType,
    priority: priority,
    versionMinId: versionMinId,
    versionMaxId: versionMaxId,
  );

  Map<String, dynamic> toJson() {
    return {
      "name": this.name,
      "type": helperTypeToString(this.type),
      "triggerType": this.triggerType,
      "priority": this.priority,
      "versionMinId": this.versionMinId,
      "versionMaxId": this.versionMaxId,
      "title": this.title,
      "theme": this.theme,
      "languageId": this.languageId,
    };
  }
}