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

    this.viewModel.titleKey = GlobalKey();
    this.viewModel.formKey = GlobalKey<FormState>();

    this.viewModel.titleController = TextEditingController();

    this.viewModel.helperOpacity = 0;
    this.viewModel.isToolbarVisible = true;

    this.viewModel.titleController.addListener(() {
      fullscreenHelperViewModel.title?.value = this.viewModel.titleController?.value?.text;
    });

    Future.delayed(Duration(seconds: 1), () {
      this.viewModel.helperOpacity = 1;
      this.refreshView();
    });
  }

  // @override
  // void onDestroy() {
  //   this.viewModel.titleFocus.dispose();
  //   this.viewModel.titleController.dispose();
  //   super.onDestroy();
  // }

  // Title text field stuff
  onTitleTextFieldTapped() {
    this.viewModel.isToolbarVisible = true;
    this.refreshView();
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