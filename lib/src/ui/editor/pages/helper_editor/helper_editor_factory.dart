import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/services/editor/helper/helper_editor_models.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';
import 'package:pal/src/extensions/color_extension.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';

import 'helpers/editor_fullscreen_helper/editor_fullscreen_helper_viewmodel.dart';
import 'helpers/editor_simple_helper/editor_simple_helper_viewmodel.dart';
import 'helpers/editor_update_helper/editor_update_helper_viewmodel.dart';

class EditorViewModelFactory {

  @deprecated
  static HelperViewModel transform(HelperViewModel model) {
    switch (model?.helperType) {
      case HelperType.HELPER_FULL_SCREEN:
        return FullscreenHelperViewModel.fromHelperViewModel(model);
      case HelperType.SIMPLE_HELPER:
        return SimpleHelperViewModel.fromHelperViewModel(model);
      case HelperType.UPDATE_HELPER:
        return UpdateHelperViewModel.fromHelperViewModel(model);
      case HelperType.ANCHORED_OVERLAYED_HELPER:
        return model;
      default:
        return null;
    }
  }

  static HelperViewModel build(HelperEntity helperEntity) {
    switch (helperEntity?.type) {
      case HelperType.HELPER_FULL_SCREEN:
        return FullscreenHelperViewModel.fromHelperEntity(helperEntity);
      case HelperType.SIMPLE_HELPER:
        return SimpleHelperViewModel.fromHelperEntity(helperEntity);
      case HelperType.UPDATE_HELPER:
        return UpdateHelperViewModel.fromHelperEntity(helperEntity);
      default:
        return null;
    }
  }
}

class EditorEntityFactory {

  static CreateFullScreenHelper buildFullscreenArgs(
    CreateHelperConfig config,
    FullscreenHelperViewModel model,
  ) =>
      CreateFullScreenHelper(
        config: config,
        title: HelperTextConfig(
          id: model.titleField?.id,
          text: model.titleField?.text?.value,
          fontColor: model.titleField?.fontColor?.value?.toHex(),
          fontWeight: model.titleField?.fontWeight?.value,
          fontSize: model.titleField?.fontSize?.value,
          fontFamily: model.titleField?.fontFamily?.value,
        ),
        description: HelperTextConfig(
          id: model.descriptionField?.id,
          text: model.descriptionField?.text?.value,
          fontColor: model.descriptionField?.fontColor?.value?.toHex(),
          fontWeight: model.descriptionField?.fontWeight?.value,
          fontSize: model.descriptionField?.fontSize?.value,
          fontFamily: model.descriptionField?.fontFamily?.value,
        ),
        mediaHeader: HelperMediaConfig(
          id: model.media?.id,
          url: model.media?.url?.value,
        ),
        bodyBox: HelperBoxConfig(
          id: model.bodyBox?.id,
          color: model.bodyBox?.backgroundColor?.value?.toHex(),
        ),
        positivButton: HelperTextConfig(
          id: model.positivButtonField?.id,
          text: model.positivButtonField?.text?.value,
          fontColor: model.positivButtonField?.fontColor?.value?.toHex(),
          fontWeight: model.positivButtonField?.fontWeight?.value,
          fontSize: model.positivButtonField?.fontSize?.value,
          fontFamily: model.positivButtonField?.fontFamily?.value,
        ),
        negativButton: HelperTextConfig(
          id: model.negativButtonField?.id,
          text: model.negativButtonField?.text?.value,
          fontColor: model.negativButtonField?.fontColor?.value?.toHex(),
          fontWeight: model.negativButtonField?.fontWeight?.value,
          fontSize: model.negativButtonField?.fontSize?.value,
          fontFamily: model.negativButtonField?.fontFamily?.value,
        ),
      );

  static CreateSimpleHelper buildSimpleArgs(
          CreateHelperConfig config, SimpleHelperViewModel model) =>
      CreateSimpleHelper(
        config: config,
        boxConfig: HelperBoxConfig(
          id: model.bodyBox?.id,
          color: model.bodyBox?.backgroundColor?.value?.toHex(),
        ),
        titleText: HelperTextConfig(
          text: model.detailsField?.text?.value,
          fontColor: model.detailsField?.fontColor?.value?.toHex(),
          fontWeight: model.detailsField?.fontWeight?.value,
          fontSize: model.detailsField?.fontSize?.value,
          fontFamily: model.detailsField?.fontFamily?.value,
        ),
      );

  static CreateUpdateHelper buildUpdateArgs(
      CreateHelperConfig config, UpdateHelperViewModel model) {
    List<HelperTextConfig> lines = [];
    for (var note in model.changelogsFields.entries) {
      lines.add(
        HelperTextConfig(
          id: note?.value?.id,
          text: note?.value?.text?.value,
          fontColor: note?.value?.fontColor?.value?.toHex(),
          fontWeight: note?.value?.fontWeight?.value,
          fontSize: note?.value?.fontSize?.value,
          fontFamily: note?.value?.fontFamily?.value,
        ),
      );
    }
    return CreateUpdateHelper(
      config: config,
      title: HelperTextConfig(
        id: model.titleField?.id,
        text: model.titleField?.text?.value,
        fontColor: model.titleField?.fontColor?.value?.toHex(),
        fontWeight: model.titleField?.fontWeight?.value,
        fontSize: model.titleField?.fontSize?.value,
        fontFamily: model.titleField?.fontFamily?.value,
      ),
      headerMedia: HelperMediaConfig(
        id: model.media?.id,
        url: model.media?.url?.value,
      ),
      bodyBox: HelperBoxConfig(
        id: model.bodyBox?.id,
        color: model.bodyBox?.backgroundColor?.value?.toHex(),
      ),
      lines: lines,
      positivButton: HelperTextConfig(
        id: model.thanksButton?.id,
        text: model.thanksButton?.text?.value,
        fontColor: model.thanksButton?.fontColor?.value?.toHex(),
        fontWeight: model.thanksButton?.fontWeight?.value,
        fontSize: model.thanksButton?.fontSize?.value,
        fontFamily: model.thanksButton?.fontFamily?.value,
      ),
    );
  }
}
