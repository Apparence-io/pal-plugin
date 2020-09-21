import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';

class EditorUpdateHelperModel extends MVVMModel {
  GlobalKey<FormState> formKey;
  GlobalKey containerKey;
  TextEditingController detailsController;
  
  EditorUpdateHelperModel({
    this.formKey,
    this.containerKey,
    this.detailsController,
  });
}