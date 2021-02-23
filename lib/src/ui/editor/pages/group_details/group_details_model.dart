import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';

class GroupDetailsModel extends MVVMModel{
  HelperTriggerType triggerType;
  String name;
  String minVer;
  String maxVer;

}