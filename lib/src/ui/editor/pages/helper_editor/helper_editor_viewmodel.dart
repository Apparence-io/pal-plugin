import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/database/entity/helper/helper_trigger_type.dart';
import 'package:palplugin/src/database/entity/helper/helper_type.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/font_editor/pickers/font_weight_picker/font_weight_picker_loader.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor_notifiers.dart';

class HelperEditorViewModel extends MVVMModel {
  bool enableSave;
  bool isLoading;
  bool isEditableWidgetValid;
  bool isEditingWidget;

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
  final ValueNotifier<int> languageId = ValueNotifier(1);
  final ValueNotifier<Color> backgroundColor = ValueNotifier(Colors.blueAccent);
  final MediaNotifier media = MediaNotifier(key: 'header');
  final TextFormFieldNotifier titleField = TextFormFieldNotifier(
    fontColor: Colors.white,
    borderColor: Colors.greenAccent,
    fontSize: 60,
    text: '',
    fontWeight: FontWeightMapper.toFontKey(FontWeight.normal),
  );
  final TextFormFieldNotifier descriptionField = TextFormFieldNotifier(
    fontColor: Color(0xFFCCC2),
    fontSize: 14,
    text: '',
    fontWeight: FontWeightMapper.toFontKey(FontWeight.normal),
  );
  final TextFormFieldNotifier positivButtonField = TextFormFieldNotifier(
    fontColor: Color(0xFFCCC2),
    fontSize: 14,
    text: '',
    fontWeight: FontWeightMapper.toFontKey(FontWeight.normal),
  );
  final TextFormFieldNotifier negativButtonField = TextFormFieldNotifier(
    text: '',
    fontWeight: FontWeightMapper.toFontKey(FontWeight.normal),
    fontColor: Color(0xFFCCC2),
    fontSize: 14,);

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

  factory FullscreenHelperViewModel.fromHelperViewModel(HelperViewModel model) =>
      FullscreenHelperViewModel(
        name: model.name,
        triggerType: model.triggerType,
        priority: model.priority,
        versionMinId: model.versionMinId,
        versionMaxId: model.versionMaxId,
      );
}

class SimpleHelperViewModel extends HelperViewModel {
  final ValueNotifier<int> languageId = ValueNotifier(1);

  final TextFormFieldNotifier detailsField = TextFormFieldNotifier(
    backgroundColor: Colors.black87,
    fontColor: Colors.white,
    borderColor: Colors.greenAccent,
    fontSize: 14,
    text: '',
  );

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
  final ValueNotifier<int> languageId = ValueNotifier(1);
  final ValueNotifier<Color> backgroundColor = ValueNotifier(Colors.blueAccent);
  final Map<String, TextFormFieldNotifier> changelogsFields = {};
  final MediaNotifier media = MediaNotifier(key: 'header');
  final TextFormFieldNotifier thanksButton = TextFormFieldNotifier(
    backgroundColor: Colors.black87,
    fontColor: Colors.black87,
    fontSize: 24,
    text: 'Thank you!',
  );
  final TextFormFieldNotifier titleField = TextFormFieldNotifier(
    backgroundColor: Colors.black87,
    fontColor: Colors.black87,
    fontSize: 24,
    text: '',
    hintText: 'Enter your title here...'
  );

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