import 'dart:ui';

import 'package:palplugin/src/database/entity/helper/create_helper_entity.dart';
import 'package:palplugin/src/database/entity/helper/create_helper_full_screen_entity.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';

class EditorFactory {
  static CreateHelperEntity build(HelperViewModel model) {
    CreateHelperEntity createHelperEntity;

    switch (model.runtimeType) {
      case FullscreenHelperViewModel:
        createHelperEntity = _buildFullscreenHelper(model);
        break;
      default:
    }

    return createHelperEntity;
  }

  static CreateHelperFullScreenEntity _buildFullscreenHelper(
      FullscreenHelperViewModel model) {
    return CreateHelperFullScreenEntity(
      name: model.name,
      triggerType: model.triggerType,
      priority: model.priority,
      versionMaxId: model.versionMaxId,
      versionMinId: model.versionMinId,
      title: model.title?.value,
      fontColor: colorToHex(model.fontColor?.value),
      backgroundColor: colorToHex(model.backgroundColor?.value),
      borderColor: colorToHex(model.borderColor?.value),
      languageId: model.languageId?.value,
    );
  }

  // TODO: Move to global utils file
  static String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2, 8)}';
  }
}
