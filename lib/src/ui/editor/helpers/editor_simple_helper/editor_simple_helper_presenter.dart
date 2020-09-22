import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_simple_helper/editor_simple_helper.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_simple_helper/editor_simple_helper_viewmodel.dart';
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
    this.viewModel.detailsController.dispose();
    super.onDestroy();
  }

  onDetailsChanged(Key key, String newValue) {
    simpleHelperViewModel.details?.value = newValue;
  }

  onOutsideTap() {
    this.viewModel.editableTextFieldController.add(true);
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
}