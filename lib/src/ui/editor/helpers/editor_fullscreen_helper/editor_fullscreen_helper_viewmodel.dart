import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';

class EditorFullScreenHelperModel extends MVVMModel {
  double helperOpacity;
  GlobalKey<FormState> formKey;
  GlobalKey titleKey;
  FocusNode titleFocus;
  TextEditingController titleController;
  bool isToolbarVisible;
  
  EditorFullScreenHelperModel({
    this.helperOpacity,
    this.formKey,
    this.titleKey,
    this.titleFocus,
    this.titleController,
    this.isToolbarVisible,
  });
}