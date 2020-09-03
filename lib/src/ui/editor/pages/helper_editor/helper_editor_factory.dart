import 'dart:ui';

import 'package:palplugin/src/database/entity/helper/create_helper_entity.dart';
import 'package:palplugin/src/database/entity/helper/create_helper_full_screen_entity.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';
import 'package:palplugin/src/extensions/color_extension.dart';

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
      fontColor: model.fontColor?.value?.toHex(),
      backgroundColor: model.backgroundColor?.value?.toHex(),
      borderColor: model.borderColor?.value?.toHex(),
      languageId: model.languageId?.value,
    );
  }
}
