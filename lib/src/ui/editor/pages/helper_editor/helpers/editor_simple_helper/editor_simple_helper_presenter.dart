import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/services/editor/helper/helper_editor_models.dart';
import 'package:pal/src/services/editor/helper/helper_editor_service.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_data.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_factory.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_sending_overlay.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/font_editor/font_editor_viewmodel.dart';

import 'editor_simple_helper.dart';
import 'editor_simple_helper_viewmodel.dart';

class EditorSimpleHelperPresenter
    extends Presenter<SimpleHelperViewModel, EditorSimpleHelperView> {
  final EditorHelperService editorHelperService;

  final HelperEditorPageArguments? parameters;

  bool editMode = false;

  EditorSimpleHelperPresenter(
      EditorSimpleHelperView viewInterface,
      SimpleHelperViewModel simpleHelperViewModel,
      this.editorHelperService,
      this.parameters)
      : super(simpleHelperViewModel, viewInterface);

  @override
  void onInit() {
    super.onInit();

    this.viewModel.loading = true;

    if (this.viewModel.id != null) {
      this.editMode = true;
      this.editorHelperService.getHelper(this.viewModel.id).then((helper) {
        this.viewModel = SimpleHelperViewModel.fromHelperEntity(helper);
        viewModel.canValidate = ValueNotifier(false);
        viewModel.currentSelectedEditableNotifier = ValueNotifier(null);
        this
            .viewModel
            .currentSelectedEditableNotifier!
            .addListener(removeSelectedEditableItems);
        this.viewModel.loading = false;
        this.refreshView();
      });
    } else {
      viewModel.canValidate = ValueNotifier(false);
      viewModel.currentSelectedEditableNotifier = ValueNotifier(null);
      this
          .viewModel
          .currentSelectedEditableNotifier!
          .addListener(removeSelectedEditableItems);
      this.viewModel.loading = false;
      this.refreshView();
    }

    // Refresh UI to remove all selected items
  }

  void removeSelectedEditableItems() {
    if (this.viewModel.currentSelectedEditableNotifier?.value == null) {
      this.refreshView();
    }
  }

  @override
  Future onDestroy() async {
    super.onDestroy();

    this
        .viewModel
        .currentSelectedEditableNotifier
        ?.removeListener(removeSelectedEditableItems);
    this.viewModel.currentSelectedEditableNotifier?.dispose();
  }

  Future onValidate() async {
    ValueNotifier<SendingStatus> status =
        new ValueNotifier(SendingStatus.SENDING);
    final config = CreateHelperConfig.from(parameters!.pageId, viewModel);
    try {
      await viewInterface.showLoadingScreen(status);
      await Future.delayed(Duration(seconds: 1));
      await editorHelperService.saveSimpleHelper(
          EditorEntityFactory.buildSimpleArgs(config, viewModel));
      status.value = SendingStatus.SENT;
    } catch (error) {
      print("error: $error");
      status.value = SendingStatus.ERROR;
    } finally {
      await Future.delayed(Duration(seconds: 2));
      viewInterface.closeLoadingScreen();
      await Future.delayed(Duration(milliseconds: 100));
      status.dispose();
      viewInterface.closeEditor(!this.editMode,false);
    }
  }

  void onCancel() {
    viewInterface.closeEditor(!this.editMode,false);
  }

  String? validateDetailsTextField(String currentValue) {
    if (currentValue.length <= 0) {
      return 'Please enter some text';
    }
    if (currentValue.length > 45) {
      return 'Maximum 45 characters';
    }
    return null;
  }

  // updateBackgroundColor(Color aColor) {
  //   viewModel.bodyBox.backgroundColor.value = aColor;
  //   this.refreshView();
  //   // this.viewInterface.closeColorPickerDialog();
  // }

  onPreview() {
    this.viewInterface.showPreviewOfHelper(this.viewModel);
  }

  onFontPickerDone(EditedFontModel newFont) {
    this.viewModel.contentTextForm!.fontFamily =
        newFont.fontKeys!.fontFamilyNameKey;
    this.viewModel.contentTextForm!.fontWeight =
        newFont.fontKeys!.fontWeightNameKey;
    this.viewModel.contentTextForm!.fontSize = newFont.size!.toInt();
    this._updateValidState();
  }

  onTextPickerDone(String newVal) {
    this.viewModel.contentTextForm!.text = newVal;
    this._updateValidState();
  }

  onTextColorPickerDone(Color newColor) {
    this.viewModel.contentTextForm!.fontColor = newColor;
    this._updateValidState();
  }

  onNewEditableSelect(EditableData? editedData) {
    this.viewModel.currentSelectedEditableNotifier!.value = editedData;
    this.refreshView();
  }

  bool isValid() => viewModel.contentTextForm!.text!.isNotEmpty;

  // ----------------------------------
  // PRIVATES
  // ----------------------------------

  _updateValidState() {
    viewModel.canValidate!.value = isValid();
    this.refreshView();
  }
}
