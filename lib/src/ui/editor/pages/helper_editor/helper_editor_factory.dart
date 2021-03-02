import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/services/editor/helper/helper_editor_models.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';

import 'helpers/editor_anchored_helper/editor_anchored_helper_viewmodel.dart';
import 'helpers/editor_fullscreen_helper/editor_fullscreen_helper_viewmodel.dart';
import 'helpers/editor_simple_helper/editor_simple_helper_viewmodel.dart';
import 'helpers/editor_update_helper/editor_update_helper_viewmodel.dart';
import 'package:pal/src/extensions/color_extension.dart';

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
            id: model.titleTextForm?.id,
            text: model.titleTextForm?.text,
            fontColor: model.titleTextForm?.fontColor?.toHex(),
            fontWeight: model.titleTextForm?.fontWeight,
            fontSize: model.titleTextForm?.fontSize,
            fontFamily: model.titleTextForm?.fontFamily,
          ),
          description: HelperTextConfig(
            id: model.descriptionTextForm?.id,
            text: model.descriptionTextForm?.text,
            fontColor: model.descriptionTextForm?.fontColor?.toHex(),
            fontWeight: model.descriptionTextForm?.fontWeight,
            fontSize: model.descriptionTextForm?.fontSize,
            fontFamily: model.descriptionTextForm?.fontFamily,
          ),
          mediaHeader: HelperMediaConfig(
            id: model.headerMediaForm?.id,
            url: model.headerMediaForm?.url,
          ),
          bodyBox: HelperBoxConfig(
            id: model.backgroundBoxForm?.id,
            color: model.backgroundBoxForm?.backgroundColor?.toHex(),
          ),
          positivButton: HelperTextConfig(
            id: model.positivButtonForm?.id,
            text: model.positivButtonForm?.text,
            fontColor: model.positivButtonForm?.fontColor?.toHex(),
            fontWeight: model.positivButtonForm?.fontWeight,
            fontSize: model.positivButtonForm?.fontSize,
            fontFamily: model.positivButtonForm?.fontFamily,
          ),
          negativButton: HelperTextConfig(
            id: model.negativButtonForm?.id,
            text: model.negativButtonForm?.text,
            fontColor: model.negativButtonForm?.fontColor?.toHex(),
            fontWeight: model.negativButtonForm?.fontWeight,
            fontSize: model.negativButtonForm?.fontSize,
            fontFamily: model.negativButtonForm?.fontFamily,
          ),
          helperGroup: HelperGroupConfig(
            id: model.helperGroup.id,
            name: model.helperGroup.name,
            maxVersion: model.helperGroup.maxVersionCode,
            minVersion: model.helperGroup.minVersionCode,
            triggerType:model.helperGroup.triggerType ==null ? null :  helperTriggerTypeToString(model.helperGroup.triggerType),
          ));

  static CreateSimpleHelper buildSimpleArgs(
          CreateHelperConfig config, SimpleHelperViewModel model) =>
      CreateSimpleHelper(
          config: config,
          boxConfig: HelperBoxConfig(
              // id: model.bodyBox?.id,
              // color: model.bodyBox?.backgroundColor?.value?.toHex(),
              ),
          titleText: HelperTextConfig(
            text: model.contentTextForm?.text,
            fontColor: model.contentTextForm?.fontColor?.toHex(),
            fontWeight: model.contentTextForm?.fontWeight,
            fontSize: model.contentTextForm?.fontSize,
            fontFamily: model.contentTextForm?.fontFamily,
          ),
          helperGroup: HelperGroupConfig(
              id: model.helperGroup.id,
              name: model.helperGroup.name,
              minVersion: model.helperGroup.minVersionCode,
              maxVersion: model.helperGroup.maxVersionCode,
              triggerType:model.helperGroup.triggerType ==null ? null :  helperTriggerTypeToString(model.helperGroup.triggerType)));

  static CreateUpdateHelper buildUpdateArgs(
      CreateHelperConfig config, UpdateHelperViewModel model) {
    List<HelperTextConfig> lines = [];
    for (var changelogNote in model.changelogsTextsForm.entries) {
      lines.add(
        HelperTextConfig(
          id: changelogNote?.value?.id,
          text: changelogNote?.value?.text,
          fontColor: changelogNote?.value?.fontColor?.toHex(),
          fontWeight: changelogNote?.value?.fontWeight,
          fontSize: changelogNote?.value?.fontSize,
          fontFamily: changelogNote?.value?.fontFamily,
        ),
      );
    }
    return CreateUpdateHelper(
        config: config,
        title: HelperTextConfig(
          id: model.titleTextForm?.id,
          text: model.titleTextForm?.text,
          fontColor: model.titleTextForm?.fontColor?.toHex(),
          fontWeight: model.titleTextForm?.fontWeight,
          fontSize: model.titleTextForm?.fontSize,
          fontFamily: model.titleTextForm?.fontFamily,
        ),
        headerMedia: HelperMediaConfig(
          id: model.headerMediaForm?.id,
          url: model.headerMediaForm?.url,
        ),
        bodyBox: HelperBoxConfig(
          id: model.backgroundBoxForm?.id,
          color: model.backgroundBoxForm?.backgroundColor?.toHex(),
        ),
        lines: lines,
        positivButton: HelperTextConfig(
          id: model.positivButtonForm?.id,
          text: model.positivButtonForm?.text,
          fontColor: model.positivButtonForm?.fontColor?.toHex(),
          fontWeight: model.positivButtonForm?.fontWeight,
          fontSize: model.positivButtonForm?.fontSize,
          fontFamily: model.positivButtonForm?.fontFamily,
        ),
        helperGroup: HelperGroupConfig(
          id: model.helperGroup.id,
          name: model.helperGroup.name,
          maxVersion: model.helperGroup.maxVersionCode,
          minVersion: model.helperGroup.minVersionCode,
          triggerType:model.helperGroup.triggerType ==null ? null :  helperTriggerTypeToString(model.helperGroup.triggerType),
        ));
  }

  static CreateAnchoredHelper buildAnchoredScreenArgs(
          CreateHelperConfig config, AnchoredFullscreenHelperViewModel model) =>
      CreateAnchoredHelper(
          config: config,
          title: HelperTextConfig(
            id: model.titleField?.id,
            text: model.titleField?.text,
            fontColor: model.titleField?.fontColor?.toHex(),
            fontWeight: model.titleField?.fontWeight,
            fontSize: model.titleField?.fontSize,
            fontFamily: model.titleField?.fontFamily,
          ),
          description: HelperTextConfig(
            id: model.descriptionField?.id,
            text: model.descriptionField?.text,
            fontColor: model.descriptionField?.fontColor?.toHex(),
            fontWeight: model.descriptionField?.fontWeight,
            fontSize: model.descriptionField?.fontSize,
            fontFamily: model.descriptionField?.fontFamily,
          ),
          positivButton: HelperTextConfig(
            id: model.positivBtnField?.id,
            text: model.positivBtnField?.text,
            fontColor: model.positivBtnField?.fontColor?.toHex(),
            fontWeight: model.positivBtnField?.fontWeight,
            fontSize: model.positivBtnField?.fontSize,
            fontFamily: model.positivBtnField?.fontFamily,
          ),
          negativButton: HelperTextConfig(
            id: model.negativBtnField?.id,
            text: model.negativBtnField?.text,
            fontColor: model.negativBtnField?.fontColor?.toHex(),
            fontWeight: model.negativBtnField?.fontWeight,
            fontSize: model.negativBtnField?.fontSize,
            fontFamily: model.negativBtnField?.fontFamily,
          ),
          bodyBox: HelperBoxConfig(
            id: model.backgroundBox.id,
            key: model.selectedAnchorKey,
            color: model.backgroundBox?.backgroundColor?.toHex(),
          ),
          helperGroup: HelperGroupConfig(
            id: model.helperGroup.id,
            name: model.helperGroup.name,
            maxVersion: model.helperGroup.maxVersionCode,
            minVersion: model.helperGroup.minVersionCode,
            triggerType: model.helperGroup.triggerType ==null ? null : helperTriggerTypeToString(model.helperGroup.triggerType),
          ));
}
