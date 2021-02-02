import 'package:flutter/material.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/editor_tool_bar.dart';

typedef OnNewBgColor(Color color);

class EditedBorderData {
  double thickness;
  Color color;

  EditedBorderData(
    Key key, {
    this.thickness,
    this.color,
  });
}

class EditedFontData {
  Color color;
  double size;
  String fontFamily;
  FontWeight fontWeight;

  EditedFontData(
    Key key, {
    this.size,
    this.color,
    this.fontFamily,
    this.fontWeight,
  });
}

class EditorToolboxModel {
  bool isActionBarVisible;
  bool isToolBarVisible;

  bool animateIcons;
  double animationTarget;

  ValueNotifier<bool> isBottomVisible;

  List<ToolBarGlobalActionButton> globalActions;
  List<ToolBarActionButton> editableElementActions;

  BoxViewHandler boxViewHandler;

  bool animateActionBar;

  EditorToolboxModel({
    this.isActionBarVisible,
    this.isToolBarVisible,
    this.animationTarget,
    this.isBottomVisible,
    this.globalActions,
    this.editableElementActions,
    this.animateIcons,
    this.boxViewHandler,
  });
}

class BoxViewHandler{
  Color selectedColor;
  OnNewBgColor callback;

  BoxViewHandler({this.selectedColor, this.callback});
}
