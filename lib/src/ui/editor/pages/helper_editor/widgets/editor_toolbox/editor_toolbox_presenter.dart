import 'package:flutter/widgets.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/graphic_entity.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_data.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/editor_tool_bar.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/font_editor/font_editor_viewmodel.dart';

import 'editor_toolbox.dart';
import 'editor_toolbox_viewmodel.dart';

class EditorToolboxPresenter
    extends Presenter<EditorToolboxModel, EditorToolboxView> {
  final ValueNotifier<EditableData> currentEditableItemNotifier;

  // TODO : Remove dynamic
  final Function(String) onTextPickerDone;
  final Function(Color) onTextColorPickerDone;
  final Function(EditedFontModel) onFontPickerDone;
  // final Function(dynamic) onBorderPickerDone;
  final Function(GraphicEntity) onMediaPickerDone;

  EditorToolboxPresenter(
    EditorToolboxView viewInterface, {
    @required BoxViewHandler boxViewHandler,
    @required this.currentEditableItemNotifier,
    // this.onBorderPickerDone,
    this.onFontPickerDone,
    this.onTextColorPickerDone,
    this.onTextPickerDone,
    this.onMediaPickerDone,
  }) : super(EditorToolboxModel(boxViewHandler: boxViewHandler), viewInterface);

  @override
  void onInit() {
    super.onInit();

    // INIT ATTRIBUTES
    this.viewModel.isActionBarVisible = true;
    this.viewModel.isToolBarVisible = true;
    this.viewModel.animateIcons = false;
    this.viewModel.animateActionBar = false;
    // INIT ATTRIBUTES

    if(this.viewModel.editableElementActions == null) this.viewModel.editableElementActions = [];
    this.viewModel.globalActions = [
      ToolBarGlobalActionButton.backgroundColor,
    ];

    // Bottom drawer animation listener
    this.viewModel.animationTarget = 1;
    this.viewModel.isBottomVisible = ValueNotifier<bool>(true);

    // BOTTOM ANIMATION
    this.viewModel.isBottomVisible.addListener(animateActionBar);

    this.currentEditableItemNotifier.addListener(() {
      this.displayEditableItemActions();
    });
  }

  void animateActionBar() {
    this.viewModel.animateActionBar = true;
    this.refreshAnimations();
    this.refreshView();
    this.viewModel.animationTarget =
        this.viewModel.isBottomVisible.value ? 1 : 0;
  }

  void displayEditableItemActions() {
    switch (this.currentEditableItemNotifier.value?.runtimeType) {
      case EditableButtonFormData:
        this.viewModel.editableElementActions = [
          ToolBarActionButton.border,
          ToolBarActionButton.text,
          ToolBarActionButton.font,
          ToolBarActionButton.color,
        ];
        break;
      case EditableMediaFormData:
        this.viewModel.editableElementActions = [
          ToolBarActionButton.media,
        ];
        break;
      case EditableTextFormData:
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
    if(this.currentEditableItemNotifier.value != null)this.refreshAnimations();
  }

  @override
  void afterViewDestroyed() {
    this.viewModel.isBottomVisible.removeListener(animateActionBar);
    super.afterViewDestroyed();
  }

  void onOutsideTap() {
    this.viewModel.editableElementActions = [];
    this.currentEditableItemNotifier.value = null;

  }

  void openPicker(ToolBarActionButton toolBarActionButton) async {
    switch (toolBarActionButton) {
      // TODO: Séparer les couleurs de Font/Background/Border
      case ToolBarActionButton.color:
        EditableTextData editableFormField =
            this.currentEditableItemNotifier?.value;
        Color newColor = await this
            .viewInterface
            .openColorPicker(editableFormField.fontColor);
        if (newColor != null) {
          this.onTextColorPickerDone(newColor);
        }
        break;
      case ToolBarActionButton.font:
        EditableTextData editableFormField =
            this.currentEditableItemNotifier?.value;
        EditedFontModel newFont = await this.viewInterface.openFontPicker(
            editableFormField.fontFamily,
            editableFormField.fontSize,
            editableFormField.fontWeight);
        if (newFont != null) {
          this.onFontPickerDone(newFont);
        }
        break;
      case ToolBarActionButton.media:
        EditableMediaFormData mediaNotifier = this.currentEditableItemNotifier?.value;
        GraphicEntity newGraphicEntity =
            await this.viewInterface.openMediaPicker(mediaNotifier?.uuid);
        if (newGraphicEntity != null) {
          this.onMediaPickerDone(newGraphicEntity);
        }
        break;
      case ToolBarActionButton.text:
        EditableTextData editableFormField =
            this.currentEditableItemNotifier?.value;
        String newText = await this
            .viewInterface
            .openTextPicker(editableFormField.text);
        if (newText != null) {
          this.onTextPickerDone(newText);
        }
        break;
      default:
    }
  }

  void openGlobalPicker(
      ToolBarGlobalActionButton toolBarGlobalActionButton) async {
    switch (toolBarGlobalActionButton) {
      case ToolBarGlobalActionButton.backgroundColor:
        Color newColor = await this
            .viewInterface
            .openColorPicker(this.viewModel.boxViewHandler?.selectedColor);
        if (newColor != null) {
          this.viewModel.boxViewHandler.callback(newColor);
        }
        break;
      default:
    }
  }
}
