import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/services/editor/helper/helper_editor_models.dart';
import 'package:pal/src/services/editor/helper/helper_editor_service.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_factory.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_sending_overlay.dart';

import 'editor_fullscreen_helper.dart';
import 'editor_fullscreen_helper_viewmodel.dart';

class EditorFullScreenHelperPresenter
    extends Presenter<FullscreenHelperViewModel, EditorFullScreenHelperView> {
  final EditorHelperService editorHelperService;

  final HelperEditorPageArguments parameters;

  EditorFullScreenHelperPresenter(
    EditorFullScreenHelperView viewInterface,
    FullscreenHelperViewModel viewModel,
    this.editorHelperService,
    this.parameters,
  ) : super(viewModel, viewInterface);

  @override
  void onInit() {
    super.onInit();
    this.viewModel.helperOpacity = 1;
    this.viewModel.canValidate = new ValueNotifier(false);
  }

  Future onValidate() async {
    ValueNotifier<SendingStatus> status =
        new ValueNotifier(SendingStatus.SENDING);
    final config = CreateHelperConfig.from(parameters.pageId, viewModel);
    try {
      await viewInterface.showLoadingScreen(status);
      await Future.delayed(Duration(seconds: 1));
      await editorHelperService.saveFullScreenHelper(
          EditorEntityFactory.buildFullscreenArgs(config, viewModel));
      status.value = SendingStatus.SENT;
    } catch (error) {
      print("error occured $error");
      status.value = SendingStatus.ERROR;
    } finally {
      await Future.delayed(Duration(seconds: 2));
      viewInterface.closeLoadingScreen();
      await Future.delayed(Duration(milliseconds: 100));
      status.dispose();
      viewInterface.closeEditor();
    }
  }

  onCancel() {
    viewInterface.closeEditor();
  }

  @override
  void afterViewDestroyed() {
    // this.viewModel.canValidate.dispose();
    // this.viewModel.canValidate = null;
  }

  //TODO move  to view
  TextStyle googleCustomFont(String fontFamily) =>
      this.viewInterface.googleCustomFont(fontFamily);

  String validateTitleTextField(String currentValue) {
    if (currentValue.length <= 0) {
      return 'Please enter some text';
    }
    if (currentValue.length > 45) {
      return 'Maximum 45 characters';
    }
    return null;
  }

  updateBackgroundColor(Color aColor) {
    viewModel.bodyBox.backgroundColor.value = aColor;
    // this.viewInterface.closeColorPickerDialog();
    this.updateValidState();
    // this.refreshView();
  }

  editMedia() async {
    final selectedMedia =
        await this.viewInterface.pushToMediaGallery(this.viewModel.media?.uuid);

    this.viewModel.media?.url?.value = selectedMedia?.url;
    this.viewModel.media?.uuid = selectedMedia?.id;
    this.refreshView();
  }

  // ----------------------------------
  // PRIVATES
  // ----------------------------------

  updateValidState() {
    viewModel.canValidate.value = isValid();
    this.refreshView();

  }

  bool isValid() =>
      viewModel.positivButtonField.text.value.isNotEmpty &&
      viewModel.negativButtonField.text.value.isNotEmpty &&
      viewModel.titleField.text.value.isNotEmpty &&
      viewModel.descriptionField.text.value.isNotEmpty;

  onPreview() {
    this.viewInterface.showPreviewOfHelper(this.viewModel);
  }
}
