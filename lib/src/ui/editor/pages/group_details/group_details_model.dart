import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_group_entity.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';

enum PageStep { DETAILS, HELPERS }

class GroupDetailsPageModel extends MVVMModel {
  final groupId;
  final routeName;
  final startPage;

  // GROUP INFO / GROUP HELPERS
  late GroupModel groupModel;
  late ValueNotifier<List<HelperModel>?> helpers;

  // GROUP INFO CONTROLLERS & FORM KEY
  TextEditingController? groupNameController;
  HelperTriggerType? groupTriggerValue;
  TextEditingController? groupMinVerController;
  TextEditingController? groupMaxVerController;
  final GlobalKey<FormState> formKey;

  // STATE ATTRIBUTES
  bool? loading;
  PageStep? page;
  late ValueNotifier<bool> canSave;
  PageController? pageController;

  bool? editorMode;
  bool? locked;


  GroupDetailsPageModel(this.groupId, this.formKey, this.routeName, this.startPage);
}

class GroupModel {
  HelperTriggerType? triggerType;
  String? name;
  String? minVer;
  String? maxVer;
  String? groupRoute;

  GroupModel({this.triggerType, this.name, this.minVer, this.maxVer});

  static GroupModel from(HelperGroupEntity entity) => GroupModel(
        maxVer: entity.maxVersion,
        minVer: entity.minVersion,
        name: entity.name,
        triggerType: entity.triggerType,
      );
}

class HelperModel {
  String? helperId;
  String? title;
  HelperType? type;
  int? priority;
  DateTime? creationDate;

  HelperModel(
      {this.title, this.type, this.priority, this.creationDate, this.helperId});

  static HelperModel from(HelperEntity entity) => HelperModel(
        helperId: entity.id,
        creationDate: entity.creationDate,
        priority: entity.priority,
        title: entity.name,
        type: entity.type,
      );
}
