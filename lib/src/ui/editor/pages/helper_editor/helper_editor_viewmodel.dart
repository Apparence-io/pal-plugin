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
  IconData icon;

  HelperTypeOption(
    this.text,
    this.type, {
    this.icon = Icons.border_outer,
  });
}

class HelperViewModel extends MVVMModel {
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

  factory FullscreenHelperViewModel.fromHelperViewModel(
          HelperViewModel model) =>
      FullscreenHelperViewModel(
        name: model.name,
        triggerType: model.triggerType,
        priority: model.priority,
        versionMinId: model.versionMinId,
        versionMaxId: model.versionMaxId,
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

  factory SimpleHelperViewModel.fromHelperViewModel(HelperViewModel model) =>
      SimpleHelperViewModel(
        name: model.name,
        triggerType: model.triggerType,
        priority: model.priority,
        versionMinId: model.versionMinId,
        versionMaxId: model.versionMaxId,
      );
}

class UpdateHelperViewModel extends HelperViewModel {
  // TODO: It can be better to use a multi prop listener to only send
  // - Text value
  // - Text style value (including font color, background color, font size...)
  // Title text stuff
  final ValueNotifier<String> titleText =
      ValueNotifier('Enter your title here...');
  final ValueNotifier<Color> titleFontColor = ValueNotifier(Colors.white);
  final ValueNotifier<Color> titleBackgroundColor =
      ValueNotifier(Colors.black87);
  final ValueNotifier<num> titleFontSize = ValueNotifier(14.0);
  // FIXME: Remove this test
  final ValueNotifier<TextStyle> titleTextStyle =
      ValueNotifier(TextStyle(color: Colors.blue, fontSize: 30.0));
  // END

  // Changelog text stuff
  final ValueNotifier<List<String>> changelogText = ValueNotifier(
    ['Enter your first update line here...'],
  );
  final ValueNotifier<Color> changelogFontColor = ValueNotifier(Colors.white);
  final ValueNotifier<Color> changelogBackgroundColor =
      ValueNotifier(Colors.black87);
  final ValueNotifier<num> changelogFontSize = ValueNotifier(14.0);
  final ValueNotifier<int> languageId = ValueNotifier(1);

  UpdateHelperViewModel({
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

  factory UpdateHelperViewModel.fromHelperViewModel(HelperViewModel model) =>
      UpdateHelperViewModel(
        name: model.name,
        triggerType: model.triggerType,
        priority: model.priority,
        versionMinId: model.versionMinId,
        versionMaxId: model.versionMaxId,
      );
}
