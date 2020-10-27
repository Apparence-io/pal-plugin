import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_simple_helper/editor_simple_helper.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_simple_helper/editor_simple_helper_viewmodel.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/font_editor/font_editor_viewmodel.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';

class EditorSimpleHelperPresenter extends Presenter<EditorSimpleHelperModel, EditorSimpleHelperView>{
  final SimpleHelperViewModel simpleHelperViewModel;

  EditorSimpleHelperPresenter(
    EditorSimpleHelperView viewInterface,
    this.simpleHelperViewModel,
  ) : super(EditorSimpleHelperModel(), viewInterface);

  @override
  void onInit() {
    super.onInit();

    this.viewModel.editableTextFieldController = StreamController<bool>.broadcast();

    // Init keys
    this.viewModel.containerKey = GlobalKey();
    this.viewModel.formKey = GlobalKey<FormState>();
  }

  @override
  Future onDestroy() async {
    this.viewModel.editableTextFieldController.close();
    super.onDestroy();
  }

  onDetailsFieldChanged(Key key, String newValue) {
    simpleHelperViewModel.detailsField?.text?.value = newValue;
  }

  onOutsideTap() {
    this.viewModel.editableTextFieldController.add(true);
  }

  onDetailsTextStyleChanged(Key key, TextStyle newTextStyle, FontKeys fontKeys) {
    simpleHelperViewModel.detailsField?.fontColor?.value =
        newTextStyle?.color;
    simpleHelperViewModel.detailsField?.fontSize?.value =
        newTextStyle?.fontSize?.toInt();

    if (fontKeys != null) {
      simpleHelperViewModel.detailsField?.fontWeight?.value =
          fontKeys.fontWeightNameKey;
      simpleHelperViewModel.detailsField?.fontFamily?.value =
          fontKeys.fontFamilyNameKey;
    }
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
    simpleHelperViewModel.backgroundColor.value = aColor;
    this.refreshView();
  }
}