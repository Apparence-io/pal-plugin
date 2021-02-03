import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/helper/helper_theme.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/ui/editor/pages/create_helper/steps/create_helper_infos/create_helper_infos_step_model.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';

class CreateHelperModel extends MVVMModel {

  ValueNotifier<bool> isFormValid = ValueNotifier(false);
  List<String> stepsTitle;
  ValueNotifier<int> step;

  // Step 0
  List<HelperGroupViewModel> helperGroups;
  HelperGroupViewModel selectedHelperGroup;
  List<HelperTriggerTypeDisplay> triggerTypes;
  HelperTriggerTypeDisplay selectedTriggerType;
  String appVersion, minVersion, maxVersion;
  bool helperGroupCreationState;

  // Step 1
  GlobalKey<FormState> infosForm;
  bool isAppVersionLoading;
  TextEditingController helperNameController;
  List<GroupHelperViewModel> currentGroupHelpersList;

  // Step 2
  HelperType selectedHelperType;

  // Step 3
  HelperTheme selectedHelperTheme;


  CreateHelperModel({
    this.selectedTriggerType,
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
    name: helperNameController?.value?.text,
    // priority: ,
    helperGroup: HelperGroupModel(
      id: selectedHelperGroup?.groupId,
      name: selectedHelperGroup?.title,
      triggerType: selectedTriggerType.key,
      minVersionCode: selectedHelperGroup?.groupId != null ? minVersion : null,
      maxVersionCode: selectedHelperGroup?.groupId != null ? maxVersion : null,
    )
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

  HelperGroupViewModel copy() => HelperGroupViewModel(
    groupId: this.groupId,
    title: this.title
  );
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