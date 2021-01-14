import 'package:flutter/material.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_theme.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/font_editor/pickers/font_weight_picker/font_weight_picker_loader.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_notifiers.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/editor_toolbox_viewmodel.dart';
import 'package:pal/src/ui/shared/helper_shared_factory.dart';
import 'package:pal/src/ui/shared/helper_shared_viewmodels.dart';


class UpdateHelperViewModel extends HelperViewModel {

  // form validation boolean
  ValueNotifier<bool> canValidate;
  bool isKeyboardVisible;

  LanguageNotifier language;
  
  ValueNotifier<CurrentEditableItem> currentEditableItemNotifier;
  BoxNotifier bodyBox;
  Map<String, TextFormFieldNotifier> changelogsFields;
  MediaNotifier media;
  ButtonFormFieldNotifier thanksButton;
  TextFormFieldNotifier titleField;

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
    Map<String, TextFormFieldNotifier> changelogsLabels,
    HelperImageViewModel helperImageViewModel,
    HelperTextViewModel titleLabel,
    HelperTextViewModel positivButtonLabel,
  }) : super(
    id: id,
    name: name,
    triggerType: triggerType,
    priority: priority,
    minVersionCode: minVersionCode,
    maxVersionCode: maxVersionCode,
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
    this.changelogsFields = changelogsLabels ?? {};
    this.media = MediaNotifier(
      id: helperImageViewModel?.id,
      url: helperImageViewModel?.url,
    );
    this.thanksButton = ButtonFormFieldNotifier(
      backgroundColor: Color(0xFF03045E),
      id: positivButtonLabel?.id,
      fontColor: positivButtonLabel?.fontColor ?? Colors.white,
      fontSize: positivButtonLabel?.fontSize?.toInt() ?? 22,
      text: positivButtonLabel?.text ?? 'Thank you!',
      fontWeight: FontWeightMapper.toFontKey(
        positivButtonLabel?.fontWeight ?? FontWeight.normal),
      fontFamily: positivButtonLabel?.fontFamily,
    );
    this.titleField = TextFormFieldNotifier(
      id: titleLabel?.id,
      fontColor: titleLabel?.fontColor ?? Colors.white,
      fontSize: titleLabel?.fontSize?.toInt() ?? 36,
      text: titleLabel?.text ?? '',
      fontWeight: FontWeightMapper.toFontKey(titleLabel?.fontWeight),
      fontFamily: titleLabel?.fontFamily,
      hintText: 'Enter your title here...',
    );
    this.currentEditableItemNotifier = ValueNotifier<CurrentEditableItem>(null);
  }

  factory UpdateHelperViewModel.fromHelperViewModel(HelperViewModel model) {
    final updateHelper = UpdateHelperViewModel(
      id: model.id,
      name: model.name,
      triggerType: model.triggerType,
      priority: model.priority,
      minVersionCode: model.minVersionCode,
      maxVersionCode: model.maxVersionCode,
      helperTheme: model.helperTheme,
    );

    if (model is UpdateHelperViewModel) {
      updateHelper.bodyBox = model?.bodyBox;
      updateHelper.language = model?.language;
      updateHelper.titleField = model?.titleField;
      updateHelper.thanksButton = model?.thanksButton;
      updateHelper.changelogsFields = model?.changelogsFields;
      updateHelper.media = model?.media;
    }

    return updateHelper;
  }

  factory UpdateHelperViewModel.fromHelperEntity(HelperEntity helperEntity) {
    Map<String, TextFormFieldNotifier> changelogsMap = {};
    List<HelperTextViewModel> changelogs = HelperSharedFactory.parseTextsLabel(
      UpdatescreenHelperKeys.LINES_KEY,
      helperEntity?.helperTexts,
    );

    if (changelogs != null && changelogs.length > 0) {
      for (var changelog in changelogs) {
        changelogsMap.putIfAbsent(
          'template_${changelog.id.toString()}',
            () => TextFormFieldNotifier(
            id: changelog?.id,
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
      minVersionCode: helperEntity?.versionMin,
      maxVersionCode: helperEntity?.versionMax,
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
    String textFieldId = changelogsFields.length.toString();
    this.changelogsFields.putIfAbsent(
      textFieldId,
      () => TextFormFieldNotifier(
          text: '',
          fontSize: 18,
          fontColor: Colors.white
      ),
    );
    return textFieldId;
  }

  List<dynamic> get fields => [
    titleField,
    ...changelogsFields.values,
    thanksButton
  ];  
}
