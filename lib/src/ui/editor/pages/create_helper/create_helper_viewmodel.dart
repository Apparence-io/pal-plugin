import 'package:mvvm_builder/mvvm_builder.dart';

class HelperSteps {
  final double index;
  final String title;

  HelperSteps({
    this.index,
    this.title,
  });
}

class HelperTriggerTypeDisplay {
  final String key;
  final String description;

  HelperTriggerTypeDisplay({
    this.key,
    this.description,
  });
}

class CreateHelperModel extends MVVMModel {
  bool isFormValid;
  List<HelperTriggerTypeDisplay> triggerTypes;
  String selectedTriggerType;

  CreateHelperModel({
    this.isFormValid,
    this.triggerTypes,
    this.selectedTriggerType,
  });
}