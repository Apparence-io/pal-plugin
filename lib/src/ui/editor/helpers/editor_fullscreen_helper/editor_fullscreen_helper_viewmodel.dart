import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';

class EditorFullScreenHelperModel extends MVVMModel {
  // Keys
  GlobalKey<FormState> formKey;
  GlobalKey titleKey;

  TextEditingController titleController;
  double helperOpacity;
  StreamController<bool> editableTextFieldController;
  
  EditorFullScreenHelperModel({
    this.helperOpacity,
    this.formKey,
    this.titleKey,
    this.titleController,
    this.editableTextFieldController,
  });
}