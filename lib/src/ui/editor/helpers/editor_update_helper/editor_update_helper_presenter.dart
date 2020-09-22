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
    this.viewModel.scrollController = ScrollController();

    // Init keys
    this.viewModel.containerKey = GlobalKey();
    this.viewModel.formKey = GlobalKey<FormState>();

    this.viewModel.releaseNotes = 0;

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

    this.viewModel.thanksController.addListener(() {
      updateHelperViewModel.thanksButtonText?.value =
          this.viewModel.thanksController?.value?.text;
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
    String hintText;
    if (this.viewModel.changelogsTextfieldWidgets.length <= 0) {
      hintText = 'Enter your first update line here...';
    } else {
      hintText = 'Enter update line here...';
    }

    // Create static keys
    ValueKey textFormFieldKey = ValueKey(
      'pal_EditorUpdateHelperWidget_ReleaseNoteField_${this.viewModel.releaseNotes}',
    );
    ValueKey textFormToolbarKey = ValueKey(
      'pal_EditorUpdateHelperWidget_ReleaseNoteToolbar_${this.viewModel.releaseNotes}',
    );
    String textFormMapKey = textFormFieldKey.toString();

    // Assign data
    UpdateHelperViewModel helperModel = this.viewInterface.getModel();
    helperModel.changelogFontColor?.value
        ?.putIfAbsent(textFormMapKey, () => Colors.black87);
    helperModel.changelogFontSize?.value
        ?.putIfAbsent(textFormMapKey, () => 14.0);
    helperModel.changelogText?.value
        ?.putIfAbsent(textFormMapKey, () => '');

    this.viewModel.changelogsTextfieldWidgets.add(
          EditableTextField(
            textFormFieldKey: textFormFieldKey,
            helperToolbarKey: textFormToolbarKey,
            outsideTapStream: this.viewModel.editableTextFieldController.stream,
            hintText: hintText,
            maximumCharacterLength: 120,
            textStyle: TextStyle(
              color: helperModel.changelogFontColor?.value[textFormMapKey],
              fontSize: helperModel.changelogFontSize?.value[textFormMapKey],
            ),
            onChanged: (Key key, String newValue) {
              updateHelperViewModel.changelogText?.value[textFormMapKey] =
                  newValue;
            },
          ),
        );
    this.viewModel.releaseNotes++;

    this.refreshView();
  }

  onTitleChanged(Key key, String newValue) {
    updateHelperViewModel.titleText?.value = newValue;
  }

  onThanksChanged(Key key, String newValue) {
    updateHelperViewModel.thanksButtonText?.value = newValue;
  }

  scrollToBottom() {
    if (this.viewModel.scrollController.hasClients) {
      this.viewModel.scrollController.animateTo(
            0.0,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 500),
          );
    }
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
