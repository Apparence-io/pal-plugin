import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';

class EditorSimpleHelperModel extends MVVMModel {
  GlobalKey<FormState> formKey;
  GlobalKey containerKey;
  TextEditingController detailsController;
  bool isToolbarVisible;
  
  EditorSimpleHelperModel({
    this.formKey,
    this.containerKey,
    this.detailsController,
    this.isToolbarVisible,
  });
}