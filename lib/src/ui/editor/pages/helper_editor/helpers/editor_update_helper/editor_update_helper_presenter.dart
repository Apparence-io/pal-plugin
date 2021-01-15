import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/services/editor/helper/helper_editor_models.dart';
import 'package:pal/src/services/editor/helper/helper_editor_service.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_factory.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_sending_overlay.dart';

import 'editor_update_helper.dart';
import 'editor_update_helper_viewmodel.dart';

class EditorUpdateHelperPresenter
    extends Presenter<UpdateHelperViewModel, EditorUpdateHelperView> {
  final EditorHelperService editorHelperService;
  final HelperEditorPageArguments parameters;
  final StreamController<bool> editableTextFieldController;

  final GlobalKey titleKey;
  final GlobalKey thanksButtonKey;

  EditorUpdateHelperPresenter(
    EditorUpdateHelperView viewInterface,
    UpdateHelperViewModel updateHelperViewModel,
    this.editorHelperService,
    this.parameters, {
    this.titleKey,
    this.thanksButtonKey,
  })  : editableTextFieldController = StreamController<bool>.broadcast(),
        super(updateHelperViewModel, viewInterface);

  @override
  void onInit() {
    this.viewModel.canValidate = new ValueNotifier(false);
    this.viewModel.isKeyboardVisible = false;
  }

  @override
  void afterViewInit() {
    this.viewInterface.hidePalBubble();
  }

  onTextPickerDone() {
    this._updateValidState();
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
    ValueNotifier<SendingStatus> status =
        new ValueNotifier(SendingStatus.SENDING);
    final config = CreateHelperConfig.from(parameters.pageId, viewModel);
    try {
      await viewInterface.showLoadingScreen(status);
      await Future.delayed(Duration(seconds: 1));
      await editorHelperService.saveUpdateHelper(
          EditorEntityFactory.buildUpdateArgs(config, viewModel));
      status.value = SendingStatus.SENT;
    } catch (error) {
      status.value = SendingStatus.ERROR;
    } finally {
      await Future.delayed(Duration(seconds: 2));
      viewInterface.closeLoadingScreen();
      await Future.delayed(Duration(milliseconds: 100));
      status.dispose();
      viewInterface.closeEditor();
    }
  }

  updateBackgroundColor(Color aColor) {
    viewModel.bodyBox.backgroundColor.value = aColor;
  }

  onOutsideTap() => this.editableTextFieldController.add(true);

  editMedia() async {
    final selectedMedia =
        await this.viewInterface.pushToMediaGallery(viewModel.media?.uuid);
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

  _updateValidState() {
    viewModel.canValidate.value = isValid();
  }


  bool isValid() =>
      viewModel.titleField.text.value.isNotEmpty &&
      viewModel.changelogsFields.length > 0;

  onPreview() {
    this.viewInterface.showPreviewOfHelper(this.viewModel);
  }
}
