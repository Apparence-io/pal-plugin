import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';

class AnchoredFullscreenHelperViewModel extends MVVMModel {

  final HelperViewModel helper;
  // Elements on user page
  Map<String, WidgetElementModel> userPageElements;
  // Rect where we will write our helper text
  Rect writeArea;
  String title, description;


  AnchoredFullscreenHelperViewModel({
    @required this.helper,
  });

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