import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/services/editor/helper/helper_editor_models.dart';
import 'package:pal/src/services/editor/helper/helper_editor_service.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_factory.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_sending_overlay.dart';

import 'editor_simple_helper.dart';
import 'editor_simple_helper_viewmodel.dart';

class EditorSimpleHelperPresenter extends Presenter<SimpleHelperViewModel, EditorSimpleHelperView>{

  final EditorHelperService editorHelperService;

  final HelperEditorPageArguments parameters;

  final StreamController<bool> editableTextFieldController;

  EditorSimpleHelperPresenter(
    EditorSimpleHelperView viewInterface,
    SimpleHelperViewModel simpleHelperViewModel,
    this.editorHelperService,
    this.parameters
  ) : editableTextFieldController = StreamController<bool>.broadcast(),
      super(simpleHelperViewModel, viewInterface);

  @override
  void onInit() {
    super.onInit();
    viewModel.canValidate = new ValueNotifier(false);
    viewModel.currentSelectedEditableNotifier = ValueNotifier(null);
  }

  @override
  Future onDestroy() async {
    editableTextFieldController.close();
    super.onDestroy();
  }

  onTextPickerDone() {
    this._updateValidState();
    this.refreshView();
  }

  Future onValidate() async {
    ValueNotifier<SendingStatus> status = new ValueNotifier(SendingStatus.SENDING);
    final config = CreateHelperConfig.from(parameters.pageId, viewModel);
    try {
      await viewInterface.showLoadingScreen(status);
      await Future.delayed(Duration(seconds: 1));
      await editorHelperService.saveSimpleHelper(
        EditorEntityFactory.buildSimpleArgs(config, viewModel));
      status.value = SendingStatus.SENT;
    } catch(error) {
      print("error: $error");
      status.value = SendingStatus.ERROR;
    } finally {
      await Future.delayed(Duration(seconds: 2));
      viewInterface.closeLoadingScreen();
      await Future.delayed(Duration(milliseconds: 100));
      status.dispose();
      viewInterface.closeEditor();
    }
  }

  void onCancel() {
    viewInterface.closeEditor();
  }

  String validateDetailsTextField(String currentValue) {
    if (currentValue.length <= 0) {
      return 'Please enter some text';
    }
    if (currentValue.length > 45) {
      return 'Maximum 45 characters';
    }
    return null;
  }
  updateBackgroundColor(Color aColor) {
    viewModel.bodyBox.backgroundColor.value = aColor;
    this.refreshView();
    // this.viewInterface.closeColorPickerDialog();
  }

  // ----------------------------------
  // PRIVATES
  // ----------------------------------

  
  _updateValidState() => viewModel.canValidate.value = isValid();

  bool isValid() => viewModel.contentTextForm.text.value.isNotEmpty;

  onPreview() {
    this.viewInterface.showPreviewOfHelper(this.viewModel);
  }

}