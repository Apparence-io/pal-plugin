import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';

class EditorUpdateHelperModel extends MVVMModel {
  GlobalKey<FormState> formKey;
  List<Widget> changelogsTextfieldWidgets;
  StreamController<bool> editableTextFieldController;
  bool isKeyboardVisible;
  ScrollController scrollController;
  
  EditorUpdateHelperModel({
    this.formKey,
    this.changelogsTextfieldWidgets,
    this.editableTextFieldController,
    this.isKeyboardVisible,
    this.scrollController,
  });
}