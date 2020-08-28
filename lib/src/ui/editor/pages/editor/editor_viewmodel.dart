import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/database/entity/helper/create_helper_full_screen_entity.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_fullscreen_helper_widget.dart';
import 'package:palplugin/src/ui/client/helpers/user_fullscreen_helper_widget.dart';

class EditorViewModel extends MVVMModel {
  bool enableSave;
  bool toobarIsVisible;
  Offset toolbarPosition;
  Size toolbarSize;
  bool isLoading;

  FullscreenHelperNotifier fullscreenHelperNotifier;
}
