import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/services/editor/helper/helper_editor_models.dart';
import 'package:pal/src/services/editor/helper/helper_editor_service.dart';
import 'package:pal/src/services/finder/finder_service.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_sending_overlay.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/font_editor/font_editor_viewmodel.dart';

import '../../helper_editor_factory.dart';
import '../../helper_editor_notifiers.dart';
import 'editor_anchored_helper.dart';
import 'editor_anchored_helper_viewmodel.dart';

// this is the key used in our editor to inject all widgets in
const EDITOR_PARENT_NODE_KEY = "EditorPage";

class EditorAnchoredFullscreenPresenter extends Presenter<AnchoredFullscreenHelperViewModel, EditorAnchoredFullscreenHelperView> {

  final FinderService finderService;
  final bool isTestingMode;

  final EditorHelperService helperEditorService;

  final HelperEditorPageArguments parameters;

  EditorAnchoredFullscreenPresenter(
    AnchoredFullscreenHelperViewModel viewModel,
    EditorAnchoredFullscreenHelperView viewInterface, 
    this.finderService,
    this.isTestingMode,
    this.helperEditorService,
    this.parameters
    ): super(viewModel, viewInterface) {
    assert(finderService != null, 'A finder service must be provided');
    if(viewModel.id == null) {
      viewModel.titleField.text.value = "My helper title";
      viewModel.descriptionField.text.value = "Describe your element here";
    } 
    viewModel.userPageElements = Map();
    viewModel.canValidate = new ValueNotifier(false);
  }

  @override
  void onInit() {
    // viewModel.fields.forEach(
    //   (field) => field.toolbarVisibility.addListener(
    //     () => _onTextToolbarVisibilityChange(field)
    //   )
    // );
  }

  @override
  void afterViewInit() async {
    await scanElements();
    if(viewModel.backgroundBox.key != null) {
      await this.onTapElement(viewModel.backgroundBox.key);
      await validateSelection();
    } else {
      viewInterface.showTutorial(
        "First step", 
        "Select the widget you want to explain on the overlayed page.\r\n\r\nNote: if you don't have your widget selectable, just add a key on it."
      );
    }
  }

  Future resetSelection() async {
    await scanElements();
    viewModel.anchorValidated = false;
    viewModel.backgroundBox.backgroundColor.value = Colors.lightGreenAccent.withOpacity(0.6);
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
    if(viewModel.anchorValidated)
      return;
    var previouslySelected = viewModel.selectedAnchor;
    if (previouslySelected != null) {
      previouslySelected.value.selected = false;
    }
    if(!viewModel.userPageElements.containsKey(key)) {
      debugPrint("key cannot be found : ${viewModel.userPageElements.keys.length} keys found");
      viewModel.userPageElements.keys.forEach((element) => debugPrint("=> $element"));
      viewInterface.showErrorMessage("Key cannot be found on page. Did you remove this element?");
      return;
    }
    viewModel.userPageElements[key].selected = true;
    var element = await finderService.searchChildElement(key);
    viewModel.writeArea = await finderService.getLargestAvailableSpace(element);
    refreshView();
    refreshAnimations();
  }

  Future validateSelection() async {
    if(viewModel.selectedAnchorKey == null) {
      return;
    }
    if(viewModel.id == null) {
      viewModel.backgroundBox.backgroundColor.value = Colors.blueGrey.shade900;
    }
    viewModel.anchorValidated = true;
    refreshView();
  }

  onCallChangeBackground() {
    // viewInterface.showColorPickerDialog(
    //   viewModel.backgroundBox.backgroundColor.value,
    //   (color) {
    //     viewModel.backgroundBox.backgroundColor.value = color;
    //     viewInterface.closeColorPickerDialog();
    //     refreshView();
    //   },
    //   () => viewInterface.closeColorPickerDialog()
    // );
  }

  // Title
  onTitleChanged(String id, String newValue)
    => _onTextChanged(viewModel.titleField, newValue);

  onTitleSubmit(String text)
    => _onFieldSubmit(text);

  onTitleTextStyleChanged(String id, TextStyle newTextStyle, FontKeys fontKeys)
   => _onStyleChanged(viewModel.titleField, newTextStyle, fontKeys);

  // Description field
  onDescriptionChanged(String id, String newValue)
    => _onTextChanged(viewModel.descriptionField, newValue);

  onDescriptionSubmit(String text)
    => _onFieldSubmit(text);

  onDescriptionTextStyleChanged(String id, TextStyle newTextStyle, FontKeys fontKeys)
    => _onStyleChanged(viewModel.descriptionField, newTextStyle, fontKeys);

  // Positiv button
  onPositivTextChanged(String id, String newValue)
    => _onTextChanged(viewModel.positivBtnField, newValue);

  onPositivSubmit(String text)
    => _onFieldSubmit(text);

  onPositivTextStyleChanged(String id, TextStyle newTextStyle, FontKeys fontKeys)
    => _onStyleChanged(viewModel.positivBtnField, newTextStyle, fontKeys);

  // Negativ button
  onNegativTextChanged(String id, String newValue)
    => _onTextChanged(viewModel.negativBtnField, newValue);

  onNegativSubmit(String text)
    => _onFieldSubmit(text);

  onNegativTextStyleChanged(String id, TextStyle newTextStyle, FontKeys fontKeys)
    => _onStyleChanged(viewModel.negativBtnField, newTextStyle, fontKeys);

  // save and cancel   
  Future onValidate() async {
    ValueNotifier<SendingStatus> status = new ValueNotifier(SendingStatus.SENDING);
    final config = CreateHelperConfig.from(parameters.pageId, viewModel);
    try {
      await viewInterface.showLoadingScreen(status);
      await Future.delayed(Duration(seconds: 1));
      await helperEditorService
        .saveAnchoredWidget(EditorEntityFactory.buildAnchoredScreenArgs(config, viewModel));
      status.value = SendingStatus.SENT;
    } catch(error) {
      print("error occured $error");
      status.value = SendingStatus.ERROR;
    } finally {
      await Future.delayed(Duration(seconds: 2));
      viewInterface.closeLoadingScreen();
      await Future.delayed(Duration(milliseconds: 100));
      viewInterface.closeEditor();
      await Future.delayed(Duration(seconds: 1));
      status.dispose();
    }
  }

  onCancel() {
    viewInterface.closeEditor();
  }
  
  // ----------------------------------
  // PRIVATES
  // ----------------------------------

  _onTextChanged(TextFormFieldNotifier textNotifier, String newValue) {
    textNotifier.text.value = newValue;
    _updateValidState();
  }

  _onTextToolbarVisibilityChange(TextFormFieldNotifier textNotifier) {
    // if(textNotifier.toolbarVisibility.value) {
    //   viewModel.fields.where((element) => element != textNotifier && element.toolbarVisibility.value)
    //     .forEach((element) => element.toolbarVisibility.value = false);
    // }
  }

  _updateValidState() => viewModel.canValidate.value = isValid();

  _onStyleChanged(TextFormFieldNotifier textNotifier, TextStyle newTextStyle, FontKeys fontKeys) {
    textNotifier?.fontColor?.value = newTextStyle?.color;
    textNotifier?.fontSize?.value = newTextStyle?.fontSize?.toInt();
    if (fontKeys != null) {
      textNotifier?.fontWeight?.value = fontKeys.fontWeightNameKey;
      textNotifier?.fontFamily?.value = fontKeys.fontFamilyNameKey;
    }
    _updateValidState();
  }

  bool isValid() => viewModel.titleField.text.value.isNotEmpty
    && viewModel.descriptionField.text.value.isNotEmpty;

  _onFieldSubmit(String text) {
    this.refreshView();
  }

  onPreview() {
    this.viewInterface.showPreviewOfHelper(this.viewModel,this.finderService, this.isTestingMode);
  }

}
