import 'package:mvvm_builder/mvvm_builder.dart';

import '../../../../database/entity/helper/helper_trigger_type.dart';

enum HelperDetailsPopState { deleted, editorOpened }

class HelperDetailsModel extends MVVMModel {
  String helperName;
  String helperMinVer;
  String helperMaxVer;
  HelperTriggerType helperTriggerType;
  bool isDeleting;
  bool isDeleteSuccess;
}
