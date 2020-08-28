import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/database/entity/helper/helper_trigger_type.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_fullscreen_helper_widget.dart';

class EditorViewModel extends MVVMModel {
  bool enableSave;
  bool isLoading;

  // Toolbar stuff
  bool toobarIsVisible;
  Offset toolbarPosition;
  Size toolbarSize;

  FullscreenHelperNotifier fullscreenHelperNotifier;
  BasicHelper basicHelper;
}

class BasicHelper {
  final String name;
  final HelperTriggerType triggerType;
  final int priority;
  final int versionMinId;
  final int versionMaxId;

  BasicHelper({
    @required this.name,
    @required this.triggerType,
    @required this.priority,
    @required this.versionMinId,
    this.versionMaxId,
  });
}
