import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';

class EditorFullScreenHelperModel extends MVVMModel {
  // Keys
  GlobalKey<FormState> formKey;
  GlobalKey titleKey;

  // Title text field
  FocusNode titleFocus;
  TextEditingController titleController;
  
  double helperOpacity;
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