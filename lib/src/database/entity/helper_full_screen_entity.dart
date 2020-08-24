
import 'package:palplugin/src/database/entity/helper_entity.dart';
import 'package:palplugin/src/database/entity/helper_type.dart';

class HelperFullScreenEntity extends HelperEntity {
  String title;
  String fontColor;
  String backgroundColor;
  String borderColor;
  int languageId;

  HelperFullScreenEntity(
      {String id,
        String name,
        HelperType type,
        String triggerType,
        DateTime creationDate,
        DateTime lastUpdateDate,
        int priority,
        String pageId,
        int versionMinId,
        String versionMin,
        int versionMaxId,
        String versionMax,
        String title,
        String fontColor,
        String backgroundColor,
        String borderColor,
        int languageId})
      : super(
      id: id,
      name: name,
      type: type,
      triggerType: triggerType,
      creationDate: creationDate,
      lastUpdateDate: lastUpdateDate,
      priority: priority,
      pageId: pageId,
      versionMinId: versionMinId,
      versionMin: versionMin,
      versionMaxId: versionMaxId,
      versionMax: versionMax) {
    this.title = title;
    this.fontColor = fontColor;
    this.backgroundColor = backgroundColor;
    this.borderColor = borderColor;
    this.languageId = languageId;
  }
}
