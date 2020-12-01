import 'package:flutter/widgets.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_theme.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/ui/editor/pages/create_helper/steps/create_helper_infos/create_helper_infos_step_model.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';

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
    this.appVersion,
    this.isAppVersionLoading,
    this.isFormValid,
    this.triggerTypes,
    this.stepsTitle,
    this.step,
    this.helperNameController,
    this.selectedHelperType,
    this.selectedHelperTheme,
  });

  HelperViewModel asHelperViewModel() => HelperViewModel(
    helperType: selectedHelperType,
    helperTheme: selectedHelperTheme,
    triggerType: getHelperTriggerType(selectedTriggerType),
    name: helperNameController?.value?.text,
  );


}
