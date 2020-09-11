import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/database/entity/helper/helper_trigger_type.dart';
import 'package:palplugin/src/database/entity/helper/helper_type.dart';

class HelperEditorViewModel extends MVVMModel {
  bool enableSave;
  bool isLoading;
  bool isEditableWidgetValid;

  // Toolbar stuff
  bool toolbarIsVisible;
  Offset toolbarPosition;
  Size toolbarSize;
  Size editedWidgetSize;
  bool isEditingWidget;

  // this is used to let user choose between all available type options
  List<HelperTypeOption> availableHelperType;
  
  // This the template view model with all default values
  HelperViewModel templateViewModel;

  // This is the actual edited widget view model
  HelperViewModel helperViewModel;
}

// this is used to let user choose between all available type options
class HelperTypeOption {
  String text;
  HelperType type;

  HelperTypeOption(this.text, this.type);
}

class HelperViewModel {
  final String name;
  final HelperTriggerType triggerType;
  final int priority;
  final int versionMinId;
  final int versionMaxId;

  HelperViewModel({
    @required this.name,
    @required this.triggerType,
    @required this.priority,
    @required this.versionMinId,
    this.versionMaxId,
  });
}

class FullscreenHelperViewModel extends HelperViewModel {
  final ValueNotifier<String> title = ValueNotifier('Edit me!');
  final ValueNotifier<Color> fontColor = ValueNotifier(Colors.white);
  final ValueNotifier<Color> backgroundColor = ValueNotifier(Colors.blueAccent);
  final ValueNotifier<Color> borderColor = ValueNotifier(Colors.greenAccent);
  final ValueNotifier<int> languageId = ValueNotifier(1);
  final ValueNotifier<num> fontSize = ValueNotifier(80.0);

  FullscreenHelperViewModel({
    @required String name,
    @required HelperTriggerType triggerType,
    @required int priority,
    @required int versionMinId,
    int versionMaxId,
  }) : super(
          name: name,
          triggerType: triggerType,
          priority: priority,
          versionMinId: versionMinId,
          versionMaxId: versionMaxId,
        );
}

class SimpleHelperViewModel extends HelperViewModel {
  final ValueNotifier<String> details = ValueNotifier('Edit me!');
  final ValueNotifier<Color> fontColor = ValueNotifier(Colors.white);
  final ValueNotifier<Color> backgroundColor = ValueNotifier(Colors.black87);
  final ValueNotifier<Color> borderColor = ValueNotifier(Colors.greenAccent);
  final ValueNotifier<int> languageId = ValueNotifier(1);
  final ValueNotifier<num> fontSize = ValueNotifier(14.0);

  SimpleHelperViewModel({
    @required String name,
    @required HelperTriggerType triggerType,
    @required int priority,
    @required int versionMinId,
    int versionMaxId,
  }) : super(
          name: name,
          triggerType: triggerType,
          priority: priority,
          versionMinId: versionMinId,
          versionMaxId: versionMaxId,
        );
}

