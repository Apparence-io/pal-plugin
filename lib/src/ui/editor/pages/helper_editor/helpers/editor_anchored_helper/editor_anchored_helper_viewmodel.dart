import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_theme.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/extensions/color_extension.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/font_editor/pickers/font_weight_picker/font_weight_picker_loader.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';
import 'package:pal/src/ui/shared/helper_shared_factory.dart';
import 'package:pal/src/ui/shared/helper_shared_viewmodels.dart';

import '../../helper_editor.dart';
import '../../helper_editor_notifiers.dart';

class AnchoredFullscreenHelperViewModel extends HelperViewModel {

  /// Elements on user page
  Map<String, WidgetElementModel> userPageElements;

  /// Rect where we will write our helper text
  Rect writeArea;

  /// background color notifier
  BoxNotifier backgroundBox;

  /// enables the save button
  ValueNotifier<bool> canValidate;

  /// titleField notifier including style
  TextFormFieldNotifier titleField;

  /// descriptionField notifier including style
  TextFormFieldNotifier descriptionField;

  /// buttons textNotifiers
  TextFormFieldNotifier positivBtnField, negativBtnField;

  /// true if user has validated the current anchor selection
  bool anchorValidated;

  AnchoredFullscreenHelperViewModel._({
    String id,
    String name,
    HelperTriggerType triggerType,
    int priority,
    String minVersionCode,
    String maxVersionCode,
    HelperTheme helperTheme,
    BoxNotifier backgroundBox,
    HelperTextViewModel titleViewModel,
    HelperTextViewModel descriptionLabel,
    HelperTextViewModel positivButtonLabel,
    HelperTextViewModel negativButtonLabel,
    this.anchorValidated = false
  }) : titleField = TextFormFieldNotifier(
        id: titleViewModel?.id,
        fontColor: titleViewModel?.fontColor ?? Colors.white,
        fontSize: titleViewModel?.fontSize?.toInt() ?? 31,
        text: titleViewModel?.text ?? '',
        fontWeight: FontWeightMapper.toFontKey(titleViewModel?.fontWeight ?? FontWeight.normal),
      ),
      descriptionField = TextFormFieldNotifier(
        id: descriptionLabel?.id,
        fontColor: descriptionLabel?.fontColor ?? Colors.white,
        fontSize: descriptionLabel?.fontSize?.toInt() ?? 20,
        text: descriptionLabel?.text ?? '',
        fontWeight: FontWeightMapper.toFontKey(descriptionLabel?.fontWeight ?? FontWeight.normal),
        fontFamily: descriptionLabel?.fontFamily,
      ),
      positivBtnField = TextFormFieldNotifier(
        id: positivButtonLabel?.id,
        fontColor: positivButtonLabel?.fontColor ?? Colors.white,
        fontSize: positivButtonLabel?.fontSize?.toInt() ?? 20,
        text: positivButtonLabel?.text ?? 'Ok, thanks!',
        fontWeight: FontWeightMapper.toFontKey(positivButtonLabel?.fontWeight ?? FontWeight.normal),
      ),
      negativBtnField = TextFormFieldNotifier(
        id: negativButtonLabel?.id,
        text: negativButtonLabel?.text ?? 'This is not helping',
        fontWeight: FontWeightMapper.toFontKey(negativButtonLabel?.fontWeight ?? FontWeight.normal),
        fontColor: negativButtonLabel?.fontColor ?? Colors.white,
        fontSize: negativButtonLabel?.fontSize?.toInt() ?? 15,
        fontFamily: negativButtonLabel?.fontFamily,
      ),
      backgroundBox = backgroundBox ?? BoxNotifier(
        backgroundColor: Colors.lightGreenAccent.withOpacity(.6)
      ),
      super(
        id: id,
        helperType: HelperType.ANCHORED_OVERLAYED_HELPER,
        name: name,
        priority: priority,
        minVersionCode: minVersionCode,
        maxVersionCode: maxVersionCode,
        helperTheme: helperTheme,
        triggerType: triggerType
      );

  /// the current selected element to show anchor
  MapEntry<String, WidgetElementModel> get selectedAnchor => userPageElements.entries.firstWhere(
      (element) => element.value.selected, orElse: () => null);

  /// the current selected element's key to show anchor
  String get selectedAnchorKey => userPageElements.entries
    .firstWhere((element) => element.value.selected, orElse: () => null)?.key;

  /// [userPageElements] without selected anchor
  Map<String, WidgetElementModel> get userPageSelectableElements => Map.from(userPageElements)
    ..removeWhere((key, value) => key == selectedAnchorKey);

  factory AnchoredFullscreenHelperViewModel.fromModel(HelperViewModel model) {
    return AnchoredFullscreenHelperViewModel._(
      id: model.id,
      name: model.name,
      priority: model.priority,
      minVersionCode: model.minVersionCode,
      maxVersionCode: model.maxVersionCode,
      helperTheme: model.helperTheme,
      triggerType: model.triggerType,
    );
  }

  factory AnchoredFullscreenHelperViewModel.fromEntity(HelperEntity entity) {
    return AnchoredFullscreenHelperViewModel._(
      id: entity?.id,
      name: entity?.name,
      priority: entity.priority,
      minVersionCode: entity.versionMin,
      maxVersionCode: entity?.versionMax,
      helperTheme: null,
      triggerType: entity?.triggerType,
      backgroundBox: BoxNotifier(
        key: entity.helperBoxes.first.key,
        backgroundColor: HexColor?.fromHex(entity.helperBoxes.first.backgroundColor)
      ),
      titleViewModel: HelperSharedFactory.parseTextLabel(
        FullscreenHelperKeys.TITLE_KEY,
        entity?.helperTexts,
      ),
      descriptionLabel: HelperSharedFactory.parseTextLabel(
        FullscreenHelperKeys.DESCRIPTION_KEY,
        entity?.helperTexts,
      ),
      positivButtonLabel: HelperSharedFactory.parseTextLabel(
        FullscreenHelperKeys.POSITIV_KEY,
        entity?.helperTexts,
      ),
      negativButtonLabel: HelperSharedFactory.parseTextLabel(
        FullscreenHelperKeys.NEGATIV_KEY,
        entity?.helperTexts,
      ),
    );
  }

  List<TextFormFieldNotifier> get fields => [
    titleField,
    descriptionField,
    positivBtnField,
    negativBtnField
  ];

}

class WidgetElementModel {
  final Rect rect;
  final Offset offset;
  bool selected;

  WidgetElementModel(this.rect, this.offset) {
   selected = false;
  }
}