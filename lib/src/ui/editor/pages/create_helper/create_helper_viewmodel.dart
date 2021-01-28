import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/helper/helper_theme.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/ui/editor/pages/create_helper/steps/create_helper_infos/create_helper_infos_step_model.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';

class CreateHelperModel extends MVVMModel {

  bool isFormValid;
  List<String> stepsTitle;
  ValueNotifier<int> step;

  // Step 0
  List<HelperGroupViewModel> helperGroups;
  HelperGroupViewModel selectedHelperGroup;
  List<HelperTriggerTypeDisplay> triggerTypes;
  HelperTriggerTypeDisplay selectedTriggerType;

  // Step 1
  GlobalKey<FormState> infosForm;
  String appVersion;
  bool isAppVersionLoading;
  TextEditingController helperNameController;
  TextEditingController minVersionController;
  List<GroupHelperViewModel> currentGroupHelpersList;

  // Step 2
  HelperType selectedHelperType;

  // Step 3
  HelperTheme selectedHelperTheme;

  CreateHelperModel({
    this.selectedTriggerType,
    this.minVersionController,
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
    triggerType: selectedTriggerType.key,
    name: helperNameController?.value?.text,
    minVersionCode: minVersionController?.value?.text,
    maxVersionCode: null,
    helperGroupId: selectedHelperGroup.groupId,
    helperGroupName: selectedHelperGroup.title
  );

  selectHelperGroup(HelperGroupViewModel select) {
    this.helperGroups.forEach((element) => element.selected = false);
    this.selectedHelperGroup = this.helperGroups
      .firstWhere((element) => element == select)
      ..selected = true;
  }
}

class HelperGroupViewModel extends ChangeNotifier implements ValueListenable<HelperGroupViewModel> {
  bool _selected;
  String groupId;
  String title;

  HelperGroupViewModel({@required this.groupId, @required this.title})
    : this._selected = false;

  set selected(bool selected) {
    if(this._selected != selected) {
      this._selected = selected;
      notifyListeners();
    }
  }

  bool get selected => this._selected;

  @override
  HelperGroupViewModel get value => this;

  void refresh() => notifyListeners();
}

class HelperSelectionViewModel {
  String id, title;
  HelperSelectionViewModel({@required this.id, @required this.title});
}

class GroupHelperViewModel {
  String id;
  String title;

  GroupHelperViewModel({this.id, this.title});
}