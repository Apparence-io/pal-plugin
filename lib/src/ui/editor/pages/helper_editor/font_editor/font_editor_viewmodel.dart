import 'package:flutter/widgets.dart';
import 'package:mvvm_builder/mvvm_builder.dart';

class FontEditorDialogModel extends MVVMModel {
  String fontFamilyName;
  TextStyle modifiedTextStyle;

  FontEditorDialogModel({
    this.fontFamilyName,
    this.modifiedTextStyle,
  });
}