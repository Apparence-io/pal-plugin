import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';

class EditorSimpleHelperModel extends MVVMModel {
  GlobalKey<FormState> formKey;
  GlobalKey containerKey;
  StreamController<bool> editableTextFieldController;
  
  EditorSimpleHelperModel({
    this.formKey,
    this.containerKey,
    this.editableTextFieldController,
  });
}