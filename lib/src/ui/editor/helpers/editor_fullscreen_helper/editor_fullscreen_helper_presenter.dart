import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_fullscreen_helper/editor_fullscreen_helper.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_fullscreen_helper/editor_fullscreen_helper_viewmodel.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/font_editor/font_editor_viewmodel.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/font_editor/pickers/font_weight_picker/font_weight_picker_loader.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';

class EditorFullScreenHelperPresenter
    extends Presenter<EditorFullScreenHelperModel, EditorFullScreenHelperView> {
  final FullscreenHelperViewModel fullscreenHelperViewModel;

  EditorFullScreenHelperPresenter(
    EditorFullScreenHelperView viewInterface,
    this.fullscreenHelperViewModel,
  ) : super(EditorFullScreenHelperModel(), viewInterface);

  @override
  void onInit() {
    super.onInit();

    this.viewModel.editableTextFieldController =
        StreamController<bool>.broadcast();

    this.viewModel.titleKey = GlobalKey();
    this.viewModel.formKey = GlobalKey<FormState>();

    this.viewModel.helperOpacity = 1;

    // Disable animation on editor mode ?
    // Future.delayed(Duration(seconds: 1), () {
    //   this.viewModel.helperOpacity = 1;
    //   this.refreshView();
    // });
  }

  onTitleChanged(Key key, String newValue) {
    fullscreenHelperViewModel.titleField?.text?.value = newValue;
  }

  onTitleTextStyleChanged(Key key, TextStyle newTextStyle, FontKeys fontKeys) {
    fullscreenHelperViewModel.titleField?.fontColor?.value =
        newTextStyle?.color;
    fullscreenHelperViewModel.titleField?.fontSize?.value =
        newTextStyle?.fontSize?.toInt();

    if (fontKeys != null) {
      fullscreenHelperViewModel.titleField?.fontWeight?.value =
          fontKeys.fontWeightNameKey;
      fullscreenHelperViewModel.titleField?.fontFamily?.value =
          fontKeys.fontFamilyNameKey;
    }
  }

  @override
  Future onDestroy() async {
    this.viewModel.editableTextFieldController.close();
    super.onDestroy();
  }

  onOutsideTap() {
    this.viewModel.editableTextFieldController.add(true);
  }

  String validateTitleTextField(String currentValue) {
    if (currentValue.length <= 0) {
      return 'Please enter some text';
    }
    if (currentValue.length > 45) {
      return 'Maximum 45 characters';
    }
    return null;
  }

  changeBackgroundColor(
    FullscreenHelperViewModel viewModel,
    EditorFullScreenHelperPresenter presenter,
  ) {
    this.viewInterface.showColorPickerDialog(viewModel, presenter);
  }

  updateBackgroundColor(Color aColor) {
    fullscreenHelperViewModel.backgroundColor.value = aColor;
    this.refreshView();
  }
}
