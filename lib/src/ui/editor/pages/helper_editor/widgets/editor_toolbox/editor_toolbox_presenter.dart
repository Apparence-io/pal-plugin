import 'package:flutter/widgets.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_notifiers.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/editor_tool_bar.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/font_editor/font_editor_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/font_editor/pickers/font_weight_picker/font_weight_picker_loader.dart';

import 'editor_toolbox.dart';
import 'editor_toolbox_viewmodel.dart';

class EditorToolboxPresenter
    extends Presenter<EditorToolboxModel, EditorToolboxView> {
  final ValueNotifier<FormFieldNotifier> currentEditableItemNotifier;

  final Function(EditedTextData) onTextPickerDone;
  final Function(EditedColorData) onTextColorPickerDone;
  final Function(EditedFontData) onFontPickerDone;
  final Function(EditedBorderData) onBorderPickerDone;
  final Function(EditedMediaData) onMediaPickerDone;

  EditorToolboxPresenter(
    EditorToolboxView viewInterface, {
    @required BoxViewHandler boxViewHandler,
    @required this.currentEditableItemNotifier,
    this.onBorderPickerDone,
    this.onFontPickerDone,
    this.onTextColorPickerDone,
    this.onTextPickerDone,
    this.onMediaPickerDone,
  }) : super(EditorToolboxModel(boxViewHandler: boxViewHandler), viewInterface);

  @override
  void onInit() {
    super.onInit();

    // INIT ATTRIBUTES
    this.viewModel.currentEditableItem = null;
    this.viewModel.isActionBarVisible = true;
    this.viewModel.isToolBarVisible = true;
    this.viewModel.animateIcons = false;
    this.viewModel.animateActionBar = false;
    // INIT ATTRIBUTES

    this.viewModel.editableElementActions = [];
    this.viewModel.globalActions = [
      ToolBarGlobalActionButton.backgroundColor,
    ];

    // Bottom drawer animation listener
    this.viewModel.animationTarget = 1;
    this.viewModel.isBottomVisible = ValueNotifier<bool>(true);

    // BOTTOM ANIMATION
    this.viewModel.isBottomVisible.addListener(() {
      this.viewModel.animateActionBar = true;
      this.refreshAnimations();
      this.refreshView();
      this.viewModel.animationTarget =
          this.viewModel.isBottomVisible.value ? 1 : 0;
    });

    this.currentEditableItemNotifier.addListener(() {
      this.displayEditableItemActions();
    });
  }

  void displayEditableItemActions() {
    switch (this.currentEditableItemNotifier.value?.runtimeType) {
      case ButtonFormFieldNotifier:
        this.viewModel.editableElementActions = [
          ToolBarActionButton.border,
          ToolBarActionButton.text,
          ToolBarActionButton.font,
          ToolBarActionButton.color,
        ];
        break;
      case MediaNotifier:
        this.viewModel.editableElementActions = [
          ToolBarActionButton.media,
        ];
        break;
      case TextFormFieldNotifier:
        this.viewModel.editableElementActions = [
          ToolBarActionButton.text,
          ToolBarActionButton.font,
          ToolBarActionButton.color,
        ];
        break;
      default:
    }
    this.viewModel.animateIcons = true;
    this.refreshView();
    this.refreshAnimations();
  }

  @override
  void afterViewDestroyed() {
    this.viewModel.isBottomVisible.dispose();
    super.afterViewDestroyed();
  }

  void onOutsideTap() {
    this.viewModel.editableElementActions = [];
    this.currentEditableItemNotifier.value = null;
    this.refreshView();
  }

  void openPicker(ToolBarActionButton toolBarActionButton) async {
    switch (toolBarActionButton) {
      // TODO: Séparer les couleurs de Font/Background/Border
      case ToolBarActionButton.color:
        EditableFormFieldNotifier editableFormField = this.currentEditableItemNotifier?.value;
        Color newColor =
            await this.viewInterface.openColorPicker(editableFormField.fontColor.value);
        if (newColor != null) {
          editableFormField.fontColor.value = newColor;
        }
        break;
      case ToolBarActionButton.font:
        EditableFormFieldNotifier editableFormField = this.currentEditableItemNotifier?.value;
        EditedFontModel newFont = await this.viewInterface.openFontPicker(editableFormField.fontFamily.value,editableFormField.fontSize.value,editableFormField.fontWeight.value);
        if (newFont != null) {
          String fontWeight = newFont.fontKeys.fontWeightNameKey;
          String fontFamily = newFont.fontKeys.fontFamilyNameKey;
          double fontSize = newFont.size;

          
          editableFormField.fontFamily.value = fontFamily;
          editableFormField.fontSize.value = fontSize.toInt();
          editableFormField.fontWeight.value = fontWeight;
          this.refreshView();
        }
        break;
      case ToolBarActionButton.media:
        String newUrl = await this.viewInterface.openMediaPicker();
        if (newUrl != null) {
          MediaNotifier mediaNotifier = this.currentEditableItemNotifier?.value;
          mediaNotifier.url.value = newUrl;
        }
        break;
      case ToolBarActionButton.text:
        EditableFormFieldNotifier editableFormField = this.currentEditableItemNotifier?.value;
        String newText = await this.viewInterface.openTextPicker(editableFormField.text.value);
        if (newText != null) {
          editableFormField.text.value = newText;
        }
        break;
      default:
    }
  }

  void openGlobalPicker(
      ToolBarGlobalActionButton toolBarGlobalActionButton) async {
    switch (toolBarGlobalActionButton) {
      case ToolBarGlobalActionButton.backgroundColor:
        Color newColor = await this.viewInterface.openColorPicker(this.viewModel.boxViewHandler.selectedColor);
        if (newColor != null) {
          this.viewModel.boxViewHandler.callback(newColor);
        }
        break;
      default:
    }
  }
}
