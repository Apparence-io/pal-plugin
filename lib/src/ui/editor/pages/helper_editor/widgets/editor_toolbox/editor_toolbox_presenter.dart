import 'package:flutter/widgets.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/editor_tool_bar.dart';

import 'editor_toolbox.dart';
import 'editor_toolbox_viewmodel.dart';

class EditorToolboxPresenter
    extends Presenter<EditorToolboxModel, EditorToolboxView> {
  final ValueNotifier<CurrentEditableItem> currentEditableItemNotifier;

  EditorToolboxPresenter(
    EditorToolboxView viewInterface, {
    @required BoxViewHandler boxViewHandler,
    @required this.currentEditableItemNotifier,
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
    switch (this.currentEditableItemNotifier.value) {
      case CurrentEditableItem.button:
        this.viewModel.editableElementActions = [
          ToolBarActionButton.border,
          ToolBarActionButton.text,
          ToolBarActionButton.font,
          ToolBarActionButton.color,
        ];
        break;
      case CurrentEditableItem.media:
        this.viewModel.editableElementActions = [
          ToolBarActionButton.media,
        ];
        break;
      case CurrentEditableItem.textfield:
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
    // TODO: Open correct picker in view interface
    switch (toolBarActionButton) {
      case ToolBarActionButton.color:
        Color newColor = await this.viewInterface.openColorPicker(this.viewModel,this);
        break;
      case ToolBarActionButton.font:
        // TODO: Create mode
        dynamic newFont = await this.viewInterface.openFontPicker();
        break;
      case ToolBarActionButton.media:
        String newUrl = await this.viewInterface.openMediaPicker();
        break;
      case ToolBarActionButton.text:
        String newText = await this.viewInterface.openTextPicker();
        break;
      default:
    }

    // TODO: Update child helper
  }

  void openGlobalPicker(ToolBarGlobalActionButton toolBarGlobalActionButton) async {
    switch (toolBarGlobalActionButton) {
      case ToolBarGlobalActionButton.backgroundColor:
        this.viewInterface.openColorPicker(this.viewModel,this);
        break;
      default:
    }
  }

  notifyBgColorChange(Color newColor) {
    this.viewModel.boxViewHandler.callback(newColor);
  }
}
