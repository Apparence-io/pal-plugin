import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_fullscreen_helper/editor_fullscreen_helper.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_fullscreen_helper/editor_fullscreen_helper_viewmodel.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';

class EditorFullScreenHelperPresenter extends Presenter<EditorFullScreenHelperModel, EditorFullScreenHelperView>{
  final FullscreenHelperViewModel fullscreenHelperViewModel;

  EditorFullScreenHelperPresenter(
    EditorFullScreenHelperView viewInterface, this.fullscreenHelperViewModel,
  ) : super(EditorFullScreenHelperModel(), viewInterface);

  @override
  void onInit() {
    super.onInit();

    this.viewModel.editableTextFieldController = StreamController<bool>.broadcast();

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
}