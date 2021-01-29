import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/graphic_entity.dart';
import 'package:pal/src/services/editor/helper/helper_editor_models.dart';
import 'package:pal/src/services/editor/helper/helper_editor_service.dart';
import 'package:pal/src/services/finder/finder_service.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_data.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_sending_overlay.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/editor_toolbox_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/font_editor/font_editor_viewmodel.dart';

import '../../helper_editor_factory.dart';
import 'editor_anchored_helper.dart';
import 'editor_anchored_helper_viewmodel.dart';

// this is the key used in our editor to inject all widgets in
const EDITOR_PARENT_NODE_KEY = "EditorPage";

class EditorAnchoredFullscreenPresenter extends Presenter<
    AnchoredFullscreenHelperViewModel, EditorAnchoredFullscreenHelperView> {
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
      this.parameters)
      : super(viewModel, viewInterface) {
    assert(finderService != null, 'A finder service must be provided');
  }

  @override
  void onInit() {
    this.viewModel.userPageElements = Map();
    this.viewModel.canValidate = new ValueNotifier(false);
  }

  @override
  void afterViewInit() async {
    await scanElements();
    // FIXME: Useful ??
    // if (viewModel.backgroundBox.key != null) {
    //   await this.onTapElement(viewModel.backgroundBox.key);
    //   await validateSelection();
    // } else {
    //   viewInterface.showTutorial("First step",
    //       "Select the widget you want to explain on the overlayed page.\r\n\r\nNote: if you don't have your widget selectable, just add a key on it.");
    // }
    viewInterface.showTutorial("First step",
          "Select the widget you want to explain on the overlayed page.\r\n\r\nNote: if you don't have your widget selectable, just add a key on it.");
  }

  @override
  void onDestroy() {
    this.viewModel.canValidate.dispose();

    super.onDestroy();
  }

  Future resetSelection() async {
    await scanElements();
    viewModel.anchorValidated = false;
    viewModel.backgroundBox.backgroundColor =
        Colors.lightGreenAccent.withOpacity(0.6);
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
    if (viewModel.anchorValidated) return;
    var previouslySelected = viewModel.selectedAnchor;
    if (previouslySelected != null) {
      previouslySelected.value.selected = false;
    }
    if (!viewModel.userPageElements.containsKey(key)) {
      debugPrint(
          "key cannot be found : ${viewModel.userPageElements.keys.length} keys found");
      viewModel.userPageElements.keys
          .forEach((element) => debugPrint("=> $element"));
      viewInterface.showErrorMessage(
          "Key cannot be found on page. Did you remove this element?");
      return;
    }
    viewModel.userPageElements[key].selected = true;
    var element = await finderService.searchChildElement(key);
    viewModel.writeArea = await finderService.getLargestAvailableSpace(element);
    refreshView();
    refreshAnimations();
  }

  Future validateSelection() async {
    if (viewModel.selectedAnchorKey == null) {
      return;
    }
    if (viewModel.id == null) {
      viewModel.backgroundBox.backgroundColor = Colors.blueGrey.shade900;
    }
    viewModel.anchorValidated = true;
    refreshView();
  }

  updateBackgroundColor(Color newColor) {
    viewModel.backgroundBox.backgroundColor = newColor;
    this.refreshView();
  }

  // save and cancel
  Future onValidate() async {
    ValueNotifier<SendingStatus> status =
        new ValueNotifier(SendingStatus.SENDING);
    final config = CreateHelperConfig.from(parameters.pageId, viewModel);
    try {
      await viewInterface.showLoadingScreen(status);
      await Future.delayed(Duration(seconds: 1));
      await helperEditorService.saveAnchoredWidget(
          EditorEntityFactory.buildAnchoredScreenArgs(config, viewModel));
      status.value = SendingStatus.SENT;
    } catch (error) {
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

  void _updateValidState() {
    viewModel.canValidate.value = isValid();
    this.refreshView();
  }

  bool isValid() =>
      viewModel.titleField.text.isNotEmpty &&
      viewModel.descriptionField.text.isNotEmpty;

  onPreview() {
    this.viewInterface.showPreviewOfHelper(
        this.viewModel, this.finderService, this.isTestingMode);
  }

  onTextPickerDone(String newVal) {
    EditableTextData formData =
        this.viewModel.currentEditableItemNotifier.value;
    formData.text = newVal;
    this.refreshView();
    this._updateValidState();
  }

  onFontPickerDone(EditedFontModel newVal) {
    EditableTextData formData =
        this.viewModel.currentEditableItemNotifier.value;
    formData.fontSize = newVal.size.toInt();
    formData.fontFamily = newVal.fontKeys.fontFamilyNameKey;
    formData.fontWeight = newVal.fontKeys.fontWeightNameKey;

    this.refreshView();
    this._updateValidState();
  }

  onMediaPickerDone(GraphicEntity newVal) {
    EditableMediaFormData formData =
        this.viewModel.currentEditableItemNotifier.value;
    formData.url = newVal.url;
    formData.uuid = newVal.id;
    this.refreshView();
    this._updateValidState();
  }

  onTextColorPickerDone(Color newVal) {
    EditableTextData formData =
        this.viewModel.currentEditableItemNotifier.value;
    formData.fontColor = newVal;
    this.refreshView();
    this._updateValidState();
  }

  onNewEditableSelect(EditableData editedData) {
    this.viewModel.currentEditableItemNotifier.value = editedData;
    this.refreshView();
  }
}
