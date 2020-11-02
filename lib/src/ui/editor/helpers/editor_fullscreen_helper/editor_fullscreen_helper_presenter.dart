import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/ui/editor/helpers/editor_fullscreen_helper/editor_fullscreen_helper.dart';
import 'package:pal/src/ui/editor/helpers/editor_fullscreen_helper/editor_fullscreen_helper_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/font_editor/font_editor_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/font_editor/pickers/font_weight_picker/font_weight_picker_loader.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';

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
  }

  // Title
  onTitleChanged(String id, String newValue) {
    fullscreenHelperViewModel.titleField?.text?.value = newValue;
  }

  onTitleTextStyleChanged(
      String id, TextStyle newTextStyle, FontKeys fontKeys) {
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

  // Positiv button
  onPositivTextChanged(String id, String newValue) {
    fullscreenHelperViewModel.positivButtonField?.text?.value = newValue;
  }

  onPositivTextStyleChanged(
      String id, TextStyle newTextStyle, FontKeys fontKeys) {
    fullscreenHelperViewModel.positivButtonField?.fontColor?.value =
        newTextStyle?.color;
    fullscreenHelperViewModel.positivButtonField?.fontSize?.value =
        newTextStyle?.fontSize?.toInt();

    if (fontKeys != null) {
      fullscreenHelperViewModel.positivButtonField?.fontWeight?.value =
          fontKeys.fontWeightNameKey;
      fullscreenHelperViewModel.positivButtonField?.fontFamily?.value =
          fontKeys.fontFamilyNameKey;
    }
  }

  // Negativ button
  onNegativTextChanged(String id, String newValue) {
    fullscreenHelperViewModel.negativButtonField?.text?.value = newValue;
  }

  onNegativTextStyleChanged(
      String id, TextStyle newTextStyle, FontKeys fontKeys) {
    fullscreenHelperViewModel.negativButtonField?.fontColor?.value =
        newTextStyle?.color;
    fullscreenHelperViewModel.negativButtonField?.fontSize?.value =
        newTextStyle?.fontSize?.toInt();

    if (fontKeys != null) {
      fullscreenHelperViewModel.negativButtonField?.fontWeight?.value =
          fontKeys.fontWeightNameKey;
      fullscreenHelperViewModel.negativButtonField?.fontFamily?.value =
          fontKeys.fontFamilyNameKey;
    }
  }

  @override
  Future onDestroy() async {
    this.viewModel.editableTextFieldController.close();
    super.onDestroy();
  }

  googleCustomFont(String fontFamily) {
    this.viewInterface.googleCustomFont(fontFamily);
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

  editMedia() async {
    final selectedMedia = await this
        .viewInterface
        .pushToMediaGallery(this.fullscreenHelperViewModel.media?.uuid);

    this.fullscreenHelperViewModel.media?.url?.value = selectedMedia?.url;
    this.fullscreenHelperViewModel.media?.uuid = selectedMedia?.id;
    this.refreshView();
  }

  updateBackgroundColor(Color aColor) {
    fullscreenHelperViewModel.bodyBox.backgroundColor.value = aColor;
    this.refreshView();
  }
}
