import 'dart:async';

import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_update_helper/editor_update_helper.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_update_helper/editor_update_helper_viewmodel.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';

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

    // Controllers
    this.viewModel.editableTextFieldController =
        StreamController<bool>.broadcast();
    this.viewModel.scrollController = ScrollController();

    // Key stuff
    this.viewModel.formKey = GlobalKey<FormState>();

    // View stuff
    this.viewModel.changelogsTextfieldWidgets = [];
    this.viewModel.isKeyboardVisible = false;

    // Keyboard visibility listener
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        this.viewModel.isKeyboardVisible = visible;
        this.refreshView();
      },
    );

    this.addChangelogNote(this.viewModel);
  }

  addChangelogNote(EditorUpdateHelperModel model) {
    String hintText;
    if (this.viewModel.changelogsTextfieldWidgets.length <= 0) {
      hintText = 'Enter your first update line here...';
    } else {
      hintText = 'Enter update line here...';
    }

    // Create static keys
    final textFieldId = this.viewModel.changelogsTextfieldWidgets.length;
    final ValueKey textFormFieldKey = ValueKey(
      'pal_EditorUpdateHelperWidget_ReleaseNoteField_$textFieldId',
    );
    final ValueKey textFormToolbarKey = ValueKey(
      'pal_EditorUpdateHelperWidget_ReleaseNoteToolbar_$textFieldId',
    );

    // Create the textfield
    String textFormMapKey = textFormFieldKey.toString();
    this.viewInterface.addChangelogNoteTextField(
          model,
          textFormFieldKey,
          textFormToolbarKey,
          hintText,
          textFormMapKey,
        );

    this.refreshView();
  }

  onTitleFieldChanged(Key key, String newValue) {
    updateHelperViewModel.titleField?.text?.value = newValue;
  }

  onThanksFieldChanged(Key key, String newValue) {
    updateHelperViewModel.thanksButton?.text?.value = newValue;
  }

  changeBackgroundColor(
    BuildContext context,
    EditorUpdateHelperPresenter presenter,
  ) {
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
