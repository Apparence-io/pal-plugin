
import 'package:palplugin/src/database/entity/helper/create_helper_entity.dart';
import 'package:palplugin/src/database/entity/helper/helper_type.dart';

class CreateHelperFullScreenEntity extends CreateHelperEntity {
  String title;
  String fontColor;
  String backgroundColor;
  String borderColor;
  int languageId;

  CreateHelperFullScreenEntity({
    String name,
    String triggerType,
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
          type: HelperType.HELPER_FULL_SCREEN,
          triggerType: triggerType,
          priority: priority,
          versionMinId: versionMinId,
          versionMaxId: versionMaxId,
        );

  Map<String, dynamic> toJson() {
    return {
      'name': this.name,
      'type': helperTypeToString(this.type),
      'triggerType': this.triggerType,
      'priority': this.priority,
      'versionMinId': this.versionMinId,
      'versionMaxId': this.versionMaxId,
      'title': this.title,
      'fontColor': this.fontColor,
      'backgrounColor': this.backgroundColor,
      'borderColor': this.borderColor,
      'languageId': this.languageId,
    };
  }
}
