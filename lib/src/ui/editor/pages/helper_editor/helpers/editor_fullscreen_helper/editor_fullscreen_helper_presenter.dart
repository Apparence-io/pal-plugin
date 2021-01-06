import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/services/editor/helper/helper_editor_models.dart';
import 'package:pal/src/services/editor/helper/helper_editor_service.dart';
import 'package:pal/src/services/pal/pal_state_service.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/font_editor/font_editor_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_factory.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_notifiers.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_sending_overlay.dart';

import 'editor_fullscreen_helper.dart';
import 'editor_fullscreen_helper_viewmodel.dart';

class EditorFullScreenHelperPresenter extends Presenter<FullscreenHelperViewModel, EditorFullScreenHelperView> {

  final EditorHelperService editorHelperService;

  final HelperEditorPageArguments parameters;
  
  EditorFullScreenHelperPresenter(
    EditorFullScreenHelperView viewInterface,
    FullscreenHelperViewModel viewModel,
    this.editorHelperService,
    this.parameters,
  ) : super(viewModel, viewInterface) {
    this.viewModel.helperOpacity = 1;
    this.viewModel.canValidate = new ValueNotifier(false);
    this.viewModel.editableTextFieldController = StreamController<bool>.broadcast();
  }

  @override
  void onInit() {
    super.onInit();
    viewModel.fields.forEach(
      (field) => field.toolbarVisibility.addListener(
        () => _onTextToolbarVisibilityChange(field)
      )
    );
  }


  Future onValidate() async {
    ValueNotifier<SendingStatus> status = new ValueNotifier(SendingStatus.SENDING);
    final config = CreateHelperConfig.from(parameters.pageId, viewModel);
    try {
      await viewInterface.showLoadingScreen(status);
      await Future.delayed(Duration(seconds: 1));
      await editorHelperService
        .saveFullScreenHelper(EditorEntityFactory.buildFullscreenArgs(config, viewModel));
      status.value = SendingStatus.SENT;
    } catch(error) {
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

  // Title
  onTitleChanged(String id, String newValue)
    => _onTextChanged(viewModel.titleField, newValue);
  
  onTitleSubmit(String text)
    => _onFieldSubmit(text);

  onTitleTextStyleChanged(String id, TextStyle newTextStyle, FontKeys fontKeys) 
    => _onStyleChanged(viewModel.titleField, newTextStyle, fontKeys);

  // Description field
  onDescriptionChanged(String id, String newValue)
    => _onTextChanged(viewModel.descriptionField, newValue);

  onDescriptionSubmit(String text)
    => _onFieldSubmit(text);

  onDescriptionTextStyleChanged(String id, TextStyle newTextStyle, FontKeys fontKeys)
    => _onStyleChanged(viewModel.descriptionField, newTextStyle, fontKeys);
  
  // Positiv button
  onPositivTextChanged(String id, String newValue)
    => _onTextChanged(viewModel.positivButtonField, newValue);
  
  onPositivTextSubmit(String text)
    => _onFieldSubmit(text);

  onPositivTextStyleChanged(String id, TextStyle newTextStyle, FontKeys fontKeys) 
    => _onStyleChanged(viewModel.positivButtonField, newTextStyle, fontKeys);

  // Negativ button
  onNegativTextChanged(String id, String newValue) 
    => _onTextChanged(viewModel.negativButtonField, newValue);
  
  onNegativTextSubmit(String text)
    => _onFieldSubmit(text);

  onNegativTextStyleChanged(String id, TextStyle newTextStyle, FontKeys fontKeys) 
    => _onStyleChanged(viewModel.negativButtonField, newTextStyle, fontKeys);

  

  @override
  Future onDestroy() async {
    this.viewModel.editableTextFieldController.close();
    super.onDestroy();
    // this.viewModel.canValidate.dispose();
    // this.viewModel.canValidate = null;
  }

  @override
  void afterViewDestroyed() {
    // this.viewModel.canValidate.dispose();
    // this.viewModel.canValidate = null;
  }

  //TODO move  to view
  TextStyle googleCustomFont(String fontFamily) => this.viewInterface.googleCustomFont(fontFamily);

  onOutsideTap() {
    this.viewModel.editableTextFieldController.add(true);
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

  changeBackgroundColor() => this.viewInterface.showColorPickerDialog(viewModel, this);

  updateBackgroundColor(Color aColor) {
    viewModel.bodyBox.backgroundColor.value = aColor;
    this.viewInterface.closeColorPickerDialog();
    _updateValidState();
    this.refreshView();
  }

  cancelUpdateBackgroundColor() => this.viewInterface.closeColorPickerDialog();

  editMedia() async {
    final selectedMedia = await this
        .viewInterface
        .pushToMediaGallery(this.viewModel.media?.uuid);

    this.viewModel.media?.url?.value = selectedMedia?.url;
    this.viewModel.media?.uuid = selectedMedia?.id;
    this.refreshView();
  }
  
  
  // ----------------------------------
  // PRIVATES 
  // ----------------------------------
  
  _onTextChanged(TextFormFieldNotifier textNotifier, String newValue) {
    textNotifier.text.value = newValue;
    _updateValidState();
  }

  _onTextToolbarVisibilityChange(TextFormFieldNotifier textNotifier) {
    if(textNotifier.toolbarVisibility.value) {
      viewModel.fields.where((element) => element != textNotifier && element.toolbarVisibility.value)
        .forEach((element) => element.toolbarVisibility.value = false);
    }
  }

  _updateValidState() => viewModel.canValidate.value = isValid();

  _onStyleChanged(TextFormFieldNotifier textNotifier, TextStyle newTextStyle, FontKeys fontKeys) {
    textNotifier?.fontColor?.value = newTextStyle?.color;
    textNotifier?.fontSize?.value = newTextStyle?.fontSize?.toInt();
    if (fontKeys != null) {
      textNotifier?.fontWeight?.value = fontKeys.fontWeightNameKey;
      textNotifier?.fontFamily?.value = fontKeys.fontFamilyNameKey;
    }
    _updateValidState();
  }

  bool isValid() => viewModel.positivButtonField.text.value.isNotEmpty
        && viewModel.negativButtonField.text.value.isNotEmpty
        && viewModel.titleField.text.value.isNotEmpty
        && viewModel.descriptionField.text.value.isNotEmpty;

  _onFieldSubmit(String text) {
    this.refreshView();
  }
}
