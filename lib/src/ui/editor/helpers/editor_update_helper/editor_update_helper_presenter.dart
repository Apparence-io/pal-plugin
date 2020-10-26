import 'dart:async';

import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/database/entity/graphic_entity.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_update_helper/editor_update_helper.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_update_helper/editor_update_helper_viewmodel.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/font_editor/font_editor_viewmodel.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor_notifiers.dart';
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

    this.addChangelogNote();
  }

  addChangelogNote() {
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
    this.updateHelperViewModel.changelogsFields?.putIfAbsent(
          textFormMapKey,
          () => TextFormFieldNotifier(
            text: '',
            fontSize: 14,
            fontColor: Colors.black87,
          ),
        );

    this.viewModel.changelogsTextfieldWidgets.add(
          EditableTextField.text(
            textFormFieldKey: textFormFieldKey,
            helperToolbarKey: textFormToolbarKey,
            outsideTapStream: this.viewModel.editableTextFieldController.stream,
            hintText: hintText,
            maximumCharacterLength: 120,
            textStyle: TextStyle(
              color: this
                  .updateHelperViewModel
                  .changelogsFields[textFormMapKey]
                  ?.fontColor
                  ?.value,
              fontSize: this
                  .updateHelperViewModel
                  .changelogsFields[textFormMapKey]
                  ?.fontSize
                  ?.value
                  ?.toDouble(),
            ),
            onChanged: (Key key, String newValue) {
              this
                  .updateHelperViewModel
                  .changelogsFields[textFormMapKey]
                  ?.text
                  ?.value = newValue;
            },
            onTextStyleChanged: this.onChangelogTextStyleFieldChanged,
          ),
        );

    this.refreshView();
  }

  onTitleFieldChanged(Key key, String newValue) {
    updateHelperViewModel.titleField?.text?.value = newValue;
  }

  onThanksFieldChanged(Key key, String newValue) {
    updateHelperViewModel.thanksButton?.text?.value = newValue;
  }

  onTitleTextStyleChanged(Key key, TextStyle newTextStyle, FontKeys fontKeys) {
    updateHelperViewModel.titleField?.fontColor?.value = newTextStyle?.color;

    if (fontKeys != null) {
      updateHelperViewModel.titleField?.fontWeight?.value =
          fontKeys.fontWeightNameKey;
      updateHelperViewModel.titleField?.fontFamily?.value =
          fontKeys.fontFamilyNameKey;
    }
  }

  onThanksTextStyleFieldChanged(
    Key key,
    TextStyle newTextStyle,
    FontKeys fontKeys,
  ) {
    updateHelperViewModel.thanksButton?.fontColor?.value = newTextStyle?.color;

    if (fontKeys != null) {
      updateHelperViewModel.thanksButton?.fontWeight?.value =
          fontKeys.fontWeightNameKey;
      updateHelperViewModel.thanksButton?.fontFamily?.value =
          fontKeys.fontFamilyNameKey;
    }
  }

  onChangelogTextStyleFieldChanged(
    Key key,
    TextStyle newTextStyle,
    FontKeys fontKeys,
  ) {
    updateHelperViewModel.changelogsFields[key.toString()]?.fontColor?.value =
        newTextStyle?.color;
    updateHelperViewModel.changelogsFields[key.toString()]?.fontSize?.value =
        newTextStyle?.fontSize?.toInt();

    if (fontKeys != null) {
      updateHelperViewModel.changelogsFields[key.toString()]?.fontWeight
          ?.value = fontKeys.fontWeightNameKey;
      updateHelperViewModel.changelogsFields[key.toString()]?.fontFamily
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
    updateHelperViewModel.backgroundColor.value = aColor;
    this.refreshView();
  }

  onOutsideTap() {
    this.viewModel.editableTextFieldController.add(true);
  }

  editMedia() async {
    final selectedMedia = await this
        .viewInterface
        .pushToMediaGallery(this.updateHelperViewModel.media?.id?.value);
    
      this.updateHelperViewModel.media?.url?.value = selectedMedia?.url;
      this.updateHelperViewModel.media?.id?.value = selectedMedia?.id;

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
