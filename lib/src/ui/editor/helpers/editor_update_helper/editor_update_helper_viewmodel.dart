import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';

class EditorUpdateHelperModel extends MVVMModel {
  GlobalKey<FormState> formKey;
  GlobalKey containerKey;
  TextEditingController titleController;
  List<TextEditingController> changelogsControllers;
  TextEditingController thanksController;
  List<Widget> changelogsTextfieldWidgets;
  StreamController<bool> editableTextFieldController;
  bool isKeyboardVisible;
  
  EditorUpdateHelperModel({
    this.formKey,
    this.containerKey,
    this.titleController,
    this.changelogsControllers,
    this.changelogsTextfieldWidgets,
    this.thanksController,
    this.editableTextFieldController,
    this.isKeyboardVisible,
  });
}