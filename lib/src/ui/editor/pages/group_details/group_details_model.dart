import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_group_entity.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';

enum PageStep { DETAILS, HELPERS }

class GroupDetailsPageModel extends MVVMModel {
  final groupId;

  // GROUP INFO / GROUP HELPERS
  GroupModel groupModel;
  ValueNotifier<List<HelperModel>> helpers;

  // GROUP INFO CONTROLLERS & FORM KEY
  TextEditingController groupNameController;
  HelperTriggerType groupTriggerValue;
  TextEditingController groupMinVerController;
  TextEditingController groupMaxVerController;
  final GlobalKey<FormState> formKey;

  // STATE ATTRIBUTES
  bool loading;
  PageStep page;
  ValueNotifier<bool> canSave;

  bool locked;

  GroupDetailsPageModel(this.groupId, this.formKey);
}

class GroupModel {
  HelperTriggerType triggerType;
  String name;
  String minVer;
  String maxVer;

  GroupModel({this.triggerType, this.name, this.minVer, this.maxVer});

  static GroupModel from(HelperGroupEntity entity) => GroupModel(
        maxVer: entity.maxVersion,
        minVer: entity.minVersion,
        name: entity.name,
        triggerType: entity.triggerType,
      );
}

class HelperModel {
  String title;
  HelperType type;
  int priority;
  DateTime creationDate;

  HelperModel({this.title, this.type, this.priority, this.creationDate});

  static HelperModel from(HelperEntity entity) => HelperModel(
      creationDate: entity.creationDate,
      priority: entity.priority,
      title: entity.name,
      type: entity.type);
}
