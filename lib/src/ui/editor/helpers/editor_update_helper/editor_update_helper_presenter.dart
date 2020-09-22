import 'dart:async';

import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_update_helper/editor_update_helper.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_update_helper/editor_update_helper_viewmodel.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';
import 'package:palplugin/src/ui/editor/widgets/editable_textfield.dart';

class EditorUpdateHelperPresenter
    extends Presenter<EditorUpdateHelperModel, EditorUpdateHelperView> {
  final UpdateHelperViewModel updateHelperViewModel;

  EditorUpdateHelperPresenter(
    EditorUpdateHelperView viewInterface,
    this.updateHelperViewModel,
  ) : super(EditorUpdateHelperModel(), viewInterface);

  @override
  void onInit() {
    super.onInit();

    this.viewModel.editableTextFieldController =
        StreamController<bool>.broadcast();

    // Init keys
    this.viewModel.containerKey = GlobalKey();
    this.viewModel.formKey = GlobalKey<FormState>();

    // Init details textfield
    this.viewModel.titleController = TextEditingController();
    this.viewModel.thanksController = TextEditingController();
    this.viewModel.changelogsControllers = [];

    this.viewModel.changelogsTextfieldWidgets = [];
    this.viewModel.isKeyboardVisible = false;

    // Add listeners for details textfield
    this.viewModel.titleController.addListener(() {
      updateHelperViewModel.titleText?.value =
          this.viewModel.titleController?.value?.text;
    });

    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        this.viewModel.isKeyboardVisible = visible;
        this.refreshView();
      },
    );

    this.addChangelogNote();
  }

  @override
  Future onDestroy() async {
    this.viewModel.editableTextFieldController?.close();
    this.viewModel.titleController?.dispose();
    this.viewModel.thanksController?.dispose();
    // Dismiss all changelogs controllers
    for (TextEditingController controller
        in this.viewModel.changelogsControllers) {
      controller?.dispose();
    }
    super.onDestroy();
  }

  addChangelogNote() {
    var changelogController = TextEditingController();

    String hintText;
    if (this.viewModel.changelogsTextfieldWidgets.length <= 0) {
      hintText = 'Enter your first update line here...';
    } else {
      hintText = 'Enter update line here...';
    }

    UpdateHelperViewModel helperModel = this.viewInterface.getModel();
    helperModel.changelogFontColor?.value?.add(Colors.black87);
    helperModel.changelogFontSize?.value?.add(14.0);
    helperModel.changelogText?.value?.add(hintText);

    this.viewModel.changelogsControllers.add(changelogController);
    this.viewModel.changelogsTextfieldWidgets.add(
          EditableTextField.floating(
            outsideTapStream: this.viewModel.editableTextFieldController.stream,
            hintText: helperModel.changelogText?.value?.last,
            textStyle: TextStyle(
              color: helperModel.changelogFontColor?.value?.last,
              fontSize: helperModel.changelogFontSize?.value?.last,
            ),
            textEditingController: changelogController,
          ),
        );
    changelogController.addListener(() {
      updateHelperViewModel.changelogText?.value?.last =
          changelogController?.value?.text;
    });
    this.refreshView();
  }

  changeBackgroundColor(
      BuildContext context, EditorUpdateHelperPresenter presenter) {
    this.viewInterface.showColorPickerDialog(context, presenter);
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
