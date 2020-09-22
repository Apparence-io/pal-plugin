import 'dart:ui';

import 'package:palplugin/src/database/entity/helper/create_helper_entity.dart';
import 'package:palplugin/src/database/entity/helper/create_helper_full_screen_entity.dart';
import 'package:palplugin/src/database/entity/helper/create_helper_simple_entity.dart';
import 'package:palplugin/src/database/entity/helper/create_helper_update_entity.dart';
import 'package:palplugin/src/database/entity/helper/helper_type.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';
import 'package:palplugin/src/extensions/color_extension.dart';

class EditorFactory {

  //FIXME DELETE
  static HelperViewModel init(HelperViewModel model, HelperType helperType) {
    switch (helperType) {
      case HelperType.HELPER_FULL_SCREEN:
        return FullscreenHelperViewModel.fromHelperViewModel(model);
      case HelperType.SIMPLE_HELPER:
        return SimpleHelperViewModel.fromHelperViewModel(model);
      case HelperType.UPDATE_HELPER:
        return UpdateHelperViewModel.fromHelperViewModel(model);
      default:
        return null;
    }
  }

  static CreateHelperEntity build(HelperViewModel model) {
    CreateHelperEntity createHelperEntity;
    switch (model.runtimeType) {
      case FullscreenHelperViewModel:
        createHelperEntity = _buildFullscreenHelper(model);
        break;
      case SimpleHelperViewModel:
        createHelperEntity = _buildSimpleHelper(model);
        break;
      case UpdateHelperViewModel:
        createHelperEntity = _buildUpdateHelper(model);
        break;
      default:
    }
    return createHelperEntity;
  }

  static CreateHelperFullScreenEntity _buildFullscreenHelper(FullscreenHelperViewModel model) {
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

  static CreateHelperSimpleEntity _buildSimpleHelper(SimpleHelperViewModel model) {
    return CreateHelperSimpleEntity(
      name: model.name,
      triggerType: model.triggerType,
      priority: model.priority,
      versionMaxId: model.versionMaxId,
      versionMinId: model.versionMinId,
      title: model.details?.value,
      fontColor: model.fontColor?.value?.toHex(),
      backgroundColor: model.backgroundColor?.value?.toHex(),
      borderColor: model.borderColor?.value?.toHex(),
      languageId: model.languageId?.value,
    );
  }

  static CreateHelperUpdateEntity _buildUpdateHelper(UpdateHelperViewModel model) {
    return CreateHelperUpdateEntity(
      name: model.name,
      triggerType: model.triggerType,
      priority: model.priority,
      versionMaxId: model.versionMaxId,
      versionMinId: model.versionMinId,
      title: model.titleText?.value,
      fontColor: model.titleFontColor?.value?.toHex(),
      backgroundColor: model.backgroundColor?.value?.toHex(),
      // borderColor: model.titleBackgroundColor?.value?.toHex(),
      languageId: model.languageId?.value,
    );
  }

  // TODO: Move to global utils file
  // static String colorToHex(Color color) {
  //   return '#${color.value.toRadixString(16).substring(2, 8)}';
  // }
}
