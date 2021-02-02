import 'package:flutter/widgets.dart';
import 'package:mvvm_builder/mvvm_builder.dart';

class FontEditorDialogModel extends MVVMModel {
  FontKeys fontKeys;
  TextStyle modifiedTextStyle;

  FontEditorDialogModel({
    this.fontKeys,
    this.modifiedTextStyle,
  });
}

class FontKeys {
  String fontFamilyNameKey;
  String fontWeightNameKey;

  FontKeys({
    this.fontFamilyNameKey,
    this.fontWeightNameKey,
  });
}

class EditedFontModel{
  FontKeys fontKeys;
  double size;

  EditedFontModel(this.fontKeys,this.size);
}