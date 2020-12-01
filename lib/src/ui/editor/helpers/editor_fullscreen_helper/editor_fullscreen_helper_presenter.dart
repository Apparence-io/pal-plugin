import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/ui/editor/helpers/editor_fullscreen_helper/editor_fullscreen_helper.dart';
import 'package:pal/src/ui/editor/helpers/editor_fullscreen_helper/editor_fullscreen_helper_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/font_editor/font_editor_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_notifiers.dart';

class EditorFullScreenHelperPresenter extends Presenter<FullscreenHelperViewModel, EditorFullScreenHelperView> {

  EditorFullScreenHelperPresenter(
    EditorFullScreenHelperView viewInterface,
    FullscreenHelperViewModel viewModel,
  ) : super(viewModel, viewInterface);

  @override
  void onInit() {
    super.onInit();
    this.viewModel.helperOpacity = 1;
    this.viewModel.editableTextFieldController = StreamController<bool>.broadcast();
  }

  // Title
  onTitleChanged(String id, String newValue)
    => _onTextChanged(viewModel.titleField, newValue);

  onTitleTextStyleChanged(String id, TextStyle newTextStyle, FontKeys fontKeys) 
    => _onStyleChanged(viewModel.titleField, newTextStyle, fontKeys);

  // Description field
  onDescriptionChanged(String id, String newValue)
    => _onTextChanged(viewModel.descriptionField, newValue);

  onDescriptionTextStyleChanged(String id, TextStyle newTextStyle, FontKeys fontKeys)
    => _onStyleChanged(viewModel.descriptionField, newTextStyle, fontKeys);
  
  // Positiv button
  onPositivTextChanged(String id, String newValue)
    => _onTextChanged(viewModel.positivButtonField, newValue);

  onPositivTextStyleChanged(String id, TextStyle newTextStyle, FontKeys fontKeys) 
    => _onStyleChanged(viewModel.positivButtonField, newTextStyle, fontKeys);

  // Negativ button
  onNegativTextChanged(String id, String newValue) 
    => _onTextChanged(viewModel.negativButtonField, newValue);

  onNegativTextStyleChanged(String id, TextStyle newTextStyle, FontKeys fontKeys) 
    => _onStyleChanged(viewModel.negativButtonField, newTextStyle, fontKeys);
  

  @override
  Future onDestroy() async {
    this.viewModel.editableTextFieldController.close();
    super.onDestroy();
  }

  //TODO move  to view
  TextStyle googleCustomFont(String fontFamily) => this.viewInterface.googleCustomFont(fontFamily);

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

  changeBackgroundColor() => this.viewInterface.showColorPickerDialog(viewModel, this);

  editMedia() async {
    final selectedMedia = await this
        .viewInterface
        .pushToMediaGallery(this.viewModel.media?.uuid);

    this.viewModel.media?.url?.value = selectedMedia?.url;
    this.viewModel.media?.uuid = selectedMedia?.id;
    this.refreshView();
  }

  updateBackgroundColor(Color aColor) {
    viewModel.bodyBox.backgroundColor.value = aColor;
    this.refreshView();
  }
  
  
  // ----------------------------------
  // PRIVATES 
  // ----------------------------------
  
  _onTextChanged(TextFormFieldNotifier textNotifier, String newValue) => textNotifier.text.value = newValue;

  _onStyleChanged(TextFormFieldNotifier textNotifier, TextStyle newTextStyle, FontKeys fontKeys) {
    textNotifier?.fontColor?.value = newTextStyle?.color;
    textNotifier?.fontSize?.value = newTextStyle?.fontSize?.toInt();
    if (fontKeys != null) {
      textNotifier?.fontWeight?.value = fontKeys.fontWeightNameKey;
      textNotifier?.fontFamily?.value = fontKeys.fontFamilyNameKey;
    }
  }
}
