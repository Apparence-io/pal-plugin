import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';

class PageGroupsListViewModel extends MVVMModel {

  // list of groups per trigger type
  Map<HelperTriggerType, List<GroupItemViewModel>> groups;

  bool isLoading;

}

class GroupItemViewModel {
  final String title, date, version;

  GroupItemViewModel(this.title, this.date, this.version);
}


const HelperTriggerTypeStrings = {
  HelperTriggerType.ON_SCREEN_VISIT :"First screen visit",
  HelperTriggerType.ON_NEW_UPDATE:"New update",
  // "RANDOM_TIPS":"Random tips",
};

extension HelperTriggerTypeText on HelperTriggerType {
  String toText() => HelperTriggerTypeStrings[this];
}