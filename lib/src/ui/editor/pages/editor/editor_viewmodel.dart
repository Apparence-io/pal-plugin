import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/database/entity/helper/helper_trigger_type.dart';

class EditorViewModel extends MVVMModel {
  bool enableSave;
  bool isLoading;

  // Toolbar stuff
  bool toolbarIsVisible;
  Offset toolbarPosition;
  Size toolbarSize;

  // FullscreenHelperNotifier fullscreenHelperNotifier;
  HelperViewModel basicHelperModel;
}

class HelperViewModel<T> {
  final String name;
  final HelperTriggerType triggerType;
  final int priority;
  final int versionMinId;
  final int versionMaxId;
  final T helper;

  HelperViewModel({
    @required this.name,
    @required this.triggerType,
    @required this.priority,
    @required this.versionMinId,
    this.versionMaxId,
    @required this.helper,
  });
}

class FullscreenHelperViewModel
    extends HelperViewModel<FullscreenHelperViewModel> {
  final ValueNotifier<String> title = ValueNotifier('Edit me!');
  final ValueNotifier<Color> fontColor = ValueNotifier(Colors.white);
  final ValueNotifier<Color> backgroundColor = ValueNotifier(Colors.blueAccent);
  final ValueNotifier<Color> borderColor = ValueNotifier(Colors.greenAccent);
  final ValueNotifier<int> languageId = ValueNotifier(1);
  final ValueNotifier<num> fontSize = ValueNotifier(80.0);
}
