import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/database/entity/graphic_entity.dart';

class EditorFullScreenHelperModel extends MVVMModel {
  // Keys
  GlobalKey<FormState> formKey;
  GlobalKey titleKey;

  double helperOpacity;
  StreamController<bool> editableTextFieldController;

  GraphicEntity selectedMedia;
  
  EditorFullScreenHelperModel({
    this.helperOpacity,
    this.formKey,
    this.titleKey,
    this.editableTextFieldController,
    this.selectedMedia,
  });
}