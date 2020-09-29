import 'package:flutter/widgets.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/database/entity/helper/helper_type.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/steps/create_helper_infos/create_helper_infos_step_model.dart';

class CreateHelperModel extends MVVMModel {
  List<HelperTriggerTypeDisplay> triggerTypes;
  GlobalKey<NavigatorState> nestedNavigationKey;
  GlobalKey<FormState> formStep1Key;
  bool isFormValid;
  String selectedTriggerType;
  List<String> stepsTitle;
  ValueNotifier<int> step;
  TextEditingController helperNameController;
  HelperType selectedHelperType;

  CreateHelperModel({
    this.selectedTriggerType,
    this.nestedNavigationKey,
    this.formStep1Key,
    this.isFormValid,
    this.triggerTypes,
    this.stepsTitle,
    this.step,
    this.helperNameController,
    this.selectedHelperType,
  });
}
