import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/services/editor/helper/helper_editor_models.dart';
import 'package:pal/src/services/editor/helper/helper_editor_service.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/font_editor/font_editor_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_factory.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_notifiers.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_sending_overlay.dart';

import 'editor_update_helper.dart';
import 'editor_update_helper_viewmodel.dart';

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
  }

  @override
  void afterViewInit() {
    this.viewInterface.hidePalBubble();
  }

  onKeyboardVisibilityChange(bool visible) {
    this.viewModel.isKeyboardVisible = visible;
    this.refreshView();
  }

  Future addChangelogNote() async {
    await viewInterface.scrollToBottomChangelogList();
    viewModel.addChangelog();
    this.refreshView();
  }

  void onCancel() => viewInterface.closeEditor();

  Future<void> onValidate() async {
    ValueNotifier<SendingStatus> status = new ValueNotifier(SendingStatus.SENDING);
    final config = CreateHelperConfig.from(parameters.pageId, viewModel);
    try {
      await viewInterface.showLoadingScreen(status);
      await Future.delayed(Duration(seconds: 1));
      await editorHelperService
        .saveUpdateHelper(EditorEntityFactory.buildUpdateArgs(config, viewModel));
      status.value = SendingStatus.SENT;
    } catch(error) {
      status.value = SendingStatus.ERROR;
    } finally {
      await Future.delayed(Duration(seconds: 2));
      viewInterface.closeLoadingScreen();
      await Future.delayed(Duration(milliseconds: 100));
      status.dispose();
      viewInterface.closeEditor();
    }
  }

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
      updateBackgroundColor,
      () => viewInterface.closeColorPickerDialog()
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
