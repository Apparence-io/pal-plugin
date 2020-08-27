import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';

class EditorViewModel extends MVVMModel {
  bool enableSave;
  bool toobarIsVisible;
  Offset toolbarPosition;
  Size toolbarSize;
}
