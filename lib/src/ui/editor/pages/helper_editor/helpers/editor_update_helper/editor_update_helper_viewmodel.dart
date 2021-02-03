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

class UpdateHelperViewModel extends HelperViewModel {
  // form validation boolean
  ValueNotifier<bool> canValidate;
  bool isKeyboardVisible;
  // LanguageNotifier language;

  ValueNotifier<EditableData> currentEditableItemNotifier;
  EditableBoxFormData backgroundBoxForm;
  Map<String, EditableTextFormData> changelogsTextsForm;
  EditableMediaFormData headerMediaForm;
  EditableButtonFormData positivButtonForm;
  EditableTextFormData titleTextForm;

  UpdateHelperViewModel({
    String id,
    @required String name,
    @required HelperTriggerType triggerType,
    @required int priority,
    @required HelperTheme helperTheme,
    String minVersionCode,
    String maxVersionCode,
    int versionMaxId,
    int languageId,
    HelperBoxViewModel helperBoxViewModel,
    Map<String, EditableTextFormData> changelogsLabels,
    HelperImageViewModel helperImageViewModel,
    HelperTextViewModel titleLabel,
    HelperTextViewModel positivButtonLabel,
  }) : super(
    id: id,
    name: name,
    priority: priority,
    helperGroup: HelperGroupModel(
      triggerType: triggerType,
      minVersionCode: minVersionCode,
      maxVersionCode: maxVersionCode,
    ),
    helperType: HelperType.UPDATE_HELPER,
    helperTheme: helperTheme,
  ) {
    this.language = LanguageNotifier(
      id: languageId ?? 1,
    );
    this.bodyBox = BoxNotifier(
      id: helperBoxViewModel?.id,
      backgroundColor: helperBoxViewModel?.backgroundColor ?? Colors.blueAccent,
    );
    this.changelogsTextsForm = changelogsLabels ?? {};
    this.headerMediaForm = EditableMediaFormData(
      helperImageViewModel?.id,
      UpdatescreenHelperKeys.IMAGE_KEY,
      url: helperImageViewModel?.url,
    );
    this.positivButtonForm = EditableButtonFormData(
      positivButtonLabel?.id,
      UpdatescreenHelperKeys.POSITIV_KEY,
      backgroundColor: Color(0xFF03045E),
      fontColor: positivButtonLabel?.fontColor ?? Colors.white,
      fontSize: positivButtonLabel?.fontSize?.toInt() ?? 22,
      text: positivButtonLabel?.text ?? 'Thank you!',
      fontWeight: FontWeightMapper.toFontKey(
          positivButtonLabel?.fontWeight ?? FontWeight.normal),
      fontFamily: positivButtonLabel?.fontFamily,
    );
    this.titleTextForm = EditableTextFormData(
      titleLabel?.id,
      UpdatescreenHelperKeys.TITLE_KEY,
      fontColor: titleLabel?.fontColor ?? Colors.white,
      fontSize: titleLabel?.fontSize?.toInt() ?? 36,
      text: titleLabel?.text ?? 'New update',
      fontWeight: FontWeightMapper.toFontKey(titleLabel?.fontWeight),
      fontFamily: titleLabel?.fontFamily,
      hintText: 'Enter your title here...',
    );
    this.currentEditableItemNotifier = ValueNotifier<EditableData>(null);
  }

  factory UpdateHelperViewModel.fromHelperViewModel(HelperViewModel model) {
    final updateHelper = UpdateHelperViewModel(
      id: model.id,
      name: model.name,
      priority: model.priority,
      helperTheme: model.helperTheme,
      triggerType: model?.helperGroup?.triggerType,
      minVersionCode: model?.helperGroup?.minVersionCode,
      maxVersionCode: model?.helperGroup?.maxVersionCode,
    );

    if (model is UpdateHelperViewModel) {
      updateHelper.backgroundBoxForm = model?.backgroundBoxForm;
      // updateHelper.language = model?.language;
      updateHelper.titleTextForm = model?.titleTextForm;
      updateHelper.positivButtonForm = model?.positivButtonForm;
      updateHelper.changelogsTextsForm = model?.changelogsTextsForm;
      updateHelper.headerMediaForm = model?.headerMediaForm;
    }

    return updateHelper;
  }

  factory UpdateHelperViewModel.fromHelperEntity(HelperEntity helperEntity) {
    Map<String, EditableTextFormData> changelogsMap = {};
    List<HelperTextViewModel> changelogs = HelperSharedFactory.parseTextsLabel(
      UpdatescreenHelperKeys.LINES_KEY,
      helperEntity?.helperTexts,
    );

    if (changelogs != null && changelogs.length > 0) {
      int index = 0;
      for (var changelog in changelogs) {
        changelogsMap.putIfAbsent(
          'template_${changelog.id.toString()}',
          () => EditableTextFormData(
            changelog?.id,
            '${UpdatescreenHelperKeys.LINES_KEY}_${index++}',
            text: changelog?.text ?? '',
            fontColor: changelog?.fontColor ?? Colors.white,
            fontSize: changelog?.fontSize?.toInt() ?? 18,
            fontFamily: changelog?.fontFamily,
            fontWeight: FontWeightMapper.toFontKey(changelog?.fontWeight),
          ),
        );
      }
    }
    return UpdateHelperViewModel(
      id: helperEntity?.id,
      name: helperEntity?.name,
      triggerType: helperEntity?.triggerType,
      priority: helperEntity?.priority,
      helperTheme: null,
      helperBoxViewModel: HelperSharedFactory.parseBoxBackground(
        SimpleHelperKeys.BACKGROUND_KEY,
        helperEntity?.helperBoxes,
      ),
      titleLabel: HelperSharedFactory.parseTextLabel(
        UpdatescreenHelperKeys.TITLE_KEY,
        helperEntity?.helperTexts,
      ),
      positivButtonLabel: HelperSharedFactory.parseTextLabel(
        UpdatescreenHelperKeys.POSITIV_KEY,
        helperEntity?.helperTexts,
      ),
      helperImageViewModel: HelperSharedFactory.parseImageUrl(
        UpdatescreenHelperKeys.IMAGE_KEY,
        helperEntity?.helperImages,
      ),
      changelogsLabels: changelogsMap,
      // TODO: Add changelog edit
    );
  }

  String addChangelog() {
    String textFieldId = changelogsTextsForm.length.toString();
    this.changelogsTextsForm.putIfAbsent(
          textFieldId,
          () => EditableTextFormData(
            null,
            '${UpdatescreenHelperKeys.LINES_KEY}_${changelogsTextsForm.length}',
            text: '',
            fontSize: 18,
            fontColor: Colors.white,
          ),
        );
    return textFieldId;
  }

  List<dynamic> get fields => [
        titleTextForm,
        ...changelogsTextsForm.values,
        positivButtonForm,
      ];
}
