import 'dart:ui';

import 'package:palplugin/src/database/entity/helper/helper_type.dart';
import 'package:palplugin/src/services/editor/helper/helper_editor_models.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';
import 'package:palplugin/src/extensions/color_extension.dart';

class EditorViewModelFactory {

  static HelperViewModel transform(HelperViewModel model, HelperType helperType) {
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
}

class EditorEntityFactory {

  static CreateFullScreenHelper buildFullscreenArgs(CreateHelperConfig config, FullscreenHelperViewModel model) =>
    CreateFullScreenHelper(
      config: config,
      title: HelperTextConfig(
        text: model.titleField.text.value,
        fontColor: model.titleField.fontColor.value.toHex(),
        fontWeight: "w100", //FIXME missing value
        fontSize: model.titleField.fontSize.value,
        fontFamily: "cortana" //FIXME missing value
      ),
      description: HelperTextConfig(
        text: "missing text", //FIXME missing value
        fontColor: "#CCC2", //FIXME missing value
        fontWeight: "w400", //FIXME missing value
        fontSize: 14, //FIXME missing value
        fontFamily: "cortanaBis" //FIXME missing value
      ),
      backgroundColor: model.backgroundColor.value.toHex(),
      topImageId: "2513aeaezaed213254df", //FIXME missing value
      positivButton: HelperTextConfig(
        text: "missing text", //FIXME missing value
        fontColor: "#CCC2", //FIXME missing value
        fontWeight: "w400", //FIXME missing value
        fontSize: 14, //FIXME missing value
        fontFamily: "cortanaBis" //FIXME missing value
      ),
      negativButton: HelperTextConfig(
        text: "missing text", //FIXME missing value
        fontColor: "#CCC2", //FIXME missing value
        fontWeight: "w400", //FIXME missing value
        fontSize: 14, //FIXME missing value
        fontFamily: "cortanaBis" //FIXME missing value
      ),
    );
}