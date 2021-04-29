import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';

class PageGroupsListViewModel extends MVVMModel {

  // list of groups per trigger type
  late Map<HelperTriggerType?, List<GroupItemViewModel>> groups;

  bool? isLoading;

  String? errorMessage;
  String? route;
}

class GroupItemViewModel {
  final String? title, date, version, id;

  GroupItemViewModel(this.title, this.date, this.version, this.id);
}


const HelperTriggerTypeStrings = {
  HelperTriggerType.ON_SCREEN_VISIT :"First screen visit",
  HelperTriggerType.ON_NEW_UPDATE:"New update",
  // "RANDOM_TIPS":"Random tips",
};

extension HelperTriggerTypeText on HelperTriggerType? {
  String? toText() => HelperTriggerTypeStrings[this!];
}