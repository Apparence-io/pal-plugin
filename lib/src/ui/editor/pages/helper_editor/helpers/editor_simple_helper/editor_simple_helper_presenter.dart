import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/services/editor/helper/helper_editor_models.dart';
import 'package:pal/src/services/editor/helper/helper_editor_service.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/font_editor/font_editor_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_factory.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_notifiers.dart';
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
      super(simpleHelperViewModel, viewInterface) {
    viewModel.canValidate = new ValueNotifier(false);
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  Future onDestroy() async {
    super.onDestroy();
    editableTextFieldController.close();
    // fixme =>  mvvm_builder add afterDestroy method
    // viewModel.canValidate.dispose();
    // viewModel.canValidate = null;
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

  onOutsideTap() => this.editableTextFieldController.add(true);

  onDetailsFieldChanged(String id, String newValue)
    => _onTextChanged(viewModel.detailsField, newValue);

  onDetailsTextStyleChanged(String id, TextStyle newTextStyle, FontKeys fontKeys)
    => _onStyleChanged(viewModel.detailsField, newTextStyle, fontKeys);
  
  onDetailsFieldSubmitted(String value) => this.refreshView();

  String validateDetailsTextField(String currentValue) {
    if (currentValue.length <= 0) {
      return 'Please enter some text';
    }
    if (currentValue.length > 45) {
      return 'Maximum 45 characters';
    }
    return null;
  }

  onChangeColorRequest()
    => viewInterface.showColorPickerDialog(
      viewModel,
      this.updateBackgroundColor,
      this.viewInterface.closeColorPickerDialog
    );

  updateBackgroundColor(Color aColor) {
    viewModel.bodyBox.backgroundColor.value = aColor;
    this.refreshView();
    this.viewInterface.closeColorPickerDialog();
  }

  // ----------------------------------
  // PRIVATES
  // ----------------------------------

  _onTextChanged(TextFormFieldNotifier textNotifier, String newValue) {
    textNotifier.text.value = newValue;
    if(viewModel.canValidate != null)  {
      _updateValidState();
    }
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

  bool isValid() => viewModel.detailsField.text.value.isNotEmpty;

}