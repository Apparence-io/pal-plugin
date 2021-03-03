import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';

class EditorPreviewModel extends MVVMModel {
  // CORE ATTRIBUTES
  final String helperId;
  final Widget preBuiltHelper;
  final Function onDismiss;
  //* BASE HELPER ENTITY FOR PREVIEW HELPER
  HelperEntity helperEntity;

  // STATE ATTRIBUTES
  bool loading;


  EditorPreviewModel(this.helperId, this.onDismiss, this.preBuiltHelper);
}