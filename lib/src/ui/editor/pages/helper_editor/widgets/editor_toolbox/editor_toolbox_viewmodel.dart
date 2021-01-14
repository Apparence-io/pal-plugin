import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/editor_tool_bar.dart';

enum CurrentEditableItem { textfield, button, media }

class EditorToolboxModel extends MVVMModel {
  CurrentEditableItem currentEditableItem;
  bool isActionBarVisible;
  bool isToolBarVisible;
  bool animateIcons;
  double animationTarget;
  ValueNotifier<bool> isBottomVisible;
  List<ToolBarGlobalActionButton> globalActions;
  List<ToolBarActionButton> editableElementActions;

  EditorToolboxModel({
    this.currentEditableItem,
    this.isActionBarVisible,
    this.isToolBarVisible,
    this.animationTarget,
    this.isBottomVisible,
    this.globalActions,
    this.editableElementActions,
    this.animateIcons
  });
}