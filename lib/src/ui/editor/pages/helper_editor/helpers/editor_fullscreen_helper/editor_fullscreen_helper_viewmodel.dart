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


class FullscreenHelperViewModel extends HelperViewModel {

  // form
  double helperOpacity;
  ValueNotifier<bool> canValidate;
  // StreamController<bool> editableTextFieldController;
  ValueNotifier<EditableData> currentEditableItemNotifier;

  // helper properties
  // LanguageNotifier language;
  EditableBoxFormData backgroundBoxForm;
  EditableMediaFormData headerMediaForm;
  EditableTextFormData titleTextForm;
  EditableTextFormData descriptionTextForm;
  EditableButtonFormData positivButtonForm;
  EditableButtonFormData negativButtonForm;

  bool loading;

  FullscreenHelperViewModel({
    String id,
    String name,
    String groupId,
    String groupName,
    HelperTriggerType triggerType,
    int priority,
    HelperTheme helperTheme,
    String minVersionCode,
    String maxVersionCode,
    int versionMaxId,
    int languageId,
    // For edit mode only
    HelperBoxViewModel boxViewModel,
    HelperImageViewModel helperImageViewModel,
    HelperTextViewModel titleViewModel,
    HelperTextViewModel descriptionLabel,
    HelperTextViewModel positivButtonLabel,
    HelperTextViewModel negativButtonLabel,
  }) : super(
    id: id,
    name: name,
    priority: priority,
    helperGroup: HelperGroupModel(
      id: groupId,
      name: groupName,
      triggerType: triggerType,
      minVersionCode: minVersionCode,
      maxVersionCode: maxVersionCode,
    ),
    helperTheme: helperTheme,
    helperType: HelperType.HELPER_FULL_SCREEN,
  ) {
    // this.language = LanguageNotifier(
    //   id: languageId ?? 1,
    // );
    this.backgroundBoxForm = EditableBoxFormData(
      boxViewModel?.id,
      FullscreenHelperKeys.BACKGROUND_KEY,
      backgroundColor: boxViewModel?.backgroundColor ?? Colors.blueAccent,
    );
    this.headerMediaForm = EditableMediaFormData(
      helperImageViewModel?.id,
      FullscreenHelperKeys.IMAGE_KEY,
      url: helperImageViewModel?.url,
    );
    this.titleTextForm = EditableTextFormData(
      titleViewModel?.id,
      FullscreenHelperKeys.TITLE_KEY,
      fontColor: titleViewModel?.fontColor ?? Colors.white,
      fontSize: titleViewModel?.fontSize?.toInt() ?? 55,
      fontFamily: titleViewModel?.fontFamily,
      text: titleViewModel?.text ?? '',
      fontWeight: FontWeightMapper.toFontKey(titleViewModel?.fontWeight),
    );
    this.descriptionTextForm = EditableTextFormData(
      descriptionLabel?.id,
      FullscreenHelperKeys.DESCRIPTION_KEY,
      fontColor: descriptionLabel?.fontColor ?? Colors.white,
      fontSize: descriptionLabel?.fontSize?.toInt() ?? 14,
      text: descriptionLabel?.text ?? '',
      fontWeight: FontWeightMapper.toFontKey(descriptionLabel?.fontWeight),
      fontFamily: descriptionLabel?.fontFamily,
    );
    this.positivButtonForm = EditableButtonFormData(
      positivButtonLabel?.id,
      FullscreenHelperKeys.POSITIV_KEY,
      backgroundColor: Color(0xFF2ecc71),
      fontColor: positivButtonLabel?.fontColor ?? Colors.white,
      fontSize: positivButtonLabel?.fontSize?.toInt() ?? 23,
      text: positivButtonLabel?.text ?? 'Ok, thanks !',
      fontWeight: FontWeightMapper.toFontKey(
        positivButtonLabel?.fontWeight ?? FontWeight.bold,
      ),
      fontFamily: positivButtonLabel?.fontFamily,
    );
    this.negativButtonForm = EditableButtonFormData(
      negativButtonLabel?.id,
      FullscreenHelperKeys.NEGATIV_KEY,
      backgroundColor: Color(0xFFe74c3c),
      text: negativButtonLabel?.text ?? 'This is not helping',
      fontWeight: FontWeightMapper.toFontKey(
        negativButtonLabel?.fontWeight ?? FontWeight.bold),
      fontColor: negativButtonLabel?.fontColor ?? Colors.white,
      fontSize: negativButtonLabel?.fontSize?.toInt() ?? 13,
      fontFamily: negativButtonLabel?.fontFamily,
    );
    this.currentEditableItemNotifier = ValueNotifier<EditableData>(null);
  }

  factory FullscreenHelperViewModel.fromHelperViewModel(HelperViewModel model) {
    final fullscreenHelper = FullscreenHelperViewModel(
      id: model.id,
      name: model.name,
      priority: model.priority,
      minVersionCode: model.helperGroup?.minVersionCode,
      maxVersionCode: model.helperGroup?.maxVersionCode,
      triggerType: model.helperGroup?.triggerType,
      helperTheme: model.helperTheme,
      groupId: model.helperGroup.id,
      groupName: model.helperGroup.name
    );
    if (model is FullscreenHelperViewModel) {
      fullscreenHelper.backgroundBoxForm = model?.backgroundBoxForm;
      // fullscreenHelper.language = model?.language;
      fullscreenHelper.titleTextForm = model?.titleTextForm;
      fullscreenHelper.descriptionTextForm = model?.descriptionTextForm;
      fullscreenHelper.positivButtonForm = model?.positivButtonForm;
      fullscreenHelper.negativButtonForm = model?.negativButtonForm;
      fullscreenHelper.headerMediaForm = model?.headerMediaForm;
    }

    return fullscreenHelper;
  }

  factory FullscreenHelperViewModel.fromHelperEntity(HelperEntity helperEntity) =>
    FullscreenHelperViewModel(
      id: helperEntity?.id,
      name: helperEntity?.name,
      triggerType: helperEntity?.triggerType,
      priority: helperEntity?.priority,
      helperTheme: null,
      boxViewModel: HelperSharedFactory.parseBoxBackground(
        FullscreenHelperKeys.BACKGROUND_KEY,
        helperEntity?.helperBoxes,
      ),
      titleViewModel: HelperSharedFactory.parseTextLabel(
        FullscreenHelperKeys.TITLE_KEY,
        helperEntity?.helperTexts,
      ),
      descriptionLabel: HelperSharedFactory.parseTextLabel(
        FullscreenHelperKeys.DESCRIPTION_KEY,
        helperEntity?.helperTexts,
      ),
      positivButtonLabel: HelperSharedFactory.parseTextLabel(
        FullscreenHelperKeys.POSITIV_KEY,
        helperEntity?.helperTexts,
      ),
      negativButtonLabel: HelperSharedFactory.parseTextLabel(
        FullscreenHelperKeys.NEGATIV_KEY,
        helperEntity?.helperTexts,
      ),
      helperImageViewModel: HelperSharedFactory.parseImageUrl(
        FullscreenHelperKeys.IMAGE_KEY,
        helperEntity?.helperImages,
      ),
    );

  List<EditableTextData> get fields => [
    titleTextForm,
    descriptionTextForm,
    positivButtonForm,
    negativButtonForm,
  ];  
}