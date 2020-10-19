import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/database/entity/graphic_entity.dart';

class EditorUpdateHelperModel extends MVVMModel {
  GlobalKey<FormState> formKey;
  List<Widget> changelogsTextfieldWidgets;
  StreamController<bool> editableTextFieldController;
  bool isKeyboardVisible;
  ScrollController scrollController;
  GraphicEntity selectedMedia;
  
  EditorUpdateHelperModel({
    this.formKey,
    this.changelogsTextfieldWidgets,
    this.editableTextFieldController,
    this.isKeyboardVisible,
    this.scrollController,
    this.selectedMedia,
  });
}