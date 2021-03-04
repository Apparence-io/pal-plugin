import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/database/entity/helper/helper_theme.dart';


class HelperViewModel extends MVVMModel {
  final String id;
  final String name;
  final int priority;
  final HelperTheme helperTheme;
  final HelperType helperType;
  final HelperGroupModel helperGroup;

  HelperViewModel({
    this.id,
    @required this.name,
    @required this.helperType,
    @required this.priority,
    this.helperTheme,
    this.helperGroup
  });

}

class HelperGroupModel {
  final String id;
  final String name;
  final String minVersionCode;
  final String maxVersionCode;
  final HelperTriggerType triggerType;

  HelperGroupModel({
    this.id, this.name, this.minVersionCode, this.maxVersionCode,
    this.triggerType
  });
}