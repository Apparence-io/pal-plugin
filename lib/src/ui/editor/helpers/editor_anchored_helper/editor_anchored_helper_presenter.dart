import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_anchored_helper/editor_anchored_helper_viewmodel.dart';
import 'package:palplugin/src/ui/shared/utilities/element_finder.dart';

import 'editor_anchored_helper.dart';

// this is the key used in our editor to inject all widgets in
const EDITOR_PARENT_NODE_KEY = "EditorPage";

class EditorAnchoredFullscreenPresenter extends Presenter<AnchoredFullscreenHelperViewModel, EditorAnchoredFullscreenHelperView> {

  final ElementFinder elementFinder;

  EditorAnchoredFullscreenPresenter(EditorAnchoredFullscreenHelperView viewInterface, this.elementFinder)
    : super(AnchoredFullscreenHelperViewModel(), viewInterface) {
    viewModel.userPageElements = Map();
    viewModel.title = "My helper title";
    viewModel.description = "Lorem ipsum lorem ipsum lorem ipsum";
  }

  @override
  void afterViewInit() {
    scanElements();
  }

  // this methods scan elements on the user page we want to add an helper
  // this load all elements with their bounds + key
  scanElements() {
    var bounds = elementFinder.scan(omitChildsOf: ValueKey(EDITOR_PARENT_NODE_KEY));
    viewModel.userPageElements = bounds.map((key, value) => new MapEntry(key, new WidgetElementModel(value.bounds, value.offset)));
    refreshView();
  }

  void onTapElement(String key) {
    var previouslySelected = viewModel.selectedAnchor;
    if(previouslySelected != null) {
      previouslySelected.value.selected = false;
    }
    viewModel.userPageElements[key].selected = true;
    elementFinder.searchChildElement(key);
    viewModel.writeArea = elementFinder.getLargestAvailableSpace();
    refreshView();
  }
}


