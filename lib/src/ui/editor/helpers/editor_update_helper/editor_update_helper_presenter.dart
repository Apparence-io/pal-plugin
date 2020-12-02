import 'dart:async';

import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/services/editor/helper/helper_editor_service.dart';
import 'package:pal/src/ui/editor/helpers/editor_update_helper/editor_update_helper.dart';
import 'package:pal/src/ui/editor/helpers/editor_update_helper/editor_update_helper_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/font_editor/font_editor_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_notifiers.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';
import 'package:pal/src/ui/editor/widgets/editable_textfield.dart';

class EditorUpdateHelperPresenter extends Presenter<UpdateHelperViewModel, EditorUpdateHelperView> {

  final EditorHelperService editorHelperService;

  final HelperEditorPageArguments parameters;

  final StreamController<bool> editableTextFieldController;

  EditorUpdateHelperPresenter(
      EditorUpdateHelperView viewInterface,
      UpdateHelperViewModel updateHelperViewModel,
      this.editorHelperService,
      this.parameters
  ) : editableTextFieldController = StreamController<bool>.broadcast(),
      super(updateHelperViewModel, viewInterface) {
    viewModel.canValidate = new ValueNotifier(false);
  }

  @override
  void onInit() {
    this.viewModel.isKeyboardVisible = false;
    // Check if a pre-filled template already exist
    // if (updateHelperViewModel.changelogsFields.length > 0) {
    //   this.initFromTemplate();
    // } else {
    //   this.addChangelogNote();
    // }
  }

  onKeyboardVisibilityChange(bool visible) {
    this.viewModel.isKeyboardVisible = visible;
    this.refreshView();
  }

  Future addChangelogNote() async {
    await viewInterface.scrollToBottomChangelogList();
    String textFieldId = viewModel.changelogsFields.length.toString();
    viewModel.changelogsFields.putIfAbsent(
      textFieldId, () => TextFormFieldNotifier(
          text: '',
          fontSize: 18,
          fontColor: Colors.white
      ),
    );
    this.refreshView();
    // wait for UI to be updated
    // Future.delayed(Duration(milliseconds: 500), () {
    //   if (textFieldCount > 0) callonFormChanged();
    // });
  }

  void onCancel() {

  }

  Future<void> onValidate() {

  }

  // initFromTemplate() {
  //   List<EditableTextField> editableTextFields = [];
  //   int index = 0;
  //   for (final changelog in viewModel.changelogsFields.entries) {
  //     final String textFieldId = changelog.key;
  //
  //     final textField = createTextField(
  //       textFieldId,
  //       index++,
  //     );
  //     editableTextFields.add(textField);
  //   }
  //
  //   this.viewModel.changelogsTextfieldWidgets = editableTextFields;
  //
  //   this.refreshView();
  //   // wait for UI to be updated
  //   Future.delayed(Duration(milliseconds: 500), () {
  //     callonFormChanged();
  //   });
  // }

  // EditableTextField createTextField(
  //   String textFieldId,
  //   int changelogsCount,
  // ) {
  //   String hintText;
  //   if (changelogsCount <= 0) {
  //     hintText = 'Enter your first update line here...';
  //   } else {
  //     hintText = 'Enter update line here...';
  //   }
  //
  //   // Create static keys
  //   final textFieldCount = changelogsCount;
  //   final ValueKey textFormFieldKey = ValueKey(
  //     'pal_EditorUpdateHelperWidget_ReleaseNoteField_$textFieldCount',
  //   );
  //   final ValueKey textFormToolbarKey = ValueKey(
  //     'pal_EditorUpdateHelperWidget_ReleaseNoteToolbar_$textFieldCount',
  //   );
  //
  //   return EditableTextField.text(
  //     id: textFieldId,
  //     textFormFieldKey: textFormFieldKey,
  //     helperToolbarKey: textFormToolbarKey,
  //     outsideTapStream: this.viewModel.editableTextFieldController.stream,
  //     hintText: hintText,
  //     initialValue:
  //         this.updateHelperViewModel.changelogsFields[textFieldId]?.text?.value,
  //     minimumCharacterLength: 1,
  //     maximumCharacterLength: 120,
  //     fontFamilyKey: this
  //         .updateHelperViewModel
  //         .changelogsFields[textFieldId]
  //         ?.fontFamily
  //         ?.value,
  //     autovalidate: AutovalidateMode.always,
  //     textStyle: TextStyle(
  //       color: this
  //           .updateHelperViewModel
  //           .changelogsFields[textFieldId]
  //           ?.fontColor
  //           ?.value,
  //       fontSize: this
  //           .updateHelperViewModel
  //           .changelogsFields[textFieldId]
  //           ?.fontSize
  //           ?.value
  //           ?.toDouble(),
  //     ).merge(this.viewInterface.googleCustomFont(
  //           this
  //               .updateHelperViewModel
  //               .changelogsFields[textFieldId]
  //               ?.fontFamily
  //               ?.value,
  //         )),
  //     onChanged: (String id, String newValue) {
  //       this.updateHelperViewModel.changelogsFields[id]?.text?.value = newValue;
  //     },
  //     onTextStyleChanged: this.onChangelogTextStyleFieldChanged,
  //   );
  // }

  onTitleFieldChanged(String id, String newValue)
    => _onTextChanged(viewModel.titleField, newValue);

  onThanksFieldChanged(String id, String newValue)
    => _onTextChanged(viewModel.thanksButton, newValue);

  onTitleTextStyleChanged(String id, TextStyle newTextStyle, FontKeys fontKeys)
    => _onStyleChanged(viewModel.titleField, newTextStyle, fontKeys);

  onThanksTextStyleFieldChanged(String id, TextStyle newTextStyle, FontKeys fontKeys)
    => _onStyleChanged(viewModel.thanksButton, newTextStyle, fontKeys);

  onChangelogTextChanged(String id, String newValue)
    => _onTextChanged(viewModel.changelogsFields[id], newValue);

  onChangelogTextStyleFieldChanged(String id, TextStyle newTextStyle, FontKeys fontKeys)
    => _onStyleChanged(viewModel.changelogsFields[id], newTextStyle, fontKeys);

  changeBackgroundColor() {
    this.viewInterface.showColorPickerDialog(
      viewModel?.bodyBox?.backgroundColor?.value,
      updateBackgroundColor
    );
  }

  updateBackgroundColor(Color aColor) {
    viewModel.bodyBox.backgroundColor.value = aColor;
    this.refreshView();
  }

  onOutsideTap() => this.editableTextFieldController.add(true);

  editMedia() async {
    final selectedMedia = await this
        .viewInterface
        .pushToMediaGallery(viewModel.media?.uuid);
    viewModel.media?.url?.value = selectedMedia?.url;
    viewModel.media?.uuid = selectedMedia?.id;
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

  // ----------------------------------
  // PRIVATES
  // ----------------------------------

  _onTextChanged(TextFormFieldNotifier textNotifier, String newValue) {
    textNotifier.text.value = newValue;
    viewModel.canValidate.value = isValid();
  }

  _onStyleChanged(TextFormFieldNotifier textNotifier, TextStyle newTextStyle, FontKeys fontKeys) {
    textNotifier?.fontColor?.value = newTextStyle?.color;
    textNotifier?.fontSize?.value = newTextStyle?.fontSize?.toInt();
    if (fontKeys != null) {
      textNotifier?.fontWeight?.value = fontKeys.fontWeightNameKey;
      textNotifier?.fontFamily?.value = fontKeys.fontFamilyNameKey;
    }
  }

  bool isValid() => viewModel.titleField.text.value.isNotEmpty
    && viewModel.changelogsFields.length > 0;
}
