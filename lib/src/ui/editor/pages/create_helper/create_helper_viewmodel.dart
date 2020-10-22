import 'package:flutter/widgets.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/database/entity/helper/helper_theme.dart';
import 'package:palplugin/src/database/entity/helper/helper_type.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/steps/create_helper_infos/create_helper_infos_step_model.dart';

class CreateHelperModel extends MVVMModel {
  GlobalKey<NavigatorState> nestedNavigationKey;
  bool isFormValid;
  List<String> stepsTitle;
  ValueNotifier<int> step;

  // Step 1
  GlobalKey<FormState> infosForm;
  String selectedTriggerType;
  String appVersion;
  bool isAppVersionLoading;
  TextEditingController helperNameController;
  TextEditingController minVersionController;
  List<HelperTriggerTypeDisplay> triggerTypes;
  
  // Step 2
  HelperType selectedHelperType;

  // Step 3
  HelperTheme selectedHelperTheme;

  CreateHelperModel({
    this.selectedTriggerType,
    this.minVersionController,
    this.nestedNavigationKey,
    this.infosForm,
    this.isFormValid,
    this.triggerTypes,
    this.stepsTitle,
    this.step,
    this.helperNameController,
    this.selectedHelperType,
    this.selectedHelperTheme,
  });
}
