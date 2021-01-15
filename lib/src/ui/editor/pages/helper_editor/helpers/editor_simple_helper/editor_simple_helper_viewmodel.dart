import 'package:flutter/material.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_theme.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_notifiers.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/font_editor/pickers/font_weight_picker/font_weight_picker_loader.dart';
import 'package:pal/src/ui/shared/helper_shared_factory.dart';
import 'package:pal/src/ui/shared/helper_shared_viewmodels.dart';

class SimpleHelperViewModel extends HelperViewModel {

  // form validation boolean
  ValueNotifier<bool> canValidate;

  LanguageNotifier language;
  BoxNotifier bodyBox;
  TextFormFieldNotifier detailsField;

  ValueNotifier<FormFieldNotifier> currentEditableItemNotifier;

  SimpleHelperViewModel({
    String id,
    @required String name,
    @required HelperTriggerType triggerType,
    @required int priority,
    String minVersionCode,
    String maxVersionCode,
    HelperTheme helperTheme,
    int versionMaxId,
    int languageId,
    HelperBoxViewModel helperBoxViewModel,
    HelperTextViewModel detailsField,
  }) : super(
    id: id,
    name: name,
    triggerType: triggerType,
    priority: priority,
    minVersionCode: minVersionCode,
    maxVersionCode: maxVersionCode,
    helperType: HelperType.SIMPLE_HELPER,
    helperTheme: helperTheme,
  ) {
    this.language = LanguageNotifier(
      id: languageId ?? 1,
    );
    this.bodyBox = BoxNotifier(
      id: helperBoxViewModel?.id,
      backgroundColor: helperBoxViewModel?.backgroundColor ?? Colors.black87,
    );
    this.detailsField = TextFormFieldNotifier(
      detailsField?.id,
      fontColor: detailsField?.fontColor ?? Colors.white,
      fontSize: detailsField?.fontSize?.toInt() ?? 14,
      fontFamily: detailsField?.fontFamily,
      fontWeight: FontWeightMapper.toFontKey(detailsField?.fontWeight),
      text: detailsField?.text ?? '',
    );
    this.currentEditableItemNotifier = ValueNotifier<FormFieldNotifier>(null);
  }

  factory SimpleHelperViewModel.fromHelperViewModel(HelperViewModel model) {
    final simpleHelper = SimpleHelperViewModel(
      id: model?.id,
      name: model.name,
      triggerType: model.triggerType,
      priority: model.priority,
      minVersionCode: model.minVersionCode,
      maxVersionCode: model.maxVersionCode,
      helperTheme: model.helperTheme,
    );

    if (model is SimpleHelperViewModel) {
      simpleHelper.bodyBox = model?.bodyBox;
      simpleHelper.language = model?.language;
      simpleHelper.detailsField = model?.detailsField;
    }
    return simpleHelper;
  }

  factory SimpleHelperViewModel.fromHelperEntity(HelperEntity helperEntity) {
    return SimpleHelperViewModel(
      id: helperEntity?.id,
      name: helperEntity?.name,
      triggerType: helperEntity?.triggerType,
      priority: helperEntity?.priority,
      minVersionCode: helperEntity?.versionMin,
      maxVersionCode: helperEntity?.versionMax,
      helperTheme: null,
      helperBoxViewModel: HelperSharedFactory.parseBoxBackground(
        SimpleHelperKeys.BACKGROUND_KEY,
        helperEntity?.helperBoxes,
      ),
      detailsField: HelperSharedFactory.parseTextLabel(
        SimpleHelperKeys.CONTENT_KEY,
        helperEntity?.helperTexts,
      ),
    );
  }
}
