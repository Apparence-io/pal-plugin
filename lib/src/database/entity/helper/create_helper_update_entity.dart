
import 'package:palplugin/src/database/entity/helper/create_helper_entity.dart';
import 'package:palplugin/src/database/entity/helper/helper_trigger_type.dart';
import 'package:palplugin/src/database/entity/helper/helper_type.dart';

class CreateHelperUpdateEntity extends CreateHelperEntity {
  String title;
  String fontColor;
  String backgroundColor;
  String borderColor;
  int languageId;

  CreateHelperUpdateEntity({
    String name,
    HelperTriggerType triggerType,
    int priority,
    int versionMinId,
    int versionMaxId,
    this.title,
    this.fontColor,
    this.backgroundColor,
    this.borderColor,
    this.languageId,
  }) : super(
          name: name,
          type: HelperType.UPDATE_HELPER,
          triggerType: triggerType,
          priority: priority,
          versionMinId: versionMinId,
          versionMaxId: versionMaxId,
        );

  Map<String, dynamic> toJson() {
    return {
      'name': this.name,
      'type': helperTypeToString(this.type),
      'triggerType': helperTriggerTypeToString(this.triggerType),
      'priority': this.priority,
      'versionMinId': this.versionMinId,
      'versionMaxId': this.versionMaxId,
      'title': this.title,
      'fontColor': this.fontColor,
      'backgroundColor': this.backgroundColor,
      'borderColor': this.borderColor,
      'languageId': this.languageId,
    };
  }
}
