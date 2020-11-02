import 'dart:async';

import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/ui/editor/helpers/editor_update_helper/editor_update_helper.dart';
import 'package:pal/src/ui/editor/helpers/editor_update_helper/editor_update_helper_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/font_editor/font_editor_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_notifiers.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';
import 'package:pal/src/ui/editor/widgets/editable_textfield.dart';

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

    // Check if a pre-filled template already exist
    if (updateHelperViewModel.changelogsFields.length > 0) {
      this.initFromTemplate();
    } else {
      this.addChangelogNote();
    }
  }

  addChangelogNote() {
    // Create static keys
    final textFieldCount = this.viewModel.changelogsTextfieldWidgets.length;

    // Create the textfield
    String textFieldId = textFieldCount.toString();
    this.updateHelperViewModel.changelogsFields?.putIfAbsent(
          textFieldId,
          () => TextFormFieldNotifier(
            text: '',
            fontSize: 18,
            fontColor: Colors.white,
          ),
        );

    this.viewModel.changelogsTextfieldWidgets.add(
          createTextField(
            textFieldId,
            this.viewModel.changelogsTextfieldWidgets.length,
          ),
        );

    this.refreshView();
    // wait for UI to be updated
    Future.delayed(Duration(milliseconds: 500), () {
      if (textFieldCount > 0) callonFormChanged();
    });
  }

  initFromTemplate() {
    List<EditableTextField> editableTextFields = [];
    int index = 0;
    for (final changelog in updateHelperViewModel.changelogsFields.entries) {
      final String textFieldId = changelog.key;

      final textField = createTextField(
        textFieldId,
        index++,
      );
      editableTextFields.add(textField);
    }

    this.viewModel.changelogsTextfieldWidgets = editableTextFields;

    this.refreshView();
    // wait for UI to be updated
    Future.delayed(Duration(milliseconds: 500), () {
      callonFormChanged();
    });
  }

  EditableTextField createTextField(
    String textFieldId,
    int changelogsCount,
  ) {
    String hintText;
    if (changelogsCount <= 0) {
      hintText = 'Enter your first update line here...';
    } else {
      hintText = 'Enter update line here...';
    }

    // Create static keys
    final textFieldCount = changelogsCount;
    final ValueKey textFormFieldKey = ValueKey(
      'pal_EditorUpdateHelperWidget_ReleaseNoteField_$textFieldCount',
    );
    final ValueKey textFormToolbarKey = ValueKey(
      'pal_EditorUpdateHelperWidget_ReleaseNoteToolbar_$textFieldCount',
    );

    return EditableTextField.text(
      id: textFieldId,
      textFormFieldKey: textFormFieldKey,
      helperToolbarKey: textFormToolbarKey,
      outsideTapStream: this.viewModel.editableTextFieldController.stream,
      hintText: hintText,
      initialValue: this
          .updateHelperViewModel
          .changelogsFields[textFieldId]
          ?.text
          ?.value,
      minimumCharacterLength: 1,
      maximumCharacterLength: 120,
      autovalidate: AutovalidateMode.always,
      textStyle: TextStyle(
        color: this
            .updateHelperViewModel
            .changelogsFields[textFieldId]
            ?.fontColor
            ?.value,
        fontSize: this
            .updateHelperViewModel
            .changelogsFields[textFieldId]
            ?.fontSize
            ?.value
            ?.toDouble(),
      ),
      onChanged: (String id, String newValue) {
        this.updateHelperViewModel.changelogsFields[id]?.text?.value =
            newValue;
      },
      onTextStyleChanged: this.onChangelogTextStyleFieldChanged,
    );
  }

  callonFormChanged() {
    this.viewInterface.callOnFormChanged(this.viewModel);
  }

  onTitleFieldChanged(String id, String newValue) {
    updateHelperViewModel.titleField?.text?.value = newValue;
  }

  onThanksFieldChanged(String id, String newValue) {
    updateHelperViewModel.thanksButton?.text?.value = newValue;
  }

  onTitleTextStyleChanged(String id, TextStyle newTextStyle, FontKeys fontKeys) {
    updateHelperViewModel.titleField?.fontColor?.value = newTextStyle?.color;
    updateHelperViewModel.titleField?.fontSize?.value =
        newTextStyle?.fontSize?.toInt();

    if (fontKeys != null) {
      updateHelperViewModel.titleField?.fontWeight?.value =
          fontKeys.fontWeightNameKey;
      updateHelperViewModel.titleField?.fontFamily?.value =
          fontKeys.fontFamilyNameKey;
    }
  }

  onThanksTextStyleFieldChanged(
    String id,
    TextStyle newTextStyle,
    FontKeys fontKeys,
  ) {
    updateHelperViewModel.thanksButton?.fontColor?.value = newTextStyle?.color;
    updateHelperViewModel.thanksButton?.fontSize?.value =
        newTextStyle?.fontSize?.toInt();

    if (fontKeys != null) {
      updateHelperViewModel.thanksButton?.fontWeight?.value =
          fontKeys.fontWeightNameKey;
      updateHelperViewModel.thanksButton?.fontFamily?.value =
          fontKeys.fontFamilyNameKey;
    }
  }

  onChangelogTextStyleFieldChanged(
    String id,
    TextStyle newTextStyle,
    FontKeys fontKeys,
  ) {
        print(id);

    updateHelperViewModel.changelogsFields[id]?.fontColor?.value =
        newTextStyle?.color;
    updateHelperViewModel.changelogsFields[id]?.fontSize?.value =
        newTextStyle?.fontSize?.toInt();

    if (fontKeys != null) {
      updateHelperViewModel.changelogsFields[id]?.fontWeight
          ?.value = fontKeys.fontWeightNameKey;
      updateHelperViewModel.changelogsFields[id]?.fontFamily
          ?.value = fontKeys.fontFamilyNameKey;
    }
  }

  changeBackgroundColor(
    BuildContext context,
    EditorUpdateHelperPresenter presenter,
  ) {
    this.viewInterface.showColorPickerDialog(context, presenter);
  }

  updateBackgroundColor(Color aColor) {
    updateHelperViewModel.bodyBox.backgroundColor.value = aColor;
    this.refreshView();
  }

  onOutsideTap() {
    this.viewModel.editableTextFieldController.add(true);
  }

  editMedia() async {
    final selectedMedia = await this
        .viewInterface
    // FIXME: Int or String ??
        .pushToMediaGallery(this.updateHelperViewModel.media?.uuid); 

    this.updateHelperViewModel.media?.url?.value = selectedMedia?.url;
    this.updateHelperViewModel.media?.uuid = selectedMedia?.id;

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

  String validateChangelogTextField(String currentValue) {
    if (currentValue.length <= 0) {
      return 'Please enter some text';
    }
    if (currentValue.length > 45) {
      return 'Maximum 45 characters';
    }
    return null;
  }
}
