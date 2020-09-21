import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_update_helper/editor_update_helper.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_update_helper/editor_update_helper_viewmodel.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';

class EditorUpdateHelperPresenter extends Presenter<EditorUpdateHelperModel, EditorUpdateHelperView>{
  final UpdateHelperViewModel updateHelperViewModel;

  EditorUpdateHelperPresenter(
    EditorUpdateHelperView viewInterface,
    this.updateHelperViewModel,
  ) : super(EditorUpdateHelperModel(), viewInterface);

  @override
  void onInit() {
    super.onInit();

    // Init keys
    this.viewModel.containerKey = GlobalKey();
    this.viewModel.formKey = GlobalKey<FormState>();

    // Init details textfield
    this.viewModel.detailsController = TextEditingController();

    // Add listeners for details textfield
    this.viewModel.detailsController.addListener(() {
      updateHelperViewModel.titleText?.value = this.viewModel.detailsController?.value?.text;
    });
  }

  // @override
  // Future onDestroy() async {
  //   this.viewModel.detailsFocus.dispose();
  //   this.viewModel.detailsController.dispose();
  //   super.onDestroy();
  // }

  // Details text field stuff
  onDetailTextFieldTapped() {
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
}