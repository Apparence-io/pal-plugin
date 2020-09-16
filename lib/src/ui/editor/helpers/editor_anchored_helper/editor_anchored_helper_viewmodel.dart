import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/database/entity/helper/helper_trigger_type.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';

class AnchoredFullscreenHelperViewModel extends MVVMModel {

  final String name;
  final HelperTriggerType triggerType;
  final int priority;
  final int versionMinId;
  final int versionMaxId;
  // Elements on user page
  Map<String, WidgetElementModel> userPageElements;
  // Rect where we will write our helper text
  Rect writeArea;
  String title, description;


  AnchoredFullscreenHelperViewModel({
    @required this.name,
    @required this.triggerType,
    @required this.priority,
    @required this.versionMinId,
    this.versionMaxId,
  });

  factory AnchoredFullscreenHelperViewModel.fromHelperViewModel(HelperViewModel model)
    => AnchoredFullscreenHelperViewModel(
      name: model.name,
      triggerType: model.triggerType,
      priority: model.priority,
      versionMinId: model.versionMinId,
      versionMaxId: model.versionMaxId,
    );

  // the current selected element to show anchor
  MapEntry<String, WidgetElementModel> get selectedAnchor => userPageElements.entries.firstWhere(
      (element) => element.value.selected, orElse: () => null);

  // the current selected element's key to show anchor
  String get selectedAnchorKey => userPageElements.entries.firstWhere(
      (element) => element.value.selected, orElse: () => null).key;
}

class WidgetElementModel {
  final Rect rect;
  final Offset offset;
  bool selected;

  WidgetElementModel(this.rect, this.offset) {
   selected = false;
  }
}