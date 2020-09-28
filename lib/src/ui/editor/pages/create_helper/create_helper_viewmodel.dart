import 'package:flutter/widgets.dart';
import 'package:mvvm_builder/mvvm_builder.dart';

class HelperTriggerTypeDisplay {
  final String key;
  final String description;

  HelperTriggerTypeDisplay({
    this.key,
    this.description,
  });
}

class CreateHelperModel extends MVVMModel {
  List<HelperTriggerTypeDisplay> triggerTypes;
  GlobalKey<NavigatorState> nestedNavigationKey;
  GlobalKey<FormState> formKey;
  bool isFormValid;
  String selectedTriggerType;
  List<String> stepsTitle;
  ValueNotifier<int> step;
  TextEditingController helperNameController;

  CreateHelperModel({
    this.selectedTriggerType,
    this.nestedNavigationKey,
    this.formKey,
    this.isFormValid,
    this.triggerTypes,
    this.stepsTitle,
    this.step,
    this.helperNameController,
  });
}
