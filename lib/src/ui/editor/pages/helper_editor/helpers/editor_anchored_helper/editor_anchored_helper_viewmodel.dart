import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';

class AnchoredFullscreenHelperViewModel extends MVVMModel {

  final HelperViewModel helper;

  /// Elements on user page
  Map<String, WidgetElementModel> userPageElements;

  /// Rect where we will write our helper text
  Rect writeArea;

  String title, description;

  /// true if user has validated the current anchor selection
  bool anchorValidated;

  AnchoredFullscreenHelperViewModel({
    @required this.helper,
    this.anchorValidated = false
  });

  /// the current selected element to show anchor
  MapEntry<String, WidgetElementModel> get selectedAnchor => userPageElements.entries.firstWhere(
      (element) => element.value.selected, orElse: () => null);

  /// the current selected element's key to show anchor
  String get selectedAnchorKey => userPageElements.entries
    .firstWhere((element) => element.value.selected, orElse: () => null)?.key;

  /// [userPageElements] without selected anchor
  Map<String, WidgetElementModel> get userPageSelectableElements => Map.from(userPageElements)
    ..removeWhere((key, value) => key == selectedAnchorKey);
}

class WidgetElementModel {
  final Rect rect;
  final Offset offset;
  bool selected;

  WidgetElementModel(this.rect, this.offset) {
   selected = false;
  }
}