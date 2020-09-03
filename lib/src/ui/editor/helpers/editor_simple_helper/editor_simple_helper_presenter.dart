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

    this.viewModel.isToolbarVisible = true;

    // Init keys
    this.viewModel.containerKey = GlobalKey();
    this.viewModel.formKey = GlobalKey<FormState>();

    // Init details textfield
    this.viewModel.detailsFocusNode = FocusNode();
    this.viewModel.detailsController = TextEditingController();

    // Add listeners for details textfield
    this.viewModel.detailsController.addListener(() {
      simpleHelperViewModel.details?.value = this.viewModel.detailsController?.value?.text;
    });
  }

  @override
  Future onDestroy() async {
    this.viewModel.detailsFocusNode.dispose();
    this.viewModel.detailsController.dispose();
    super.onDestroy();
  }

  // Details text field stuff
  onDetailTextFieldTapped() {
    this.viewModel.isToolbarVisible = true;
    this.refreshView();
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

  // Toolbar stuff
  onChangeBorderTap() { }
  onCloseTap() {
    this.viewModel.isToolbarVisible = false;
    this.viewModel.detailsFocusNode.unfocus();
    this.refreshView();
  }
  onChangeFontTap() { }
  onEditTextTap() { }
}