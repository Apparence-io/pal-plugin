import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/helper/helper_theme.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';

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

  AnchoredFullscreenHelperViewModel({
    String id,
    String name,
    HelperTriggerType triggerType,
    int priority,
    String minVersionCode,
    String maxVersionCode,
    HelperTheme helperTheme,
    this.anchorValidated = false
  }) : titleField = TextFormFieldNotifier(
        fontColor: Colors.white,
        fontSize: 31,
        text: '',
      ),
      descriptionField = TextFormFieldNotifier(
        fontColor: Colors.white,
        fontSize: 20,
        text: '',
      ),
      positivBtnField = TextFormFieldNotifier(
        fontColor: Colors.white,
        fontSize: 20,
        text: 'Ok, thanks!',
      ),
      negativBtnField = TextFormFieldNotifier(
        fontColor: Colors.white,
        fontSize: 15,
        text: 'This is not helping',
      ),
      backgroundBox = BoxNotifier(
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
    return AnchoredFullscreenHelperViewModel(
      id: model.id,
      name: model.name,
      priority: model.priority,
      minVersionCode: model.minVersionCode,
      maxVersionCode: model.maxVersionCode,
      helperTheme: model.helperTheme,
      triggerType: model.triggerType,
    );
  }

}

class WidgetElementModel {
  final Rect rect;
  final Offset offset;
  bool selected;

  WidgetElementModel(this.rect, this.offset) {
   selected = false;
  }
}