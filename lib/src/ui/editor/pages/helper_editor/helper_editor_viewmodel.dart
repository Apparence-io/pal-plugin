import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/database/entity/helper/helper_theme.dart';

import 'helper_editor_notifiers.dart';

// class HelperEditorViewModel extends MVVMModel {
//   bool enableSave;
//   bool isLoading;
//   bool isEditableWidgetValid;
//   bool isEditingWidget;
//   bool isKeyboardOpened;
//   double loadingOpacity;
//   bool isHelperCreated;
//   bool isHelperCreating;
//
//   // This the template view model with all default values
//   HelperViewModel templateViewModel;
//
//   // This is the actual edited widget view model
//   HelperViewModel helperViewModel;
// }

// this is used to let user choose between all available type options
// class HelperTypeOption {
//   String text;
//   HelperType type;
//   IconData icon;
//
//   HelperTypeOption(
//     this.text,
//     this.type, {
//     this.icon = Icons.border_outer,
//   });
// }

class HelperViewModel extends MVVMModel {
  final String id;
  final String name;
  // final HelperTriggerType triggerType;
  final int priority;
  // final String minVersionCode;
  // final String maxVersionCode;
  final HelperTheme helperTheme;
  final HelperType helperType;
  final HelperGroupModel helperGroup;

  HelperViewModel({
    this.id,
    @required this.name,
    // @required this.triggerType,
    @required this.helperType,
    this.priority,
    // this.minVersionCode,
    this.helperTheme,
    // this.maxVersionCode,
    // this.helperGroupId,
    // this.helperGroupName,
    this.helperGroup
  });

}

class HelperGroupModel {
  final String id;
  final String name;
  final String minVersionCode;
  final String maxVersionCode;
  final HelperTriggerType triggerType;

  HelperGroupModel({
    this.id, this.name, this.minVersionCode, this.maxVersionCode,
    this.triggerType
  });
}