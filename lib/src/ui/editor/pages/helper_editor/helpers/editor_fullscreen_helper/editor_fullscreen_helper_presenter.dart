import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/graphic_entity.dart';
import 'package:pal/src/services/editor/helper/helper_editor_models.dart';
import 'package:pal/src/services/editor/helper/helper_editor_service.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_data.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_factory.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_sending_overlay.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/font_editor/font_editor_viewmodel.dart';

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
    viewModel.backgroundBoxForm.backgroundColor = aColor;
    // this.viewInterface.closeColorPickerDialog();
    this._updateValidState();
    // this.refreshView();
  }

  editMedia() async {
    final selectedMedia = await this
        .viewInterface
        .pushToMediaGallery(this.viewModel.headerMediaForm?.uuid);

    this.viewModel.headerMediaForm?.url = selectedMedia?.url;
    this.viewModel.headerMediaForm?.uuid = selectedMedia?.id;
    this.refreshView();
  }

  // ----------------------------------
  // PRIVATES
  // ----------------------------------

  _updateValidState() {
    viewModel.canValidate.value = isValid();
    this.refreshView();
  }

  bool isValid() =>
      viewModel.positivButtonForm.text.isNotEmpty &&
      viewModel.negativButtonForm.text.isNotEmpty &&
      viewModel.titleTextForm.text.isNotEmpty &&
      viewModel.descriptionTextForm.text.isNotEmpty;

  onPreview() {
    this.viewInterface.showPreviewOfHelper(this.viewModel);
  }

  onTextPickerDone(String newVal) {
    EditableTextData formData =
        this.viewModel.currentEditableItemNotifier.value;
    formData.text = newVal;
    this.refreshView();
    this._updateValidState();
  }

  onFontPickerDone(EditedFontModel newVal) {
    EditableTextData formData =
        this.viewModel.currentEditableItemNotifier.value;
    formData.fontSize = newVal.size.toInt();
    formData.fontFamily = newVal.fontKeys.fontFamilyNameKey;
    formData.fontWeight = newVal.fontKeys.fontWeightNameKey;

    this.refreshView();
    this._updateValidState();
  }

  onMediaPickerDone(GraphicEntity newVal) {
    EditableMediaFormData formData =
        this.viewModel.currentEditableItemNotifier.value;
    formData.url = newVal.url;
    formData.uuid = newVal.id;
    this.refreshView();
    this._updateValidState();
  }

  onTextColorPickerDone(Color newVal) {
    EditableTextFormData formData =
        this.viewModel.currentEditableItemNotifier.value;
    formData.fontColor = newVal;
    this.refreshView();
    this._updateValidState();
  }

  onNewEditableSelect(EditableData p1) {
    this.viewModel.currentEditableItemNotifier.value = p1;
    this.refreshView();
  }
}
