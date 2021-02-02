import 'package:flutter/material.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_theme.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_data.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/font_editor/pickers/font_weight_picker/font_weight_picker_loader.dart';
import 'package:pal/src/ui/shared/helper_shared_factory.dart';
import 'package:pal/src/ui/shared/helper_shared_viewmodels.dart';

class SimpleHelperViewModel extends HelperViewModel {

  // form validation boolean
  ValueNotifier<bool> canValidate;

  // LanguageNotifier language;
  // TODO : Add background box attribute
  // EditableBoxFormData bodyBox;
  EditableTextFormData contentTextForm;
  ValueNotifier<EditableData> currentSelectedEditableNotifier;

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
    // HelperBoxViewModel helperBoxViewModel,
    HelperTextViewModel contentTextViewModel,
  }) : super(
    id: id,
    name: name,
    priority: priority,
    helperGroup: HelperGroupModel(
      triggerType: triggerType,
      minVersionCode: minVersionCode,
      maxVersionCode: maxVersionCode,
    ),
    helperType: HelperType.SIMPLE_HELPER,
    helperTheme: helperTheme,
  ) {
    // this.language = LanguageNotifier(
    //   id: languageId ?? 1,
    // );
    // this.bodyBox = EditableBoxFormData(
    //   id: helperBoxViewModel?.id,
    //   backgroundColor: helperBoxViewModel?.backgroundColor ?? Colors.black87,
    // );
    this.contentTextForm = EditableTextFormData(
      contentTextViewModel?.id,
      SimpleHelperKeys.CONTENT_KEY,
      fontColor: contentTextViewModel?.fontColor ?? Colors.white,
      fontSize: contentTextViewModel?.fontSize?.toInt() ?? 14,
      fontFamily: contentTextViewModel?.fontFamily,
      fontWeight: FontWeightMapper.toFontKey(contentTextViewModel?.fontWeight),
      text: contentTextViewModel?.text ?? '',
    );
  }

  factory SimpleHelperViewModel.fromHelperViewModel(HelperViewModel model) {
    final simpleHelper = SimpleHelperViewModel(
      id: model?.id,
      name: model.name,
      priority: model.priority,
      helperTheme: model.helperTheme,
      triggerType: model.helperGroup?.triggerType,
      minVersionCode: model.helperGroup?.minVersionCode,
      maxVersionCode: model.helperGroup?.maxVersionCode,
    );

    if (model is SimpleHelperViewModel) {
      // simpleHelper.bodyBox = model?.bodyBox;
      // simpleHelper.language = model?.language;
      simpleHelper.contentTextForm = model?.contentTextForm;
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
      // helperBoxViewModel: HelperSharedFactory.parseBoxBackground(
      //   SimpleHelperKeys.BACKGROUND_KEY,
      //   helperEntity?.helperBoxes,
      // ),
      contentTextViewModel: HelperSharedFactory.parseTextLabel(
        SimpleHelperKeys.CONTENT_KEY,
        helperEntity?.helperTexts,
      ),
    );
  }
}
