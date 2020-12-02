import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/font_editor/pickers/font_weight_picker/font_weight_picker_loader.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_notifiers.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_theme.dart';
import 'package:pal/src/ui/shared/helper_shared_factory.dart';
import 'package:pal/src/ui/shared/helper_shared_viewmodels.dart';

class HelperEditorViewModel extends MVVMModel {
  bool enableSave;
  bool isLoading;
  bool isEditableWidgetValid;
  bool isEditingWidget;
  bool isKeyboardOpened;
  double loadingOpacity;
  bool isHelperCreated;
  bool isHelperCreating;

  // This the template view model with all default values
  HelperViewModel templateViewModel;

  // This is the actual edited widget view model
  HelperViewModel helperViewModel;
}

// this is used to let user choose between all available type options
class HelperTypeOption {
  String text;
  HelperType type;
  IconData icon;

  HelperTypeOption(
    this.text,
    this.type, {
    this.icon = Icons.border_outer,
  });
}

class HelperViewModel extends MVVMModel {
  final String id;
  final String name;
  final HelperTriggerType triggerType;
  final int priority;
  final int versionMinId;
  final int versionMaxId;
  final HelperTheme helperTheme;
  final HelperType helperType;

  HelperViewModel({
    this.id,
    @required this.name,
    @required this.triggerType,
    this.priority,
    this.versionMinId,
    @required this.helperType,
    this.helperTheme,
    this.versionMaxId,
  });
}



class UpdateHelperViewModel extends HelperViewModel {
  LanguageNotifier language;
  BoxNotifier bodyBox;
  Map<String, TextFormFieldNotifier> changelogsFields;
  MediaNotifier media;
  TextFormFieldNotifier thanksButton;
  TextFormFieldNotifier titleField;

  UpdateHelperViewModel({
    String id,
    @required String name,
    @required HelperTriggerType triggerType,
    @required int priority,
    @required int versionMinId,
    @required HelperTheme helperTheme,
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
          versionMinId: versionMinId,
          versionMaxId: versionMaxId,
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
    this.thanksButton = TextFormFieldNotifier(
      // backgroundColor: Colors.black87,
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
  }

  factory UpdateHelperViewModel.fromHelperViewModel(HelperViewModel model) {
    final updateHelper = UpdateHelperViewModel(
      name: model.name,
      triggerType: model.triggerType,
      priority: model.priority,
      versionMinId: model.versionMinId,
      versionMaxId: model.versionMaxId,
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
      versionMinId: helperEntity?.versionMinId,
      versionMaxId: helperEntity?.versionMaxId,
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
}
