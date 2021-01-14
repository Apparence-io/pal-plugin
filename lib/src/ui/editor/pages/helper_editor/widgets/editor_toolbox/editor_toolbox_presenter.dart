import 'package:flutter/widgets.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/editor_tool_bar.dart';

import 'editor_toolbox.dart';
import 'editor_toolbox_viewmodel.dart';

class EditorToolboxPresenter
    extends Presenter<EditorToolboxModel, EditorToolboxView> {
  final ValueNotifier<CurrentEditableItem> currentEditableItemNotifier;

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
    switch (this.currentEditableItemNotifier.value?.editableItemType) {
      case EditableItemType.button:
        this.viewModel.editableElementActions = [
          ToolBarActionButton.border,
          ToolBarActionButton.text,
          ToolBarActionButton.font,
          ToolBarActionButton.color,
        ];
        break;
      case EditableItemType.media:
        this.viewModel.editableElementActions = [
          ToolBarActionButton.media,
        ];
        break;
      case EditableItemType.textfield:
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
      case ToolBarActionButton.color:
        EditedColorData colorData = await this.viewInterface.openColorPicker(this.viewModel, this);
        this.onTextColorPickerDone(colorData);
        break;
      case ToolBarActionButton.font:
        EditedFontData fontData = await this.viewInterface.openFontPicker();
        this.onFontPickerDone(fontData);
        break;
      case ToolBarActionButton.media:
        EditedMediaData mediaData = await this.viewInterface.openMediaPicker();
        this.onMediaPickerDone(mediaData);
        break;
      case ToolBarActionButton.text:
        EditedTextData textData = await this.viewInterface.openTextPicker();
        this.onTextPickerDone(textData);
        break;
      default:
    }
  }

  void openGlobalPicker(ToolBarGlobalActionButton toolBarGlobalActionButton) async {
    switch (toolBarGlobalActionButton) {
      case ToolBarGlobalActionButton.backgroundColor:
        this.viewInterface.openColorPicker(this.viewModel, this);
        break;
      default:
    }
  }

  notifyBgColorChange(Color newColor) {
    this.viewModel.boxViewHandler.callback(newColor);
  }
}
