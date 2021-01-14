import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/editor_tool_bar.dart';

enum EditableItemType { textfield, button, media }

class CurrentEditableItem {
  final EditableItemType editableItemType;
  final Key itemKey;

  CurrentEditableItem({
    @required this.editableItemType,
    @required this.itemKey,
  });
}

class EditedData {
  final Key key;
  EditedData(this.key);
}

class EditedTextData extends EditedData {
  String text;

  EditedTextData(
    Key key, {
    this.text,
  }) : super(key);
}

class EditedMediaData extends EditedData {
  String url;

  EditedMediaData(
    Key key, {
    this.url,
  }) : super(key);
}

class EditedColorData extends EditedData {
  Color color;

  EditedColorData(
    Key key, {
    this.color,
  }) : super(key);
}

class EditedBorderData extends EditedData {
  double thickness;
  Color color;

  EditedBorderData(
    Key key, {
    this.thickness,
    this.color,
  }) : super(key);
}

class EditedFontData extends EditedData {
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
  }) : super(key);
}

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
    this.animateIcons,
  });
}
