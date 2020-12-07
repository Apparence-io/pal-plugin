import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/services/editor/finder/finder_service.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';

import 'editor_anchored_helper.dart';
import 'editor_anchored_helper_viewmodel.dart';

// this is the key used in our editor to inject all widgets in
const EDITOR_PARENT_NODE_KEY = "EditorPage";

class EditorAnchoredFullscreenPresenter extends Presenter<AnchoredFullscreenHelperViewModel, EditorAnchoredFullscreenHelperView> {
  final FinderService finderService;

  EditorAnchoredFullscreenPresenter(EditorAnchoredFullscreenHelperView viewInterface, this.finderService)
    : super(
        AnchoredFullscreenHelperViewModel(
          helper: HelperViewModel(
          name: 'test',
          triggerType: HelperTriggerType.ON_SCREEN_VISIT,
          helperType: HelperType.ANCHORED_OVERLAYED_HELPER,
        )
      ), viewInterface) {
    assert(finderService != null, 'A finder service must be provided');
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
  Future scanElements() async {
    var elements = await finderService.scan();
    // var bounds = elementFinder.scan(omitChildsOf: ValueKey(EDITOR_PARENT_NODE_KEY));
    viewModel.userPageElements = elements.map((key, value) =>
        new MapEntry(key, new WidgetElementModel(value.bounds, value.offset)));
    refreshView();
  }

  Future onTapElement(String key) async {
    var previouslySelected = viewModel.selectedAnchor;
    if (previouslySelected != null) {
      previouslySelected.value.selected = false;
    }
    viewModel.userPageElements[key].selected = true;
    var element = await finderService.searchChildElement(key);
    viewModel.writeArea = await finderService.getLargestAvailableSpace(element);
    refreshView();
  }
}
