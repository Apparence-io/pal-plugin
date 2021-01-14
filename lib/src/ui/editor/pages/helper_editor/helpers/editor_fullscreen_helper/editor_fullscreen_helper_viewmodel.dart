import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_theme.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_notifiers.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/font_editor/pickers/font_weight_picker/font_weight_picker_loader.dart';
import 'package:pal/src/ui/shared/helper_shared_factory.dart';
import 'package:pal/src/ui/shared/helper_shared_viewmodels.dart';


class FullscreenHelperViewModel extends HelperViewModel {

  // form
  double helperOpacity;
  ValueNotifier<bool> canValidate;
  StreamController<bool> editableTextFieldController;

  // helper properties
  LanguageNotifier language;
  BoxNotifier bodyBox;
  MediaNotifier media;
  TextFormFieldNotifier titleField;
  TextFormFieldNotifier descriptionField;
  TextFormFieldNotifier positivButtonField;
  TextFormFieldNotifier negativButtonField;

  FullscreenHelperViewModel({
    String id,
    @required String name,
    @required HelperTriggerType triggerType,
    @required int priority,
    @required HelperTheme helperTheme,
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
    triggerType: triggerType,
    priority: priority,
    minVersionCode: minVersionCode,
    maxVersionCode: maxVersionCode,
    helperTheme: helperTheme,
    helperType: HelperType.HELPER_FULL_SCREEN,
  ) {
    this.language = LanguageNotifier(
      id: languageId ?? 1,
    );
    this.bodyBox = BoxNotifier(
      id: boxViewModel?.id,
      backgroundColor: boxViewModel?.backgroundColor ?? Colors.blueAccent,
    );
    this.media = MediaNotifier(
      id: helperImageViewModel?.id,
      url: helperImageViewModel?.url,
    );
    this.titleField = TextFormFieldNotifier(
      titleViewModel?.id,
      fontColor: titleViewModel?.fontColor ?? Colors.white,
      fontSize: titleViewModel?.fontSize?.toInt() ?? 60,
      fontFamily: titleViewModel?.fontFamily,
      text: titleViewModel?.text ?? '',
      fontWeight: FontWeightMapper.toFontKey(titleViewModel?.fontWeight),
    );
    this.descriptionField = TextFormFieldNotifier(
      descriptionLabel?.id,
      fontColor: descriptionLabel?.fontColor ?? Colors.white,
      fontSize: descriptionLabel?.fontSize?.toInt() ?? 14,
      text: descriptionLabel?.text ?? 'Describe me',
      fontWeight: FontWeightMapper.toFontKey(descriptionLabel?.fontWeight),
      fontFamily: descriptionLabel?.fontFamily,
    );
    this.positivButtonField = TextFormFieldNotifier(
      positivButtonLabel?.id,
      fontColor: positivButtonLabel?.fontColor ?? Colors.white,
      fontSize: positivButtonLabel?.fontSize?.toInt() ?? 23,
      text: positivButtonLabel?.text ?? 'Ok, thanks !',
      fontWeight: FontWeightMapper.toFontKey(
        positivButtonLabel?.fontWeight ?? FontWeight.bold,
      ),
      fontFamily: positivButtonLabel?.fontFamily,
    );
    this.negativButtonField = TextFormFieldNotifier(
      negativButtonLabel?.id,
      text: negativButtonLabel?.text ?? 'This is not helping',
      fontWeight: FontWeightMapper.toFontKey(
        negativButtonLabel?.fontWeight ?? FontWeight.bold),
      fontColor: negativButtonLabel?.fontColor ?? Colors.white,
      fontSize: negativButtonLabel?.fontSize?.toInt() ?? 13,
      fontFamily: negativButtonLabel?.fontFamily,
    );
  }

  factory FullscreenHelperViewModel.fromHelperViewModel(HelperViewModel model) {
    final fullscreenHelper = FullscreenHelperViewModel(
      id: model.id,
      name: model.name,
      triggerType: model.triggerType,
      priority: model.priority,
      maxVersionCode: model.maxVersionCode,
      minVersionCode: model.minVersionCode,
      helperTheme: model.helperTheme,
    );
    if (model is FullscreenHelperViewModel) {
      fullscreenHelper.bodyBox = model?.bodyBox;
      fullscreenHelper.language = model?.language;
      fullscreenHelper.titleField = model?.titleField;
      fullscreenHelper.descriptionField = model?.descriptionField;
      fullscreenHelper.positivButtonField = model?.positivButtonField;
      fullscreenHelper.negativButtonField = model?.negativButtonField;
      fullscreenHelper.media = model?.media;
    }

    return fullscreenHelper;
  }

  factory FullscreenHelperViewModel.fromHelperEntity(HelperEntity helperEntity) =>
    FullscreenHelperViewModel(
      id: helperEntity?.id,
      name: helperEntity?.name,
      triggerType: helperEntity?.triggerType,
      priority: helperEntity?.priority,
      minVersionCode: helperEntity?.versionMin,
      maxVersionCode: helperEntity?.versionMax,
      helperTheme: null,
      boxViewModel: HelperSharedFactory.parseBoxBackground(
        SimpleHelperKeys.BACKGROUND_KEY,
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

  List<TextFormFieldNotifier> get fields => [
    titleField,
    descriptionField,
    positivButtonField,
    negativButtonField,
  ];  
}